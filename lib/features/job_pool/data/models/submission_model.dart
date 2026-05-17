import '../../domain/entities/submission_entity.dart';

class SubmissionModel extends SubmissionEntity {
  const SubmissionModel({
    required super.id,
    required super.campaignId,
    required super.kreatorId,
    super.urlBuktiTayang,
    super.jumlahViewsAktual = 0,
    required super.statusValidasi,
    super.danaDicairkan = 0.0,
    required super.createdAt,
  });

  factory SubmissionModel.fromDocument(Map<String, dynamic> data) {
    return SubmissionModel(
      id: data['\$id'],
      campaignId: data['campaign_id'],
      kreatorId: data['kreator_id'],
      urlBuktiTayang: data['url_bukti_tayang'] as String?,
      jumlahViewsAktual: data['jumlah_views_aktual'] as int? ?? 0,
      statusValidasi: data['status_validasi'] ?? 'Pending',
      danaDicairkan: (data['dana_dicairkan'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(data['\$createdAt']),
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

  SubmissionEntity toEntity() {
    return SubmissionEntity(
      id: id,
      campaignId: campaignId,
      kreatorId: kreatorId,
      urlBuktiTayang: urlBuktiTayang,
      jumlahViewsAktual: jumlahViewsAktual,
      statusValidasi: statusValidasi,
      danaDicairkan: danaDicairkan,
      createdAt: createdAt,
    );
  }
}
