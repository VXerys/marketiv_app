import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/pekerjaan_entity.dart';
import '../../domain/usecases/get_my_pekerjaan_usecase.dart';
import '../../domain/usecases/get_pekerjaan_by_id_usecase.dart';
import '../../domain/usecases/submit_bukti_tayang_usecase.dart';

class PekerjaanAktifController extends GetxController {
  final GetMyPekerjaanUseCase _getMyPekerjaanUseCase;
  final SubmitBuktiTayangUseCase _submitBuktiTayangUseCase;
  final GetPekerjaanByIdUseCase _getPekerjaanByIdUseCase;

  PekerjaanAktifController({
    required GetMyPekerjaanUseCase getMyPekerjaanUseCase,
    required SubmitBuktiTayangUseCase submitBuktiTayangUseCase,
    required GetPekerjaanByIdUseCase getPekerjaanByIdUseCase,
  })  : _getMyPekerjaanUseCase = getMyPekerjaanUseCase,
        _submitBuktiTayangUseCase = submitBuktiTayangUseCase,
        _getPekerjaanByIdUseCase = getPekerjaanByIdUseCase;

  final _pekerjaanList = <PekerjaanEntity>[].obs;
  final _selectedPekerjaan = Rxn<PekerjaanEntity>();
  final _isLoading = false.obs;
  final _isSubmitting = false.obs;
  final _errorMessage = ''.obs;
  final _selectedFilter = 'Semua'.obs;
  final _filteredPekerjaan = <PekerjaanEntity>[].obs;

  final urlBuktiController = TextEditingController();

  List<PekerjaanEntity> get pekerjaanList => _filteredPekerjaan;
  PekerjaanEntity? get selectedPekerjaan => _selectedPekerjaan.value;
  bool get isLoading => _isLoading.value;
  bool get isSubmitting => _isSubmitting.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  String get errorMessage => _errorMessage.value;
  String get selectedFilter => _selectedFilter.value;

  static const List<String> filterOptions = [
    'Semua',
    'Pending',
    'Valid',
    'Fraud',
  ];

  @override
  void onInit() {
    super.onInit();
    loadPekerjaan();
  }

  Future<void> loadPekerjaan() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final kreatorId = StorageService.getUserId() ?? '';
    final result = await _getMyPekerjaanUseCase(kreatorId);

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
        _pekerjaanList.assignAll(data);
        _applyFilter(_selectedFilter.value);
      },
    );

    _isLoading.value = false;
  }

  void _applyFilter(String filter) {
    _selectedFilter.value = filter;
    if (filter == 'Semua') {
      _filteredPekerjaan.assignAll(_pekerjaanList);
    } else {
      _filteredPekerjaan.assignAll(
        _pekerjaanList.where((pekerjaan) {
          return pekerjaan.statusValidasi == filter;
        }).toList(),
      );
    }
  }

  void filterByStatus(String filter) {
    _applyFilter(filter);
  }

  void selectPekerjaan(PekerjaanEntity pekerjaan) {
    _selectedPekerjaan.value = pekerjaan;
    urlBuktiController.text = pekerjaan.urlBuktiTayang ?? '';
  }

  Future<void> refreshSelectedPekerjaan() async {
    if (_selectedPekerjaan.value == null) {
      return;
    }

    final result = await _getPekerjaanByIdUseCase(_selectedPekerjaan.value!.id);
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (pekerjaan) {
        _selectedPekerjaan.value = pekerjaan;
        final index = _pekerjaanList.indexWhere((item) {
          return item.id == pekerjaan.id;
        });
        if (index != -1) {
          _pekerjaanList[index] = pekerjaan;
          _applyFilter(_selectedFilter.value);
        }
      },
    );
  }

  Future<void> submitBuktiTayang() async {
    if (_selectedPekerjaan.value == null) {
      return;
    }

    final url = urlBuktiController.text.trim();
    if (url.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Link video tidak boleh kosong',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isValidUrl = url.startsWith('https://www.tiktok.com/') ||
        url.startsWith('https://www.instagram.com/');
    if (!isValidUrl) {
      Get.snackbar(
        'URL Tidak Valid',
        'Link harus berupa URL TikTok (https://www.tiktok.com/...) atau Instagram (https://www.instagram.com/...)',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isSubmitting.value = true;

    final result = await _submitBuktiTayangUseCase(
      SubmitBuktiParams(
        submissionId: _selectedPekerjaan.value!.id,
        urlBukti: url,
      ),
    );

    result.fold(
      (failure) => Get.snackbar(
        'Gagal Submit',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (updated) {
        _selectedPekerjaan.value = updated;
        final index = _pekerjaanList.indexWhere((pekerjaan) {
          return pekerjaan.id == updated.id;
        });
        if (index != -1) {
          _pekerjaanList[index] = updated;
          _applyFilter(_selectedFilter.value);
        }
        Get.back();
        Get.snackbar(
          'Berhasil! ✅',
          'Bukti tayang berhasil disubmit. Menunggu validasi dari tim kami.',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );

    _isSubmitting.value = false;
  }

  @override
  void onClose() {
    urlBuktiController.dispose();
    super.onClose();
  }
}
