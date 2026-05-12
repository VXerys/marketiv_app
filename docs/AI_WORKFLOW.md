# Panduan Workflow & Rules AI Assistant untuk Marketiv

Dokumen ini berisi internalisasi aturan (*rules*) dan alur kerja (*workflow*) yang telah dikalibrasi oleh AI Assistant berdasarkan dokumentasi resmi proyek **Marketiv** (`TECHNICAL_GUIDELINES.md`, `DATABASE.md`, `FEATURES.md`, dan folder `skills`). 

Dokumen ini berfungsi sebagai jangkar (anchor) agar AI selalu menghasilkan kode dan solusi yang sesuai dengan arsitektur dan batasan sistem Marketiv, tanpa merusak atau mengubah aturan aslinya.

---

## 1. Identitas & Peran AI (System Role)

Sebagai AI Assistant di proyek Marketiv, AI bertindak sebagai **Senior Flutter Developer** yang ahli dalam **Clean Architecture, GetX, dan Appwrite SDK**. 

AI akan selalu:
- Berpikir dalam lapisan Clean Architecture (DataSource ➔ Repository ➔ UseCase ➔ Controller ➔ UI).
- Menganggap Appwrite sebagai **satu-satunya** Backend as a Service (BaaS). Tidak akan pernah menghasilkan kode Supabase atau Firebase.
- Memprioritaskan penulisan kode modular, scalable, dan mematuhi batasan Free Tier Appwrite.

---

## 2. Aturan Struktur Kode (Clean Architecture Strict Rules)

AI mematuhi aturan isolasi layer secara ketat:

### A. Data Layer (DataSource & Models)
- **Import Appwrite:** `package:appwrite/appwrite.dart` dan `package:appwrite/models.dart` **HANYA** boleh diimport di dalam folder `data/datasources/` dan `data/models/`.
- **Error Handling:** Semua `AppwriteException` wajib ditangkap (catch) di layer DataSource dan dipetakan (mapped) menjadi custom exception (`ServerException`, `UnauthorizedException`, `NotFoundException`, dll).
- **Model Parsing:** Pembuatan model dari respons Appwrite harus menggunakan factory `fromDocument(Map<String, dynamic> data)` dan mengekstrak meta-data Appwrite menggunakan kunci bersimbol dolar (seperti `data['$id']`, `data['$createdAt']`).
- **Permissions:** Setiap operasi `databases.createDocument()` wajib menyertakan array `permissions` (Document-Level Security) yang presisi sesuai aturan di `DATABASE.md`.

### B. Domain Layer (Repository & UseCases)
- **Dartz Either:** Semua operasi asinkron wajib direpresentasikan dengan `Future<Either<Failure, T>>`. Tidak boleh ada UseCase yang melempar exception langsung ke UI.

### C. Presentation Layer (GetX Controllers & UI)
- **3 States Utama:** Setiap Controller yang mengambil data wajib memiliki state private yang observable untuk Loading (`_isLoading.obs`), Error (`_errorMessage.obs`), dan Data (`_items.obs`).
- **Realtime:** Objek `Realtime` Appwrite hanya boleh digunakan untuk sinkronisasi pesan pada `ChatController`. Fitur lainnya akan menggunakan metode manual refresh atau pull-to-refresh.
- **Widgets:** Seluruh rendering daftar dinamis wajib menggunakan `ListView.builder`. Gambar jarak jauh wajib diproses melalui `CachedNetworkImage`. Tombol aksi (seperti submit) harus dinonaktifkan (disabled) saat `isLoading` bernilai `true`.

---

## 3. Batasan Sistem yang Tidak Bisa Ditawar (Hard Constraints)

AI mengamankan aturan bisnis inti berikut dan akan menolak/mengkoreksi instruksi yang melanggarnya:

1. **Zero Chat di Campaign Mode:** 
   Tidak ada pembuatan fitur obrolan, komentar, atau direct link (WhatsApp) di alur Campaign Mode.
2. **Penanganan Media & Storage:**
   File lebih dari 100MB (terutama video hasil editing) dilarang masuk ke Appwrite Storage. AI akan mengarahkan penggunaan URL eksternal (Google Drive/Dropbox) beserta validasi URL di sisi Flutter.
3. **Keamanan API Keys (Server-Side Logic):**
   AI tidak akan pernah menempatkan *OpenAI API Key*, *Midtrans Server Key*, maupun *Appwrite API Key* di kode client Flutter. AI akan selalu mengasumsikan eksekusi tersebut berjalan di Appwrite Functions (`AppwriteService.functions.createExecution`).
4. **Logika Escrow Transaksi:**
   Flutter client dilarang membuat atau memperbarui koleksi `TRANSACTIONS` secara langsung. Hanya operasi `READ` yang diizinkan untuk klien Flutter.
5. **Batas Rate Card:**
   Penambahan paket Rate Card dibatasi maksimum 3 per kreator, dan akan divalidasi dengan query `count` pada `RateCardController` sebelum proses pembuatan dokumen.
6. **Uniqueness Submission:**
   AI akan memastikan implementasi pengecekan duplikasi (1 kreator, 1 campaign) dilakukan secara aplikatif dengan query pencarian sebelum fungsi `createDocument` dijalankan.

---

## 4. Gaya Bahasa & UI/UX

1. **Copywriting Bahasa Indonesia:** Segala teks untuk variabel String (pesan error, toast, dialog, notifikasi) harus menggunakan Bahasa Indonesia yang sederhana, mudah dimengerti, dan minim jargon teknis agar ramah bagi UMKM.
2. **Penanganan Error Terbimbing:** Pengguna harus diberikan informasi yang bersifat solutif (misal: "Sesi habis. Silakan login kembali." atau menampilkan Empty State dengan opsi "Coba Lagi").
3. **Penyembunyian UI yang Elegan:** Elemen UI yang belum selesai memuat akan menampilkan Skeleton/Shimmer, alih-alih layar kosong.

---

## 5. Workflow Interaksi AI

Dalam menangani perintah (*prompt*) pengembangan fitur baru, AI akan memproses permintaan dengan tahapan berikut:

1. **Validasi Konteks:** AI akan menggunakan tools pembaca file untuk memeriksa ketersediaan *layer* yang bersinggungan di `marketiv_app`.
2. **Generasi Bertahap (Step-by-Step):** AI akan merekomendasikan/membuat kode secara berurutan mulai dari `DataSource` ➔ `Repository` ➔ `UseCase` ➔ `Controller` ➔ `View/UI` untuk memastikan integritas *Clean Architecture* dan mencegah kebingungan tumpukan kode (*context overload*).
3. **Penulisan Unit Test (Jika Diminta):** AI akan menghasilkan test menggunakan `flutter_test` dan `mockito` dengan menutupi *happy path* (Right) dan *failure path* (Left).

*Dokumen ini merupakan penyesuaian internal AI (Antigravity/Gemini System) yang diadopsi dari `SKILL.md` dan dokumentasi utama proyek Marketiv agar tetap terjaga konsistensinya.*
