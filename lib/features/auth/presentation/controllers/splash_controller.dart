import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

class SplashController extends GetxController {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SplashController(this._getCurrentUserUseCase);

  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    await checkSession();
  }

  Future<void> checkSession() async {
    final result = await _getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        // Redirect to onboarding/login on failure
        Get.offAllNamed(Routes.login);
      },
      (user) {
        // Save user session to storage
        StorageService.saveRole(user.role);
        StorageService.saveUserId(user.userId);
        StorageService.saveNama(user.namaLengkap);
        if (user.fotoProfilUrl != null) {
          StorageService.saveAvatar(user.fotoProfilUrl!);
        }

        // Redirect based on role
        _redirectByRole(user.role);
      },
    );
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
        Get.offAllNamed(Routes.login);
    }
  }
}
