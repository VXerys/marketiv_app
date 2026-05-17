import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/campaign_entity.dart';
import '../controllers/campaign_controller.dart';

class CampaignListPage extends StatefulWidget {
  const CampaignListPage({super.key});

  @override
  State<CampaignListPage> createState() => _CampaignListPageState();
}

class _CampaignListPageState extends State<CampaignListPage> {
  late final CampaignController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CampaignController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(_controller, StorageService.getRole());
    });
  }

  void _loadData(CampaignController controller, String? role) {
    if (role == 'UMKM') {
      final String userId = StorageService.getUserId() ?? '';
      controller.loadMyCampaigns(userId);
    } else {
      controller.loadActiveCampaigns();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? role = StorageService.getRole();

    return Scaffold(
      appBar: AppBar(
        title: Text(role == 'UMKM' ? 'Kampanye Saya' : 'Cari Kampanye'),
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: [
                    _buildFilterChip('Semua'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Aktif'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Draft'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Selesai'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Dibatalkan'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return const ShimmerCard(height: 240);
                  },
                );
              }

              if (_controller.hasError) {
                return Center(
                  child: EmptyStateWidget.error(
                    message: 'Gagal memuat kampanye',
                    submessage: _controller.errorMessage,
                    onRetry: () => _loadData(_controller, role),
                  ),
                );
              }

              if (_controller.filteredCampaigns.isEmpty && !_controller.isLoading) {
                return EmptyStateWidget(
                  icon: Icons.campaign_outlined,
                  message: 'Belum Ada Kampanye',
                  submessage: role == 'UMKM'
                      ? 'Buat kampanye pertamamu dan mulai promosi!'
                      : 'Belum ada kampanye aktif saat ini.',
                  actionLabel: role == 'UMKM' ? 'Buat Kampanye' : null,
                  onAction: role == 'UMKM'
                      ? () => Get.toNamed(Routes.campaignCreate)
                      : null,
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _loadData(_controller, role),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: _controller.filteredCampaigns.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CampaignEntity campaign =
                        _controller.filteredCampaigns[index];
                    return _CampaignCard(
                      campaign: campaign,
                      onTap: () => Get.toNamed(Routes.campaignDetail),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: role == 'UMKM'
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.campaignCreate),
              icon: const Icon(Icons.add),
              label: const Text('Buat Kampanye'),
              backgroundColor: AppColors.primary500,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _controller.selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _controller.filterByStatus(label),
      selectedColor: AppColors.primary500,
      backgroundColor: AppColors.grey100,
      labelStyle: isSelected
          ? const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )
          : const TextStyle(
              color: AppColors.grey700,
              fontSize: 12,
            ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
      showCheckmark: false,
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignEntity campaign;
  final VoidCallback onTap;

  const _CampaignCard({
    required this.campaign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
    final double progress = campaign.kuotaKreator > 0
        ? campaign.kuotaTerpakai / campaign.kuotaKreator
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary50, AppColors.primary100],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.campaign_rounded,
                              size: 52,
                              color: AppColors.primary500.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              campaign.niche ?? 'Umum',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: StatusBadge(status: campaign.status),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.judulCampaign,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey900,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_rounded,
                          size: 13,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 3),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_rounded,
                          size: 13,
                          color: AppColors.grey500,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${campaign.kuotaTerpakai}/${campaign.kuotaKreator} kreator',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: AppColors.grey100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          campaign.kuotaTerpakai >= campaign.kuotaKreator
                              ? AppColors.warning
                              : AppColors.primary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
