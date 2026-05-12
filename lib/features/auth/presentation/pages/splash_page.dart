import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary500,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Placeholder Icon (Icons.storefront)
            const Icon(
              Icons.storefront,
              size: 80,
              color: Colors.white,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // App Name
            Text(
              'Marketiv',
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontFamily: 'Newsreader',
              ),
            ),
            
            const SizedBox(height: AppSpacing.sm),
            
            // Tagline
            Text(
              'Marketplace Kreator & UMKM',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Loader
            const CircularProgressIndicator(
              color: AppColors.primary500,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
