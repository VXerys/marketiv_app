import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/campaign_entity.dart';
import '../repositories/campaign_repository.dart';

class GetCampaignByIdUseCase implements UseCase<CampaignEntity, String> {
  final CampaignRepository repository;

  GetCampaignByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CampaignEntity>> call(String id) async {
    return await repository.getCampaignById(id);
  }
}
