# DOKUMEN 3
# Screen-by-Screen UI Requirements
## Marketiv — Mobile App UI/UX Hand-Off Document

**Versi:** 1.0
**Dipersiapkan untuk:** Tim UI/UX Designer
**Catatan:** Dokumen ini adalah panduan wireframe per layar. Setiap layar dijelaskan dari atas ke bawah (top-to-bottom) mengikuti tata letak visual di smartphone. Ukuran referensi layar: **375px × 812px** (iPhone SE/standard).

---

## Navigasi Dokumen

| # | Dokumen | Isi |
|---|---------|-----|
| 1 | User Personas & Journeys | Siapa pengguna kita & bagaimana mereka berinteraksi |
| 2 | Information Architecture & Sitemap | Peta navigasi aplikasi mobile |
| **3** | **Screen-by-Screen UI Requirements** ← Anda di sini | Panduan wireframe per layar |
| 4 | Design System & UX Constraints | Aturan desain & batasan keras |

---

# GRUP A — LAYAR PUBLIK (Sebelum Login)

---

## A.1 — Layar Onboarding

**Tipe:** Full-screen carousel (swipe horizontal), 3 slide + 1 layar CTA

**Elemen per Slide:**
```
┌────────────────────────────────┐
│                                │
│        [ILUSTRASI BESAR]       │  ← 60% tinggi layar
│                                │
│   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│                                │
│   [JUDUL SLIDE]                │  ← Font besar, bold
│   Misalnya: "Promosi Aman,     │
│   Bayar Sesuai Hasil"          │
│                                │
│   [DESKRIPSI 2 BARIS]          │  ← Font kecil, muted
│                                │
│   ● ○ ○   [Lanjut →]          │  ← Dot indicator + tombol
│                                │
└────────────────────────────────┘
```

**Slide 1:** Ilustrasi UMKM + kreator saling terhubung. Tagline Marketiv.
**Slide 2:** Ilustrasi alur "Upload Brief → Kreator Klaim → Dibayar Sesuai Views".
**Slide 3:** Ilustrasi kreator edit video + dapat penghasilan pertama.

**Layar 4 (CTA):**
- Tombol utama (full-width): **"Saya Pemilik UMKM"** — warna primer
- Tombol sekunder (full-width, outline): **"Saya Kreator Konten"**
- Link teks kecil di bawah: "Sudah punya akun? Masuk"

---

## A.2 — Layar Login

**Tipe:** Stack screen

**Elemen (atas ke bawah):**
```
┌────────────────────────────────┐
│  ← Kembali           [Logo]   │  ← AppBar ringan
│                                │
│  Masuk ke Marketiv             │  ← Heading
│  Selamat datang kembali!       │  ← Subheading, muted
│                                │
│  [Input: Email]                │
│  [Input: Password] [👁 Toggle] │
│                                │
│  Lupa Password?                │  ← Link, rata kanan
│                                │
│  [Tombol: Masuk — full width]  │  ← Tombol primer besar
│                                │
│  ──────── atau ────────        │
│                                │
│  [Belum punya akun? Daftar]    │  ← Link di bawah
└────────────────────────────────┘
```

**State tombol "Masuk":**
- Default: aktif, warna primer
- Loading: disabled + indikator loading kecil di dalam tombol
- Error: form di-shake, pesan error muncul di bawah field

**Pesan Error:**
- Email/password salah: `"Email atau password tidak sesuai. Coba lagi."`
- Belum verifikasi email: `"Silakan cek email kamu untuk verifikasi akun."` + tombol "Kirim Ulang"

---

## A.3 — Layar Registrasi

**Tipe:** Single screen dengan scroll (tidak wizard — registrasi harus cepat)

**Elemen:**
- Heading: "Buat Akun"
- Field: Nama Lengkap / Nama Usaha
- Field: Email
- Field: Nomor WhatsApp
- Field: Password + konfirmasi password
- Checkbox: "Saya setuju dengan Syarat & Ketentuan" (wajib dicentang)
- Tombol: **"Daftar Sekarang"** (full-width, primer)

**Validasi Inline (tampil langsung saat user selesai ketik di field):**
- Email: "Format email tidak valid"
- Password: "Minimal 8 karakter, gunakan huruf dan angka"
- WhatsApp: "Nomor harus dimulai dengan 08 atau +62"

---

# GRUP B — LAYAR UMKM

---

## B.1 — Dashboard Beranda UMKM

**Tipe:** Scrollable screen

**Elemen (atas ke bawah):**
```
┌────────────────────────────────┐
│  ~ Hai, Bu Sari!    [🔔] [👤] │  ← Greeting + notif + avatar
│                                │
│  ┌──────────────────────────┐  │
│  │  Total Saldo Escrow       │  │  ← Hero card (warna gradient)
│  │  Rp 150.000               │  │
│  │  Campaign Aktif: 2        │  │
│  └──────────────────────────┘  │
│                                │
│  Campaign Aktif Saya           │  ← Section title
│  ┌──────────────────────────┐  │
│  │ [Nama Campaign]          │  │  ← Shortcut card campaign aktif
│  │ 🟢 Aktif · 1.200 views   │  │
│  └──────────────────────────┘  │
│  [Lihat Semua Campaign →]      │  ← Link teks
│                                │
│  [+ Buat Campaign Baru]        │  ← FAB / Tombol besar
└────────────────────────────────┘
```

---

## B.2 — Form Buat Campaign (Wizard 4 Langkah)

**Tipe:** Modal Full-Screen dengan Progress Bar di atas

**Progress Bar:** Terdapat di bawah AppBar, 4 segmen. Segmen yang sudah selesai berwarna primer, segmen mendatang berwarna abu-abu.

```
[←]  Buat Campaign Baru              [X Batal]
━━━━━━━━━░░░░░░░░░░░░░░░░░░░░░░░  Langkah 1 dari 4
```

---

### B.2.1 — Step 1: Informasi Produk

**Elemen (atas ke bawah):**

```
Judul Langkah: "Ceritakan Produkmu"
Subjudul: "Isi informasi dasar agar kreator tahu apa yang akan mereka promosikan."

[Label] Nama Produk / Judul Campaign *
[Input field — wajib]
Placeholder: "cth: Ayam Geprek Special Bu Sari"

[Label] Kategori Produk *
[Dropdown / Chip Selector — wajib]
Pilihan: Kuliner 🍽 · Fesyen 👗 · Pariwisata 🏝 · Edukasi 📚 · Kecantikan 💄 · Lainnya

[Label] Instruksi untuk Kreator (Brief)
[Textarea multi-line — opsional, tapi direkomendasikan]
Placeholder: "Ceritakan apa yang kamu ingin kreator sampaikan dalam videonya..."
[Counter karakter: 0/500]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Kesulitan mengisi brief?
   Biarkan AI membantu kamu!
   [Tombol: "Bantu Saya Tulis Brief ✨"]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Fixed Bottom Bar]
[Tombol: "Lanjut →" (full-width, primer, disabled jika field wajib kosong)]
```

**State Tombol "Bantu Saya Tulis Brief ✨":**
- Tap → Bottom Sheet muncul dari bawah
- Loading state: ikon berputar, teks "AI sedang menyusun brief untukmu..."
- Selesai: teks hasil AI mengisi otomatis textarea
- Ada label kecil di bawah textarea: `✨ Draf oleh AI — bisa kamu edit`

---

### B.2.2 — Step 2: Upload Aset

**Elemen:**

```
Judul Langkah: "Upload Materi Promosi"
Subjudul: "Berikan bahan mentah videomu (foto/video produk) untuk kreator."

┌──────────────────────────────────────┐
│                                      │
│   📁  Ketuk untuk pilih foto         │  ← Area Upload (tap target besar)
│       atau video dari galeri         │
│                                      │
│   Format: JPG, PNG, MP4              │
│   Maks. ukuran file: 100 MB          │
│                                      │
└──────────────────────────────────────┘

──────────── ATAU ────────────

[Label] Tempel Link Google Drive / Dropbox
[Input field]
Placeholder: "https://drive.google.com/..."
[Tombol kecil "Tempel" di kanan field]

⚠️ INFO: Untuk video berukuran besar,
   wajib gunakan link Drive/Dropbox.
   Marketiv tidak menyimpan file video.
```

**State Validasi (muncul setelah tap "Lanjut"):**

**KONDISI: File terlalu besar (> 100MB)**
```
[Bottom Sheet Error muncul dari bawah]
┌──────────────────────────────────────┐
│  ☁️  File Terlalu Besar              │
│                                      │
│  Ukuran file melebihi batas 100 MB.  │
│  Kreator kita butuh file mentahnya,  │
│  jadi upload ke Google Drive dulu,   │
│  lalu tempel link-nya di kolom       │
│  di atas.                            │
│                                      │
│  [Buka Google Drive]  [Mengerti]     │
└──────────────────────────────────────┘
```

**KONDISI: URL tidak valid**
```
Pesan inline di bawah field:
❌ "Link tidak valid. Pastikan link dimulai dengan https://"
```

**KONDISI: Salah satu dari dua (file ATAU link) sudah diisi**
```
✅ Aset siap! Tap "Lanjut" untuk melanjutkan.
```

---

### B.2.3 — Step 3: Anggaran & Kuota Kreator

**Elemen:**

```
Judul Langkah: "Tentukan Anggaran"
Subjudul: "Bayaran dihitung dari jumlah tayangan nyata yang didapat."

[Label] Harga per 1.000 Tayangan (Views) *
[Slider]  Rp 2.000 ●──────────────── Rp 10.000
          [Display nilai aktif: Rp 5.000]

Semakin tinggi harga, semakin banyak
kreator yang tertarik mengklaim.

[Label] Jumlah Kreator yang Dibutuhkan *
[Stepper: − 3 +]  (min: 1, max: 100)

[Label] Batas Total Anggaran (Rp) *
[Input angka — atau auto-hitung dari estimasi]
Placeholder: "cth: 500000"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Ringkasan Perkiraan Biaya
   Budget Campaign:      Rp 500.000
   Komisi Platform 15%:  Rp  75.000
   ─────────────────────────────────
   Total yang Dibayar:   Rp 575.000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Fixed Bottom Bar]
[Tombol: "Lanjut →"]
```

**Catatan:** Kalkulasi di kotak "Ringkasan Perkiraan Biaya" harus update secara real-time saat nilai slider atau input berubah.

---

### B.2.4 — Step 4: Review & Bayar

**Elemen:**

```
Judul Langkah: "Review Campaign"
Subjudul: "Cek kembali sebelum memulai."

[Card ringkasan — seluruh isi form ditampilkan ulang]
┌──────────────────────────────────────┐
│ Nama Campaign: Ayam Geprek Special   │
│ Kategori: Kuliner                    │
│ Aset: link Drive (✓ valid)           │
│ Bayaran: Rp 5.000 / 1.000 views      │
│ Kreator dibutuhkan: 3                │
│ Total Anggaran: Rp 575.000           │
│                      [Edit ✏️]       │
└──────────────────────────────────────┘

[Akordion — bisa dibuka: "Syarat Campaign"]
Dengan membuat campaign ini, kamu setuju
dana akan ditahan hingga kampanye selesai
divalidasi.

[Fixed Bottom Bar]
[Tombol: "Bayar Sekarang — Rp 575.000"]
(tap → buka payment gateway)
```

**Setelah Pembayaran Berhasil:**
```
[Layar Sukses — full screen]

     ✅  (animasi centang)

Campaign Berhasil Dibuat!

Kreator akan mulai mengklaim pekerjaanmu
dalam waktu dekat.

[Tombol: "Pantau Campaign"]
[Link: "Buat Campaign Lain"]
```

---

## B.3 — Halaman Detail Campaign (UMKM)

**Tipe:** Stack screen dengan Tab View di dalam

**AppBar:** Nama Campaign + status badge (🟢 Aktif / ⚫ Selesai)

**Tab View (3 tab):**
1. **Ringkasan** — Total views terkumpul, progress budget terpakai, kreator yang mengerjakan
2. **Kreator** — Daftar kreator yang sudah submit bukti, dengan status tiap submission
3. **Riwayat** — Log pembayaran dan perubahan status

**Tab "Kreator" → Item per Kreator:**
```
┌──────────────────────────────────────┐
│ [Avatar]  Nama Kreator               │
│           Link TikTok: [Lihat ↗]    │
│           Views: 12.400              │
│           Status: ✅ Valid           │
│           Dana: Rp 62.000 (sudah cair)│
└──────────────────────────────────────┘
```

---

# GRUP C — LAYAR KREATOR

---

## C.1 — Dashboard Beranda Kreator

**Elemen (atas ke bawah):**
```
┌────────────────────────────────┐
│  ~ Hai, Rafi!        [🔔] [👤]│
│                                │
│  ┌──────────────────────────┐  │
│  │  💰 Total Pendapatan     │  │  ← Hero card
│  │  Rp 320.000 bulan ini    │  │
│  │  Saldo Tersedia: Rp 120K │  │
│  └──────────────────────────┘  │
│                                │
│  Pekerjaan Aktif Saya          │
│  ┌──────────────────────────┐  │
│  │ [Nama Campaign]          │  │  ← Shortcut card
│  │ ⏳ Menunggu Validasi     │  │
│  └──────────────────────────┘  │
│  [Lihat Semua →]               │
│                                │
│  Job Baru di Job Pool          │
│  ┌──────────────────────────┐  │
│  │ [Preview 2 job terbaru]  │  │
│  └──────────────────────────┘  │
│  [Jelajahi Job Pool →]         │
└────────────────────────────────┘
```

---

## C.2 — Job Pool (Feed Kartu Campaign)

**Tipe:** Scrollable feed

**Layout Kartu Job:**
```
┌──────────────────────────────────────┐
│ [Thumbnail foto produk — 16:9]       │
│                                      │
│ [Badge Niche: 🍽 Kuliner]  [BARU!]  │
│                                      │
│ Nama Campaign                        │  ← Bold, ukuran sedang
│ Nama UMKM                            │  ← Kecil, muted
│                                      │
│ 💰 Rp 5.000 / 1.000 views            │  ← Info kunci — harus besar
│                                      │
│ 👥 Sisa slot: 2 dari 5               │  ← Progress visual
│    [████████░░] 60% terisi           │
│                                      │
│           [Lihat Detail →]           │
└──────────────────────────────────────┘
```

**KONDISI: Kuota Penuh**
```
┌──────────────────────────────────────┐
│ [Thumbnail — dengan overlay abu-abu] │
│                                      │
│ [Badge: KUOTA PENUH]                 │
│ Nama Campaign                        │
│                                      │
│ 💰 Rp 5.000 / 1.000 views            │
│ 👥 Semua slot sudah terisi           │
│                                      │
│     [Tombol: "Penuh" — disabled]     │
└──────────────────────────────────────┘
```
> *Kartu dengan kuota penuh tetap ditampilkan tapi secara visual lebih redup — kartu ini tidak bisa diklik untuk klaim.*

---

## C.3 — Halaman Detail Job

**Tipe:** Stack screen

**Elemen (atas ke bawah):**
```
[AppBar: ← Kembali    "Detail Campaign"]

[Thumbnail besar — rasio 16:9]

Nama Campaign
[Badge Niche] · [Badge Status: 🟢 Tersedia]

Bayaran:
💰 Rp 5.000 per 1.000 views

Sisa Slot:
👥 2 dari 5 kreator dibutuhkan
[Progress bar visual]

Deadline:
📅 Selesaikan dalam 7 hari setelah klaim

──────────────────────────────────────
Brief dari UMKM:
[Teks brief lengkap — scrollable]

──────────────────────────────────────
Aset Mentah dari UMKM:
📂 [Tombol: "Buka di Google Drive ↗"]
(tap → buka browser, bukan in-app)

──────────────────────────────────────

[FIXED BOTTOM BAR — tidak ikut scroll]
┌──────────────────────────────────────┐
│    [Tombol: "Klaim Job Ini" — besar] │
└──────────────────────────────────────┘
```

**Setelah Tap "Klaim Job Ini" → Bottom Sheet Konfirmasi:**
```
┌──────────────────────────────────────┐
│  ── (drag handle) ──                 │
│                                      │
│  Yakin mau klaim job ini?            │
│                                      │
│  Kamu punya 7 hari untuk             │
│  menyelesaikan dan submit            │
│  bukti tayang.                       │
│                                      │
│  [Tombol: "Ya, Klaim!"]  ← primer   │
│  [Tombol: "Batal"]       ← ghost    │
└──────────────────────────────────────┘
```

**Setelah Klaim Berhasil → Layar Sukses:**
```
     🎉  (animasi confetti atau centang besar)

Job Berhasil Diklaim!

Kamu punya 7 hari untuk edit video,
posting di TikTok/Instagram kamu,
lalu submit link-nya di sini.

[Tombol: "Lihat Panduan Lengkap"]
[Tombol: "Ke Pekerjaan Aktif"]
```

---

## C.4 — Layar Submit Bukti Tayang

**Tipe:** Stack screen

**⚠️ CATATAN KERAS:** Layar ini HANYA berisi 1 kolom input URL. TIDAK ADA tombol upload file video. Kreator WAJIB posting video di platform mereka sendiri terlebih dahulu, baru tempel URL-nya di sini.

**Elemen:**
```
[AppBar: ← Kembali    "Submit Bukti Tayang"]

[Nama Campaign & nama UMKM — card ringkasan di atas]

──────────────────────────────────────
📋 Cara Submit:

1️⃣ Edit video menggunakan bahan mentah
   dari link Drive yang sudah diberikan.

2️⃣ Upload video ke akun TikTok atau
   Instagram KAMU sendiri.

3️⃣ Salin link video yang sudah diposting,
   lalu tempel di bawah ini.

──────────────────────────────────────

[Label] Link Video (TikTok atau Instagram Reels) *
[Input field besar]
Placeholder: "https://www.tiktok.com/..."

[Validasi inline]
✅ "Link valid! Pastikan videonya bisa
    dilihat publik sebelum submit."

──────────────────────────────────────

[FIXED BOTTOM BAR]
[Tombol: "Submit Bukti Tayang"]
```

**State setelah Submit:**
- Tampil badge status: `⏳ Menunggu Validasi`
- Teks informasi: "Kami akan mengecek video kamu dalam 1×24 jam. Kamu akan dapat notifikasi hasilnya."
- Tombol "Submit" berubah menjadi disabled dengan teks "Sudah Disubmit"

---

# GRUP D — LAYAR RATE CARD MODE (UMKM & KREATOR)

---

## D.1 — Direktori Kreator (Rate Card, sisi UMKM)

**Tipe:** Scrollable grid + filter

**Elemen:**
```
[AppBar: "Cari Kreator"]

[Search bar — full width, dengan ikon 🔍]

[Filter Chip Row — horizontal scroll]
Semua · Kuliner · Fesyen · Pariwisata · Edukasi

[Grid 2 kolom — kartu kreator]
┌──────────┐ ┌──────────┐
│ [Avatar] │ │ [Avatar] │
│ Nama     │ │ Nama     │
│ 🍽 Kuliner│ │ 👗 Fesyen│
│ Mulai Rp │ │ Mulai Rp │
│ 150.000  │ │ 200.000  │
└──────────┘ └──────────┘
```

---

## D.2 — Profil Publik Kreator

**Tipe:** Stack screen, scrollable

**Elemen:**
```
[AppBar: ← Kembali]

[Cover foto atau warna — bagian atas]
[Avatar kreator — overlap dengan cover]
[Nama kreator — heading]
[Badge niche + badge lokasi]
[Bio singkat — 2-3 baris]

──────────────────────────────────────
Media Sosial
[Logo TikTok] @username  [Kunjungi ↗]
[Logo IG] @username      [Kunjungi ↗]

──────────────────────────────────────
Rate Card Saya

[Kartu Paket 1]
┌──────────────────────────────────┐
│ Paket Basic           Rp 150.000 │
│ 1 video Reels · 3 hari kerja     │
│ Termasuk: 1x revisi              │
└──────────────────────────────────┘

[Kartu Paket 2]
[Kartu Paket 3] (jika ada)

──────────────────────────────────────

[FIXED BOTTOM BAR]
[Tombol: "Hubungi Kreator — Chat Sekarang"]
```

---

## D.3 — Chat Room Rate Card

**Tipe:** Stack screen — layout khas chat mobile

**⚠️ CATATAN KERAS:** Halaman ini HANYA ADA untuk Rate Card Mode. Di Campaign Mode, TIDAK ADA halaman chat sama sekali.

**Elemen (atas ke bawah):**

```
[AppBar]
[Avatar] Nama Kreator         [⋮ Menu]

─────── STATUS BAR ORDER ───────────
[Negosiasi → Menunggu Bayar → Aktif → Selesai]
 ●──────────○───────────○─────────○
Status saat ini: Negosiasi
─────────────────────────────────────

╔═══════════════════════════════════╗
║ ⚠️  PENTING: Saat posting hasil  ║
║ kerja, kreator WAJIB gunakan     ║  ← STICKY BANNER — tidak bisa
║ fitur Collab Post di Instagram   ║    di-dismiss / ditutup
║ atau TikTok.                     ║
╚═══════════════════════════════════╝

[Area percakapan — scrollable ke atas]

─────── bubble pesan biasa ──────────
Rafi: "Halo Bu Sari! Saya bisa bantu
      promosi kuliner Anda 😊"

Bu Sari: "Halo Rafi, paket Basic-nya
          berapa lama pengerjaannya?"
─────────────────────────────────────

─────── bubble Custom Offer ─────────
┌─────────────────────────────────┐
│ 📋  PENAWARAN RESMI             │  ← Background berbeda (primer muted)
│ ─────────────────────────────   │  ← Border kiri tebal warna primer
│ Harga        : Rp 350.000       │
│ Pekerjaan    : 1 Reels 30 dtk,  │
│               3x revisi         │
│ Deadline     : 7 hari kerja     │
│ ─────────────────────────────   │
│   [✅ Terima]  [❌ Tolak]       │  ← Hanya tampil pada status Kreator
└─────────────────────────────────┘
─────────────────────────────────────

[Input bar chat]
[Input text field]  [📎]  [Kirim ➤]
[Tombol: "Kirim Penawaran 📋"]  ← Hanya untuk UMKM
```

**State Bubble Custom Offer setelah diterima:**
```
┌─────────────────────────────────┐
│ 📋  PENAWARAN RESMI             │
│ ─────────────────────────────   │
│ Harga        : Rp 350.000       │
│ Pekerjaan    : 1 Reels 30 dtk   │
│ Deadline     : 7 hari kerja     │
│ ─────────────────────────────   │
│  ✅ Penawaran Diterima           │  ← Tidak ada tombol lagi
│  Menunggu pembayaran dari UMKM  │  ← Info status
└─────────────────────────────────┘
```

---

## D.4 — Form Custom Offer (Bottom Sheet dari Chat)

**Tipe:** Bottom Sheet (muncul dari bawah, menutup sebagian chat)

**Elemen:**
```
┌──────────────────────────────────────┐
│  ── (drag handle) ──                 │
│                                      │
│  📋  Kirim Penawaran Resmi           │
│                                      │
│  [Label] Harga Final (Rp) *          │
│  [Input angka]                       │
│  Placeholder: "cth: 350000"          │
│                                      │
│  [Label] Lingkup Pekerjaan *         │
│  [Textarea]                          │
│  Placeholder: "cth: 1 video Reels    │
│  30 detik, 3x revisi, collab post"   │
│                                      │
│  [Label] Deadline *                  │
│  [Date Picker / Dropdown hari]       │
│  "Selesai dalam: [7 hari ▼]"         │
│                                      │
│  [Tombol: "Kirim Penawaran" — penuh] │
│  [Tombol: "Batal" — ghost]           │
└──────────────────────────────────────┘
```

---

# GRUP E — LAYAR PROFIL & DOMPET

---

## E.1 — Profil Kreator (Editable, sisi Kreator)

**Tipe:** Stack screen

**Elemen:**
- Foto profil (tap → ganti foto)
- Nama, Bio (editable)
- Pilih Niche utama (dropdown)
- Sambungkan TikTok (tap → buka browser OAuth)
- Sambungkan Instagram (tap → buka browser OAuth)
- Tombol "Simpan Perubahan" (sticky bottom)

---

## E.2 — Kelola Rate Card

**Tipe:** Stack screen

**Elemen:**
```
[AppBar: "Rate Card Saya"]

[Daftar paket — card list]

┌──────────────────────────────────┐
│ Paket Basic                      │
│ Rp 150.000                       │
│ 1 video Reels · 3 hari kerja     │
│              [Edit ✏️] [Hapus 🗑]│
└──────────────────────────────────┘

[Tombol: "+ Tambah Paket Baru"]
→ Jika sudah 3 paket aktif:
  Tombol DISABLED + tooltip:
  "Maksimal 3 paket. Hapus satu dulu."
```

**Form Tambah/Edit Paket (Bottom Sheet atau Stack):**
- Nama Paket (contoh: "Paket Basic")
- Deskripsi paket
- Harga (input angka, minimum Rp 10.000)
- Yang didapat klien (textarea, contoh: "1 video Reels 30-60 detik")
- Estimasi pengerjaan (dropdown: 1 / 3 / 5 / 7 / 14 hari)

---

## E.3 — Dompet & Penarikan Dana (Kreator)

**Tipe:** Stack screen

**Elemen:**
```
[AppBar: "Dompet Saya"]

[Hero card — gradient]
Saldo Tersedia
Rp 320.000
[Tombol: "Tarik Dana"]

──────────────────────────────────────
Riwayat Pendapatan

[Filter chip: Semua · Masuk · Keluar]

[Item riwayat] × N
┌──────────────────────────────────┐
│ [Ikon 💰]  Campaign "Ayam Geprek"│
│             + Rp 62.000          │
│             15 Des 2025 · Berhasil│
└──────────────────────────────────┘
```

**Bottom Sheet Tarik Dana:**
```
┌──────────────────────────────────────┐
│  Tarik Dana                          │
│                                      │
│  [Label] Nama Bank *                 │
│  [Dropdown: BCA / BNI / BRI / dll]   │
│                                      │
│  [Label] Nomor Rekening *            │
│  [Input angka]                       │
│                                      │
│  [Label] Nama Pemilik Rekening *     │
│  [Input teks]                        │
│                                      │
│  [Label] Jumlah yang Ditarik (Rp) *  │
│  [Input angka]  Maks: Rp 320.000    │
│                                      │
│  [Tombol: "Konfirmasi Penarikan"]    │
└──────────────────────────────────────┘
```

---

# GRUP F — EMPTY STATES & ERROR STATES

Setiap layar dengan daftar harus memiliki **Empty State** yang dirancang — jangan gunakan halaman kosong.

---

## F.1 — Empty State Standards

| Layar | Ilustrasi | Judul | Deskripsi | CTA |
|-------|-----------|-------|-----------|-----|
| Job Pool kosong | Ilustrasi orang menunggu | "Belum Ada Job Tersedia" | "Job baru muncul setiap hari. Pantau terus!" | — |
| Campaign UMKM kosong | Ilustrasi megafon | "Belum Ada Campaign" | "Buat campaign pertamamu dan mulai promosi!" | "Buat Campaign" |
| Chat kosong | Ilustrasi pesan | "Belum Ada Obrolan" | "Temukan kreator dan mulai kolaborasi!" | "Cari Kreator" |
| Dompet kosong | Ilustrasi dompet | "Belum Ada Transaksi" | "Selesaikan pekerjaan pertamamu untuk mulai mendapat penghasilan." | — |
| Direktori Kreator kosong (hasil filter) | Ilustrasi pencarian | "Kreator Tidak Ditemukan" | "Coba ubah filter pencarian kamu." | "Reset Filter" |

---

## F.2 — Error State Standards

| Kondisi | Tampilan |
|---------|----------|
| **Tidak ada koneksi internet** | Full-screen banner di atas + teks "Tidak ada koneksi. Beberapa fitur mungkin tidak tersedia." + tombol "Coba Lagi" |
| **File upload > 100MB** | Bottom Sheet dengan ikon ☁️ + panduan link Drive (lihat B.2.2) |
| **Kuota kreator penuh (saat klaim)** | Bottom Sheet error: "Maaf, semua slot baru saja terisi. Cari job lain yang tersedia." + tombol "Lihat Job Lain" |
| **URL tidak valid** | Pesan inline merah di bawah field: ❌ "Format link tidak valid." |
| **Pembayaran gagal** | Layar full-screen: ❌ ikon + "Pembayaran Gagal" + alasan + "Coba Lagi" |
| **Server error** | Snackbar di bagian bawah: "Terjadi kesalahan. Silakan coba beberapa saat lagi." |

---

*Lanjut ke Dokumen 4: Design System & UX Constraints →*
