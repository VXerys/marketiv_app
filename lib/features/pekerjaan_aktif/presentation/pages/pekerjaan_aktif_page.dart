import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../navigation/presentation/controllers/main_navigation_controller.dart';
import '../../domain/entities/pekerjaan_entity.dart';
import '../controllers/pekerjaan_aktif_controller.dart';

class PekerjaanAktifPage extends GetView<PekerjaanAktifController> {
  const PekerjaanAktifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pekerjaan Aktif', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.grey100),
        ),
        actions: [
          IconButton(
            onPressed: controller.loadPekerjaan,
            tooltip: 'Refresh',
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.grey700,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: Obx(() => _buildBody()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: AppSpacing.xxl + AppSpacing.xs,
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md - AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Obx(
          () => Row(
            children: [
              ...PekerjaanAktifController.filterOptions.map((String option) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: SizedBox(
                    height: AppSpacing.xxl,
                    child: FilterChip(
                      selected: controller.selectedFilter == option,
                      onSelected: (_) => controller.filterByStatus(option),
                      label: Text(option),
                      selectedColor: AppColors.primary500,
                      backgroundColor: AppColors.grey100,
                      labelStyle: controller.selectedFilter == option
                          ? AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            )
                          : AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey700,
                            ),
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading && controller.pekerjaanList.isEmpty) {
      return _buildLoadingState();
    }
    if (controller.hasError && controller.pekerjaanList.isEmpty) {
      return _buildErrorState();
    }
    if (controller.pekerjaanList.isEmpty) {
      return _buildEmptyState();
    }
    return _buildList();
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: ShimmerCard(height: 130),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return EmptyStateWidget.error(
      message: 'Gagal memuat pekerjaan',
      submessage: controller.errorMessage,
      onRetry: controller.loadPekerjaan,
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.work_off_outlined,
      message: 'Belum Ada Pekerjaan',
      submessage: 'Klaim job dari Job Pool untuk mulai bekerja!',
      actionLabel: 'Ke Job Pool',
      onAction: () {
        Get.find<MainNavigationController>().changePage(1);
      },
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: controller.loadPekerjaan,
      color: AppColors.primary500,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
        itemCount: controller.pekerjaanList.length,
        itemBuilder: (BuildContext context, int index) {
          final PekerjaanEntity pekerjaan = controller.pekerjaanList[index];
          return _PekerjaanCard(
            pekerjaan: pekerjaan,
            onTap: () {
              controller.selectPekerjaan(pekerjaan);
              Get.toNamed(Routes.submitBukti);
            },
          );
        },
      ),
    );
  }
}

class _PekerjaanCard extends StatelessWidget {
  final PekerjaanEntity pekerjaan;
  final VoidCallback onTap;

  const _PekerjaanCard({
    required this.pekerjaan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pekerjaan.judulCampaign,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      StatusBadge(status: pekerjaan.statusValidasi),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (pekerjaan.niche != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pekerjaan.niche!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (pekerjaan.isSubmitted)
                        Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 13,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Sudah disubmit',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.success,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            const Icon(
                              Icons.pending_outlined,
                              size: 13,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Belum disubmit',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.warning,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.grey100),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              size: 13,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                '${numberFormat.format(pekerjaan.jumlahViewsAktual)} views',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monetization_on_outlined,
                              size: 13,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                'Est. Rp ${numberFormat.format(pekerjaan.estimasiPendapatan.toInt())}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('d MMM yyyy', 'id_ID').format(
                          pekerjaan.createdAt,
                        ),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  if (!pekerjaan.isSubmitted && !pekerjaan.isDone) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary500,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Submit Bukti ->',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
