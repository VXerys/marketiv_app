---
trigger: model_decision
description: Aturan integrasi pembayaran Midtrans Snap melalui Appwrite Functions
---

# Midtrans Payment Rules

1. **Keamanan Kunci**:
   - `MIDTRANS_SERVER_KEY` **DILARANG** ada di kode Flutter. Gunakan hanya di *environment variables* Appwrite Functions.
   - `MIDTRANS_CLIENT_KEY` diizinkan ada di `.env` Flutter untuk konfigurasi WebView.
2. **Alur Transaksi**:
   - Flutter ➔ Panggil Appwrite Function (`midtrans-create-fn`) ➔ Terima `snap_token`.
   - Buka `MidtransWebViewPage` menggunakan `snap_token` yang diterima.
3. **Penanganan Webhook**:
   - Status transaksi hanya diperbarui oleh `midtrans-webhook-fn` setelah menerima notifikasi dari Midtrans.
   - Flutter client hanya diperbolehkan memantau (*watch*) perubahan dokumen di koleksi `TRANSACTIONS`.
4. **Status Transaksi**:
   - `Pending`: Menunggu pembayaran.
   - `Escrow`: Pembayaran sukses, dana ditahan sistem.
   - `Success`: Dana telah dirilis ke kreator.
   - `Refunded`: Dana dikembalikan ke UMKM.