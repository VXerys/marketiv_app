---
description: Langkah-langkah inisialisasi Appwrite Project dan Services di Flutter
---
# Workflow: Setup Appwrite Project

1. **Konfigurasi Konstanta**: Update `lib/core/constants/app_constants.dart` dengan `endpoint`, `projectId`, dan `databaseId`.
2. **Inisialisasi Client**: Pastikan `AppwriteService.initialize()` dipanggil di `main.dart` sebelum `runApp()`.
3. **Definisi Koleksi**: Tambahkan ID koleksi baru ke dalam `AppConstants` (contoh: `colCampaigns = 'campaigns'`).
4. **Pendaftaran Service**: Gunakan *singleton pattern* untuk `Databases`, `Account`, `Storage`, `Realtime`, dan `Functions` di dalam `AppwriteService`.
5. **Setup Storage Buckets**: Jika fitur memerlukan unggahan file, pastikan Bucket ID sudah terdaftar di `AppConstants` dan permissions di Appwrite Console sudah diatur ke *public read* (jika aset publik).
