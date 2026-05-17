import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../../domain/usecases/check_already_claimed_usecase.dart';
import '../../domain/usecases/claim_campaign_usecase.dart';
import '../../domain/usecases/get_active_campaigns_job_pool_usecase.dart';
import '../../domain/usecases/get_campaign_detail_job_pool_usecase.dart';

class JobPoolController extends GetxController {
  final GetActiveCampaignsJobPoolUseCase _getActiveCampaignsUseCase;
  final GetCampaignDetailJobPoolUseCase _getCampaignDetailUseCase;
  final ClaimCampaignUseCase _claimCampaignUseCase;
  final CheckAlreadyClaimedUseCase _checkAlreadyClaimedUseCase;

  JobPoolController({
    required GetActiveCampaignsJobPoolUseCase getActiveCampaignsUseCase,
    required GetCampaignDetailJobPoolUseCase getCampaignDetailUseCase,
    required ClaimCampaignUseCase claimCampaignUseCase,
    required CheckAlreadyClaimedUseCase checkAlreadyClaimedUseCase,
  })  : _getActiveCampaignsUseCase = getActiveCampaignsUseCase,
        _getCampaignDetailUseCase = getCampaignDetailUseCase,
        _claimCampaignUseCase = claimCampaignUseCase,
        _checkAlreadyClaimedUseCase = checkAlreadyClaimedUseCase;

  final _campaigns = <CampaignEntity>[].obs;
  final _filteredCampaigns = <CampaignEntity>[].obs;
  final _selectedCampaign = Rxn<CampaignEntity>();
  final _isLoading = false.obs;
  final _isLoadingDetail = false.obs;
  final _isClaiming = false.obs;
  final _errorMessage = ''.obs;
  final _selectedNiche = Rxn<String>();
  final _alreadyClaimed = false.obs;
  final _hasMoreData = true.obs;
  final _currentOffset = 0.obs;

  List<CampaignEntity> get campaigns => _filteredCampaigns;
  CampaignEntity? get selectedCampaign => _selectedCampaign.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingDetail => _isLoadingDetail.value;
  bool get isClaiming => _isClaiming.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  String get errorMessage => _errorMessage.value;
  String? get selectedNiche => _selectedNiche.value;
  bool get alreadyClaimed => _alreadyClaimed.value;
  bool get hasMoreData => _hasMoreData.value;

  static const List<String> nicheOptions = [
    'Kuliner',
    'Fesyen',
    'Pariwisata',
    'Edukasi',
    'Kecantikan',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    loadCampaigns();
  }

  Future<void> loadCampaigns({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOffset.value = 0;
      _hasMoreData.value = true;
      _campaigns.clear();
    }

    if (!_hasMoreData.value && !isRefresh) {
      return;
    }

    if (_campaigns.isEmpty) {
      _isLoading.value = true;
    }
    _errorMessage.value = '';

    final result = await _getActiveCampaignsUseCase(
      GetJobPoolParams(
        niche: _selectedNiche.value,
        limit: 20,
        offset: _currentOffset.value,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Memuat',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        if (isRefresh) {
          _campaigns.assignAll(data);
        } else {
          _campaigns.addAll(data);
        }
        _filteredCampaigns.assignAll(_campaigns);
        if (data.length < 20) {
          _hasMoreData.value = false;
        }
        _currentOffset.value += data.length;
      },
    );

    _isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (_isLoading.value || !_hasMoreData.value) {
      return;
    }
    await loadCampaigns();
  }

  Future<void> filterByNiche(String? niche) async {
    _selectedNiche.value = niche;
    await loadCampaigns(isRefresh: true);
  }

  Future<void> selectCampaign(String campaignId) async {
    _isLoadingDetail.value = true;
    _errorMessage.value = '';
    _alreadyClaimed.value = false;

    final kreatorId = StorageService.getUserId() ?? '';
    final results = await Future.wait<Object>([
      _getCampaignDetailUseCase(campaignId),
      _checkAlreadyClaimedUseCase(
        ClaimCampaignParams(
          campaignId: campaignId,
          kreatorId: kreatorId,
        ),
      ),
    ]);

    final detailResult = results[0] as Either<Failure, CampaignEntity>;
    final claimedResult = results[1] as Either<Failure, bool>;

    detailResult.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (campaign) {
        _selectedCampaign.value = campaign;
      },
    );

    claimedResult.fold(
      (_) {},
      (claimed) {
        _alreadyClaimed.value = claimed;
      },
    );

    _isLoadingDetail.value = false;
  }

  Future<void> claimCampaign() async {
    if (_selectedCampaign.value == null) {
      return;
    }

    if (_alreadyClaimed.value) {
      Get.snackbar(
        'Perhatian',
        'Kamu sudah mengklaim kampanye ini',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    _isClaiming.value = true;

    final kreatorId = StorageService.getUserId() ?? '';
    final result = await _claimCampaignUseCase(
      ClaimCampaignParams(
        campaignId: _selectedCampaign.value!.id,
        kreatorId: kreatorId,
      ),
    );

    result.fold(
      (failure) => Get.snackbar(
        'Gagal Klaim',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) {
        _alreadyClaimed.value = true;
        Get.back();
        Get.snackbar(
          'Berhasil!',
          'Kampanye berhasil diklaim. Selamat berkarya!',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        loadCampaigns(isRefresh: true);
      },
    );

    _isClaiming.value = false;
  }
}
