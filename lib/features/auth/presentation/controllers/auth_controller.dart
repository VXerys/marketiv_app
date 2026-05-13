import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';

class AuthController extends GetxController {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final ConfirmPasswordResetUseCase _confirmPasswordResetUseCase;

  AuthController({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required ConfirmPasswordResetUseCase confirmPasswordResetUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
        _sendPasswordResetUseCase = sendPasswordResetUseCase,
        _confirmPasswordResetUseCase = confirmPasswordResetUseCase;

  // Private Rx, public getter
  final _isLoading = false.obs;
  final _user = Rxn<UserEntity>();
  final _errorMessage = ''.obs;
  final _isEmailVerificationSent = false.obs;

  bool get isLoading => _isLoading.value;
  UserEntity? get user => _user.value;
  String get errorMessage => _errorMessage.value;
  bool get isEmailVerificationSent => _isEmailVerificationSent.value;

  Future<void> register({
    required String namaLengkap,
    required String email,
    required String password,
    required String role,
    String? nomorWhatsapp,
  }) async {
    // 1. Validasi Sederhana di Controller
    if (namaLengkap.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Input Tidak Valid',
        'Semua kolom wajib diisi.',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email Tidak Valid',
        'Gunakan format email yang benar.',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }
    if (password.length < 8) {
      Get.snackbar(
        'Password Terlalu Pendek',
        'Password minimal 8 karakter.',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _registerUseCase(RegisterParams(
      namaLengkap: namaLengkap,
      email: email,
      password: password,
      role: role,
      nomorWhatsapp: nomorWhatsapp,
    ));

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Daftar',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
      },
      (user) {
        _user.value = user;
        // Simpan sesi ke Storage
        StorageService.saveRole(user.role);
        StorageService.saveUserId(user.userId);
        StorageService.saveNama(user.namaLengkap);
        
        Get.offAllNamed(Routes.emailVerification);
      },
    );

    _isLoading.value = false;
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Input Kosong',
        'Email dan password wajib diisi.',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _loginUseCase(LoginParams(
      email: email,
      password: password,
    ));

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Masuk',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
      },
      (user) {
        _user.value = user;
        // Simpan sesi ke Storage
        StorageService.saveRole(user.role);
        StorageService.saveUserId(user.userId);
        StorageService.saveNama(user.namaLengkap);
        
        _redirectByRole(user.role);
      },
    );

    _isLoading.value = false;
  }

  void _redirectByRole(String role) {
    switch (role.toUpperCase()) {
      case 'UMKM':
        Get.offAllNamed(Routes.umkmHome);
        break;
      case 'KREATOR':
        Get.offAllNamed(Routes.kreatorHome);
        break;
      case 'ADMIN':
        Get.offAllNamed(Routes.adminHome);
        break;
      default:
        Get.offAllNamed(Routes.welcome);
    }
  }

  Future<void> logout() async {
    _isLoading.value = true;
    final result = await _logoutUseCase(NoParams());
    
    result.fold(
      (failure) => Get.snackbar(
        'Gagal Logout',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      ),
      (_) {
        StorageService.clearAll();
        _user.value = null;
        Get.offAllNamed(Routes.welcome);
      },
    );
    _isLoading.value = false;
  }

  Future<void> sendPasswordReset(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Input Tidak Valid',
        'Masukkan email yang valid.',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;
    final result = await _sendPasswordResetUseCase(email);

    result.fold(
      (failure) => Get.snackbar(
        'Gagal Mengirim Email',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      ),
      (_) {
        Get.snackbar(
          'Email Terkirim',
          'Cek inbox kamu untuk reset password',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      },
    );
    _isLoading.value = false;
  }

  Future<void> resendEmailVerification() async {
    _isLoading.value = true;
    final result = await _sendEmailVerificationUseCase(NoParams());

    result.fold(
      (failure) => Get.snackbar(
        'Gagal Mengirim Verifikasi',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      ),
      (_) {
        _isEmailVerificationSent.value = true;
        Get.snackbar(
          'Email Verifikasi Terkirim',
          'Silakan cek inbox email kamu.',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      },
    );
    _isLoading.value = false;
  }

  Future<void> checkVerificationAndProceed() async {
    _isLoading.value = true;
    final result = await _getCurrentUserUseCase(NoParams());
    
    result.fold(
      (failure) {
        Get.snackbar(
          'Gagal Memuat',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
        );
      },
      (user) {
        if (user != null && user.isVerified) {
          _user.value = user;
          _redirectByRole(user.role);
        } else {
          Get.snackbar(
            'Belum Terverifikasi',
            'Kamu belum klik link di email. Cek folder spam juga ya 📬',
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      },
    );
    
    _isLoading.value = false;
  }

  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    _isLoading.value = true;
    final result = await _confirmPasswordResetUseCase(ConfirmPasswordResetParams(
      userId: userId,
      secret: secret,
      newPassword: newPassword,
    ));

    result.fold(
      (failure) => Get.snackbar(
        'Gagal Reset Password',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      ),
      (_) {
        Get.snackbar(
          'Password Berhasil Diganti',
          'Silakan masuk dengan password baru kamu.',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.login);
      },
    );
    _isLoading.value = false;
  }
}
