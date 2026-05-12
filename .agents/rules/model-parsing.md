---
trigger: model_decision
description: Aturan konversi data Appwrite Document ke Model/Entity di Flutter
---

# Model Parsing & Mapping Rules

1. **Atribut Sistem Appwrite**:
   - Gunakan simbol dolar bersandi escape (`\$`) untuk atribut internal Appwrite:
     - ID: `data['\$id']`
     - Waktu Dibuat: `data['\$createdAt']`
     - Waktu Diperbarui: `data['\$updatedAt']`
     - Permissions: `data['\$permissions']`
2. **Tipe Data**:
   - Selalu lakukan konversi eksplisit untuk tipe numerik: `(data['harga'] as num).toDouble()`.
   - Gunakan `DateTime.parse()` untuk *timestamp* dari Appwrite.
3. **fromDocument vs fromJson**:
   - Gunakan factory `fromDocument(Map<String, dynamic> data)` untuk memproses hasil `.data` dari `Document` Appwrite.
   - Gunakan `toJson()` untuk menyiapkan data sebelum dikirim ke `createDocument` atau `updateDocument` (Pastikan **TIDAK** menyertakan atribut sistem seperti `\$id` di dalam `toJson()` untuk pembuatan dokumen baru).
4. **Konversi Domain**:
   - Setiap Model di layer *Data* wajib memiliki method `.toEntity()` untuk dikonversi menjadi *Entity* di layer *Domain*.