import '../../domain/entities/user_entity.dart';

class UserModel {
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
  final DateTime createdAt;

  const UserModel({
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
    required this.createdAt,
  });

  factory UserModel.fromDocument(Map<String, dynamic> data) {
    return UserModel(
      id: data['\$id'],
      userId: data['user_id'],
      role: data['role'],
      namaLengkap: data['nama_lengkap'],
      email: data['email'] ?? '',
      nomorWhatsapp: data['nomor_whatsapp'],
      dompetSaldo: (data['dompet_saldo'] as num).toDouble(),
      niche: data['niche'] as String?,
      fotoProfilUrl: data['foto_profil_url'],
      bio: data['bio'],
      isVerified: data['is_verified'] ?? false,
      fcmToken: data['fcm_token'],
      unreadCount: data['unread_count'] ?? 0,
      createdAt: DateTime.parse(data['\$createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role': role,
      'nama_lengkap': namaLengkap,
      'email': email,
      'nomor_whatsapp': nomorWhatsapp,
      'dompet_saldo': dompetSaldo,
      'niche': niche,
      'foto_profil_url': fotoProfilUrl,
      'bio': bio,
      'is_verified': isVerified,
      'fcm_token': fcmToken,
      'unread_count': unreadCount,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      userId: userId,
      role: role,
      namaLengkap: namaLengkap,
      email: email,
      nomorWhatsapp: nomorWhatsapp,
      dompetSaldo: dompetSaldo,
      niche: niche,
      fotoProfilUrl: fotoProfilUrl,
      bio: bio,
      isVerified: isVerified,
      fcmToken: fcmToken,
      unreadCount: unreadCount,
    );
  }
}
