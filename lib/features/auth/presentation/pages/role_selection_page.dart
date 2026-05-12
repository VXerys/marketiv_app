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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Navigator.canPop(context)
            ? const BackButton(color: AppColors.secondary500)
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              const SizedBox(height: AppSpacing.md),
              Text(
                'Saya adalah...',
                style: AppTextStyles.h2.copyWith(color: AppColors.secondary500),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pilih peran untuk melanjutkan',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ROLE SELECTION CARDS
              _buildRoleCard(
                title: 'Pemilik UMKM',
                subtitle: 'Buat campaign, bayar sesuai tayangan nyata',
                icon: Icons.store_rounded,
                onTap: () => Get.toNamed(Routes.register, arguments: 'UMKM'),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildRoleCard(
                title: 'Kreator Konten',
                subtitle: 'Klaim job, buat video, dapat bayaran aman',
                icon: Icons.videocam_rounded,
                onTap: () => Get.toNamed(Routes.register, arguments: 'KREATOR'),
              ),
              
              const SizedBox(height: AppSpacing.xl),

              // BOTTOM SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(Routes.login),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Masuk',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.primary500, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 56, color: AppColors.primary500),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(color: AppColors.secondary500),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
