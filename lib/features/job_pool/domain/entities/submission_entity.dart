class SubmissionEntity {
  final String id;
  final String campaignId;
  final String kreatorId;
  final String? urlBuktiTayang;
  final int jumlahViewsAktual;
  final String statusValidasi; // 'Pending' | 'Valid' | 'Fraud' | 'Dispute'
  final double danaDicairkan;
  final DateTime createdAt;

  const SubmissionEntity({
    required this.id,
    required this.campaignId,
    required this.kreatorId,
    this.urlBuktiTayang,
    this.jumlahViewsAktual = 0,
    required this.statusValidasi,
    this.danaDicairkan = 0.0,
    required this.createdAt,
  });
}
