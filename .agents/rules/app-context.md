---
trigger: model_decision
description: Konteks bisnis, operasional, dan batasan fungsional aplikasi Marketiv
---

# Application Context Rules

Marketiv adalah platform *hybrid marketplace* berbasis Flutter yang menghubungkan UMKM (Usaha Mikro, Kecil, dan Menengah) dengan Konten Kreator untuk pemasaran produk melalui video pendek (TikTok/Instagram).

### 1. Peran Pengguna (User Roles)
- **UMKM**: Pihak yang membuat kampanye (*Campaign*) atau menyewa kreator via *Rate Card*.
- **KREATOR**: Pihak yang mengklaim pekerjaan (*Job*) atau menawarkan jasa pembuatan konten.
- **ADMIN**: Pihak yang memantau transaksi, mengelola sengketa (*Dispute*), dan memvalidasi pekerjaan.

### 2. Mode Operasional (Key Operational Modes)
- **Campaign Mode (Performance-Based)**:
  - UMKM membayar berdasarkan jumlah *views* yang dihasilkan.
  - **ATURAN MUTLAK**: *Zero Chat*. Tidak ada fitur obrolan atau komunikasi antara kedua pihak.
- **Rate Card Mode (Fixed Price)**:
  - UMKM menyewa kreator berdasarkan paket harga tetap.
  - Melibatkan negosiasi melalui *Live Chat* dan pengiriman *Custom Offer*.

### 3. Batasan Teknis & Bisnis (Functional Constraints)
- **Backend**: Appwrite Cloud adalah satu-satunya BaaS. Dilarang menggunakan Supabase/Firebase.
- **Media Besar**: File video > 100MB dilarang masuk ke Appwrite Storage. Wajib menggunakan URL eksternal (Drive/Dropbox/TikTok).
- **Escrow & Keamanan**: Semua dana ditahan di koleksi `TRANSACTIONS` (Escrow) dan hanya diproses via Appwrite Functions. Client Flutter tidak memiliki hak akses tulis ke koleksi transaksi.
- **AI Integration**: Seluruh pemrosesan AI (GPT-4o-mini) dilakukan di sisi server via Appwrite Functions untuk mengamankan API Keys.
- **Batas Paket**: Kreator dibatasi maksimal 3 paket Rate Card.

### 4. Aliran Data (Clean Architecture)
- **DataSource**: Satu-satunya tempat pemanggilan Appwrite SDK.
- **Repository**: Mengembalikan `Either<Failure, T>` untuk penanganan error yang konsisten.
- **UseCase**: Menampung logika bisnis spesifik untuk satu aksi.
- **Controller**: Mengelola state UI menggunakan GetX.
- **UI**: Render komponen reaktif berdasarkan state Controller.