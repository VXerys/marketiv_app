---
trigger: model_decision
description: Aturan khusus untuk interaksi dengan Appwrite Cloud
---

# Appwrite Backend Rules

1. **Model Parsing**: Selalu gunakan factory `fromDocument(Map<String, dynamic> data)` untuk memproses respons dari SDK Appwrite. Ambil atribut sistem `$id` dan `$createdAt` secara manual dengan escape karakter dolar (contoh: `data['\$id']`).
2. **Permissions (Document-Level Security)**: Method `createDocument` wajib menyertakan array `permissions` yang eksplisit sesuai tabel hak akses di `DATABASE.md`.
3. **TRANSACTIONS Collection**: Flutter client hanya memiliki akses READ. Flutter **DILARANG KERAS** memanggil `createDocument` atau `updateDocument` ke koleksi ini secara langsung.
4. **Appwrite Functions**: Logika server-side yang sensitif (integrasi Midtrans, prompt AI OpenAI, atau transfer Escrow) wajib dieksekusi melalui pemanggilan Appwrite Functions (`AppwriteService.functions.createExecution`).
5. **Realtime**: Subscription realtime hanya diizinkan pada `ChatController` untuk fitur Rate Card Mode. Fitur lainnya harus menggunakan strategi *pull-to-refresh* atau *manual refresh*.