import 'package:get/get.dart';

import '../../../../core/services/appwrite_service.dart';
import '../../data/datasources/job_pool_remote_datasource.dart';
import '../../data/repositories/job_pool_repository_impl.dart';
import '../../domain/repositories/job_pool_repository.dart';
import '../../domain/usecases/check_already_claimed_usecase.dart';
import '../../domain/usecases/claim_campaign_usecase.dart';
import '../../domain/usecases/get_active_campaigns_job_pool_usecase.dart';
import '../../domain/usecases/get_campaign_detail_job_pool_usecase.dart';
import '../controllers/job_pool_controller.dart';

class JobPoolBinding extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource
    Get.lazyPut<JobPoolRemoteDataSource>(
      () => JobPoolRemoteDataSourceImpl(
        databases: AppwriteService.databases,
        functions: AppwriteService.functions,
      ),
    );

    // 2. Repository
    Get.lazyPut<JobPoolRepository>(
      () => JobPoolRepositoryImpl(dataSource: Get.find()),
    );

    // 3. UseCases
    Get.lazyPut(() => GetActiveCampaignsJobPoolUseCase(Get.find()));
    Get.lazyPut(() => GetCampaignDetailJobPoolUseCase(Get.find()));
    Get.lazyPut(() => ClaimCampaignUseCase(Get.find()));
    Get.lazyPut(() => CheckAlreadyClaimedUseCase(Get.find()));

    // 4. Controller
    Get.lazyPut(
      () => JobPoolController(
        getActiveCampaignsUseCase: Get.find(),
        getCampaignDetailUseCase: Get.find(),
        claimCampaignUseCase: Get.find(),
        checkAlreadyClaimedUseCase: Get.find(),
      ),
    );
  }
}
