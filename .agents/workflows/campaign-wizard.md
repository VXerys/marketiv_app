---
description: Alur pembuatan wizard form multi-step untuk kampanye baru UMKM
---
# Workflow: Campaign Wizard Implementation

1. **Struktur Step**: Bagi form menjadi 4 tahap: (1) Info Produk, (2) Upload Aset, (3) Budget & Kuota, (4) Review & Bayar.
2. **State Management**: Gunakan satu `CampaignController` untuk menampung seluruh data sementara dari Step 1 hingga 3.
3. **AI Integration (Step 1)**: Tambahkan tombol "✨ Bantu dengan AI" yang memicu `GenerateBriefUseCase`.
4. **Media Validation (Step 2)**: 
   - Implementasikan pengecekan ukuran file (< 100MB) sebelum *upload*.
   - Sediakan field URL alternatif untuk Google Drive/Dropbox.
5. **Escrow Calculation (Step 3)**: Auto-calculate total budget termasuk komisi platform 15% secara *real-time* saat input harga/kuota berubah.
6. **Payment Integration (Step 4)**: Panggil `midtrans-create-fn` untuk mendapatkan *token* pembayaran dan arahkan ke WebView.
