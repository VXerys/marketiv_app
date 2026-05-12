---
description: Langkah-langkah implementasi alur penarikan dana untuk kreator
---
# Workflow: Withdrawal Process (Kreator)

1. **Validasi Saldo**: Cek `dompet_saldo` di profil user sebelum mengizinkan pengisian form withdrawal.
2. **Form Penarikan**: Buat UI untuk input `nominal` (min Rp 10.000), `nama_bank`, `nomor_rekening`, dan `nama_pemilik`.
3. **Eksekusi Server-Side**: Panggil Appwrite Function (`withdraw-fn`) via `Functions.createExecution`. Jangan pernah memproses transfer langsung dari client Flutter.
4. **Tracking Transaksi**: Setelah function sukses mengeksekusi *disbursement* (via Midtrans/Xendit), sistem akan membuat dokumen baru di koleksi `TRANSACTIONS` dengan tipe `Withdrawal` dan status `Pending` hingga diproses oleh provider.
5. **Notifikasi**: Tampilkan pesan sukses kepada kreator dan perbarui UI saldo secara reaktif.
