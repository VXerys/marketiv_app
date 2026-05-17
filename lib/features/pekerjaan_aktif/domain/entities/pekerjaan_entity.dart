class PekerjaanEntity {
  final String id;
  final String campaignId;
  final String kreatorId;
  final String judulCampaign;
  final String deskripsiBrief;
  final String? niche;
  final String? urlBuktiTayang;
  final int jumlahViewsAktual;
  final String statusValidasi; // 'Pending' | 'Valid' | 'Fraud' | 'Dispute'
  final double danaDicairkan;
  final double hargaPer1000Views;
  final DateTime createdAt;

  const PekerjaanEntity({
    required this.id,
    required this.campaignId,
    required this.kreatorId,
    required this.judulCampaign,
    required this.deskripsiBrief,
    this.niche,
    this.urlBuktiTayang,
    this.jumlahViewsAktual = 0,
    required this.statusValidasi,
    this.danaDicairkan = 0.0,
    required this.hargaPer1000Views,
    required this.createdAt,
  });

  bool get isSubmitted =>
      urlBuktiTayang != null && urlBuktiTayang!.isNotEmpty;

  bool get isDone => statusValidasi == 'Valid';

  bool get isFraud => statusValidasi == 'Fraud';

  bool get isPending => statusValidasi == 'Pending';

  double get estimasiPendapatan =>
      (jumlahViewsAktual / 1000) * hargaPer1000Views;
}
