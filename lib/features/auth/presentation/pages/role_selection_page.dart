import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Dapatkan argument mode
    final dynamic args = Get.arguments;
    String mode = 'register'; // Default
    if (args is Map && args.containsKey('mode')) {
      mode = args['mode'];
    }

    // 2. Heading dinamis
    final String heading = mode == 'login' ? 'Masuk Sebagai' : 'Pilih Peranmu';
    final String subtitle = mode == 'login' 
        ? 'Kamu terdaftar sebagai...' 
        : 'Buat akun baru sebagai...';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.secondary500),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              // HEADER
              Text(
                heading,
                style: AppTextStyles.h2.copyWith(color: AppColors.secondary700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
              ),
              
              const SizedBox(height: AppSpacing.xxl),

              // ROLE CARDS
              _buildLargeRoleCard(
                title: 'Pemilik UMKM',
                description: 'Saya ingin mempromosikan produk atau usaha saya',
                icon: Icons.storefront_rounded,
                accentColor: AppColors.primary500,
                onTap: () {
                  final route = mode == 'login' ? Routes.login : Routes.register;
                  Get.toNamed(route, arguments: {'role': 'UMKM'});
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),

              _buildLargeRoleCard(
                title: 'Konten Kreator',
                description: 'Saya ingin mendapat job konten dan penghasilan tambahan',
                icon: Icons.movie_creation_outlined,
                accentColor: AppColors.secondary500,
                onTap: () {
                  final route = mode == 'login' ? Routes.login : Routes.register;
                  Get.toNamed(route, arguments: {'role': 'KREATOR'});
                },
              ),
              
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Icon Wrapper
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(icon, size: 40, color: accentColor),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h3.copyWith(color: AppColors.secondary700),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.grey300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
