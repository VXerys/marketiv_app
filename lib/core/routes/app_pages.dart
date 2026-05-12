import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    // Auth & Onboarding
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.roleSelection,
      page: () => const RoleSelectionPage(),
    ),
    
    // Main Navigation
    // TODO: Add other pages as they are implemented
  ];
}
