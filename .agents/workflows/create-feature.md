---
description: Langkah-langkah untuk membuat atau menambahkan fitur baru di Marketiv
---
# Workflow: Create New Feature

Gunakan panduan ini secara berurutan saat diminta untuk membuat fitur baru:

1. **Pahami Skema Database**: Baca koleksi yang relevan di `DATABASE.md` untuk menentukan struktur *fields*, relasi, serta *permissions* yang tepat.
2. **Buat Model & Entity (`data/models/`, `domain/entities/`)**: Buat class representasi data. Pastikan *parsing* dari/ke Appwrite menggunakan `fromDocument(Map<String, dynamic> data)` dan `toJson()`.
3. **Buat DataSource (`data/datasources/`)**: Implementasikan *abstract class* dan *concrete class* (*Impl*). Gunakan `AppwriteService` di sini, dan pastikan memetakan `AppwriteException` menjadi *exception* kustom (contoh: `ServerException`).
4. **Buat Repository (`domain/repositories/`, `data/repositories/`)**: Tangkap seluruh *exception* dari DataSource dan bungkus hasilnya menggunakan objek `Future<Either<Failure, T>>`.
5. **Buat UseCase (`domain/usecases/`)**: Terapkan satu class terpisah untuk masing-masing aksi (misal: `CreateCampaignUseCase`).
6. **Buat GetX Controller (`presentation/controllers/`)**: Definisikan *state* reaktif (menggunakan `Rx`) untuk *Loading*, *Error*, dan *Data*. Implementasikan logika pengambilan data melalui UseCase.
7. **Daftarkan Dependency (Binding)**: Masukkan struktur dari DataSource hingga Controller ke dalam `app_pages.dart` (atau *Binding* khusus), diurutkan dari lapisan Data ke Presentation.
8. **Bangun UI (`presentation/pages/`)**: Buat halaman dengan *widget* `Obx`. Sediakan antarmuka untuk 3 *state* wajib (Skeleton/Shimmer untuk proses pemuatan data, Empty/Error State yang bersahabat, dan *ListView.builder* untuk menampilkan data sebenarnya).
