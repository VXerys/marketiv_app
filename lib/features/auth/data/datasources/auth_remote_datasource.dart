import 'package:appwrite/appwrite.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String namaLengkap,
    String email,
    String password,
    String? nomorWhatsapp,
    String role,
  );
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> updateFcmToken(String userId, String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account account;
  final Databases databases;

  AuthRemoteDataSourceImpl({required this.account, required this.databases});

  Never _handleAppwriteException(AppwriteException e) {
    switch (e.code) {
      case 401:
        throw UnauthorizedException('Akses ditolak: Email atau password salah.');
      case 404:
        throw NotFoundException('Data tidak ditemukan.');
      case 409:
        throw ConflictException('Email sudah terdaftar.');
      default:
        throw ServerException('Terjadi kesalahan pada server: ${e.message}');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final result = await databases.listDocuments(
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
      _handleAppwriteException(e);
    }
  }

  @override
  Future<UserModel> register(
    String namaLengkap,
    String email,
    String password,
    String? nomorWhatsapp,
    String role,
  ) async {
    try {
      final accountResult = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: namaLengkap,
      );

      final data = {
        'user_id': accountResult.$id,
        'role': role,
        'nama_lengkap': namaLengkap,
        'nomor_whatsapp': nomorWhatsapp,
        'dompet_saldo': 0.0,
        'niche': null,
        'foto_profil_url': null,
        'bio': null,
        'is_verified': false,
        'fcm_token': null,
        'unread_count': 0,
      };

      final doc = await databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        documentId: ID.unique(),
        data: data,
        permissions: [
          Permission.read(Role.user(accountResult.$id)),
          Permission.update(Role.user(accountResult.$id)),
        ],
      );

      return UserModel.fromDocument(doc.data);
    } on AppwriteException catch (e) {
      _handleAppwriteException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      _handleAppwriteException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final accountResult = await account.get();

      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [
          Query.equal('user_id', accountResult.$id),
        ],
      );

      if (result.documents.isEmpty) {
        throw NotFoundException('Profil pengguna tidak ditemukan.');
      }

      return UserModel.fromDocument(result.documents.first.data);
    } on AppwriteException catch (e) {
      _handleAppwriteException(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await account.createVerification(
        url: 'https://marketiv.app/verify',
      );
    } on AppwriteException catch (e) {
      _handleAppwriteException(e);
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String token) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [
          Query.equal('user_id', userId),
        ],
      );

      if (result.documents.isEmpty) {
        throw NotFoundException('Profil pengguna tidak ditemukan.');
      }

      await databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        documentId: result.documents.first.$id,
        data: {'fcm_token': token},
      );
    } on AppwriteException catch (e) {
      _handleAppwriteException(e);
    }
  }
}
