---
trigger: model_decision
description: Aturan implementasi Clean Architecture dan GetX untuk Marketiv
---

# Clean Architecture & GetX Rules

1. **Aliran Data Wajib**: DataSource ➔ Repository ➔ UseCase ➔ Controller ➔ UI.
2. **DataSource Layer**: Satu-satunya layer yang boleh mengimpor `package:appwrite/appwrite.dart`. Semua `AppwriteException` wajib di-catch di sini dan dipetakan ke custom exception (seperti `ServerException`, `UnauthorizedException`, `NotFoundException`).
3. **Repository Layer**: Selalu me-return `Future<Either<Failure, T>>` (menggunakan package `dartz`). Tidak ada exception yang lolos dari layer ini.
4. **Controller (GetX)**:
   - State selalu menggunakan private `Rx` dengan public getter (misal: `final _isLoading = false.obs; bool get isLoading => _isLoading.value;`).
   - Wajib menghandle 3 state: Loading, Error, dan Data Tampil.
   - Wajib menampilkan pesan error yang ramah pengguna berbahasa Indonesia (menggunakan `Get.snackbar`).
5. **UI Layer**:
   - Tampilkan Shimmer saat Loading, `EmptyStateWidget` saat error/kosong.
   - Seluruh rendering daftar wajib menggunakan `ListView.builder`.