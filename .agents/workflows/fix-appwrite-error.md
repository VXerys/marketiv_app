---
description: Langkah-langkah diagnosa dan perbaikan error spesifik Appwrite
---
# Workflow: Fix Appwrite Error

Jika terjadi error saat interaksi dengan Appwrite, ikuti langkah berikut:

1. **Identifikasi Kode Error**: Cek HTTP Status Code (401, 403, 404, 409, 429, 500).
2. **Cek Permissions**:
   - Jika error 403, periksa *Document-Level Security* di Appwrite Console.
   - Pastikan array `permissions` saat `createDocument` sudah benar.
3. **Validasi Model**:
   - Jika error saat *parsing*, pastikan field menggunakan key yang benar (termasuk simbol `\$`).
   - Cek tipe data, terutama konversi numerik (`as num`).
4. **Gunakan @workspace /fix**: Berikan pesan error lengkap beserta *stack trace* untuk mendapatkan solusi perbaikan otomatis.
5. **Verifikasi Session**: Jika error 401, pastikan `StorageService` masih menyimpan sesi yang valid dan tidak kadaluwarsa.
