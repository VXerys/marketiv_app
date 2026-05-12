# Routes (`lib/core/routes/`)

Folder untuk mengelola nama routing aplikasi (konstanta String) dan mapping ke Page beserta Binding-nya menggunakan GetX.

## Best Practices
1. **`app_routes.dart`:** Simpan semua string nama route (`static const login = '/login';`).
2. **`app_pages.dart`:** Daftar semua `GetPage(...)` lengkap dengan controller/binding yang diperlukan untuk halaman tersebut.
