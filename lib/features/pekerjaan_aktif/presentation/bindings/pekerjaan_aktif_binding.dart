import 'package:get/get.dart';

import '../../../../core/services/appwrite_service.dart';
import '../../data/datasources/pekerjaan_aktif_remote_datasource.dart';
import '../../data/repositories/pekerjaan_aktif_repository_impl.dart';
import '../../domain/repositories/pekerjaan_aktif_repository.dart';
import '../../domain/usecases/get_my_pekerjaan_usecase.dart';
import '../../domain/usecases/get_pekerjaan_by_id_usecase.dart';
import '../../domain/usecases/submit_bukti_tayang_usecase.dart';
import '../controllers/pekerjaan_aktif_controller.dart';

class PekerjaanAktifBinding extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource
    Get.lazyPut<PekerjaanAktifRemoteDataSource>(
      () => PekerjaanAktifRemoteDataSourceImpl(
        databases: AppwriteService.databases,
      ),
    );

    // 2. Repository
    Get.lazyPut<PekerjaanAktifRepository>(
      () => PekerjaanAktifRepositoryImpl(dataSource: Get.find()),
    );

    // 3. UseCases
    Get.lazyPut(() => GetMyPekerjaanUseCase(Get.find()));
    Get.lazyPut(() => SubmitBuktiTayangUseCase(Get.find()));
    Get.lazyPut(() => GetPekerjaanByIdUseCase(Get.find()));

    // 4. Controller
    Get.lazyPut(
      () => PekerjaanAktifController(
        getMyPekerjaanUseCase: Get.find(),
        submitBuktiTayangUseCase: Get.find(),
        getPekerjaanByIdUseCase: Get.find(),
      ),
    );
  }
}
