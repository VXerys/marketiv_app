import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/widgets/warning_banner.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../controllers/job_pool_controller.dart';

class JobPoolDetailPage extends StatelessWidget {
  const JobPoolDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final JobPoolController controller = Get.find<JobPoolController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kampanye', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.xs - AppSpacing.xs,
      ),
      body: Obx(() {
        if (controller.isLoadingDetail) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary500),
          );
        }
        if (controller.selectedCampaign == null) {
          return EmptyStateWidget.error(message: 'Kampanye tidak ditemukan');
        }
        return _buildContent(controller.selectedCampaign!);
      }),
      bottomNavigationBar: Obx(() => _buildBottomBar(context, controller)),
    );
  }

  Widget _buildContent(CampaignEntity campaign) {
    final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl + AppSpacing.xl + AppSpacing.md + AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary50, AppColors.primary100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.campaign_rounded,
                  size: AppSpacing.xxl + AppSpacing.md,
                  color: AppColors.primary500.withValues(alpha: 0.8),
                ),
                const SizedBox(height: AppSpacing.md - AppSpacing.xs),
                Text(
                  campaign.judulCampaign,
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusBadge(status: campaign.status),
                    if (campaign.niche != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md - AppSpacing.sm + AppSpacing.xs,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(AppSpacing.xl),
                        ),
                        child: Text(
                          campaign.niche!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.monetization_on_rounded,
                  label: 'Per 1rb Views',
                  value:
                      'Rp ${numberFormat.format(campaign.hargaPer1000Views.toInt())}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.people_rounded,
                  label: 'Sisa Slot',
                  value: '${campaign.sisaSlot} kreator',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Dibuat',
                  value: DateFormat('d MMM', 'id_ID').format(campaign.createdAt),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Brief Kampanye', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Text(
              campaign.deskripsiBrief,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey700,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Materi Promosi', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.sm),
          const WarningBanner(
            message:
                'Semua materi promosi tersedia di link eksternal. Tap tombol di bawah untuk membuka.',
            icon: Icons.folder_open_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final Uri uri = Uri.parse(campaign.urlAsetEksternal);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar(
                    'Error',
                    'Tidak dapat membuka link',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.danger,
                    colorText: Colors.white,
                  );
                }
              },
              icon: const Icon(Icons.open_in_new, size: AppSpacing.md + AppSpacing.xs / 2),
              label: Text(
                'Buka Materi di Drive',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary500,
                side: const BorderSide(color: AppColors.primary500),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md - AppSpacing.xs),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Budget',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md - AppSpacing.xs),
                _buildBudgetRow(
                  'Total Budget Escrow',
                  'Rp ${numberFormat.format(campaign.totalBudgetEscrow.toInt())}',
                  AppColors.grey700,
                ),
                const Divider(height: AppSpacing.md),
                _buildBudgetRow(
                  'Bayaran per 1.000 Views',
                  'Rp ${numberFormat.format(campaign.hargaPer1000Views.toInt())}',
                  AppColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl + AppSpacing.xxl - AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppSpacing.md + AppSpacing.xs, color: AppColors.primary500),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs - 2),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, JobPoolController controller) {
    final CampaignEntity? campaign = controller.selectedCampaign;
    if (campaign == null) {
      return const SizedBox.shrink();
    }

    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final EdgeInsets containerPadding = EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.md,
      AppSpacing.md,
      AppSpacing.md + bottomPadding,
    );

    if (campaign.status != 'Aktif') {
      return Container(
        padding: containerPadding,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.grey100)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.xxl + AppSpacing.xs,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey300,
              disabledBackgroundColor: AppColors.grey300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: AppSpacing.xs - AppSpacing.xs,
            ),
            child: Text(
              'Kampanye Tidak Aktif',
              style: AppTextStyles.buttonText.copyWith(color: AppColors.grey500),
            ),
          ),
        ),
      );
    }

    if (controller.alreadyClaimed) {
      return Container(
        padding: containerPadding,
        color: AppColors.surface,
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: AppSpacing.md + AppSpacing.xs,
            ),
            const SizedBox(width: AppSpacing.md - AppSpacing.xs),
            Expanded(
              child: Text(
                'Kamu sudah mengklaim kampanye ini',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: containerPadding,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.xxl + AppSpacing.xs,
        child: ElevatedButton(
          onPressed: controller.isClaiming
              ? null
              : () => _showClaimConfirmation(context, controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            elevation: AppSpacing.xs - AppSpacing.xs,
          ),
          child: controller.isClaiming
              ? const SizedBox(
                  width: AppSpacing.md + AppSpacing.xs,
                  height: AppSpacing.md + AppSpacing.xs,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text('Klaim Job Ini', style: AppTextStyles.buttonText),
        ),
      ),
    );
  }

  void _showClaimConfirmation(
    BuildContext context,
    JobPoolController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg + bottomPadding,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg + AppSpacing.xs),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.xl + AppSpacing.sm,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppSpacing.xs / 2),
                ),
              ),
              const SizedBox(height: AppSpacing.md + AppSpacing.xs),
              Icon(
                Icons.work_outlined,
                size: AppSpacing.xxl,
                color: AppColors.primary500,
              ),
              const SizedBox(height: AppSpacing.md - AppSpacing.xs),
              Text(
                'Yakin mau klaim job ini?',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Kamu bertanggung jawab untuk menyelesaikan dan submit bukti tayang setelah mengklaim.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppSpacing.xxl + AppSpacing.xs,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.grey700,
                          side: const BorderSide(color: AppColors.grey300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.grey700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md - AppSpacing.xs),
                  Expanded(
                    child: Obx(
                      () => SizedBox(
                        height: AppSpacing.xxl + AppSpacing.xs,
                        child: ElevatedButton(
                          onPressed: controller.isClaiming
                              ? null
                              : () => controller.claimCampaign(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                            ),
                            elevation: AppSpacing.xs - AppSpacing.xs,
                          ),
                          child: controller.isClaiming
                              ? const SizedBox(
                                  width: AppSpacing.md + AppSpacing.xs,
                                  height: AppSpacing.md + AppSpacing.xs,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Ya, Klaim!',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
