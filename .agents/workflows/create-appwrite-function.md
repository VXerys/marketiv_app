---
description: Langkah-langkah membuat, mengonfigurasi, dan deploy Appwrite Functions
---
# Workflow: Manage Appwrite Functions

1. **Inisialisasi Lokal**: Jalankan `appwrite init functions` untuk membuat scaffold function baru di folder `functions/`.
2. **Konfigurasi `appwrite.config.json`**:
   - Atur `runtime` (misal: `node-22` atau `dart-3.3`).
   - Tentukan `entrypoint` dan `commands` (seperti `npm install`).
   - Masukkan ID function ke dalam `includes` jika menggunakan file konfigurasi terpisah.
3. **Environment Variables**:
   - Gunakan file `.env` di dalam folder function untuk menyimpan kunci sensitif (OpenAI, Midtrans).
   - Jalankan `appwrite push functions --with-variables` untuk menyinkronkan ke server.
4. **Deployment**:
   - Jalankan `appwrite push functions --all` atau tentukan ID spesifik.
   - Gunakan flag `--activate` untuk langsung mengaktifkan deployment terbaru.
5. **Pemanggilan dari Flutter**: Gunakan `AppwriteService.functions.createExecution()` dengan ID function yang sesuai.
