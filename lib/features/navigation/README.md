# Fitur Navigation (`lib/features/navigation/`)

Mengelola Bottom Navigation Bar (Main Navigation) yang bersifat dinamis berdasarkan role (UMKM, Kreator, Admin).

## Best Practices
1. Gunakan `IndexedStack` atau PageView untuk menjaga state tab tetap hidup.
2. Gunakan percabangan berdasarkan tipe role untuk menampilkan list tab yang berbeda.
