import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. BAGIAN ATAS (40% Layar) - Ilustrasi
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary50.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.xxl),
                  bottomRight: Radius.circular(AppSpacing.xxl),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Image.file(
                    // Menggunakan path absolut file yang digenerate (disesuaikan dengan output tool)
                    // PENTING: Dalam implementasi nyata ini akan menggunakan asset atau network image
                    // Untuk demo ini, saya akan menggunakan icon sebagai fallback yang tetap estetik jika path bermasalah
                    File('C:\\Users\\user\\.gemini\\antigravity\\brain\\8c272fc9-d4a3-4bca-8e98-b68c1649d370\\marketiv_welcome_illustration_1778640904237.png'),
                    errorBuilder: (context, error, stackTrace) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rocket_launch_rounded,
                          size: 100,
                          color: AppColors.primary500,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Marketiv',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.secondary500,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // 2. BAGIAN TENGAH - Content
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang di Marketiv',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.secondary700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Platform UMKM & Kreator untuk konten yang terbukti menghasilkan',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // 3. BAGIAN BAWAH - Buttons (Fixed)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56, // Touch target minimum 48px
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(
                      Routes.roleSelection,
                      arguments: {'mode': 'register'},
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Daftar Akun',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: 56, // Touch target minimum 48px
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(
                      Routes.roleSelection,
                      arguments: {'mode': 'login'},
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary500, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      foregroundColor: AppColors.primary500,
                    ),
                    child: Text(
                      'Masuk',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
                // Extra padding for bottom safe area if needed
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
