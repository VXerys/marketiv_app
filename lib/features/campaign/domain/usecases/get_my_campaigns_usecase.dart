import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/campaign_entity.dart';
import '../repositories/campaign_repository.dart';

class GetMyCampaignsUseCase implements UseCase<List<CampaignEntity>, GetMyCampaignsParams> {
  final CampaignRepository repository;

  GetMyCampaignsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CampaignEntity>>> call(GetMyCampaignsParams params) async {
    return await repository.getMyCampaigns(
      params.umkmId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetMyCampaignsParams {
  final String umkmId;
  final int limit;
  final int offset;

  const GetMyCampaignsParams({
    required this.umkmId,
    this.limit = 20,
    this.offset = 0,
  });
}
