# DOKUMEN 1
# User Personas & User Journeys
## Marketiv — Mobile App UI/UX Hand-Off Document

**Versi:** 1.0
**Dipersiapkan untuk:** Tim UI/UX Designer
**Catatan:** Dokumen ini diterjemahkan dari spesifikasi teknis ke dalam bahasa desain interaksi untuk keperluan perancangan tampilan mobile.

---

## Navigasi Dokumen

| # | Dokumen | Isi |
|---|---------|-----|
| **1** | **User Personas & Journeys** ← Anda di sini | Siapa pengguna kita & bagaimana mereka berinteraksi |
| 2 | Information Architecture & Sitemap | Peta navigasi aplikasi mobile |
| 3 | Screen-by-Screen UI Requirements | Panduan wireframe per layar |
| 4 | Design System & UX Constraints | Aturan desain & batasan keras |

---

# BAGIAN A — USER PERSONAS

---

## Persona 1: UMKM — "Bu Sari"

> *"Saya sudah pernah tertipu bayar endorsement mahal tapi produk saya tidak laku-laku. Sekarang saya mau yang aman, bayar kalau hasilnya terbukti."*

### Profil Demografis

| Atribut | Detail |
|---------|--------|
| **Nama Fiktif** | Sari Rahayu |
| **Usia** | 38 tahun |
| **Lokasi** | Sukabumi, Jawa Barat |
| **Pekerjaan** | Pemilik usaha kuliner (Warung Sambal Matah) |
| **Pendidikan** | SMA / SMK |
| **Ponsel yang Digunakan** | Android kelas menengah (Samsung Galaxy A-series) |
| **Aplikasi yang Sering Dibuka** | WhatsApp, Shopee, TikTok (hanya scroll, tidak posting) |
| **Literasi Digital** | ⭐⭐☆☆☆ — Menengah ke bawah. Terbiasa WhatsApp & e-commerce, tapi tidak familiar dengan dasbor atau istilah teknis. |

### Tujuan Utama (Goals)

1. Mempromosikan produknya tanpa takut rugi di muka
2. Mendapatkan video promosi yang bagus tanpa harus bisa edit sendiri
3. Memantau hasilnya (berapa yang sudah lihat, berapa traffic ke toko)

### Frustrasi & Ketakutan (Pain Points)

- Pernah bayar jasa "viral" Rp 500.000 tapi tidak ada hasilnya sama sekali
- Tidak tahu cara menulis brief yang bisa dimengerti kreator
- Takut ditipu oleh kreator yang tidak serius
- Bingung dengan istilah teknis seperti "CPM", "reach", "engagement rate"
- Waktu terbatas — harus jaga warung sambil pesan promosi

### Konteks Penggunaan Aplikasi

- Membuka aplikasi di **sela-sela waktu istirahat** (antara jam 11 siang atau malam setelah tutup toko)
- Menggunakan **jaringan 4G** karena warung di daerah yang belum ada WiFi stabil
- **Tidak sabar** dengan proses yang terlalu panjang — jika lebih dari 3 langkah tanpa progres visual, kemungkinan besar akan menyerah

### Prinsip Desain yang Relevan untuk Bu Sari

```
✅ Tombol yang besar dan bertuliskan aksi yang jelas ("Buat Campaign Sekarang")
✅ Bahasa Indonesia sederhana, tanpa jargon
✅ Indikator progres yang jelas (Step 1 dari 4)
✅ Bantuan AI untuk mengisi form — Bu Sari tidak perlu tahu cara nulis brief
✅ Pesan error yang membimbing, bukan menghakimi ("Ops, videonya terlalu besar. Pakai link Google Drive ya!")
❌ Jangan tampilkan grafik tanpa label yang mudah dimengerti
❌ Jangan gunakan istilah seperti "Escrow", "Validasi", "Submission"
```

---

## Persona 2: Kreator Mikro — "Rafi"

> *"Saya jago edit video, follower saya 3.000 tapi brand selalu minta minimal 10.000. Di sini saya bisa langsung dapat job tanpa nunggu di-ghosting."*

### Profil Demografis

| Atribut | Detail |
|---------|--------|
| **Nama Fiktif** | Rafi Maulana |
| **Usia** | 21 tahun |
| **Lokasi** | Sukabumi, Jawa Barat |
| **Pekerjaan** | Mahasiswa Teknik Informatika + Freelancer konten |
| **Ponsel yang Digunakan** | iPhone 12 / Android flagship (POCO F-series) |
| **Aplikasi Favorit** | TikTok, CapCut, Instagram, Discord |
| **Literasi Digital** | ⭐⭐⭐⭐⭐ — Sangat tinggi. Paham algoritma, tren konten, dan cara kerja platform media sosial. |

### Tujuan Utama (Goals)

1. Mendapat penghasilan pertama dari skill editing-nya tanpa syarat follower tinggi
2. Membangun portofolio dari pekerjaan nyata yang bisa ditunjukkan ke klien lain
3. Mendapatkan pembayaran yang aman dan tepat waktu (tidak di-ghosting)

### Frustrasi & Ketakutan (Pain Points)

- Sudah kirim portofolio ke banyak brand, tidak ada yang balas
- Pernah kerja tapi payment tertunda berminggu-minggu tanpa kejelasan
- Susah menentukan harga yang wajar untuk jasanya
- Tidak ada "wadah" yang khusus untuk kreator pemula di daerah tier-2

### Konteks Penggunaan Aplikasi

- **Aktif seharian** — membuka aplikasi berkali-kali untuk cek job baru
- Sangat cepat membaca kartu (card) — **memindai visual, bukan membaca paragraf**
- Ekspektasi: aplikasi harus **terasa cepat dan responsif** seperti TikTok atau Instagram
- Menggunakan gestur swipe dan tap secara naluriah

### Prinsip Desain yang Relevan untuk Rafi

```
✅ Feed job yang bisa di-scroll cepat seperti media sosial
✅ Informasi krusial (bayaran, sisa slot) harus terlihat tanpa perlu buka detail
✅ Tombol "Klaim" yang sangat menonjol — satu tap, langsung eksekusi
✅ Status pekerjaan yang jelas: Menunggu Validasi / Berhasil / Gagal
✅ Visual portofolio yang menarik untuk profilnya
❌ Jangan buat alur klaim yang lebih dari 2 tap
❌ Jangan sembunyikan informasi bayaran di halaman detail
```

---

# BAGIAN B — USER JOURNEYS

---

## Journey 1: UMKM Membuat Campaign (Campaign Mode)

**Skenario:** Bu Sari ingin mempromosikan menu baru warungnya (Ayam Geprek Special) melalui Marketiv untuk pertama kalinya.

**Perangkat:** Smartphone Android, layar 6 inci
**Kondisi Jaringan:** 4G

---

### Peta Perjalanan

```
TOUCHPOINT     AKSI BU SARI               PIKIRAN & PERASAAN          PELUANG DESAIN
─────────────────────────────────────────────────────────────────────────────────────
Buka Aplikasi  Tap ikon Marketiv          "Semoga tidak ribet..."      Splash screen cepat,
                                                                        maks 2 detik

Dashboard      Melihat tombol besar        "Oh, ini tombolnya          Tombol primer berukuran
UMKM           "Buat Campaign Baru"        jelas sekali"               sangat besar di tengah
                                                                        layar (full-width)

Step 1 /4      Mengisi nama produk,        "Hmm, saya bingung          Tombol "✨ Bantu AI" 
Form Brief     mencoba tulis brief sendiri  harus nulis apa untuk       mencolok di bawah
               → macet di kolom brief       brief ini..."               textarea

Fitur AI       Tap "✨ Bantu AI",           "Wah, langsung              Loading state dengan
               tunggu sebentar,             keluar sendiri! Mudah       animasi "AI sedang
               baca hasil AI               sekali."                    menyusun brief..."

Step 2/4       Tap "Pilih File" untuk      "Eh, kok error?             Pesan error yang ramah:
Upload Aset    upload video mentah         Filenya terlalu besar?"     ikon ☁️ + instruksi
               → File > 100MB ditolak                                  tempel link Drive

               Tempel link Google Drive   "Oh pakai link, oke"         Placeholder teks
                                                                        contoh link Drive

Step 3/4       Geser slider harga,         "Kalau saya pilih           Preview real-time:
Budget         isi jumlah kreator          Rp 5.000 / 1000 views,      "Estimasi: 5 kreator
               yang dibutuhkan             berapa yang saya bayar?"    akan mendapat ±Rp 25.000"

Step 4/4       Review semua isi,           "Kok kena komisi 15%?"      Tampilkan breakdown
Konfirmasi     tap "Bayar Sekarang"        "Tapi masuk akal sih        biaya yang transparan:
               via payment gateway         kalau ada jaminannya."      Budget + Komisi = Total

Selesai        Muncul halaman sukses       "Yeay! Kapan mulai          Konfirmasi dengan
               dengan animasi ✅           ada kreator yang klaim?"    estimasi waktu respons
                                                                        pertama ("Biasanya
                                                                        klaim dalam 2 jam")

Notifikasi     Terima push notif:          "Wah, sudah ada             Notifikasi dengan
(nanti)        "Ada kreator yang           yang klaim!"                nama kreator & avatar
               klaim campaign Anda"
```

---

### Alur Langkah Detail (Step-by-Step)

**Langkah 1 — Masuk ke Form**
- Bu Sari buka tab "Campaign" → tap tombol besar **"+ Buat Campaign Baru"**
- Muncul layar Step 1 dari 4 dengan progress bar di atas

**Langkah 2 — Isi Informasi Produk (Step 1/4)**
- Isi kolom: Nama Produk, Niche (dropdown: Kuliner ✓), Deskripsi
- Jika ragu mengisi brief → tap **"✨ Bantu Saya dengan AI"**
- Sistem mengisi otomatis → Bu Sari bisa edit hasilnya
- Tap **"Lanjut →"**

**Langkah 3 — Upload Aset (Step 2/4)**
- Tap area upload → pilih file dari galeri
- Jika file > 100MB → muncul **bottom sheet error** dengan panduan link Drive
- Bu Sari tempel URL Google Drive → sistem validasi format URL
- Tap **"Lanjut →"**

**Langkah 4 — Atur Anggaran (Step 3/4)**
- Pilih harga per 1000 views (slider: Rp 2.000–10.000)
- Isi jumlah kreator yang dibutuhkan
- Lihat preview kalkulasi otomatis
- Tap **"Lanjut →"**

**Langkah 5 — Review & Bayar (Step 4/4)**
- Tampil ringkasan campaign + breakdown biaya
- Tap **"Bayar Sekarang"** → buka payment gateway (Midtrans Snap)
- Setelah bayar → kembali ke aplikasi → halaman sukses

---

## Journey 2: Kreator Klaim Job & Submit Bukti Tayang (Campaign Mode)

**Skenario:** Rafi baru buka aplikasi, melihat ada campaign Ayam Geprek dari Bu Sari, dan ingin segera mengklaimnya sebelum kuota penuh.

**Perangkat:** iPhone 12
**Kondisi:** Rafi sedang di kampus, sambil istirahat kuliah

---

### Peta Perjalanan

```
TOUCHPOINT     AKSI RAFI                  PIKIRAN & PERASAAN          PELUANG DESAIN
─────────────────────────────────────────────────────────────────────────────────────
Tab Job Pool   Scroll feed kampanye,       "Wah ada yang baru!         Card kompak dengan
               melihat kartu baru muncul   Bayarannya lumayan,         thumbnail produk,
               di atas                     kuota masih 3 slot"         badge "BARU" kuning

Kartu Campaign Tap kartu untuk buka        "Briefnya jelas,            Preview brief langsung
               detail                      saya bisa buat ini."        terlihat tanpa scroll

Halaman Detail Baca brief + lihat          "Assetnya ada di Drive,     Tombol "Klaim Job Ini"
               link aset Drive             tinggal download"           di fixed bottom bar
                                                                        (tidak perlu scroll
                                                                        untuk temukan tombol)

Klaim Job      Tap "Klaim Job Ini" →       "Semoga belum               Konfirmasi singkat:
               muncul konfirmasi           keburu penuh..."            "Yakin klaim campaign
               → tap "Ya, Klaim"                                       ini?" + tombol Ya

Sukses Klaim   Muncul animasi konfeti ✅   "Yes! Dapat!"               Halaman sukses dengan
               "Job berhasil diklaim!"                                  countdown "Selesaikan
                                                                        dalam 7 hari"

Eksekusi       Rafi download aset,         (Di luar aplikasi)          — (CapCut, TikTok,
(Luar App)     edit video di CapCut,                                   Instagram bukan bagian
               upload ke TikTok pribadi                                aplikasi ini)

Submit Bukti   Buka tab "Pekerjaan         "Ini tinggal tempel          Layar sederhana:
               Aktif" → tap campaign       link TikTok-nya saja"       1 kolom input +
               → tap "Submit Bukti"                                     1 tombol

               Tempel URL TikTok →         "Validasinya berapa         Status bar: "⏳
               tap "Submit"               lama ya?"                    Menunggu Validasi"
                                                                        + estimasi waktu

Notifikasi     Terima notif:               "Yes! Cair!"                Push notif + notif
(nanti)        "Dana Rp X telah                                        in-app di tab Dompet
               masuk ke dompet Anda"
```

---

### Alur Langkah Detail

**Langkah 1 — Temukan Job**
- Rafi buka tab **"Job Pool"** → scroll feed kartu campaign
- Filter opsional: Niche, Rentang Bayaran

**Langkah 2 — Evaluasi Campaign**
- Tap kartu → buka halaman detail campaign
- Baca brief, lihat link aset, lihat bayaran & sisa slot
- Jika tertarik → tap **"Klaim Job Ini"** (tombol fixed di bawah layar)

**Langkah 3 — Konfirmasi Klaim**
- Muncul **bottom sheet konfirmasi** singkat
- Tap "Ya, Klaim" → sistem cek ketersediaan slot (real-time)
- Jika berhasil → animasi sukses + notifikasi

**Langkah 4 — Submit Bukti (setelah selesai edit & posting)**
- Buka tab **"Pekerjaan Aktif"**
- Tap campaign yang diklaim → tap **"Submit Bukti Tayang"**
- Paste URL TikTok/Instagram → tap **"Submit"**
- Status berubah menjadi "Menunggu Validasi"

**Langkah 5 — Dana Cair**
- Setelah validasi berhasil → push notification
- Dana masuk ke tab **"Dompet"** → bisa dicairkan ke rekening

---

## Journey 3: UMKM & Kreator Bernegosiasi hingga Collab Post (Rate Card Mode)

**Skenario:** Bu Sari ingin membuat konten branding yang lebih profesional dan menemukan kreator yang cocok melalui direktori. Kreatornya adalah Rafi.

---

### Peta Perjalanan

```
TOUCHPOINT          AKSI                        PIKIRAN & PERASAAN        PELUANG DESAIN
─────────────────────────────────────────────────────────────────────────────────────────
Bu Sari:            Buka tab "Cari              "Saya mau cari yang       Filter chip di atas:
Direktori Kreator   Kreator", filter            spesialisasi kuliner      Niche · Harga · Rating
                    "Kuliner"                   dulu"

                    Scroll grid kreator →       "Yang ini profilnya        Card kreator: foto,
                    temukan Rafi               bagus, harganya oke"       nama, niche badge,
                                                                           harga mulai dari Rp X

Bu Sari:            Buka profil Rafi →          "Ada 3 paket. Yang        Layout profil publik
Profil Kreator      lihat Rate Card             Paket Basic pas          kreator dengan
                    yang tersedia               untuk budget saya"        Rate Card cards

Bu Sari:            Tap "Hubungi                "Semoga dibalas           Loading animasi
Mulai Chat          Kreator" →                  cepat..."                 masuk chat room
                    masuk chat room

Chat Room           Bu Sari kirim               (Proses negosiasi         Bubble chat standar,
Negosiasi           pesan pertama:              berlangsung               ada sticky banner
                    "Halo Rafi, mau             beberapa pesan)           ⚠️ Collab Post
                    tanya soal package                                     di atas chat
                    Basic-nya..."

                    Setelah sepakat →           "Oke, saya mau kunci      Tombol "Kirim
Bu Sari:            Bu Sari tap tombol          kontraknya"               Penawaran" di dalam
Custom Offer        "Kirim Penawaran"                                      keyboard toolbar chat

                    Isi form Custom Offer:      "Coba saya tulis          Modal/bottom sheet
                    harga, scope, deadline      dengan jelas"             dengan 3 field
                    → tap "Kirim"                                          input + tombol Kirim

                    Di chat muncul              "Ini yang saya mau        Bubble khusus warna
                    bubble "PENAWARAN           kunci kontraknya"         berbeda dari chat
                    RESMI" dengan detail                                   biasa + tombol aksi
                    dan tombol aksi

Rafi:               Rafi baca bubble            "Oke, sudah sesuai        Tombol "Terima" hijau
Terima Penawaran    penawaran → tap             dengan yang kita           dan "Tolak" abu-abu
                    "Terima Penawaran"          diskusikan"               di dalam bubble

                    Status berubah:             "Sekarang Bu Sari         Status banner di atas
                    "Menunggu Pembayaran"       perlu bayar dulu"         chat berubah warna

Bu Sari:            Terima notif →              "Oke, langsung bayar"     Deep link dari notif
Pembayaran          tap → buka payment                                     langsung ke payment
                    → bayar → kembali                                      screen
                    ke aplikasi

Rafi:               Rafi eksekusi konten        (Di luar aplikasi)        —
Eksekusi            → buat video +
                    posting via Collab
                    Post Instagram/TikTok

Rafi:               Buka tab "Pekerjaan         "Tinggal tempel           Layar submit dengan
Submit Collab       Aktif" → tap order →        link Collab Post          reminder banner
Post                paste URL Collab Post       saja"                     Collab Post wajib
                    → tap "Submit"

Selesai             Dana cair ke Rafi           "Kerja keras terbayar!"   Notifikasi + konfeti
                    Bu Sari terima              "Kontennya bagus!"        kecil di halaman
                    notif selesai                                           sukses order
```

---

### Poin Kritis Desain di Journey 3

```
⚠️  Warning Banner "Collab Post" harus selalu terlihat saat chat Rate Card Mode.
    Jangan bisa di-dismiss (sticky/persistent).

⚠️  Bubble Custom Offer harus secara visual sangat berbeda dari pesan biasa.
    Gunakan: background berbeda, border, ikon 📋, dan label "PENAWARAN RESMI".

⚠️  Setelah Kreator menerima penawaran, form Custom Offer harus terkunci.
    Tidak ada tombol edit. Tampilkan badge "✅ Penawaran Diterima" di bubble.

⚠️  Status bar di atas chat room harus berubah sesuai status order:
    Negosiasi → Menunggu Pembayaran → Aktif → Selesai → Selesai
```

---

*Lanjut ke Dokumen 2: Information Architecture & Sitemap →*
