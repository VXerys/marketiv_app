import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../controllers/create_campaign_controller.dart';
import '../widgets/create_campaign_steps.dart';

class CreateCampaignPage extends StatelessWidget {
  const CreateCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Obx(() {
          if (controller.currentStep == 0) {
            return IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _confirmCancel(context),
            );
          }
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.prevStep,
          );
        }),
        title: Obx(() {
          switch (controller.currentStep) {
            case 0:
              return const Text('Informasi Produk');
            case 1:
              return const Text('Aset Promosi');
            case 2:
              return const Text('Anggaran & Kuota');
            case 3:
              return const Text('Review & Bayar');
            default:
              return const Text('Buat Kampanye');
          }
        }),
      ),
      body: Column(
        children: [
          Obx(() => _WizardProgressBar(currentStep: controller.currentStep)),
          Expanded(
            child: Obx(() {
              switch (controller.currentStep) {
                case 0:
                  return const Step1InfoProduk();
                case 1:
                  return const Step2UploadAset();
                case 2:
                  return const Step3BudgetKuota();
                case 3:
                  return const Step4ReviewBayar();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Obx(() {
            final isFinalStep = controller.currentStep == 3;
            final isButtonDisabled =
                controller.isLoading || controller.isGeneratingBrief;

            return PrimaryButton(
              label: isFinalStep ? 'Bayar Sekarang' : 'Selanjutnya →',
              icon: isFinalStep ? Icons.payment_outlined : Icons.arrow_forward,
              isLoading: controller.isLoading,
              onPressed: isButtonDisabled
                  ? null
                  : (isFinalStep
                      ? controller.createCampaign
                      : controller.nextStep),
            );
          }),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Batalkan Campaign?'),
        content: const Text('Progress yang sudah diisi akan hilang.'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Lanjut Isi'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Tutup dialog
              Get.back(); // Kembali ke halaman sebelumnya
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }
}

class _WizardProgressBar extends StatelessWidget {
  final int currentStep;

  const _WizardProgressBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(4, (i) {
              final isCompleted = i <= currentStep;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primary500
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < 3) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Langkah ${currentStep + 1} dari 4',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}
