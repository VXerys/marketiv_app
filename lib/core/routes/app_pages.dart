import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/bindings/splash_binding.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/campaign/presentation/bindings/campaign_binding.dart';
import '../../features/campaign/presentation/pages/campaign_list_page.dart';
import '../../features/campaign/presentation/pages/create_campaign_page.dart';
import '../../features/campaign/presentation/pages/campaign_detail_page.dart';
import '../../features/navigation/presentation/bindings/main_navigation_binding.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';

class AppPages {
  static const initial = Routes.splash;

  static final pages = [
    // Auth & Splash
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: Routes.roleSelection,
      page: () => const RoleSelectionPage(),
    ),

    // UMKM
    GetPage(
      name: Routes.umkmHome,
      page: () => const MainNavigationPage(),
      bindings: [
        MainNavigationBinding(),
        CampaignBinding(),
      ],
    ),
    GetPage(
      name: Routes.campaignList,
      page: () => const CampaignListPage(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: Routes.campaignCreate,
      page: () => const CreateCampaignPage(),
      binding: CampaignBinding(),
    ),
    GetPage(
      name: Routes.campaignDetail,
      page: () => const CampaignDetailPage(),
      binding: CampaignBinding(),
    ),

    // Kreator
    GetPage(
      name: Routes.kreatorHome,
      page: () => const MainNavigationPage(),
      binding: MainNavigationBinding(),
    ),
    // TODO: static const jobPool         = '/kreator/job-pool';
    // TODO: static const jobPoolDetail   = '/kreator/job-pool/detail';
    // TODO: static const pekerjaanAktif  = '/kreator/pekerjaan-aktif';
    // TODO: static const submitBukti     = '/kreator/pekerjaan-aktif/submit';
    // TODO: static const rateCardManage  = '/kreator/rate-card';
    // TODO: static const keuanganKreator = '/kreator/keuangan';

    // Admin
    GetPage(
      name: Routes.adminHome,
      page: () => const MainNavigationPage(),
      binding: MainNavigationBinding(),
    ),

    // Shared
    // TODO: static const editProfile  = '/profile/edit';
    // TODO: static const notification = '/notification';
    GetPage(
      name: Routes.emailVerification,
      page: () => const EmailVerificationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: Routes.roleSelection,
      page: () => const RoleSelectionPage(),
    ),
  ];
}
