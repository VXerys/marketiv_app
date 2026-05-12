---
trigger: model_decision
description: Aturan alur autentikasi, registrasi, dan manajemen sesi untuk Marketiv
---

# Authentication & Session Rules

1. **Alur Registrasi**:
   - User wajib memilih role (`UMKM` atau `KREATOR`) saat mendaftar.
   - Setelah `Account.create()` sukses, segera buat dokumen profil di koleksi `users`.
   - Panggil `Account.createVerification()` untuk memicu email verifikasi.
2. **Manajemen Sesi**:
   - Gunakan `Account.createEmailPasswordSession()` untuk login.
   - Simpan `role` dan `user_id` di `GetStorage` (via `StorageService`) untuk akses cepat dan pengalihan rute (*redirect*).
   - Jangan simpan *password* atau *token* sensitif di `GetStorage`.
3. **Persistensi Sesi**:
   - Cek sesi di *Splash Screen* menggunakan `Account.get()`.
   - Jika terjadi `AppwriteException` dengan kode 401, arahkan ke halaman *Onboarding* atau *Login*.
4. **Alur Logout**:
   - Panggil `Account.deleteSession(sessionId: 'current')`.
   - Bersihkan seluruh data di `GetStorage` menggunakan `StorageService.clearAll()`.
5. **Role-Based Redirect**:
   - UMKM ➔ `Routes.umkmHome`
   - KREATOR ➔ `Routes.kreatorHome`
   - ADMIN ➔ `Routes.adminHome`