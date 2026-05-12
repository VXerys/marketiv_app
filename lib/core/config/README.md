# Config (`lib/core/config/`)

Menangani konfigurasi environment dan toggle aplikasi, seperti membaca variabel `.env` dan mengatur state `AppConfig` (contoh: toggle mock data).

## Best Practices
1. Jangan expose data sensitif di sini.
2. Variabel dari `.env` harus dimuat saat inisialisasi aplikasi (di `main.dart`) sebelum digunakan.
