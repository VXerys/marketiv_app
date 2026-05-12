# Dependency Injection (`lib/core/di/`)

Folder ini mengatur Global Dependency Injection pada level aplikasi (misalnya inisialisasi awal saat aplikasi dibuka).

## Best Practices
1. Gunakan file `initial_binding.dart` untuk men-register global instance (seperti `AppwriteService`, `StorageService`, dsb).
2. Service yang di-register di sini akan berada di memory secara `permanent: true`.
