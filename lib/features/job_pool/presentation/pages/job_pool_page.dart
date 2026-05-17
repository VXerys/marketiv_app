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
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../controllers/job_pool_controller.dart';

class JobPoolPage extends StatefulWidget {
  const JobPoolPage({super.key});

  @override
  State<JobPoolPage> createState() => _JobPoolPageState();
}

class _JobPoolPageState extends State<JobPoolPage> {
  late final JobPoolController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<JobPoolController>();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - AppSpacing.xl * 6.25) {
          _controller.loadMore();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bursa Kerja', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.xs - AppSpacing.xs,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: AppSpacing.xs - AppSpacing.xs + 1,
            color: AppColors.grey100,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildNicheFilter(_controller),
          Expanded(
            child: Obx(() => _buildBody(_controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildNicheFilter(JobPoolController controller) {
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
              _buildNicheChip(
                label: 'Semua',
                isSelected: controller.selectedNiche == null,
                onTap: () => controller.filterByNiche(null),
              ),
              const SizedBox(width: AppSpacing.sm),
              ...JobPoolController.nicheOptions.map(
                (String niche) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: _buildNicheChip(
                    label: niche,
                    isSelected: controller.selectedNiche == niche,
                    onTap: () => controller.filterByNiche(niche),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNicheChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: AppSpacing.xxl,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary500,
        backgroundColor: AppColors.grey100,
        labelStyle: isSelected
            ? AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )
            : AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey700,
              ),
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildBody(JobPoolController controller) {
    if (controller.isLoading && controller.campaigns.isEmpty) {
      return _buildLoadingState();
    }
    if (controller.hasError && controller.campaigns.isEmpty) {
      return _buildErrorState(controller);
    }
    if (controller.campaigns.isEmpty) {
      return _buildEmptyState();
    }
    return _buildCampaignList(controller);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md - AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.sm),
        child: ShimmerCard(height: AppSpacing.xl * 5),
      ),
    );
  }

  Widget _buildErrorState(JobPoolController controller) {
    return EmptyStateWidget.error(
      message: 'Gagal memuat bursa kerja',
      submessage: controller.errorMessage,
      onRetry: () => controller.loadCampaigns(isRefresh: true),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: Icons.work_off_outlined,
      message: 'Belum Ada Job Tersedia',
      submessage: 'Job baru muncul setiap hari. Pantau terus!',
    );
  }

  Widget _buildCampaignList(JobPoolController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.loadCampaigns(isRefresh: true),
      color: AppColors.primary500,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
        itemCount:
            controller.campaigns.length + (controller.hasMoreData ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == controller.campaigns.length) {
            return _buildLoadMoreIndicator();
          }
          final CampaignEntity campaign = controller.campaigns[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _JobPoolCard(
              campaign: campaign,
              onTap: () => _navigateToDetail(campaign.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary500),
      ),
    );
  }

  void _navigateToDetail(String campaignId) {
    _controller.selectCampaign(campaignId);
    Get.toNamed(Routes.jobPoolDetail);
  }
}

class _JobPoolCard extends StatelessWidget {
  final CampaignEntity campaign;
  final VoidCallback onTap;

  const _JobPoolCard({
    required this.campaign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
    final double progress = campaign.kuotaKreator > 0
        ? campaign.kuotaTerpakai / campaign.kuotaKreator
        : AppSpacing.xs - AppSpacing.xs;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          height: AppSpacing.xl * 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: AppSpacing.sm,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusMd),
                  bottomLeft: Radius.circular(AppSpacing.radiusMd),
                ),
                child: Container(
                  width: AppSpacing.xl * 3.75,
                  height: AppSpacing.xl * 4.0625,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary50, AppColors.primary100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.campaign_rounded,
                          size: AppSpacing.xl + AppSpacing.sm,
                          color: AppColors.primary500.withValues(alpha: 0.7),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.xs,
                        bottom: AppSpacing.xs,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm - AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          child: Text(
                            campaign.niche ?? 'Umum',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md - AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              campaign.judulCampaign,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          StatusBadge(status: campaign.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: AppSpacing.md - AppSpacing.xs / 2,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Rp ${numberFormat.format(campaign.hargaPer1000Views.toInt())} / 1rb views',
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
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_rounded,
                            size: AppSpacing.md - AppSpacing.xs / 2,
                            color: AppColors.grey500,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Sisa ${campaign.sisaSlot} slot dari ${campaign.kuotaKreator}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: AppSpacing.sm - AppSpacing.xs + 1,
                          backgroundColor: AppColors.grey100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            campaign.kuotaTerpakai >= campaign.kuotaKreator
                                ? AppColors.warning
                                : AppColors.primary500,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm - AppSpacing.xs / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'd MMM yyyy',
                              'id_ID',
                            ).format(campaign.createdAt),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                              fontSize: 11,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs - 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(AppSpacing.xl),
                            ),
                            child: Text(
                              'Klaim ->',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
