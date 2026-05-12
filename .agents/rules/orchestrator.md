---
trigger: always_on
description: Router utama untuk AI. Berisi instruksi agar AI selalu menganalisis konteks dan mengaktifkan aturan spesifik (Model Decision) yang sesuai.
---
# AI Orchestrator & Router (Always On)

> [!IMPORTANT]
> **INSTRUKSI UTAMA UNTUK AI:**
> Anda sedang bekerja di dalam sistem yang memiliki banyak file *Rules* dan *Workflows* spesifik. Jangan mencoba menjawab atau menulis kode secara asal-asalan. **Sebelum Anda mengeksekusi instruksi pengguna, Anda WAJIB menganalisis konteks tugas dan memanggil/merujuk pada *rules/workflows* spesifik (yang diset ke `Model Decision`) sesuai daftar di bawah ini:**

### 🔍 Kamus Pemanggilan Aturan (Rules & Workflows)
Setiap kali pengguna meminta sesuatu, cocokkan kata kunci tugas dengan pedoman berikut, lalu baca/aktifkan pedoman tersebut:

1. **Struktur Dasar & Arsitektur**
   - Jika membuat layer, binding, usecase, atau controller baru ➔ Panggil **`architecture.md`** & **`create-feature.md`**.
   - Jika menulis kode UI, widget, atau warna ➔ Panggil **`ui-styling.md`**.
   - Jika terkait standarisasi penamaan ➔ Panggil **`naming-conventions.md`**.
   - Jika melakukan review kode ➔ Panggil **`code-review.md`**.

2. **Koneksi Database & Server (Appwrite)**
   - Jika memanggil API, query, upload storage, atau Appwrite SDK ➔ Panggil **`appwrite-backend.md`** & **`model-parsing.md`**.
   - Jika terjadi error Appwrite (401, 404, 409) ➔ Panggil **`error-mapping.md`** & **`fix-appwrite-error.md`**.
   - Jika mengelola Appwrite Functions via CLI ➔ Panggil **`create-appwrite-function.md`**.

3. **Fitur & Logika Bisnis Spesifik**
   - Jika mengurus Login, Register, Sesi, atau Hak Akses ➔ Panggil **`authentication.md`** & **`rbac.md`**.
   - Jika mengurus Campaign, Job Pool, Bukti Tayang (Zero Chat) ➔ Panggil **`app-context.md`** & **`constraints.md`**.
   - Jika mengurus form panjang (contoh: buat campaign) ➔ Panggil **`campaign-wizard.md`**.
   - Jika mengurus Rate Card, Negosiasi, atau Chat ➔ Panggil **`implement-chat.md`** & **`app-context.md`**.
   - Jika mengurus Deposit, Withdraw, Escrow, atau Transaksi ➔ Panggil **`withdraw-process.md`**.
   - Jika mengurus Pembayaran Snap ➔ Panggil **`payment-midtrans.md`**.
   - Jika mengurus Prompt AI Assistant / OpenAI ➔ Panggil **`ai-integration.md`**.

4. **Performa & Testing**
   - Jika terjadi masalah *lag*, *jank*, atau rendering UI ➔ Panggil **`performance.md`**.
   - Jika diminta membuat Unit Test ➔ Panggil **`testing-standards.md`**.

**CARA KERJA ANDA (SOP AI):**
1. Baca pesan pengguna.
2. Identifikasi kategori tugas dari kamus di atas.
3. Muat *rules/workflows/skills* yang relevan secara memori.
4. Jawab dan kerjakan tugas pengguna dengan mematuhi aturan spesifik tersebut!
