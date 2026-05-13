import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/usecases/create_campaign_usecase.dart';
import '../../domain/usecases/generate_brief_usecase.dart';
import 'campaign_controller.dart';

class CreateCampaignController extends GetxController {
  final CreateCampaignUseCase _createCampaignUseCase;
  final GenerateBriefUseCase _generateBriefUseCase;

  CreateCampaignController({
    required CreateCampaignUseCase createCampaignUseCase,
    required GenerateBriefUseCase generateBriefUseCase,
  })  : _createCampaignUseCase = createCampaignUseCase,
        _generateBriefUseCase = generateBriefUseCase;

  // --- Step Management ---
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;
  static const int totalSteps = 4;

  // --- Step 1: Form ---
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final _selectedNiche = ''.obs;
  String get selectedNiche => _selectedNiche.value;

  final _isGeneratingBrief = false.obs;
  bool get isGeneratingBrief => _isGeneratingBrief.value;

  final _isAiGenerated = false.obs;
  bool get isAiGenerated => _isAiGenerated.value;

  // --- Step 2: Aset ---
  final _urlDriveController = TextEditingController();
  TextEditingController get urlDriveController => _urlDriveController;
  
  final _hasAset = false.obs;
  bool get hasAset => _hasAset.value;

  // --- Step 3: Budget ---
  final hargaController = TextEditingController();
  final kuotaController = TextEditingController();
  
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // --- Computed Getters ---
  double get hargaPer1000Views => 
      double.tryParse(hargaController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;

  int get kuotaKreator => int.tryParse(kuotaController.text) ?? 0;

  double get budgetKampanye => hargaPer1000Views * kuotaKreator * 10; // estimasi 10rb views/kreator

  double get komisiPlatform => budgetKampanye * 0.15;

  double get totalBayar => budgetKampanye + komisiPlatform;

  // --- Navigation ---
  void nextStep() {
    bool isValid = false;
    if (_currentStep.value == 0) {
      isValid = _validateStep1();
    } else if (_currentStep.value == 1) {
      isValid = _validateStep2();
    } else if (_currentStep.value == 2) {
      isValid = _validateStep3();
    } else {
      isValid = true; // Step 4 (Summary) usually doesn't need field validation before submit
    }

    if (isValid && _currentStep.value < totalSteps - 1) {
      _currentStep.value++;
    }
  }

  void prevStep() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep.value = step;
    }
  }

  // --- Validations ---
  bool _validateStep1() {
    if (judulController.text.trim().isEmpty) {
      _showSnackbar('Judul tidak boleh kosong', isError: true);
      return false;
    }
    if (deskripsiController.text.trim().length < 50) {
      _showSnackbar('Deskripsi minimal 50 karakter', isError: true);
      return false;
    }
    if (_selectedNiche.isEmpty) {
      _showSnackbar('Niche wajib dipilih', isError: true);
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    final url = _urlDriveController.text.trim();
    if (url.startsWith('https://') || _hasAset.value) {
      return true;
    }
    _showSnackbar('Upload foto ATAU masukkan link Google Drive', isError: true);
    return false;
  }

  bool _validateStep3() {
    final harga = hargaPer1000Views;
    final kuota = kuotaKreator;

    if (harga < 2000 || harga > 10000) {
      _showSnackbar('Harga per 1000 views antara Rp 2.000 - Rp 10.000', isError: true);
      return false;
    }
    if (kuota < 1 || kuota > 100) {
      _showSnackbar('Kuota kreator antara 1 - 100', isError: true);
      return false;
    }
    return true;
  }

  // --- Methods ---
  void selectNiche(String niche) {
    _selectedNiche.value = niche;
  }

  void onUrlDriveChanged(String url) {
    // Update _hasAset true jika ada URL valid, tapi jangan matikan jika user sudah upload manual
    if (url.trim().startsWith('https://')) {
      _hasAset.value = true;
    } else if (url.trim().isEmpty) {
      // Logic sederhana: jika URL kosong, _hasAset jadi false 
      // (kecuali ada flag upload file yang berbeda, tapi di sini disatukan)
      _hasAset.value = false;
    }
  }

  Future<void> generateAiBrief() async {
    if (judulController.text.trim().isEmpty || _selectedNiche.isEmpty) {
      _showSnackbar('Judul dan Niche wajib diisi dulu', isWarning: true);
      return;
    }

    _isGeneratingBrief.value = true;

    final params = GenerateBriefParams(
      namaProduk: judulController.text.trim(),
      niche: _selectedNiche.value,
      deskripsi: deskripsiController.text.isNotEmpty ? deskripsiController.text : null,
    );

    final result = await _generateBriefUseCase(params);

    result.fold(
      (failure) => _showSnackbar(failure.message, isWarning: true),
      (generatedBrief) {
        deskripsiController.text = generatedBrief;
        _isAiGenerated.value = true;
      },
    );

    _isGeneratingBrief.value = false;
  }

  Future<void> createCampaign() async {
    _isLoading.value = true;

    final umkmId = StorageService.getUserId();
    if (umkmId == null) {
      _showSnackbar('Sesi berakhir, silakan login kembali', isError: true);
      _isLoading.value = false;
      return;
    }

    final campaignParams = CreateCampaignParams(
      judulCampaign: judulController.text.trim(),
      deskripsiBrief: deskripsiController.text.trim(),
      urlAsetEksternal: _urlDriveController.text.trim(),
      kuotaKreator: kuotaKreator,
      hargaPer1000Views: hargaPer1000Views,
      totalBudgetEscrow: totalBayar, // Menggunakan total yang harus dibayar UMKM ke escrow
      niche: _selectedNiche.value,
    );

    final result = await _createCampaignUseCase(CreateCampaignWithUserParams(
      campaignParams: campaignParams,
      umkmId: umkmId,
    ));

    result.fold(
      (failure) => _showSnackbar(failure.message, isError: true),
      (campaign) {
        _showSnackbar('Kampanye berhasil dibuat!', isSuccess: true);
        
        // Refresh list di CampaignController jika ada
        if (Get.isRegistered<CampaignController>()) {
          Get.find<CampaignController>().refreshCampaigns(umkmId);
        }
        
        Get.back();
      },
    );

    _isLoading.value = false;
  }

  // --- Helpers ---
  void _showSnackbar(String message, {bool isError = false, bool isWarning = false, bool isSuccess = false}) {
    Color bgColor = AppColors.info;
    if (isError) bgColor = AppColors.danger;
    if (isWarning) bgColor = AppColors.warning;
    if (isSuccess) bgColor = AppColors.success;

    Get.snackbar(
      isError ? 'Gagal' : (isSuccess ? 'Sukses' : 'Info'),
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    _urlDriveController.dispose();
    hargaController.dispose();
    kuotaController.dispose();
    super.onClose();
  }
}
