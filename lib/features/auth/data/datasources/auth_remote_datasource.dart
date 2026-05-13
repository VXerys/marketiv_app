import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String namaLengkap,
    required String email,
    required String password,
    required String role, // 'UMKM' atau 'KREATOR'
    String? nomorWhatsapp,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account _account;
  final Databases _databases;

  AuthRemoteDataSourceImpl({
    required Account account,
    required Databases databases,
  })  : _account = account,
        _databases = databases;

  @override
  Future<UserModel> register({
    required String namaLengkap,
    required String email,
    required String password,
    required String role,
    String? nomorWhatsapp,
  }) async {
    try {
      // 1. Create Account
      final accountResult = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: namaLengkap,
      );

      // 2. Auto Login (Create Session)
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // 3. Create User Document (session is now active)
      final data = {
        'user_id': accountResult.$id,
        'role': role,
        'nama_lengkap': namaLengkap,
        'email': email,
        'nomor_whatsapp': nomorWhatsapp,
        'dompet_saldo': 0.0,
        'is_verified': false,
        'unread_count': 0,
      };

      final doc = await _databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        documentId: ID.unique(),
        data: data,
        permissions: [
          Permission.read(Role.user(accountResult.$id)),
          Permission.update(Role.user(accountResult.$id)),
        ],
      );

      // 4. Send Email Verification (Non-blocking)
      try {
        await _account.createVerification(url: 'https://marketiv.app/verify');
      } catch (e) {
        // Silently fail verification if URL is not configured yet
        // This prevents the whole registration from failing with 400 error
      }

      return UserModel.fromDocument(doc.data);
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga: $e');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create Session
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // 2. Query User Document by user_id
      final result = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [
          Query.equal('user_id', session.userId),
        ],
      );

      if (result.documents.isEmpty) {
        throw NotFoundException('Profil pengguna tidak ditemukan.');
      }

      return UserModel.fromDocument(result.documents.first.data);
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Terjadi kesalahan: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // 1. Get account session
      final appwriteUser = await _account.get();
      
      // 2. Query profile document
      final result = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [
          Query.equal('user_id', appwriteUser.$id),
        ],
      );

      if (result.documents.isEmpty) return null;

      return UserModel.fromDocument(result.documents.first.data);
    } on AppwriteException catch (e) {
      if (e.code == 401) return null; // No active session
      throw _mapAppwriteException(e);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _account.createVerification(url: 'https://marketiv.app/verify');
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://marketiv.app/reset-password',
      );
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    try {
      await _account.updateRecovery(
        userId: userId,
        secret: secret,
        password: newPassword,
      );
    } on AppwriteException catch (e) {
      throw _mapAppwriteException(e);
    }
  }

  Exception _mapAppwriteException(AppwriteException e) {
    switch (e.code) {
      case 401:
        return UnauthorizedException('Email atau password salah.');
      case 409:
        return ConflictException('Email ini sudah terdaftar. Silakan masuk.');
      case 400:
        return ValidationException('Data tidak valid. Periksa kembali isian kamu.');
      case 429:
        return RateLimitException('Terlalu banyak percobaan. Tunggu beberapa menit.');
      case 503:
        return ServerException('Layanan sedang gangguan. Coba lagi nanti.');
      default:
        return ServerException('Terjadi kesalahan (${e.code}): ${e.message}');
    }
  }
}
