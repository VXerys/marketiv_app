import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// SplashPage is a purely static display widget.
/// Its lifecycle logic is handled entirely by SplashController,
/// which is registered via SplashBinding and starts its work in onInit().
/// We intentionally do NOT use GetView here to avoid any rebuild loops
/// caused by GetX trying to resolve the controller during frame rendering.
class SplashPage extends StatelessWidget {
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
            const Icon(
              Icons.rocket_launch_rounded,
              size: 100,
              color: Colors.white,
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Marketiv',
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Marketplace Kreator & UMKM',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
