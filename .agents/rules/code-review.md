---
trigger: model_decision
description: Checklist peninjauan kode (code review) untuk kepatuhan arsitektur Marketiv
---

# Code Review Checklist

Selalu periksa poin-poin berikut sebelum menyetujui perubahan kode:

1. **Layering & Imports**:
   - ❌ Apakah ada `import 'package:appwrite/...'` di luar folder `datasources`?
   - ❌ Apakah *Controller* mengakses *Repository* secara langsung (seharusnya melalui *UseCase*)?
2. **Standardisasi Data**:
   - ❌ Apakah dokumen Appwrite di-*parse* menggunakan `fromJson` (seharusnya `fromDocument`)?
   - ❌ Apakah atribut sistem menggunakan simbol dolar (misal: `data['\$id']`)?
3. **UI & Styling**:
   - ❌ Apakah ada *hardcode* warna atau ukuran (seharusnya menggunakan `AppColors`, `AppSpacing`, `AppTextStyles`)?
   - ❌ Apakah halaman tidak memiliki penanganan 3 state (*loading*, *error*, *data*)?
   - ❌ Apakah ada teks UI dalam bahasa selain Bahasa Indonesia?
4. **Keamanan & Best Practices**:
   - ❌ Apakah `createDocument` tidak menyertakan `permissions`?
   - ❌ Apakah ada kunci rahasia (API Keys) yang tertulis di kode Flutter?
   - ❌ Apakah penggunaan *Realtime* ada di luar `ChatController`?