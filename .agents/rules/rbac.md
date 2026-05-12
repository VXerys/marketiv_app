---
trigger: model_decision
description: Matriks hak akses (RBAC) antar role pengguna di Marketiv
---

# Role-Based Access Control (RBAC) Rules

Selalu verifikasi role pengguna sebelum merender elemen UI atau mengizinkan eksekusi logika fitur:

| Fitur / Halaman | UMKM | KREATOR | ADMIN |
|---|:---:|:---:|:---:|
| Buat Campaign | ✅ | ❌ | ❌ |
| Lihat Job Pool | ❌ | ✅ | ✅ |
| Klaim Job | ❌ | ✅ | ❌ |
| Submit URL Bukti Tayang | ❌ | ✅ | ❌ |
| Direktori Kreator (Rate Card) | ✅ | ❌ | ✅ |
| Live Chat (Rate Card) | ✅ | ✅ | ❌ |
| Kirim Custom Offer | ✅ | ❌ | ❌ |
| Buat/Edit Rate Card | ❌ | ✅ | ❌ |
| Top-up / Deposit | ✅ | ❌ | ❌ |
| Withdraw Saldo | ❌ | ✅ | ❌ |
| Dashboard Admin | ❌ | ❌ | ✅ |
| Kelola Dispute | ❌ | ❌ | ✅ |

**Ketentuan Tambahan**:
- **Admin** memiliki akses *read* ke hampir seluruh koleksi untuk keperluan pemantauan dan penyelesaian sengketa (*dispute*).
- **Kreator** hanya bisa melihat kampanye dengan status 'Aktif' di *Job Pool*.
- **UMKM** hanya bisa melihat detail profil kreator yang telah mengisi *Rate Card*.