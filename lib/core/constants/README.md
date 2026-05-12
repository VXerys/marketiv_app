# Constants (`lib/core/constants/`)

Folder ini menyimpan seluruh konstanta aplikasi, design tokens (warna, font, spacing, shadow), serta konfigurasi statis seperti ID endpoint Appwrite, list niche, dan rate komisi.

## Best Practices
1. **Single Source of Truth:** Semua hardcoded string, ukuran (padding/margin), dan kode warna harus diletakkan di sini.
2. **Penamaan Spesifik:** Pisahkan dalam file yang relevan (misal `app_colors.dart` untuk warna, `app_constants.dart` untuk Appwrite).
