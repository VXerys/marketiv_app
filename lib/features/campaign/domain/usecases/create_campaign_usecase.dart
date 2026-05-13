import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/campaign_entity.dart';
import '../repositories/campaign_repository.dart';

class CreateCampaignUseCase implements UseCase<CampaignEntity, CreateCampaignWithUserParams> {
  final CampaignRepository repository;

  CreateCampaignUseCase(this.repository);

  @override
  Future<Either<Failure, CampaignEntity>> call(CreateCampaignWithUserParams params) async {
    return await repository.createCampaign(params.campaignParams, params.umkmId);
  }
}

class CreateCampaignWithUserParams {
  final CreateCampaignParams campaignParams;
  final String umkmId;

  const CreateCampaignWithUserParams({
    required this.campaignParams,
    required this.umkmId,
  });
}

class CreateCampaignParams {
  final String judulCampaign;
  final String deskripsiBrief;
  final String urlAsetEksternal;
  final int kuotaKreator;
  final double hargaPer1000Views;
  final double totalBudgetEscrow;
  final String? niche;

  const CreateCampaignParams({
    required this.judulCampaign,
    required this.deskripsiBrief,
    required this.urlAsetEksternal,
    required this.kuotaKreator,
    required this.hargaPer1000Views,
    required this.totalBudgetEscrow,
    this.niche,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul_campaign': judulCampaign,
      'deskripsi_brief': deskripsiBrief,
      'url_aset_eksternal': urlAsetEksternal,
      'kuota_kreator': kuotaKreator,
      'harga_per_1000_views': hargaPer1000Views,
      'total_budget_escrow': totalBudgetEscrow,
      'niche': niche,
    };
  }
}
