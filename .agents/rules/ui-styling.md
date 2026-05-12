---
trigger: model_decision
description: Panduan desain, tipografi, warna, dan komponen UI Marketiv yang detail dan premium
---

# UI/UX & Styling Rules (Detailed)

Gunakan panduan ini untuk memastikan setiap halaman di Marketiv terlihat premium, konsisten, dan intuitif bagi pengguna UMKM.

### 1. Design Tokens (Konstanta Wajib)
Jangan pernah menulis kode warna atau ukuran secara *hardcoded*. Selalu gunakan konstanta berikut:

#### **A. Palet Warna (AppColors)**
- `primary500`: `#F97316` (Orange Utama - Branding Marketiv)
- `secondary500`: `#1E3A5F` (Navy - Profesionalisme)
- `success`: `#16A34A` (Hijau - Berhasil/Valid)
- `danger`: `#DC2626` (Merah - Gagal/Batal/Error)
- `background`: `#FAFAFA` (Abu Sangat Muda - Latar Belakang App)
- `surface`: `#FFFFFF` (Putih - Card/Elevated Elements)
- `grey300`: `#D1D5DB` (Border/Placeholder)

#### **B. Spacing (AppSpacing)**
- `xs`: 4.0 | `sm`: 8.0 | `md`: 16.0 | `lg`: 24.0 | `xl`: 32.0

#### **C. Tipografi (AppTextStyles)**
- **Heading 3**: `Newsreader` 20 SemiBold (Untuk Judul Halaman/Produk)
- **Body Medium**: `Inter` 14 Regular (Untuk Deskripsi/Teks Standar)
- **Label Medium**: `Inter` 14 Medium (Untuk Label/Nama Field)
- **Button Text**: `Inter` 16 SemiBold (Untuk Teks Tombol Utama)

### 2. Standar Komponen & State UI
Setiap halaman yang mengambil data dari internet wajib memiliki 3 lapisan state berikut:

1. **State: Loading (Shimmer)**
   - Gunakan `LoadingShimmer` widget (bukan `CircularProgressIndicator`).
   - Tampilkan saat data sedang dimuat (`controller.isLoading && controller.items.isEmpty`).
2. **State: Empty/Error (EmptyStateWidget)**
   - Gunakan `EmptyStateWidget.error` jika terjadi kegagalan fetching data.
   - Sediakan pesan error dalam Bahasa Indonesia dan tombol "Coba Lagi" (`onRetry`).
   - Tampilkan ilustrasi yang relevan jika data memang kosong.
3. **State: Data (Tampilan Aktual)**
   - Gunakan `ListView.builder` (atau `SliverList`) untuk daftar panjang guna optimasi memori.
   - Gunakan `Obx` dari GetX untuk pembaharuan UI yang reaktif.

### 3. Penanganan Media & Gambar
- **Remote Images**: Selalu gunakan `CachedNetworkImage`.
- **Placeholder**: Wajib menyediakan `placeholder` (shimmer) dan `errorWidget` (icon/asset default) jika gambar gagal dimuat.
- **Thumbnail**: Optimasi ukuran gambar sebelum ditampilkan jika memungkinkan.

### 4. Copywriting & Bahasa
- **Lokalitas**: Gunakan Bahasa Indonesia yang praktis dan intuitif. Hindari istilah teknis yang sulit (Contoh: gunakan "Tarik Saldo" bukan "Withdrawal Request").
- **Snackbar**: Gunakan `Get.snackbar` dengan warna latar `AppColors.danger` untuk error dan `AppColors.success` untuk pesan berhasil.
- **Hint & Label**: Setiap field input harus memiliki label yang jelas dan hint yang membantu pengguna (Contoh: "Nama Produk — Sambal Matah").

### 5. Interaksi & Navigasi
- **Feedback Visual**: Tombol harus memiliki feedback saat ditekan (splash/ripple).
- **Disabled State**: Tombol aksi wajib dinonaktifkan saat `isLoading` bernilai `true` untuk mencegah *multiple submission*.
- **Transitions**: Gunakan transisi halaman bawaan GetX yang halus.