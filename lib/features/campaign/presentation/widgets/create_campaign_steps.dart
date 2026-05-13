import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/warning_banner.dart';
import '../controllers/create_campaign_controller.dart';

/// Step 1: Informasi Produk (Private)
class Step1InfoProduk extends StatelessWidget {
  const Step1InfoProduk({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ceritakan Produkmu',
            style: AppTextStyles.h3,
          ),
          Text(
            'Isi informasi dasar agar kreator tahu apa yang akan mereka promosikan.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Nama Produk / Judul Campaign
          TextField(
            controller: controller.judulController,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Nama Produk / Judul Campaign *',
              hintText: 'cth: Ayam Geprek Special Bu Sari',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Label Deskripsi & AI Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Instruksi untuk Kreator (Brief) *',
                style: AppTextStyles.labelMedium,
              ),
              Obx(() {
                if (controller.isGeneratingBrief) {
                  return const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return TextButton.icon(
                  onPressed: controller.generateAiBrief,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  icon: const Text('✨'),
                  label: const Text('Bantu dengan AI'),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // Deskripsi/Brief
          TextField(
            controller: controller.deskripsiController,
            maxLines: 6,
            maxLength: 1000,
            decoration: const InputDecoration(
              hintText: 'Ceritakan apa yang kamu ingin kreator sampaikan...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),

          // AI generated hint
          Obx(() {
            if (controller.isAiGenerated) {
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    const Text('✨ ', style: TextStyle(fontSize: 12)),
                    Text(
                      'Draf oleh AI — silakan edit sesuai kebutuhan',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: AppSpacing.md),

          // Kategori/Niche
          const Text(
            'Kategori Produk *',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() {
            const niches = [
              'Kuliner 🍽',
              'Fesyen 👗',
              'Pariwisata 🏝',
              'Edukasi 📚',
              'Kecantikan 💄',
              'Lainnya'
            ];
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: niches.map((niche) {
                final isSelected = controller.selectedNiche == niche;
                return ChoiceChip(
                  label: Text(niche),
                  selected: isSelected,
                  onSelected: (_) => controller.selectNiche(niche),
                  selectedColor: AppColors.primary100,
                  backgroundColor: AppColors.grey100,
                  labelStyle: isSelected
                      ? AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary600,
                          fontWeight: FontWeight.bold,
                        )
                      : AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey700,
                        ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

/// Step 2: Upload Aset (Private)
class Step2UploadAset extends StatelessWidget {
  const Step2UploadAset({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aset Materi Promosi',
            style: AppTextStyles.h3,
          ),
          Text(
            'Berikan bahan mentah (foto/video produk) untuk kreator.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),

          const WarningBanner(
            message:
                '📌 Untuk video bahan mentah berukuran besar, WAJIB gunakan link Google Drive. Marketiv tidak menyimpan file video secara internal.',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Opsi A
          const Text(
            'Opsi A — Link Google Drive / Dropbox',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: controller.urlDriveController,
            onChanged: controller.onUrlDriveChanged,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: 'https://drive.google.com/...',
              prefixIcon: Icon(Icons.link),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Link harus bisa diakses siapapun (public link)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Divider ATAU
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'ATAU',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Opsi B
          const Text(
            'Opsi B — Upload Foto Produk (maks. 100 MB)',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () {
              // Placeholder untuk image_picker
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.grey300),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    color: AppColors.grey300,
                    size: 40,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Ketuk untuk pilih foto',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Success indicator
          Obx(() {
            final hasUrl = controller.urlDriveController.text.startsWith('https://');
            if (controller.hasAset || hasUrl) {
              return Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Aset siap!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

/// Step 3: Budget & Kuota (Private)
class Step3BudgetKuota extends StatelessWidget {
  const Step3BudgetKuota({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tentukan Anggaran', style: AppTextStyles.h3),
          Text(
            'Bayaran dihitung dari jumlah tayangan nyata yang didapat kreator.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Harga per 1000 Views
          const Text('Harga per 1.000 Tayangan (Views) *', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: controller.hargaController,
            keyboardType: TextInputType.number,
            onChanged: (_) => controller.update(),
            decoration: const InputDecoration(
              hintText: 'cth: 5000',
              prefixText: 'Rp ',
              prefixStyle: TextStyle(color: AppColors.grey700),
              border: OutlineInputBorder(),
              suffixText: '/ 1.000 views',
            ),
          ),
          Text(
            'Rentang yang disarankan: Rp 2.000 – Rp 10.000',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.md),

          // Jumlah Kreator
          const Text('Jumlah Kreator yang Dibutuhkan *', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final val = (int.tryParse(controller.kuotaController.text) ?? 1) - 1;
                    if (val >= 1) {
                      controller.kuotaController.text = val.toString();
                      controller.update();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller.kuotaController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (_) => controller.update(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final val = (int.tryParse(controller.kuotaController.text) ?? 1) + 1;
                    if (val <= 100) {
                      controller.kuotaController.text = val.toString();
                      controller.update();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Summary Biaya
          GetBuilder<CreateCampaignController>(
            builder: (c) => _buildCostSummary(c),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummary(CreateCampaignController c) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Column(
        children: [
          _CostRow('Budget Kampanye', c.budgetKampanye),
          const Divider(height: AppSpacing.sm),
          _CostRow('Komisi Platform 15%', c.komisiPlatform),
          const Divider(height: AppSpacing.sm),
          _CostRow('Total yang Dibayar', c.totalBayar, isTotal: true),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _CostRow(this.label, this.amount, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.labelMedium.copyWith(color: AppColors.primary600)
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
        ),
        Text(
          formatter.format(amount),
          style: isTotal
              ? AppTextStyles.labelMedium.copyWith(color: AppColors.primary600, fontWeight: FontWeight.bold)
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
        ),
      ],
    );
  }
}

/// Step 4: Review & Bayar (Private)
class Step4ReviewBayar extends StatelessWidget {
  const Step4ReviewBayar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Review Campaign', style: AppTextStyles.h3),
          Text(
            'Cek kembali sebelum memulai kampanye.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),

          _ReviewCard(
            title: 'Detail Kampanye',
            stepIndex: 0,
            onEdit: () => controller.goToStep(0),
            children: [
              _ReviewItem('Judul', controller.judulController.text),
              _ReviewItem('Kategori', controller.selectedNiche),
              _ReviewItem(
                'Brief',
                controller.deskripsiController.text,
                maxLines: 4,
              ),
              _ReviewItem(
                'Aset',
                controller.urlDriveController.text.isNotEmpty
                    ? '✓ Link Drive tersedia'
                    : '✓ Foto produk dipilih',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          _ReviewCard(
            title: 'Rincian Biaya',
            stepIndex: 2,
            onEdit: () => controller.goToStep(2),
            children: [
              _ReviewItem('Harga/1000 views', 'Rp ${controller.hargaController.text} / 1.000 views'),
              _ReviewItem('Kuota kreator', '${controller.kuotaController.text} kreator'),
              _ReviewItem('Budget kampanye', formatter.format(controller.budgetKampanye)),
              _ReviewItem('Komisi platform', '15% = ${formatter.format(controller.komisiPlatform)}'),
              const Divider(),
              _ReviewItem(
                'Total dibayar',
                formatter.format(controller.totalBayar),
                isBold: true,
                color: AppColors.primary600,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(
              '💡 Dana kampanye akan ditahan dalam sistem escrow dan hanya cair ke kreator setelah tayangan tervalidasi.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final int stepIndex;
  final VoidCallback onEdit;
  final List<Widget> children;

  const _ReviewCard({
    required this.title,
    required this.stepIndex,
    required this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey700),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final String value;
  final int? maxLines;
  final bool isBold;
  final Color? color;

  const _ReviewItem(
    this.label,
    this.value, {
    this.maxLines,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? AppColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
