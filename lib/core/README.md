# Core Layer (`lib/core/`)

Folder `core/` berisi semua konfigurasi dasar, konstanta, routing, service global, dan pengaturan sistem yang bersifat fundamental untuk seluruh aplikasi Marketiv. Kode di sini TIDAK boleh bergantung pada layer `features/`.

## Best Practices
1. **Independensi:** File di dalam `core` tidak boleh mengimpor file dari folder `features/`.
2. **Global Access:** Service atau utilitas di dalam folder ini umumnya di-inject secara global dan dapat diakses dari mana saja.
