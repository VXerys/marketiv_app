import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/campaign_entity.dart';

class CampaignCard extends StatelessWidget {
  final CampaignEntity campaign;

  const CampaignCard({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'id');
    final dateFormat = DateFormat('dd MMM yyyy', 'id');
    final double progress = campaign.kuotaKreator > 0 
        ? campaign.kuotaTerpakai / campaign.kuotaKreator 
        : 0;

    // Logika warna progress
    Color progressColor = AppColors.primary500;
    if (progress >= 1.0) {
      progressColor = AppColors.danger;
    } else if (progress >= 0.8) {
      progressColor = AppColors.warning;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.campaignDetail, arguments: campaign.id),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row Atas: Judul & Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      campaign.judulCampaign,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grey900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StatusBadge(status: campaign.status),
                ],
              ),
              
              const SizedBox(height: AppSpacing.sm),

              // Row Tengah: Niche & Harga
              Row(
                children: [
                  if (campaign.niche != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        campaign.niche!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  const Icon(
                    Icons.monetization_on_outlined,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Rp ${currencyFormat.format(campaign.hargaPer1000Views)} / 1.000 views',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Row Bawah: Progress & Tanggal
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${campaign.kuotaTerpakai} dari ${campaign.kuotaKreator} kreator',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.grey100,
                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Text(
                    dateFormat.format(campaign.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
