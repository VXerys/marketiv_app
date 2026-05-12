# Error Handling (`lib/core/error/`)

Berisi definisi Exception dan Failure yang digunakan di seluruh aplikasi Marketiv.
Menggunakan `Failure` (misal `ServerFailure`, `CacheFailure`) saat kembalian dari layer Repository (umumnya dibungkus dengan `Either<Failure, T>`).

## Best Practices
1. Pisahkan `exceptions.dart` (untuk dilempar dari DataSource) dan `failures.dart` (untuk return value dari Repository).
2. Terapkan pattern Either dari `dartz` secara konsisten.
