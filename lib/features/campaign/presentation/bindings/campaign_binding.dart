import 'package:get/get.dart';
import '../../../../core/services/appwrite_service.dart';
import '../../data/datasources/campaign_remote_datasource.dart';
import '../../data/repositories/campaign_repository_impl.dart';
import '../../domain/repositories/campaign_repository.dart';
import '../../domain/usecases/get_my_campaigns_usecase.dart';
import '../../domain/usecases/get_active_campaigns_usecase.dart';
import '../../domain/usecases/get_campaign_by_id_usecase.dart';
import '../../domain/usecases/create_campaign_usecase.dart';
import '../../domain/usecases/generate_brief_usecase.dart';
import '../controllers/campaign_controller.dart';
import '../controllers/create_campaign_controller.dart';

class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource
    Get.lazyPut<CampaignRemoteDataSource>(
      () => CampaignRemoteDataSourceImpl(
        databases: AppwriteService.databases,
        functions: AppwriteService.functions,
      ),
    );

    // 2. Repository
    Get.lazyPut<CampaignRepository>(
      () => CampaignRepositoryImpl(remoteDataSource: Get.find()),
    );

    // 3. UseCases
    Get.lazyPut(() => GetMyCampaignsUseCase(Get.find()));
    Get.lazyPut(() => GetActiveCampaignsUseCase(Get.find()));
    Get.lazyPut(() => GetCampaignByIdUseCase(Get.find()));
    Get.lazyPut(() => CreateCampaignUseCase(Get.find()));
    Get.lazyPut(() => GenerateBriefUseCase(Get.find()));

    // 4. Controller
    Get.lazyPut(
      () => CampaignController(
        getMyCampaignsUseCase: Get.find(),
        getActiveCampaignsUseCase: Get.find(),
        getCampaignByIdUseCase: Get.find(),
        createCampaignUseCase: Get.find(),
        generateBriefUseCase: Get.find(),
      ),
    );

    // CreateCampaignController — terpisah dari CampaignController
    Get.lazyPut<CreateCampaignController>(
      () => CreateCampaignController(
        createCampaignUseCase: Get.find(),
        generateBriefUseCase: Get.find(),
      ),
    );
  }
}
