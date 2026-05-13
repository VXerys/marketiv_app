import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/usecases/get_my_campaigns_usecase.dart';
import '../../domain/usecases/get_active_campaigns_usecase.dart';
import '../../domain/usecases/get_campaign_by_id_usecase.dart';
import '../../domain/usecases/create_campaign_usecase.dart';
import '../../domain/usecases/generate_brief_usecase.dart';

class CampaignController extends GetxController {
  final GetMyCampaignsUseCase _getMyCampaignsUseCase;
  final GetActiveCampaignsUseCase _getActiveCampaignsUseCase;
  final GetCampaignByIdUseCase _getCampaignByIdUseCase;
  final CreateCampaignUseCase _createCampaignUseCase;
  final GenerateBriefUseCase _generateBriefUseCase;

  CampaignController({
    required GetMyCampaignsUseCase getMyCampaignsUseCase,
    required GetActiveCampaignsUseCase getActiveCampaignsUseCase,
    required GetCampaignByIdUseCase getCampaignByIdUseCase,
    required CreateCampaignUseCase createCampaignUseCase,
    required GenerateBriefUseCase generateBriefUseCase,
  })  : _getMyCampaignsUseCase = getMyCampaignsUseCase,
        _getActiveCampaignsUseCase = getActiveCampaignsUseCase,
        _getCampaignByIdUseCase = getCampaignByIdUseCase,
        _createCampaignUseCase = createCampaignUseCase,
        _generateBriefUseCase = generateBriefUseCase;

  // State
  final _campaigns = <CampaignEntity>[].obs;
  List<CampaignEntity> get campaigns => _campaigns;

  // Filter state
  final _activeFilter = 'Semua'.obs;
  String get activeFilter => _activeFilter.value;

  // List yang sudah difilter (client-side)
  List<CampaignEntity> get filteredCampaigns {
    if (_activeFilter.value == 'Semua') return _campaigns;
    return _campaigns.where((c) => c.status == _activeFilter.value).toList();
  }

  final _selectedCampaign = Rxn<CampaignEntity>();
  CampaignEntity? get selectedCampaign => _selectedCampaign.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isCreating = false.obs;
  bool get isCreating => _isCreating.value;

  final _isGeneratingBrief = false.obs;
  bool get isGeneratingBrief => _isGeneratingBrief.value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;

  // Form controllers
  final judulController = TextEditingController();
  final briefController = TextEditingController();
  final urlAsetController = TextEditingController();
  final hargaController = TextEditingController();
  final kuotaController = TextEditingController();
  final budgetController = TextEditingController();
  final selectedNiche = Rxn<String>();

  // Methods
  Future<void> loadMyCampaigns(String umkmId) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    final result = await _getMyCampaignsUseCase(GetMyCampaignsParams(umkmId: umkmId));
    
    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (data) => _campaigns.assignAll(data),
    );
    
    _isLoading.value = false;
  }

  // Alias untuk pull-to-refresh
  Future<void> refreshCampaigns(String umkmId) async {
    _isLoading.value = false; // Tidak tampilkan shimmer penuh
    await loadMyCampaigns(umkmId);
  }

  Future<void> loadActiveCampaigns({String? niche, double? minHarga, double? maxHarga}) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    final result = await _getActiveCampaignsUseCase(GetCampaignsParams(
      niche: niche,
      minHarga: minHarga,
      maxHarga: maxHarga,
    ));
    
    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (data) => _campaigns.assignAll(data),
    );
    
    _isLoading.value = false;
  }

  void setFilter(String filter) {
    _activeFilter.value = filter;
  }

  Future<void> selectCampaign(String id) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    final result = await _getCampaignByIdUseCase(id);
    
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar('Error', failure.message, snackPosition: SnackPosition.BOTTOM);
      },
      (data) => _selectedCampaign.value = data,
    );
    
    _isLoading.value = false;
  }

  void nextStep() {
    if (_currentStep.value < 3) {
      _currentStep.value++;
    }
  }

  void prevStep() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }

  void resetStep() {
    _currentStep.value = 0;
  }

  Future<void> generateBrief() async {
    if (judulController.text.isEmpty || selectedNiche.value == null) {
      Get.snackbar('Info', 'Judul dan Niche wajib diisi untuk bantu AI', 
        snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _isGeneratingBrief.value = true;
    
    final result = await _generateBriefUseCase(GenerateBriefParams(
      namaProduk: judulController.text,
      niche: selectedNiche.value!,
      deskripsi: briefController.text.isNotEmpty ? briefController.text : null,
    ));
    
    result.fold(
      (failure) => Get.snackbar('Error AI', failure.message, snackPosition: SnackPosition.BOTTOM),
      (brief) => briefController.text = brief,
    );
    
    _isGeneratingBrief.value = false;
  }

  Future<void> createCampaign(String umkmId) async {
    _isCreating.value = true;
    
    final params = CreateCampaignParams(
      judulCampaign: judulController.text,
      deskripsiBrief: briefController.text,
      urlAsetEksternal: urlAsetController.text,
      kuotaKreator: int.tryParse(kuotaController.text) ?? 0,
      hargaPer1000Views: double.tryParse(hargaController.text) ?? 0.0,
      totalBudgetEscrow: double.tryParse(budgetController.text) ?? 0.0,
      niche: selectedNiche.value,
    );

    final result = await _createCampaignUseCase(CreateCampaignWithUserParams(
      campaignParams: params,
      umkmId: umkmId,
    ));
    
    result.fold(
      (failure) => Get.snackbar('Gagal', failure.message, snackPosition: SnackPosition.BOTTOM),
      (success) {
        Get.snackbar('Sukses', 'Kampanye berhasil dibuat sebagai Draft', 
          snackPosition: SnackPosition.BOTTOM);
        resetStep();
        _clearForm();
        loadMyCampaigns(umkmId);
        Get.back();
      },
    );
    
    _isCreating.value = false;
  }

  void _clearForm() {
    judulController.clear();
    briefController.clear();
    urlAsetController.clear();
    hargaController.clear();
    kuotaController.clear();
    budgetController.clear();
    selectedNiche.value = null;
  }

  @override
  void onClose() {
    judulController.dispose();
    briefController.dispose();
    urlAsetController.dispose();
    hargaController.dispose();
    kuotaController.dispose();
    budgetController.dispose();
    super.onClose();
  }
}
