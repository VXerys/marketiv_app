# Fitur Keuangan (`lib/features/keuangan/`)

Mengelola sistem keuangan: Deposit UMKM ke escrow, riwayat saldo, penarikan dana (withdrawal) untuk kreator.

## Best Practices
1. **Aman:** Client app TIDAK PERNAH memodifikasi atau CREATE transaksi langsung. Flutter memanggil Appwrite Function atau Midtrans Endpoint untuk mengubah state saldo.
2. Menampilkan riwayat mutasi dari database Appwrite secara read-only.
