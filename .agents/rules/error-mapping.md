---
trigger: model_decision
description: Aturan pemetaan AppwriteException ke Failure sistem Marketiv
---

# Error Handling & Mapping Rules

Setiap `AppwriteException` di layer *DataSource* wajib dipetakan menggunakan pola berikut sebelum dilempar ke *Repository*:

| Kode HTTP | Exception Kustom | Kegagalan (Failure) | Pesan Indonesia |
|---|---|---|---|
| 401 | `UnauthorizedException` | `AuthFailure` | "Sesi habis. Silakan login kembali." |
| 404 | `NotFoundException` | `NotFoundFailure` | "Data tidak ditemukan." |
| 409 | `ConflictException` | `ServerFailure` | "Data sudah ada atau terjadi konflik." |
| 429 | `RateLimitException` | `ServerFailure` | "Terlalu banyak permintaan. Coba lagi nanti." |
| Default | `ServerException` | `ServerFailure` | "Terjadi kesalahan server: [message]" |

**Implementasi di DataSource**:
```dart
on AppwriteException catch (e) {
  throw _mapAppwriteException(e);
}
```

**Implementasi di Repository**:
```dart
try {
  final result = await dataSource.call();
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
} on UnauthorizedException catch (e) {
  return Left(AuthFailure(message: e.message));
}
```