import '../../domain/entities/pekerjaan_entity.dart';

class PekerjaanModel extends PekerjaanEntity {
  const PekerjaanModel({
    required super.id,
    required super.campaignId,
    required super.kreatorId,
    required super.judulCampaign,
    required super.deskripsiBrief,
    super.niche,
    super.urlBuktiTayang,
    super.jumlahViewsAktual = 0,
    required super.statusValidasi,
    super.danaDicairkan = 0.0,
    required super.hargaPer1000Views,
    required super.createdAt,
  });

  factory PekerjaanModel.fromDocuments(
    Map<String, dynamic> submissionData,
    Map<String, dynamic> campaignData,
  ) {
    return PekerjaanModel(
      id: submissionData['\$id'],
      campaignId: submissionData['campaign_id'],
      kreatorId: submissionData['kreator_id'],
      judulCampaign: campaignData['judul_campaign'] ?? '',
      deskripsiBrief: campaignData['deskripsi_brief'] ?? '',
      niche: campaignData['niche'] as String?,
      urlBuktiTayang: submissionData['url_bukti_tayang'] as String?,
      jumlahViewsAktual: submissionData['jumlah_views_aktual'] as int? ?? 0,
      statusValidasi: submissionData['status_validasi'] ?? 'Pending',
      danaDicairkan:
          (submissionData['dana_dicairkan'] as num?)?.toDouble() ?? 0.0,
      hargaPer1000Views:
          (campaignData['harga_per_1000_views'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(submissionData['\$createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'kreator_id': kreatorId,
      'url_bukti_tayang': urlBuktiTayang,
      'jumlah_views_aktual': jumlahViewsAktual,
      'status_validasi': statusValidasi,
      'dana_dicairkan': danaDicairkan,
    };
  }

}
