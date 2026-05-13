import '../../domain/entities/campaign_entity.dart';

class CampaignModel extends CampaignEntity {
  const CampaignModel({
    required super.id,
    required super.umkmId,
    required super.judulCampaign,
    required super.deskripsiBrief,
    required super.urlAsetEksternal,
    required super.kuotaKreator,
    required super.kuotaTerpakai,
    required super.hargaPer1000Views,
    required super.totalBudgetEscrow,
    super.niche,
    required super.status,
    required super.createdAt,
  });

  factory CampaignModel.fromDocument(Map<String, dynamic> data) {
    return CampaignModel(
      id: data['\$id'] ?? '',
      umkmId: data['umkm_id'] ?? '',
      judulCampaign: data['judul_campaign'] ?? '',
      deskripsiBrief: data['deskripsi_brief'] ?? '',
      urlAsetEksternal: data['url_aset_eksternal'] ?? '',
      kuotaKreator: data['kuota_kreator'] as int? ?? 0,
      kuotaTerpakai: data['kuota_terpakai'] as int? ?? 0,
      hargaPer1000Views: (data['harga_per_1000_views'] as num?)?.toDouble() ?? 0.0,
      totalBudgetEscrow: (data['total_budget_escrow'] as num?)?.toDouble() ?? 0.0,
      niche: data['niche'] as String?,
      status: data['status'] ?? 'Draft',
      createdAt: data['\$createdAt'] != null 
          ? DateTime.parse(data['\$createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'umkm_id': umkmId,
      'judul_campaign': judulCampaign,
      'deskripsi_brief': deskripsiBrief,
      'url_aset_eksternal': urlAsetEksternal,
      'kuota_kreator': kuotaKreator,
      'kuota_terpakai': kuotaTerpakai,
      'harga_per_1000_views': hargaPer1000Views,
      'total_budget_escrow': totalBudgetEscrow,
      'niche': niche,
      'status': status,
    };
  }

  CampaignEntity toEntity() {
    return CampaignEntity(
      id: id,
      umkmId: umkmId,
      judulCampaign: judulCampaign,
      deskripsiBrief: deskripsiBrief,
      urlAsetEksternal: urlAsetEksternal,
      kuotaKreator: kuotaKreator,
      kuotaTerpakai: kuotaTerpakai,
      hargaPer1000Views: hargaPer1000Views,
      totalBudgetEscrow: totalBudgetEscrow,
      niche: niche,
      status: status,
      createdAt: createdAt,
    );
  }
}
