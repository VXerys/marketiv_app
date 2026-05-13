class CampaignEntity {
  final String id;
  final String umkmId;
  final String judulCampaign;
  final String deskripsiBrief;
  final String urlAsetEksternal;
  final int kuotaKreator;
  final int kuotaTerpakai;
  final double hargaPer1000Views;
  final double totalBudgetEscrow;
  final String? niche;
  final String status; // 'Draft'|'Aktif'|'Penuh'|'Selesai'|'Dibatalkan'
  final DateTime createdAt;

  const CampaignEntity({
    required this.id,
    required this.umkmId,
    required this.judulCampaign,
    required this.deskripsiBrief,
    required this.urlAsetEksternal,
    required this.kuotaKreator,
    required this.kuotaTerpakai,
    required this.hargaPer1000Views,
    required this.totalBudgetEscrow,
    this.niche,
    required this.status,
    required this.createdAt,
  });

  // Computed Getters
  bool get isAvailable => status == 'Aktif' && kuotaTerpakai < kuotaKreator;
  int get sisaSlot => kuotaKreator - kuotaTerpakai;
  double get platformFee => totalBudgetEscrow * 0.15;
  double get totalDibayar => totalBudgetEscrow + platformFee;
}
