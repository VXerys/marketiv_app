---
name: form-wizard
description: >
  Pola multi-step form (wizard) untuk Marketiv Flutter app, khususnya CreateCampaignPage
  yang terdiri dari 4 langkah. Gunakan skill ini saat user meminta membuat form panjang
  multi-step, wizard pembuatan campaign, stepper dengan validasi per langkah, atau form
  apapun yang perlu dipecah menjadi beberapa tahap. Juga trigger saat user bertanya
  tentang cara validasi per step, cara menyimpan state form sementara, cara buat progress
  indicator, atau cara navigate antar step dengan GetX.
---

# Form Wizard — Marketiv

## Pola Umum: CreateCampaignPage (4 Step)

```
Step 1: Informasi Produk   (judul, deskripsi, niche, tombol AI Brief)
Step 2: Upload Aset        (image picker ATAU URL Drive, warning banner)
Step 3: Budget & Kuota     (harga/1000views, kuota kreator, ringkasan biaya)
Step 4: Review & Bayar     (semua data read-only, tombol bayar)
```

---

## WizardController — Pola State Management

```dart
// lib/features/campaign/presentation/controllers/create_campaign_controller.dart
class CreateCampaignController extends GetxController {
  // Step management
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;
  static const int totalSteps = 4;

  // Form state — simpan semua field di controller
  // Step 1
  final judulController   = TextEditingController();
  final deskripsiController = TextEditingController();
  final _selectedNiche    = ''.obs;
  String get selectedNiche => _selectedNiche.value;

  // Step 2
  File? selectedImage;
  final urlDriveController = TextEditingController();
  final _isImageSelected  = false.obs;
  bool get isImageSelected => _isImageSelected.value;

  // Step 3
  final hargaController   = TextEditingController();
  final kuotaController   = TextEditingController();
  final _isLoading        = false.obs;
  bool get isLoading      => _isLoading.value;

  // Computed — biaya
  double get hargaPer1000 => double.tryParse(hargaController.text.replaceAll('.', '')) ?? 0;
  double get kuota        => double.tryParse(kuotaController.text) ?? 0;
  double get budgetKampanye => hargaPer1000 * kuota * 10; // estimasi 10rb views per kreator
  double get komisiPlatform => budgetKampanye * 0.15;
  double get totalBayar   => budgetKampanye + komisiPlatform;

  // Navigasi step
  void nextStep() {
    if (!_validateCurrentStep()) return;
    if (_currentStep.value < totalSteps - 1) {
      _currentStep.value++;
    }
  }

  void prevStep() {
    if (_currentStep.value > 0) _currentStep.value--;
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) _currentStep.value = step;
  }

  // Validasi per step
  bool _validateCurrentStep() {
    switch (_currentStep.value) {
      case 0: return _validateStep1();
      case 1: return _validateStep2();
      case 2: return _validateStep3();
      default: return true;
    }
  }

  bool _validateStep1() {
    if (judulController.text.trim().isEmpty) {
      Get.snackbar('Wajib Diisi', 'Judul campaign tidak boleh kosong.');
      return false;
    }
    if (deskripsiController.text.trim().length < 50) {
      Get.snackbar('Terlalu Pendek', 'Deskripsi minimal 50 karakter.');
      return false;
    }
    if (_selectedNiche.value.isEmpty) {
      Get.snackbar('Wajib Diisi', 'Pilih niche campaign terlebih dahulu.');
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    final hasImage = selectedImage != null;
    final hasUrl   = urlDriveController.text.trim().startsWith('https://');
    if (!hasImage && !hasUrl) {
      Get.snackbar('Aset Diperlukan',
          'Upload foto produk ATAU masukkan link Google Drive.');
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    final harga = double.tryParse(hargaController.text.replaceAll('.', ''));
    if (harga == null || harga < 2000 || harga > 10000) {
      Get.snackbar('Harga Tidak Valid',
          'Harga per 1.000 views harus antara Rp 2.000 - Rp 10.000.');
      return false;
    }
    final kuotaVal = int.tryParse(kuotaController.text);
    if (kuotaVal == null || kuotaVal < 1 || kuotaVal > 100) {
      Get.snackbar('Kuota Tidak Valid', 'Kuota kreator harus antara 1 - 100.');
      return false;
    }
    return true;
  }

  void selectNiche(String niche) => _selectedNiche.value = niche;

  void onImageSelected(File file) {
    // Validasi ukuran (maks 100MB)
    final sizeMB = file.lengthSync() / (1024 * 1024);
    if (sizeMB > 100) {
      Get.snackbar('File Terlalu Besar',
          'File melebihi 100MB. Gunakan link Google Drive/Dropbox.');
      return;
    }
    selectedImage = file;
    _isImageSelected.value = true;
    urlDriveController.clear(); // clear URL jika pilih file
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    urlDriveController.dispose();
    hargaController.dispose();
    kuotaController.dispose();
    super.onClose();
  }
}
```

---

## CreateCampaignPage — Layout

```dart
// lib/features/campaign/presentation/pages/create_campaign_page.dart
class CreateCampaignPage extends StatelessWidget {
  const CreateCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buat Campaign Baru'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Obx(() => controller.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.prevStep,
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              )),
      ),
      body: Column(
        children: [
          // Progress indicator
          Obx(() => _WizardProgressBar(
                currentStep: controller.currentStep,
                totalSteps: CreateCampaignController.totalSteps,
              )),

          // Form content
          Expanded(
            child: Obx(() {
              switch (controller.currentStep) {
                case 0: return const _Step1InfoProduk();
                case 1: return const _Step2UploadAset();
                case 2: return const _Step3BudgetKuota();
                case 3: return const _Step4ReviewBayar();
                default: return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),

      // Bottom navigation button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          top: AppSpacing.sm,
        ),
        child: Obx(() => PrimaryButton(
              label: controller.currentStep < 3 ? 'Selanjutnya' : 'Bayar Sekarang',
              onPressed: controller.currentStep < 3
                  ? controller.nextStep
                  : controller.submitAndPay,
              isLoading: controller.isLoading,
              icon: controller.currentStep < 3 ? Icons.arrow_forward : Icons.payment,
            )),
      ),
    );
  }
}
```

---

## Progress Bar Widget

```dart
class _WizardProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _WizardProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent   = index == currentStep;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppColors.primary500
                              : AppColors.grey200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < totalSteps - 1) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Langkah ${currentStep + 1} dari $totalSteps',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Step 1 — Informasi Produk

```dart
class _Step1InfoProduk extends StatelessWidget {
  const _Step1InfoProduk();

  static const _niches = ['Kuliner', 'Fesyen', 'Pariwisata', 'Edukasi', 'Kecantikan', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCampaignController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Produk', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),

          // Judul
          TextField(
            controller: controller.judulController,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Nama Produk / Judul Campaign *',
              hintText: 'contoh: Dapur Sehat — Sambal Matah Khas Sukabumi',
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Deskripsi + Tombol AI
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              TextField(
                controller: controller.deskripsiController,
                maxLines: 6,
                maxLength: 1000,
                decoration: const InputDecoration(
                  labelText: 'Ceritakan Produk & Instruksi untuk Kreator *',
                  alignLabelWithHint: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm, bottom: 32),
                child: TextButton.icon(
                  onPressed: controller.generateAiBrief,
                  icon: const Text('✨', style: TextStyle(fontSize: 16)),
                  label: Text('Bantu dengan AI',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary500)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Niche selector
          Text('Kategori Produk *', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Obx(() => Wrap(
            spacing: AppSpacing.sm,
            children: _niches.map((niche) {
              final isSelected = controller.selectedNiche == niche;
              return ChoiceChip(
                label: Text(niche),
                selected: isSelected,
                onSelected: (_) => controller.selectNiche(niche),
                selectedColor: AppColors.primary100,
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary600 : AppColors.grey700,
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}
```

---

## Step 3 — Ringkasan Biaya (Kalkulasi Otomatis)

```dart
// Bagian ringkasan biaya di Step 3
Widget _buildCostSummary(CreateCampaignController controller) {
  return Obx(() => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.primary50,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(color: AppColors.primary100),
    ),
    child: Column(
      children: [
        _CostRow('Budget Kampanye', controller.budgetKampanye),
        const Divider(height: AppSpacing.md),
        _CostRow('Komisi Platform 15%', controller.komisiPlatform),
        const Divider(height: AppSpacing.md),
        _CostRow('Total yang Dibayar', controller.totalBayar, isTotal: true),
      ],
    ),
  ));
}

class _CostRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _CostRow(this.label, this.amount, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? AppTextStyles.labelMedium.copyWith(color: AppColors.primary600)
        : AppTextStyles.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
              .format(amount),
          style: style.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
```

---

## Validasi URL Eksternal

```dart
// Gunakan di Step 2 untuk validasi URL Drive
bool isValidExternalUrl(String url) {
  if (!url.startsWith('https://')) return false;
  // Opsional: batasi ke Google Drive atau Dropbox
  // return url.contains('drive.google.com') || url.contains('dropbox.com');
  return true;
}

bool isValidSocialMediaUrl(String url) {
  return url.startsWith('https://www.tiktok.com/') ||
         url.startsWith('https://www.instagram.com/');
}
```
