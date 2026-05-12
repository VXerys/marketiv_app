---
trigger: model_decision
description: Standar penulisan unit test untuk UseCase dan Repository di Marketiv
---

# Testing Standards

1. **Framework**: Gunakan `flutter_test` dan `mockito`.
2. **Cakupan Test Case**:
   - **Happy Path**: Memastikan fungsi mengembalikan `Right(data)` saat sukses.
   - **Server Failure**: Memastikan fungsi mengembalikan `Left(ServerFailure)` saat DataSource melempar `ServerException`.
   - **Auth Failure**: Memastikan fungsi mengembalikan `Left(AuthFailure)` saat terjadi masalah autentikasi.
3. **Struktur File**:
   - Simpan test di folder `test/` dengan struktur folder yang mengikuti `lib/`.
   - Gunakan anotasi `@GenerateMocks` untuk menghasilkan *mock* dari dependensi.
4. **Verifikasi**:
   - Gunakan `expect(result, Right(expectedData))` untuk hasil sukses.
   - Gunakan `verify(mockDependency.methodCall())` untuk memastikan dependensi dipanggil dengan benar.