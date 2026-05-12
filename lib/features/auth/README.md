# Fitur Auth (`lib/features/auth/`)

Menangani proses autentikasi, registrasi pengguna (UMKM & Kreator), pemeriksaan sesi, serta pengaturan akses berbasis role (RBAC).

## Best Practices
1. **Data Layer:** Gunakan Appwrite Account API untuk login/register.
2. **Domain Layer:** Implementasikan UseCase untuk login, logout, register.
3. **Role Validation:** Pastikan role tersimpan di session lokal untuk keperluan redirect dan RBAC navigation.
