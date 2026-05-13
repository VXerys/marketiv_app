class UserEntity {
  final String id;
  final String userId;
  final String role;
  final String namaLengkap;
  final String email;
  final String? nomorWhatsapp;
  final double dompetSaldo;
  final String? niche;
  final String? fotoProfilUrl;
  final String? bio;
  final bool isVerified;
  final String? fcmToken;
  final int unreadCount;

  const UserEntity({
    required this.id,
    required this.userId,
    required this.role,
    required this.namaLengkap,
    required this.email,
    this.nomorWhatsapp,
    this.dompetSaldo = 0.0,
    this.niche,
    this.fotoProfilUrl,
    this.bio,
    this.isVerified = false,
    this.fcmToken,
    this.unreadCount = 0,
  });
}
