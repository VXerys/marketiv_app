import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/campaign_entity.dart';
import '../usecases/create_campaign_usecase.dart';

abstract class CampaignRepository {
  Future<Either<Failure, List<CampaignEntity>>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<CampaignEntity>>> getMyCampaigns(
    String umkmId, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, CampaignEntity>> getCampaignById(String id);

  Future<Either<Failure, CampaignEntity>> createCampaign(
    CreateCampaignParams params,
    String umkmId,
  );

  Future<Either<Failure, String>> generateBrief({
    required String namaProduk,
    required String niche,
    String? deskripsi,
  });
}
