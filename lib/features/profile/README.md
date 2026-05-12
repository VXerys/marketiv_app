# Fitur Profile (`lib/features/profile/`)

Menangani profil pengguna: Update data, pengaturan akun, dan informasi kreator (Niche, follower stats, portofolio).

## Best Practices
1. Cache data profil penting (seperti nama, avatar) di GetStorage saat aplikasi dimulai agar UX lebih smooth.
2. Sinkronisasikan perubahan data profil dengan database via API.
