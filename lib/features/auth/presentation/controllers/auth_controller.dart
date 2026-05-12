import 'package:get/get.dart';
import 'package:marketiv_app/core/constants/app_colors.dart';
import 'package:marketiv_app/core/routes/app_routes.dart';
import 'package:marketiv_app/core/services/storage_service.dart';
import 'package:marketiv_app/features/auth/domain/entities/user_entity.dart';
import 'package:marketiv_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:marketiv_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:marketiv_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:marketiv_app/features/auth/domain/usecases/register_usecase.dart';

// Assume NoParams is available, defining a simple version if not
class NoParams {}

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  );

  final Rxn<UserEntity> _currentUser = Rxn<UserEntity>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  UserEntity? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> login(String email, String password) async {
    _isLoading.value = true;
    
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Masuk',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: AppColors.white,
        );
      },
      (user) {
        _currentUser.value = user;
        
        StorageService.saveRole(user.role);
        StorageService.saveUserId(user.userId);
        StorageService.saveNama(user.namaLengkap);
        if (user.fotoProfilUrl != null) {
          StorageService.saveAvatar(user.fotoProfilUrl!);
        }
        
        _redirectByRole(user.role);
      },
    );
    
    _isLoading.value = false;
  }

  Future<void> register(
    String namaLengkap,
    String email,
    String password,
    String? nomorWhatsapp,
    String role,
  ) async {
    _isLoading.value = true;
    
    final result = await _registerUseCase(RegisterParams(
      namaLengkap: namaLengkap,
      email: email,
      password: password,
      nomorWhatsapp: nomorWhatsapp,
      role: role,
    ));
    
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Mendaftar',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: AppColors.white,
        );
      },
      (user) async {
        await sendEmailVerification();
        Get.defaultDialog(
          title: 'Berhasil',
          middleText: 'Cek email kamu untuk verifikasi!',
          textConfirm: 'OK',
          confirmTextColor: AppColors.white,
          onConfirm: () => Get.back(),
        );
        Get.offAllNamed(Routes.login);
      },
    );
    
    _isLoading.value = false;
  }

  Future<void> logout() async {
    await _logoutUseCase(NoParams());
    StorageService.clearAll();
    _currentUser.value = null;
    Get.offAllNamed(Routes.onboarding);
  }

  void _redirectByRole(String role) {
    if (role == 'UMKM') {
      Get.offAllNamed(Routes.umkmHome);
    } else if (role == 'KREATOR') {
      Get.offAllNamed(Routes.kreatorHome);
    } else if (role == 'ADMIN') {
      Get.offAllNamed(Routes.adminHome);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }

  Future<void> checkSession() async {
    final result = await _getCurrentUserUseCase(NoParams());
    
    result.fold(
      (failure) {
        Get.offAllNamed(Routes.onboarding);
      },
      (user) {
        _currentUser.value = user;
        _redirectByRole(user.role);
      },
    );
  }

  Future<void> sendEmailVerification() async {
    // TODO: Implement email verification or call SendEmailVerificationUseCase if available
  }
}
