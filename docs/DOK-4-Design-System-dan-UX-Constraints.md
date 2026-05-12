# DOKUMEN 4
# Design System & UX Constraints
## Marketiv — Mobile App UI/UX Hand-Off Document

**Versi:** 1.0
**Dipersiapkan untuk:** Tim UI/UX Designer
**Catatan:** Dokumen ini adalah aturan desain yang bersifat **WAJIB dan MENGIKAT**. Setiap penyimpangan dari panduan ini harus didiskusikan dan disetujui sebelum diimplementasikan.

---

## Navigasi Dokumen

| # | Dokumen | Isi |
|---|---------|-----|
| 1 | User Personas & Journeys | Siapa pengguna kita & bagaimana mereka berinteraksi |
| 2 | Information Architecture & Sitemap | Peta navigasi aplikasi mobile |
| 3 | Screen-by-Screen UI Requirements | Panduan wireframe per layar |
| **4** | **Design System & UX Constraints** ← Anda di sini | Aturan desain & batasan keras |

---

# BAGIAN A — DESAIN TOKEN (Design Tokens)

Design Token adalah nilai-nilai dasar yang menjadi "bahasa bersama" antara desainer dan developer. Seluruh elemen visual wajib mengacu pada token di bawah ini. **Jangan gunakan nilai warna, ukuran, atau spasi di luar daftar ini tanpa diskusi terlebih dahulu.**

---

## A.1 — Palet Warna

### Warna Primer (Brand Color)

| Token | Nama | Nilai HEX | Keterangan |
|-------|------|-----------|------------|
| `color-primary-50` | Primary Lightest | `#FFF7ED` | Background chip/badge ringan |
| `color-primary-100` | Primary Light | `#FFEDD5` | Background state aktif ringan |
| `color-primary-500` | Primary Main | `#F97316` | **Warna utama brand (oranye)** |
| `color-primary-600` | Primary Dark | `#EA580C` | State ditekan (tombol primary) |
| `color-primary-700` | Primary Darkest | `#C2410C` | Digunakan di konteks serius/kritis |

### Warna Sekunder (Dark Navy)

| Token | Nama | Nilai HEX | Keterangan |
|-------|------|-----------|------------|
| `color-secondary-500` | Secondary Main | `#1E3A5F` | Elemen dark (header, badge penting) |
| `color-secondary-600` | Secondary Dark | `#162D4A` | State aktif secondary |
| `color-secondary-700` | Secondary Darkest | `#0F2039` | Teks heading utama gelap |

### Warna Semantik

| Token | Nama | Nilai HEX | Keterangan |
|-------|------|-----------|------------|
| `color-success` | Success | `#16A34A` | Status berhasil, validasi positif |
| `color-warning` | Warning | `#D97706` | Peringatan, perhatian |
| `color-danger` | Danger | `#DC2626` | Error, aksi berbahaya |
| `color-info` | Info | `#2563EB` | Informasi netral |

### Warna Netral

| Token | Nama | Nilai HEX | Keterangan |
|-------|------|-----------|------------|
| `color-neutral-0` | White | `#FFFFFF` | Background kartu, modal |
| `color-neutral-50` | Background | `#F8F7F5` | Background layar utama |
| `color-neutral-100` | Surface | `#F1F0EE` | Background input, divider area |
| `color-neutral-300` | Border | `#D4D0CB` | Garis pembatas, border input |
| `color-neutral-500` | Muted | `#78716C` | Teks sekunder, placeholder |
| `color-neutral-700` | Subtle | `#44403C` | Teks keterangan |
| `color-neutral-900` | Foreground | `#0A0A0A` | Teks utama, ikon |

---

## A.2 — Tipografi

**Font Utama:** `Inter` (sistem, tidak butuh unduhan tambahan)

### Skala Ukuran Teks

| Token | Nama | Ukuran | Line Height | Font Weight | Digunakan Untuk |
|-------|------|--------|-------------|-------------|-----------------|
| `text-xs` | Caption | 11px | 16px | Regular (400) | Label kecil, timestamp |
| `text-sm` | Small | 13px | 20px | Regular (400) | Teks pendukung, muted |
| `text-base` | Body | 15px | 24px | Regular (400) | **Body text standar** |
| `text-lg` | Body Large | 17px | 28px | Medium (500) | Label penting, judul kartu |
| `text-xl` | Title | 20px | 28px | SemiBold (600) | Judul section kecil |
| `text-2xl` | Headline | 24px | 32px | Bold (700) | Heading halaman |
| `text-3xl` | Display | 30px | 40px | Bold (700) | Judul utama (hero card) |

**Aturan Font Minimum:**
> ⚠️ **Ukuran font minimum untuk body text adalah 15px (text-base).**
> Tidak ada teks konten yang boleh lebih kecil dari ini.
> Ukuran 11px (text-xs) hanya boleh untuk label timestamp atau caption metadata.

---

## A.3 — Spacing & Layout

**Sistem Spacing:** Kelipatan 4px

| Token | Nilai | Keterangan |
|-------|-------|------------|
| `space-1` | 4px | Jarak sangat kecil (ikon dalam teks) |
| `space-2` | 8px | Jarak internal kecil |
| `space-3` | 12px | Jarak antara elemen dalam satu grup |
| `space-4` | 16px | **Padding standar konten** |
| `space-5` | 20px | Jarak antar elemen utama |
| `space-6` | 24px | Margin section |
| `space-8` | 32px | Jarak antar kartu / section besar |
| `space-10` | 40px | Padding vertikal layar |
| `space-12` | 48px | Jarak besar antar section |

**Layout Dasar:**
- Padding horizontal layar: `space-4` (16px) di kiri dan kanan
- Padding bottom layar: tambahan `space-6` (24px) di atas safe area perangkat
- Grid kartu 2 kolom: gap `space-3` (12px)
- Grid kartu 1 kolom: gap `space-4` (16px)

---

## A.4 — Border Radius

| Token | Nilai | Digunakan Untuk |
|-------|-------|-----------------|
| `radius-sm` | 8px | Input field, chip kecil |
| `radius-md` | 12px | Kartu (card) standar |
| `radius-lg` | 16px | Modal, bottom sheet, kartu besar |
| `radius-xl` | 24px | Tombol primer, hero card |
| `radius-full` | 999px | Badge, avatar, chip bulat |

---

## A.5 — Bayangan (Shadow)

| Token | Nilai CSS | Digunakan Untuk |
|-------|-----------|-----------------|
| `shadow-sm` | `0 1px 3px rgba(0,0,0,0.06)` | Input focus, elemen ringan |
| `shadow-md` | `0 4px 12px rgba(0,0,0,0.08)` | Kartu standar |
| `shadow-lg` | `0 8px 24px rgba(0,0,0,0.12)` | Modal, bottom sheet, FAB |
| `shadow-xl` | `0 16px 40px rgba(0,0,0,0.16)` | Tombol primer saat ditekan |

---

# BAGIAN B — KOMPONEN UI

---

## B.1 — Tombol (Button)

### Varian Tombol

| Varian | Tampilan | Digunakan Untuk |
|--------|----------|-----------------|
| **Primary** | Background `primary-500`, teks putih | Aksi utama per halaman |
| **Secondary** | Background `secondary-500`, teks putih | Aksi sekunder penting |
| **Outline** | Border `primary-500`, teks `primary-500`, bg transparan | Aksi alternatif |
| **Ghost** | Tanpa border dan bg, teks `primary-500` | Aksi ringan (batal, link) |
| **Danger** | Background `danger`, teks putih | Hapus, batalkan |
| **Disabled** | Semua varian: opacity 40%, tidak interaktif | Tombol belum bisa diklik |

### Ukuran Tombol

| Ukuran | Tinggi | Padding Horizontal | Font Size |
|--------|--------|--------------------|-----------|
| Small | 36px | 16px | 13px |
| **Medium (default)** | **48px** | **20px** | **15px** |
| Large | 56px | 24px | 17px |
| **Full Width** | **48px** | **16px (ke pinggir layar)** | **15px** |

> ⚠️ **Tombol Full Width adalah standar untuk aksi utama di mobile.** Gunakan di fixed bottom bar dan dalam form wizard.

### State Tombol

| State | Tampilan |
|-------|----------|
| **Default** | Normal, warna penuh |
| **Pressed** | Sedikit lebih gelap (darkened 10%), scale sedikit lebih kecil (0.97) |
| **Loading** | Disabled + indikator spinner kecil di dalam tombol. Teks berubah: "Memproses..." |
| **Disabled** | Opacity 40%, kursor tidak berubah |
| **Hover** | ❌ **TIDAK ADA** — ini aplikasi mobile, tidak ada hover state |

---

## B.2 — Input Field

- Tinggi minimum: **52px** (memenuhi touch target)
- Border default: `1px solid neutral-300`
- Border fokus: `2px solid primary-500`
- Border error: `2px solid danger`
- Radius: `radius-sm` (8px)
- Font placeholder: `neutral-500`, 15px
- Font input: `neutral-900`, 15px
- Padding internal: `space-3` vertikal, `space-4` horizontal

**Label Field:**
- Di atas input, bukan di dalam input (floating label tidak direkomendasikan untuk UMKM dengan literasi rendah)
- Bold, ukuran `text-sm` (13px), warna `neutral-700`
- Tanda `*` berwarna `danger` untuk field wajib

---

## B.3 — Kartu (Card)

- Background: `color-neutral-0` (putih)
- Border: `1px solid neutral-100` (opsional, atau tanpa border + shadow)
- Shadow: `shadow-md`
- Radius: `radius-md` (12px)
- Padding internal: `space-4` (16px)

---

## B.4 — Bottom Sheet

- Radius atas kiri & kanan: `radius-lg` (16px)
- Background: `color-neutral-0`
- Shadow: `shadow-xl`
- Selalu ada **drag handle** di bagian atas (garis horizontal pendek, warna `neutral-300`, lebar 40px, tinggi 4px)
- **Overlay** semi-transparan di belakang (background hitam opacity 40%)
- Bisa ditutup dengan swipe ke bawah (kecuali bottom sheet yang tidak bisa ditutup)

---

# BAGIAN C — ATURAN AKSESIBILITAS & TOUCH

---

## C.1 — Touch Target Minimum

> ⚠️ **WAJIB: Setiap elemen yang bisa diketuk harus memiliki area sentuh minimum 44px × 44px.**

Ini adalah standar Apple Human Interface Guidelines dan Google Material Design. Elemen yang terlalu kecil akan menyulitkan pengguna dengan jari besar atau pengguna lanjut usia.

**Implementasi:**
- Tombol: sudah penuhi dari ukuran standar (min 48px tinggi)
- Ikon aksi: tambahkan padding invisible di sekitarnya agar area sentuh minimal 44×44px
- Item list: tinggi minimal 56px per item
- Chip/tag: tinggi minimal 36px

---

## C.2 — Kontras Warna (Accessibility)

Semua teks harus memenuhi standar WCAG AA:

| Kombinasi | Rasio Minimum |
|-----------|---------------|
| Teks normal di background putih | 4.5:1 |
| Teks besar (18px+) di background | 3:1 |
| Teks putih di tombol primary | ✅ Terpenuhi (oranye ke putih ~4.7:1) |

**Hindari:** Teks abu-abu `neutral-300` di background putih (rasio terlalu rendah). Gunakan minimal `neutral-500`.

---

## C.3 — Zona Ibu Jari (Thumb Zone)

Pada layar 375px, area yang mudah dijangkau ibu jari:

```
┌──────────────┐
│   SULIT      │  ← Area paling atas: hindari aksi penting
│  DIJANGKAU   │     di sini. Cocok untuk judul/navigasi.
│              │
│   MUDAH      │  ← Area tengah ke bawah: paling ideal
│  DIJANGKAU   │     untuk aksi utama (klaim, submit, dll)
│              │
│  [PALING     │  ← Area ini paling mudah — fixed bottom bar
│   MUDAH]     │     cocok untuk tombol CTA utama
└──────────────┘
```

**Implementasi:**
- Tombol aksi utama (Klaim, Submit, Bayar, Kirim) → **selalu di fixed bottom bar**
- Filter & search → di bagian atas (sekunder, pengguna rela geser)
- FAB (Floating Action Button) untuk "Buat Campaign" → **pojok kanan bawah**

---

# BAGIAN D — HARD CONSTRAINTS (ATURAN YANG TIDAK BOLEH DILANGGAR)

Bagian ini menjelaskan batasan-batasan desain yang **bukan keputusan estetis**, melainkan batasan dari logika bisnis produk. Pelanggaran terhadap aturan ini akan menyebabkan produk tidak bisa dibangun sesuai rencana.

---

## ❌ LARANGAN 1: TIDAK ADA FITUR CHAT DI CAMPAIGN MODE

**Konteks:** Campaign Mode adalah mode di mana UMKM membuat campaign dan kreator mengklaimnya tanpa komunikasi langsung. Ini **disengaja** untuk memastikan proses berjalan cepat tanpa negosiasi yang melelahkan.

**Yang DILARANG didesain:**
- Tombol "Chat" atau "Pesan" di halaman daftar campaign (sisi UMKM)
- Tombol "Hubungi UMKM" di halaman detail job (sisi Kreator)
- Kolom komentar, tanya-jawab, atau form kontak di Campaign Mode
- Notifikasi yang mengundang UMKM dan Kreator untuk berkomunikasi soal campaign
- Form revisi atau feedback dari UMKM ke Kreator di Campaign Mode

**Yang BOLEH ada di Campaign Mode:**
- Informasi status (misal: "Kreator A sudah submit bukti")
- Laporan hasil (views, ROI) yang bersifat satu arah
- Notifikasi sistem (bukan chat)

> ✅ Fitur Chat **HANYA ADA** di Rate Card Mode, di dalam halaman Chat Room yang terpisah.

---

## ❌ LARANGAN 2: TIDAK ADA TOMBOL UPLOAD FILE VIDEO LANGSUNG

**Konteks:** Marketiv tidak menyimpan file video besar di server. Semua video mentah harus di-host di Google Drive atau Dropbox, dan kreator wajib posting ke TikTok/Instagram mereka sendiri.

**Yang DILARANG didesain:**
- Tombol "Upload Video" di form Campaign (untuk UMKM)
- Tombol "Upload Video" di halaman submit bukti tayang (untuk Kreator)
- Antarmuka preview video yang di-host di dalam aplikasi
- Form lampiran file video di chat (Rate Card Mode)

**Yang BENAR:**
- Di form Campaign (UMKM): Input field URL Drive/Dropbox
- Di halaman submit (Kreator): Input field URL TikTok/Instagram
- Di chat Rate Card: Hanya teks dan Custom Offer widget — tidak ada lampiran file besar

---

## ❌ LARANGAN 3: TIDAK ADA HOVER STATE

**Konteks:** Ini adalah aplikasi mobile. Perangkat sentuh tidak mengenal konsep "hover". Mendesain hover state akan membuang waktu dan tidak akan pernah diimplementasikan.

**Aturan:**
- Semua state interaksi harus dalam bentuk: Default → Pressed (ditekan) → Disabled
- Tidak perlu mendesain perubahan visual saat "kursor mendekati elemen"
- Untuk efek visual saat item disentuh (pressed), gunakan darken ringan atau scale sedikit mengecil (sudah diatur di aturan tombol)

---

## ❌ LARANGAN 4: TIDAK ADA BATAS MAKSIMAL 3 RATE CARD YANG BISA DIABAIKAN

**Konteks:** Setiap kreator hanya boleh memiliki maksimal 3 paket Rate Card.

**Aturan Desain:**
- Tombol "+ Tambah Paket Baru" harus berubah menjadi **disabled** ketika kreator sudah memiliki 3 paket aktif
- Wajib ada tooltip atau pesan kecil yang menjelaskan alasannya: *"Maksimal 3 paket. Hapus satu paket untuk menambah yang baru."*
- Jangan sembunyikan tombol — **disable-kan, bukan hilangkan** (pengguna perlu tahu alasannya)

---

## ❌ LARANGAN 5: WARNING BANNER COLLAB POST TIDAK BOLEH BISA DITUTUP

**Konteks:** Di Rate Card Mode, kreator wajib menggunakan fitur Collab Post saat memposting hasil kerja. Banner peringatan ini adalah pengingat kritikal.

**Aturan Desain:**
- Banner ⚠️ "Wajib Collab Post" di halaman Chat Room Rate Card harus bersifat **sticky (selalu tampil di atas area chat)**
- Tidak ada tombol "X" atau "Tutup" di banner ini
- Banner tidak boleh bisa di-dismiss dengan swipe atau tap

---

## ❌ LARANGAN 6: TIDAK ADA AKSES KE DATA UMKM DI CAMPAIGN MODE (UNTUK KREATOR)

**Aturan Desain:**
- Di halaman detail job (Campaign Mode), nama UMKM boleh tampil tapi **kontak (nomor WhatsApp, email) tidak boleh tampil**
- Tidak ada tombol "Lihat Profil Lengkap UMKM" yang menampilkan informasi kontak
- Kreator hanya bisa mengakses: brief, link aset Drive, informasi bayaran, dan sisa slot

---

# BAGIAN E — PANDUAN PENGALAMAN NATIVE MOBILE

---

## E.1 — Gestur Standar yang Harus Didukung

| Gestur | Aksi |
|--------|------|
| **Swipe kanan dari tepi** | Kembali (back navigation) — standar iOS |
| **Pull to refresh** | Refresh daftar (Job Pool, Campaign, Riwayat) |
| **Swipe ke bawah** | Tutup bottom sheet |
| **Long press** | Salin teks (URL, judul campaign) |
| **Scroll vertical** | Navigasi konten dalam layar |
| **Pinch to zoom** | Pada tampilan gambar/thumbnail |

---

## E.2 — Notifikasi

Jenis notifikasi yang perlu didesain (template teks):

| Peristiwa | Judul Notif | Isi Notif |
|-----------|-------------|-----------|
| Kreator klaim campaign UMKM | "Ada yang klaim! 🎉" | "[Nama Kreator] baru saja klaim campaign [Nama Campaign]." |
| Kreator submit bukti tayang | "Bukti tayang masuk" | "[Nama Kreator] sudah submit link video untuk [Nama Campaign]." |
| Dana cair ke kreator | "Dana berhasil masuk! 💰" | "Rp [X] dari [Nama Campaign] sudah masuk ke dompetmu." |
| Penawaran Custom Offer dikirim | "Ada penawaran masuk 📋" | "[Nama UMKM] mengirim penawaran Rp [X]. Cek sekarang!" |
| Pembayaran Rate Card berhasil | "Pembayaran diterima ✅" | "[Nama UMKM] sudah bayar. Yuk mulai pengerjaan!" |
| Penarikan dana berhasil | "Penarikan berhasil 🏦" | "Rp [X] sudah dikirim ke rekening [Nama Bank] kamu." |

---

## E.3 — Loading & Skeleton States

Setiap layar yang memuat data dari server harus menampilkan **Skeleton State** (bukan spinner penuh layar) agar pengalaman terasa lebih cepat:

| Elemen | Skeleton |
|--------|----------|
| Kartu Job Pool | Kotak abu-abu bergelombang sesuai bentuk kartu asli |
| Daftar chat | Baris-baris dengan gelombang, mirip bubble chat |
| Profil kreator | Lingkaran avatar + garis-garis teks |
| Riwayat transaksi | Baris daftar dengan gelombang |

**Aturan:**
- Skeleton warna dasar: `neutral-100`
- Skeleton shimmer (gelombang): `neutral-200`
- Tidak tampilkan spinner penuh layar kecuali untuk aksi yang memang membutuhkan waktu (payment gateway)

---

## E.4 — Transisi Layar (Screen Transitions)

| Jenis Navigasi | Transisi |
|----------------|----------|
| Masuk ke detail (push) | Slide dari kanan |
| Kembali (pop) | Slide ke kanan |
| Bottom Sheet muncul | Slide dari bawah |
| Modal Full-Screen | Fade + slide dari bawah |
| Tab Navigation | Fade (tanpa slide) |
| Layar sukses/error | Fade |

---

## E.5 — Safe Area & Notch

- Semua konten harus menghormati **Safe Area** perangkat (area di bawah notch/Dynamic Island iOS dan di atas navigation bar Android)
- Fixed Bottom Bar harus menyertakan padding bawah tambahan sebesar tinggi Safe Area (biasanya 34px di iPhone dengan notch)
- Konten tidak boleh terpotong di belakang status bar atas

---

# BAGIAN F — REFERENSI CEPAT (Quick Reference Card)

Gunakan tabel ini sebagai cheat sheet saat mendesain:

```
╔══════════════════════════════════════════════════════════╗
║            MARKETIV DESIGN QUICK REFERENCE               ║
╠══════════════════════════════════════════════════════════╣
║  WARNA UTAMA                                             ║
║  Primary    : #F97316 (Oranye)                           ║
║  Secondary  : #1E3A5F (Navy)                             ║
║  Background : #F8F7F5 (Krem terang)                      ║
║  Teks Utama : #0A0A0A (Hitam pekat)                      ║
║  Teks Muted : #78716C (Abu kecoklatan)                   ║
╠══════════════════════════════════════════════════════════╣
║  TIPOGRAFI                                               ║
║  Font       : Inter                                      ║
║  Body min   : 15px                                       ║
║  Caption min: 11px (hanya timestamp/metadata)            ║
║  Heading    : 24px Bold                                  ║
╠══════════════════════════════════════════════════════════╣
║  TOUCH TARGET                                            ║
║  Minimum    : 44px × 44px (WAJIB)                        ║
║  Tombol std : 48px tinggi (Full Width untuk aksi utama)  ║
╠══════════════════════════════════════════════════════════╣
║  RADIUS                                                  ║
║  Kartu      : 12px                                       ║
║  Tombol     : 24px (full rounded)                        ║
║  Input      : 8px                                        ║
║  Bottom Sheet: 16px (atas kiri & kanan)                  ║
╠══════════════════════════════════════════════════════════╣
║  LARANGAN KERAS                                          ║
║  ❌ Hover state (ini mobile app)                         ║
║  ❌ Upload video langsung (wajib pakai URL Drive/TikTok) ║
║  ❌ Chat di Campaign Mode                                ║
║  ❌ Banner Collab Post bisa ditutup                      ║
║  ❌ Rate Card > 3 paket per kreator (tombol disabled)    ║
╚══════════════════════════════════════════════════════════╝
```

---

*Ini adalah akhir dari Dokumen 4 dan seluruh paket UI/UX Hand-Off Dokumen Marketiv.*

*Untuk pertanyaan teknis lebih lanjut, silakan merujuk kembali ke dokumen spesifikasi teknis asli (FEATURES.md, DATABASE.md, TECHNICAL_GUIDELINES.md).*
