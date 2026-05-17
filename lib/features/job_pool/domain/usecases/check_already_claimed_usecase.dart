import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/job_pool_repository.dart';
import 'claim_campaign_usecase.dart';

class CheckAlreadyClaimedUseCase implements UseCase<bool, ClaimCampaignParams> {
  final JobPoolRepository repository;

  CheckAlreadyClaimedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ClaimCampaignParams params) async {
    return await repository.checkAlreadyClaimed(
      params.campaignId,
      params.kreatorId,
    );
  }
}
