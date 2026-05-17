import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../repositories/job_pool_repository.dart';

class GetActiveCampaignsJobPoolUseCase
    implements UseCase<List<CampaignEntity>, GetJobPoolParams> {
  final JobPoolRepository repository;

  GetActiveCampaignsJobPoolUseCase(this.repository);

  @override
  Future<Either<Failure, List<CampaignEntity>>> call(
    GetJobPoolParams params,
  ) async {
    return await repository.getActiveCampaigns(
      niche: params.niche,
      minHarga: params.minHarga,
      maxHarga: params.maxHarga,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetJobPoolParams {
  final String? niche;
  final double? minHarga;
  final double? maxHarga;
  final int limit;
  final int offset;

  const GetJobPoolParams({
    this.niche,
    this.minHarga,
    this.maxHarga,
    this.limit = 20,
    this.offset = 0,
  });
}
