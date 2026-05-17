import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/submission_entity.dart';
import '../repositories/job_pool_repository.dart';

class ClaimCampaignUseCase
    implements UseCase<SubmissionEntity, ClaimCampaignParams> {
  final JobPoolRepository repository;

  ClaimCampaignUseCase(this.repository);

  @override
  Future<Either<Failure, SubmissionEntity>> call(
    ClaimCampaignParams params,
  ) async {
    return await repository.claimCampaign(params.campaignId, params.kreatorId);
  }
}

class ClaimCampaignParams extends Equatable {
  final String campaignId;
  final String kreatorId;

  const ClaimCampaignParams({
    required this.campaignId,
    required this.kreatorId,
  });

  @override
  List<Object?> get props => [campaignId, kreatorId];
}
