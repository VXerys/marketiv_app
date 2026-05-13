import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/appwrite_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // 1. Tunggu 1.5 detik (brand impression)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // 2. Cek apakah first launch
    final bool hasSeenOnboarding = StorageService.hasSeenOnboarding();
    if (!hasSeenOnboarding) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    // 3. Cek session Appwrite
    try {
      await AppwriteService.account.get();
      
      // Session aktif: ambil role dari Storage
      final String? role = StorageService.getRole();
      
      if (role != null && role.isNotEmpty) {
        _redirectByRole(role);
      } else {
        Get.offAllNamed(Routes.welcome);
      }
    } on AppwriteException catch (e) {
      // code 401: Unauthorized (no session)
      Get.offAllNamed(Routes.welcome);
    } catch (e) {
      // Error lain
      Get.offAllNamed(Routes.welcome);
    }
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
}
