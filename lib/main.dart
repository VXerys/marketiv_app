import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/di/initial_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/appwrite_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  // 1. WidgetsFlutterBinding.ensureInitialized()
  WidgetsFlutterBinding.ensureInitialized();

  // 2. await dotenv.load(fileName: '.env')
  await dotenv.load(fileName: '.env');

  // 3. await StorageService.init()
  await StorageService.init();

  // 4. await AppwriteService.initialize()
  await AppwriteService.initialize();

  // 5. runApp(const MarketivApp())
  runApp(const MarketivApp());
}

class MarketivApp extends StatelessWidget {
  const MarketivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Marketiv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary500),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          foregroundColor: AppColors.secondary500,
          titleTextStyle: AppTextStyles.h3.copyWith(color: AppColors.secondary500),
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
