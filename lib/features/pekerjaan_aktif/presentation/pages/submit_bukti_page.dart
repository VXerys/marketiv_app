import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/warning_banner.dart';
import '../../domain/entities/pekerjaan_entity.dart';
import '../controllers/pekerjaan_aktif_controller.dart';

class SubmitBuktiPage extends GetView<PekerjaanAktifController> {
  const SubmitBuktiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Submit Bukti Tayang', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            controller.urlBuktiController.clear();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Obx(() {
        final PekerjaanEntity? pekerjaan = controller.selectedPekerjaan;

        if (controller.isLoading && pekerjaan == null) {
          return _buildLoadingState();
        }
        if (pekerjaan == null && controller.hasError) {
          return EmptyStateWidget.error(
            message: 'Data tidak ditemukan',
            submessage: controller.errorMessage,
            onRetry: controller.loadPekerjaan,
          );
        }
        if (pekerjaan == null) {
          return const EmptyStateWidget(
            message: 'Data tidak ditemukan',
            submessage: 'Pilih pekerjaan terlebih dahulu dari halaman sebelumnya.',
          );
        }
        return _buildContent(pekerjaan);
      }),
      bottomNavigationBar: Obx(() {
        final PekerjaanEntity? pekerjaan = controller.selectedPekerjaan;
        if (pekerjaan == null) {
          return const SizedBox.shrink();
        }
        return _buildBottomBar(context, pekerjaan);
      }),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: ShimmerCard(height: 120),
        );
      },
    );
  }

  Widget _buildContent(PekerjaanEntity pekerjaan) {
    final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    size: 28,
                    color: AppColors.primary500,
                  ),
                ),
                const SizedBox(width: AppSpacing.md - AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pekerjaan.judulCampaign,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Rp ${numberFormat.format(pekerjaan.hargaPer1000Views.toInt())} / 1.000 views',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (pekerjaan.isSubmitted) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Bukti sudah disubmit sebelumnya',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(
                      pekerjaan.urlBuktiTayang!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text('Cara Submit', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          _buildStepItem(
            '1',
            'Edit video menggunakan bahan mentah dari link Drive yang diberikan UMKM.',
          ),
          _buildStepItem(
            '2',
            'Upload video ke akun TikTok atau Instagram KAMU sendiri (bukan akun UMKM).',
          ),
          _buildStepItem(
            '3',
            'Pastikan video berstatus PUBLIK agar bisa divalidasi.',
          ),
          _buildStepItem(
            '4',
            'Salin link video yang sudah diposting, lalu tempel di kolom di bawah ini.',
          ),
          const SizedBox(height: AppSpacing.md),
          const WarningBanner(
            message:
                'Pastikan video sudah diposting dan berstatus publik sebelum submit. Link private tidak dapat divalidasi.',
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Link Video',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller.urlBuktiController,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'https://www.tiktok.com/@username/video/...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey300,
              ),
              prefixIcon: const Icon(
                Icons.link_rounded,
                color: AppColors.grey500,
                size: 20,
              ),
              fillColor: AppColors.surface,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary500,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Format yang diterima: TikTok atau Instagram Reels',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary500,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PekerjaanEntity pekerjaan) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        12,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey100)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: pekerjaan.statusValidasi == 'Valid'
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Pekerjaan sudah divalidasi & dana sedang diproses',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting
                      ? null
                      : controller.submitBuktiTayang,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    disabledBackgroundColor: AppColors.grey300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMd,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          pekerjaan.isSubmitted
                              ? 'Update Bukti Tayang'
                              : 'Submit Bukti Tayang',
                          style: AppTextStyles.buttonText,
                        ),
                ),
              ),
            ),
    );
  }
}
