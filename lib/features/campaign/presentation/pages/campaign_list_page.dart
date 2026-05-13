import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../controllers/campaign_controller.dart';
import '../widgets/campaign_card.dart';

class CampaignListPage extends StatelessWidget {
  const CampaignListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampaignController>();

    // Load data jika kosong dan tidak sedang loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.campaigns.isEmpty && !controller.isLoading) {
        controller.loadMyCampaigns(StorageService.getUserId() ?? '');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kampanye Saya',
                    style: AppTextStyles.h2,
                  ),
                  Text(
                    'Kelola semua kampanye promosi kamu',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chip Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  _buildFilterChip('Semua', controller),
                  _buildFilterChip('Aktif', controller),
                  _buildFilterChip('Draft', controller),
                  _buildFilterChip('Selesai', controller),
                  _buildFilterChip('Dibatalkan', controller),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Body Section
            Expanded(
              child: Obx(() {
                // State 1: Loading
                if (controller.isLoading) {
                  return const LoadingShimmer(
                    itemCount: 5,
                    itemHeight: 130,
                  );
                }

                // State 2: Error
                if (controller.hasError) {
                  return EmptyStateWidget.error(
                    message: 'Gagal memuat kampanye',
                    submessage: controller.errorMessage,
                    onRetry: () => controller.loadMyCampaigns(
                      StorageService.getUserId() ?? '',
                    ),
                  );
                }

                final filteredCampaigns = controller.filteredCampaigns;

                // State 3: Empty
                if (filteredCampaigns.isEmpty) {
                  if (controller.activeFilter != 'Semua') {
                    return EmptyStateWidget(
                      icon: Icons.filter_list_off,
                      message: 'Tidak ada kampanye "${controller.activeFilter}"',
                      actionLabel: 'Reset Filter',
                      onAction: () => controller.setFilter('Semua'),
                    );
                  } else {
                    return EmptyStateWidget(
                      icon: Icons.campaign_outlined,
                      message: 'Belum Ada Kampanye',
                      submessage: 'Buat kampanye pertama kamu dan mulai promosi!',
                      actionLabel: 'Buat Kampanye',
                      onAction: () => Get.toNamed(Routes.campaignCreate),
                    );
                  }
                }

                // State 4: Data
                return RefreshIndicator(
                  onRefresh: () => controller.refreshCampaigns(
                    StorageService.getUserId() ?? '',
                  ),
                  color: AppColors.primary500,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      100, // Space untuk FAB
                    ),
                    itemCount: filteredCampaigns.length,
                    itemBuilder: (context, index) {
                      return CampaignCard(campaign: filteredCampaigns[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.campaignCreate),
        backgroundColor: AppColors.primary500,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Buat Campaign',
          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, CampaignController controller) {
    return Obx(() {
      final isActive = controller.activeFilter == label;
      return GestureDetector(
        onTap: () => controller.setFilter(label),
        child: Container(
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary500 : AppColors.grey100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? Colors.white : AppColors.grey700,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }
}
