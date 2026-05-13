import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/campaign_entity.dart';
import '../repositories/campaign_repository.dart';

class GetActiveCampaignsUseCase implements UseCase<List<CampaignEntity>, GetCampaignsParams> {
  final CampaignRepository repository;

  GetActiveCampaignsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CampaignEntity>>> call(GetCampaignsParams params) async {
    return await repository.getActiveCampaigns(
      niche: params.niche,
      minHarga: params.minHarga,
      maxHarga: params.maxHarga,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetCampaignsParams {
  final String? niche;
  final double? minHarga;
  final double? maxHarga;
  final int limit;
  final int offset;

  const GetCampaignsParams({
    this.niche,
    this.minHarga,
    this.maxHarga,
    this.limit = 20,
    this.offset = 0,
  });
}
