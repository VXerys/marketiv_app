import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../entities/submission_entity.dart';

abstract class JobPoolRepository {
  Future<Either<Failure, List<CampaignEntity>>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  });
  Future<Either<Failure, CampaignEntity>> getCampaignById(String id);
  Future<Either<Failure, SubmissionEntity>> claimCampaign(
    String campaignId,
    String kreatorId,
  );
  Future<Either<Failure, bool>> checkAlreadyClaimed(
    String campaignId,
    String kreatorId,
  );
}
