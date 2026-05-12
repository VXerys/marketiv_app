---
trigger: model_decision
description: Panduan desain, tipografi, warna, dan komponen UI Marketiv yang detail dan premium
---

# UI/UX & Styling Rules (Detailed)

Gunakan panduan ini untuk memastikan setiap halaman di Marketiv terlihat premium, konsisten, dan intuitif bagi pengguna UMKM.

### 1. Design Tokens (Konstanta Wajib)
Jangan pernah menulis kode warna, ukuran, atau typography secara *hardcoded*. Anda **WAJIB** mengimpor dan menggunakan file konstanta berikut yang berada di `lib/core/constants/`:

- **A. Palet Warna**: Gunakan `AppColors` dari `app_colors.dart`.
- **B. Spacing & Layout**: Gunakan `AppSpacing` dari `app_spacing.dart` (Sistem spacing kelipatan 4px).
  - Padding horizontal layar standar: `space-4` (16px).
  - Jarak antar kartu: `space-4` (16px) atau `space-8` (32px).
- **C. Tipografi**: Gunakan `AppTextStyles` dari `app_text_styles.dart`.
  - **Font Utama**: `Newsreader` (untuk Judul/Heading).
  - **Font Sekunder**: `Inter` (untuk Body & UI).
  - **Aturan Font Minimum**: Body text minimal **15px** (`text-base`). Caption/Timestamp minimal **11px** (`text-xs`).

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

### 3. Komponen Utama (DOK-4 Standards)
- **Tombol (Button)**:
  - **Tinggi Default**: 48px (Medium).
  - **Full Width**: Standar untuk aksi utama di mobile (seperti di Fixed Bottom Bar).
  - **Varian**: Primary (Orange), Secondary (Navy), Outline, Ghost, Danger.
  - **State**: Default, Pressed (darken 10% + scale 0.97), Loading, Disabled.
- **Input Field**:
  - Tinggi minimum: **52px** (memenuhi touch target).
  - Label wajib di atas input (bukan floating label).
- **Bottom Sheet**:
  - Radius atas: 16px (`radius-lg`).
  - Wajib memiliki **drag handle** (lebar 40px, tinggi 4px, warna `neutral-300`).

### 4. Aksesibilitas & Touch
- **Touch Target**: Setiap elemen interaktif wajib memiliki area sentuh minimum **44px × 44px**.
- **Thumb Zone**: Aksi utama (Submit, Bayar, Klaim) wajib diletakkan di **Fixed Bottom Bar** agar mudah dijangkau ibu jari.
- **Kontras**: Pastikan kontras teks memenuhi standar WCAG AA (Rasio 4.5:1 untuk teks normal).

### 5. Penanganan Media & Gambar
- **Remote Images**: Selalu gunakan `CachedNetworkImage`.
- **Placeholder**: Wajib menyediakan `placeholder` (shimmer) dan `errorWidget` (icon/asset default) jika gambar gagal dimuat.
- **Thumbnail**: Optimasi ukuran gambar sebelum ditampilkan jika memungkinkan.

### 6. Copywriting & Bahasa
- **Lokalitas**: Gunakan Bahasa Indonesia yang praktis dan intuitif bagi pengguna UMKM.
- **Snackbar**: Gunakan `Get.snackbar` dengan warna latar `AppColors.danger` untuk error dan `AppColors.success` untuk pesan berhasil.