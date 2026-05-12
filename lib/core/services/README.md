# Services (`lib/core/services/`)

Berisi global service yang menjadi jembatan dengan eksternal resource atau third-party, contohnya Appwrite, GetStorage (untuk sesi lokal), atau deep link.

## Best Practices
1. Service umumnya berupa instance singleton yang diregister di `InitialBinding`.
2. Jangan taruh logika bisnis (use case) di dalam Service. Service hanya untuk utilitas atau inisialisasi (contoh `AppwriteService.initialize()`).
