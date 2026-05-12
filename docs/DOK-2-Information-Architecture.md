# DOKUMEN 2
# Information Architecture (IA) & Sitemap
## Marketiv — Mobile App UI/UX Hand-Off Document

**Versi:** 1.0
**Dipersiapkan untuk:** Tim UI/UX Designer
**Catatan:** Dokumen ini mendefinisikan struktur navigasi dan hierarki layar untuk aplikasi mobile Marketiv. Semua nama layar bersifat deskriptif — penamaan final bisa disesuaikan.

---

## Navigasi Dokumen

| # | Dokumen | Isi |
|---|---------|-----|
| 1 | User Personas & Journeys | Siapa pengguna kita & bagaimana mereka berinteraksi |
| **2** | **Information Architecture & Sitemap** ← Anda di sini | Peta navigasi aplikasi mobile |
| 3 | Screen-by-Screen UI Requirements | Panduan wireframe per layar |
| 4 | Design System & UX Constraints | Aturan desain & batasan keras |

---

# BAGIAN A — PRINSIP NAVIGASI MOBILE

Sebelum membaca sitemap, pahami dulu model navigasi yang digunakan:

| Pola Navigasi | Digunakan Untuk | Keterangan |
|---------------|-----------------|------------|
| **Stack Navigation** | Masuk ke halaman detail (push/pop) | Seperti buka profil kreator → kembali ke direktori |
| **Tab Navigation (Bottom Bar)** | Perpindahan antar fitur utama | Tab utama yang selalu terlihat |
| **Bottom Sheet** | Aksi cepat, konfirmasi, form singkat | Muncul dari bawah, tidak meninggalkan layar saat ini |
| **Modal Full-Screen** | Form wizard, error penting, payment | Menutupi seluruh layar, ada tombol tutup |
| **Tab View (dalam layar)** | Perpindahan konten dalam 1 layar | Contoh: tab "Pemasukan / Pengeluaran" |
| **Drawer Navigation** | Tidak digunakan — digantikan Bottom Bar | Drawer kurang optimal untuk 1 tangan |

---

# BAGIAN B — SITEMAP LENGKAP

## LEVEL 0 — Sebelum Login (Public Area)

```
📱 APP LAUNCH
│
├── 🟡 ONBOARDING SCREENS (hanya sekali, saat pertama install)
│   ├── Layar 1: Selamat Datang + Tagline Marketiv
│   ├── Layar 2: Ilustrasi "Buat Campaign, Bayar Sesuai Hasil" (UMKM)
│   ├── Layar 3: Ilustrasi "Klaim Job, Dapat Bayaran Aman" (Kreator)
│   └── Tombol: "Mulai" → ke Pilih Peran
│
├── 🔐 PILIH PERAN
│   ├── Tombol "Saya Pemilik UMKM" → ke Registrasi UMKM
│   └── Tombol "Saya Kreator Konten" → ke Registrasi Kreator
│
├── 🔐 REGISTRASI (Stack Navigation)
│   ├── Form Registrasi (Nama, Email, No. WhatsApp, Password)
│   ├── Verifikasi Email (OTP atau link email)
│   └── Selesai → ke Dashboard sesuai peran
│
└── 🔐 LOGIN
    ├── Form Login (Email + Password)
    ├── Lupa Password → Reset via Email
    └── Berhasil → ke Dashboard sesuai peran
```

---

## LEVEL 1 — Dashboard UMKM

```
🏠 DASHBOARD UMKM
│
│  ╔══════════════════════════════════╗
│  ║  BOTTOM NAVIGATION BAR (UMKM)   ║
│  ╠══════════════════════════════════╣
│  ║ 🏠 Beranda │ 📢 Campaign │       ║
│  ║ 👥 Kreator │ 💰 Keuangan │ 👤 Profil ║
│  ╚══════════════════════════════════╝
│
├── 🏠 TAB: BERANDA (Home Dashboard UMKM)
│   ├── Ringkasan saldo & pengeluaran campaign
│   ├── Campaign aktif (shortcut card)
│   └── Notifikasi terbaru
│
├── 📢 TAB: CAMPAIGN (Campaign Mode)
│   │
│   ├── 📋 DAFTAR CAMPAIGN SAYA
│   │   ├── Filter: Semua / Aktif / Selesai / Draft
│   │   ├── [Kartu Campaign] × N
│   │   │   └── Tap → 📊 DETAIL CAMPAIGN
│   │   │           ├── Tab "Ringkasan" (total views, ROI)
│   │   │           ├── Tab "Submissions" (daftar kreator yang mengumpulkan bukti)
│   │   │           └── Tab "Riwayat Pembayaran"
│   │   └── Tombol "+" → 🆕 FORM BUAT CAMPAIGN (Modal Full-Screen, Wizard 4 Langkah)
│   │           ├── Step 1: Informasi Produk + AI Brief
│   │           ├── Step 2: Upload Aset (foto / link Drive)
│   │           ├── Step 3: Anggaran & Kuota Kreator
│   │           └── Step 4: Review & Pembayaran
│   │
│   └── [Empty State jika belum ada campaign]
│
├── 👥 TAB: KREATOR (Rate Card Mode — sisi UMKM)
│   │
│   ├── 🔍 DIREKTORI KREATOR
│   │   ├── Search bar + Filter Chip (Niche, Harga, Lokasi)
│   │   ├── Grid kartu kreator
│   │   └── Tap kartu → 👤 PROFIL PUBLIK KREATOR
│   │           ├── Foto, nama, niche, bio
│   │           ├── Portofolio konten (link TikTok/IG)
│   │           ├── Rate Card Packages (maks 3 paket)
│   │           └── Tombol "Hubungi Kreator" → 💬 CHAT ROOM
│   │
│   ├── 💬 DAFTAR OBROLAN (Semua order Rate Card)
│   │   ├── Filter: Semua / Negosiasi / Aktif / Selesai
│   │   ├── [Item obrolan] × N (nama kreator, status, pesan terakhir)
│   │   └── Tap → 💬 CHAT ROOM (RATE CARD)
│   │           ├── Status bar order (di bagian atas)
│   │           ├── [Sticky Banner ⚠️ Collab Post — TIDAK BISA DITUTUP]
│   │           ├── Area percakapan (bubble chat)
│   │           ├── Bubble "Custom Offer" (desain khusus)
│   │           └── Input bar + tombol "Kirim Penawaran"
│   │
│   └── [Empty State jika belum pernah chat]
│
├── 💰 TAB: KEUANGAN
│   ├── Total saldo aktif (dalam Escrow + siap dipakai)
│   ├── Riwayat transaksi (deposit, pencairan, komisi)
│   └── Tap transaksi → Detail Transaksi (Stack)
│
└── 👤 TAB: PROFIL (UMKM)
    ├── Nama usaha, foto profil
    ├── Menu:
    │   ├── Edit Profil
    │   ├── Pengaturan Notifikasi
    │   ├── Bantuan & FAQ
    │   ├── Syarat & Ketentuan
    │   └── Keluar (Logout)
    └── [Badge verifikasi jika sudah verifikasi usaha]
```

---

## LEVEL 1 — Dashboard Kreator

```
🎨 DASHBOARD KREATOR
│
│  ╔══════════════════════════════════╗
│  ║  BOTTOM NAVIGATION BAR (KREATOR) ║
│  ╠══════════════════════════════════╣
│  ║ 🏠 Beranda │ 🎯 Job Pool │       ║
│  ║ ✅ Aktif  │ 💰 Dompet  │ 👤 Profil ║
│  ╚══════════════════════════════════╝
│
├── 🏠 TAB: BERANDA (Home Dashboard Kreator)
│   ├── Total pendapatan bulan ini
│   ├── Job yang sedang berjalan (shortcut)
│   └── Notifikasi terbaru
│
├── 🎯 TAB: JOB POOL (Campaign Mode — sisi Kreator)
│   │
│   ├── 🔍 FEED JOB TERSEDIA
│   │   ├── Search + Filter Chip (Niche, Bayaran Minimum)
│   │   ├── Sort: Terbaru / Bayaran Tertinggi / Hampir Penuh
│   │   ├── [Kartu Job] × N
│   │   └── Tap kartu → 📄 DETAIL JOB
│   │           ├── Brief lengkap
│   │           ├── Link aset Drive (tap → buka browser)
│   │           ├── Info: Bayaran, Sisa Slot, Niche
│   │           └── [Fixed Bottom Bar] Tombol "Klaim Job Ini"
│   │                   └── Tap → Bottom Sheet Konfirmasi
│   │                           ├── "Ya, Klaim" → animasi sukses
│   │                           └── "Batal" → tutup sheet
│   │
│   └── [Empty State: "Belum ada job yang tersedia saat ini"]
│
├── ✅ TAB: PEKERJAAN AKTIF
│   │
│   ├── Tab View: "Campaign" | "Rate Card"
│   │
│   ├── [Sub-Tab: Campaign]
│   │   ├── [Kartu pekerjaan aktif] × N
│   │   └── Tap → 📤 LAYAR SUBMIT BUKTI TAYANG
│   │           ├── Detail job (nama UMKM, brief, deadline)
│   │           ├── 1 kolom input URL TikTok/IG
│   │           ├── Panduan "Cara submit yang benar"
│   │           └── Tombol "Submit Bukti Tayang"
│   │
│   └── [Sub-Tab: Rate Card]
│       ├── [Item order] × N (nama UMKM, status, harga)
│       └── Tap → 💬 CHAT ROOM (RATE CARD)
│               ├── Status bar order
│               ├── [Sticky Banner ⚠️ Collab Post]
│               ├── Area percakapan
│               ├── Bubble "Custom Offer" (read-only setelah diterima)
│               └── Tombol "Submit Collab Post" (muncul saat status "Aktif")
│
├── 💰 TAB: DOMPET
│   ├── Total saldo tersedia
│   ├── Riwayat pendapatan
│   ├── Tombol "Tarik Dana" → Form Withdrawal (Bottom Sheet)
│   │   ├── Input: Nama Bank, No. Rekening, Nominal
│   │   └── Tombol "Konfirmasi Penarikan"
│   └── Status penarikan (Proses / Berhasil / Gagal)
│
└── 👤 TAB: PROFIL (Kreator)
    ├── Foto profil, nama, niche, bio
    ├── Statistik publik: Total job selesai, Rating
    ├── Menu:
    │   ├── Edit Profil Publik
    │   ├── Kelola Rate Card (maks 3 paket)
    │   │   ├── [Daftar paket aktif]
    │   │   ├── Tombol "+ Tambah Paket" (disabled jika sudah 3)
    │   │   └── Tap paket → Edit / Hapus Paket
    │   ├── Sambungkan Media Sosial (TikTok, Instagram)
    │   ├── Pengaturan Notifikasi
    │   └── Keluar
    └── [Preview tampilan profil publik]
```

---

## LEVEL 1 — Panel Admin

```
🔑 PANEL ADMIN
│
│  ╔══════════════════════════════════╗
│  ║  BOTTOM NAVIGATION BAR (ADMIN)   ║
│  ╠══════════════════════════════════╣
│  ║ 📊 Dasbor │ ⚠️ Sengketa │         ║
│  ║ 📋 Submisi │ 📈 Laporan │ 👤 Akun ║
│  ╚══════════════════════════════════╝
│
├── 📊 TAB: DASBOR ADMIN
│   ├── Total GMV hari ini / bulan ini
│   ├── Total pengguna aktif (UMKM & Kreator)
│   ├── Jumlah campaign aktif
│   └── Alert: Submisi menunggu validasi, Sengketa baru
│
├── ⚠️ TAB: SENGKETA
│   ├── [Daftar sengketa aktif] dengan status
│   └── Tap → Detail Sengketa
│           ├── Riwayat chat/transaksi terkait
│           ├── Tombol "Validasi Manual (Setujui)"
│           ├── Tombol "Tahan Dana"
│           └── Tombol "Refund ke UMKM"
│
├── 📋 TAB: SUBMISI
│   ├── Filter: Menunggu / Valid / Terindikasi Fraud
│   ├── [Daftar submisi] × N
│   └── Tap → Detail Submisi
│           ├── URL bukti tayang (tap → buka browser)
│           ├── Data views yang terekam
│           └── Tombol override status
│
└── 📈 TAB: LAPORAN
    ├── Pilih rentang tanggal
    ├── Pilih jenis laporan (GMV / Pengguna / Campaign)
    └── Tombol "Export CSV / Excel"
```

---

# BAGIAN C — DIAGRAM ALUR NAVIGASI (Simplified)

```
APLIKASI DIBUKA
      │
      ▼
[Cek status login]
      │
   ┌──┴──┐
   │     │
Sudah   Belum
login   login
   │     │
   │     ▼
   │  ONBOARDING → PILIH PERAN → REGISTRASI / LOGIN
   │
   ▼
[Cek role pengguna]
   │
   ├──── UMKM ────► DASHBOARD UMKM (Bottom Nav: Beranda·Campaign·Kreator·Keuangan·Profil)
   │
   ├──── KREATOR ──► DASHBOARD KREATOR (Bottom Nav: Beranda·Job Pool·Aktif·Dompet·Profil)
   │
   └──── ADMIN ───► PANEL ADMIN (Bottom Nav: Dasbor·Sengketa·Submisi·Laporan·Akun)
```

---

# BAGIAN D — PEMETAAN KONEKSI ANTAR LAYAR

Tabel ini menunjukkan dari mana sebuah layar bisa diakses, untuk membantu desainer memahami alur navigasi:

| Layar Tujuan | Bisa Diakses Dari |
|---|---|
| Detail Campaign (UMKM) | Tap kartu di tab Campaign |
| Form Buat Campaign | Tap tombol "+" di tab Campaign |
| Profil Publik Kreator | Tap kartu di Direktori Kreator |
| Chat Room | Tap "Hubungi Kreator" di Profil Kreator ATAU Tap item di Daftar Obrolan |
| Detail Job (Kreator) | Tap kartu di Job Pool |
| Submit Bukti Tayang | Tap item di tab Pekerjaan Aktif > sub-tab Campaign |
| Form Withdrawal | Tap "Tarik Dana" di tab Dompet Kreator |
| Edit Rate Card | Tap menu di tab Profil Kreator |
| Detail Sengketa (Admin) | Tap item di tab Sengketa |

---

*Lanjut ke Dokumen 3: Screen-by-Screen UI Requirements →*
