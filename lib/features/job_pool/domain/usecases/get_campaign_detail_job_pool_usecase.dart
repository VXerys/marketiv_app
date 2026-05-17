import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../repositories/job_pool_repository.dart';

class GetCampaignDetailJobPoolUseCase
    implements UseCase<CampaignEntity, String> {
  final JobPoolRepository repository;

  GetCampaignDetailJobPoolUseCase(this.repository);

  @override
  Future<Either<Failure, CampaignEntity>> call(String id) async {
    return await repository.getCampaignById(id);
  }
}
