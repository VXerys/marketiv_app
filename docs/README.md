# Marketiv — Platform Marketplace Hibrida UMKM & Kreator Mikro (Flutter Mobile App)

> **Untuk AI Coding Assistant (GitHub Copilot / Cursor / dll):**
> Dokumen ini adalah **entry point** proyek Marketiv versi Flutter Mobile App. Baca dokumen ini terlebih dahulu, kemudian lanjut ke dokumen spesifik sesuai kebutuhan. Semua keputusan arsitektur, logika bisnis, batasan fitur, dan struktur database **wajib mengacu pada dokumen-dokumen ini**.

---

## Navigasi Dokumentasi

| Dokumen | Isi |
|---------|-----|
| **README.md** ← (kamu di sini) | Gambaran umum, tech stack, arsitektur Flutter, struktur folder, env vars |
| **[FEATURES.md](FEATURES.md)** | Semua modul fitur: Auth, Campaign Mode, Rate Card Mode, Keuangan & Escrow, AI, Admin |
| **[DATABASE.md](DATABASE.md)** | Skema database lengkap (Collections, Attributes, Permissions, Query patterns) |
| **[TECHNICAL_GUIDELINES.md](TECHNICAL_GUIDELINES.md)** | Non-fungsional, UI/UX, navigasi halaman, batasan sistem, integrasi eksternal, model bisnis |

---

## 1. Gambaran Umum Proyek

### 1.1 Deskripsi Produk

**Marketiv** adalah aplikasi mobile berbasis Flutter dengan model bisnis **Hybrid Marketplace**. Platform ini menghubungkan dua sisi pasar:

- **Sisi Demand → UMKM:** Pelaku usaha daerah yang membutuhkan jasa pemasaran digital berbasis konten video pendek (TikTok/Instagram Reels), namun memiliki literasi digital terbatas.
- **Sisi Supply → Kreator Mikro:** Gen-Z / mahasiswa yang memiliki keahlian editing video, namun kesulitan mendapat monetisasi awal karena follower belum memenuhi syarat platform agensi besar.

### 1.2 Tiga Masalah yang Diselesaikan

| # | Masalah | Solusi Marketiv |
|---|---------|-----------------|
| 1 | UMKM sering tertipu buzzer bodong | Sistem **Escrow** — dana UMKM ditahan, baru cair ke kreator setelah views tervalidasi |
| 2 | UMKM tidak bisa menyusun brief pemasaran | Fitur **AI Brief Assistant** — UMKM cukup input singkat, AI otomatis susun brief |
| 3 | Kreator Mikro sulit dapat job | **Job Pool** — siapa cepat dia dapat, tidak ada syarat minimum follower |

### 1.3 Dua Mode Operasional Utama

```
MARKETIV
├── Campaign Mode (Viral / Performance-Based)
│   ├── UMKM upload brief + aset → masuk Job Pool
│   ├── Kreator klaim job → edit video → posting di akun pribadi
│   ├── Kreator submit URL TikTok/IG → sistem validasi views
│   ├── Dana Escrow cair ke kreator (tiered by views)
│   └── ❌ TIDAK ADA fitur Chat sama sekali di mode ini
│
└── Rate Card Mode (Premium / Fixed Price / Consultative)
    ├── UMKM cari kreator via direktori + filter
    ├── UMKM & Kreator negosiasi via Live Chat
    ├── Kesepakatan dikunci via "Custom Offer" widget
    ├── UMKM deposit ke Escrow
    ├── Kreator eksekusi konten → publikasi via Collab Post
    └── ✅ Live Chat AKTIF hanya di mode ini
```

### 1.4 Status Fitur

**Aktif (boleh diubah):**
- Campaign Mode (Job Pool, Buat Campaign, Submit Bukti Tayang)
- Rate Card Mode (Direktori Kreator, Chat, Custom Offer)
- Auth (Login, Register, Role Selection)
- Keuangan & Escrow (Deposit, Withdrawal, Riwayat Transaksi)
- AI Brief Assistant
- Profile (UMKM & Kreator)
- Admin Panel (read-only di mobile, full di web)

**Frozen / Read-Only:**
- *(Tidak ada fitur frozen untuk fase MVP awal)*

---

## 2. Tech Stack & Dependencies

### 2.1 Framework & Core

| Teknologi | Versi/Package | Keterangan |
|---|---|---|
| Flutter | SDK ^3.10.7 | Multi-platform mobile app |
| GetX | `get: ^4.7.3` | State management + routing + DI |
| Appwrite | `appwrite: ^14.0.0` | Auth + Database + Storage + Realtime + Functions |
| Local Storage | `get_storage: ^2.1.1` | Session/token caching lokal |
| Functional Error | `dartz: ^0.10.1` | `Either<Failure, T>` |
| HTTP Client | `http: ^1.4.0` | Panggil Midtrans (via Appwrite Function) |
| Config | `flutter_dotenv: ^6.0.0` | Baca `.env` |
| Logging | `logger: ^2.6.2` | Debug logging |
| Date Formatting | `intl: ^0.20.2` | Format tanggal, mata uang |
| UUID | `uuid: ^4.5.1` | Generate ID unik (fallback) |

> **Catatan:** `supabase_flutter` **TIDAK DIGUNAKAN** dalam proyek ini. Backend sepenuhnya menggunakan **Appwrite**.

### 2.2 UI/UX & Utilities

| Package | Keterangan |
|---|---|
| `flutter_svg: ^2.2.4` | Render aset SVG |
| `cached_network_image: ^3.4.1` | Cache foto profil, thumbnail campaign |
| `shimmer: ^3.0.0` | Skeleton loading state |
| `image_picker: ^1.2.1` | Upload foto profil / aset campaign |
| `share_plus: ^12.0.2` | Share link campaign |
| `url_launcher: ^6.2.0` | Buka URL eksternal (Drive, TikTok, IG) |
| `flutter_slidable: ^4.0.3` | Swipe action pada list item |
| `emoji_picker_flutter: ^4.4.0` | Emoji pada Live Chat |
| `cupertino_icons: ^1.0.8` | Icon iOS style |
| `flutter_image_compress` | Compress gambar sebelum upload ke Appwrite Storage |

### 2.3 Pembayaran & Deep Link

| Package | Keterangan |
|---|---|
| `midtrans_sdk` / `webview_flutter` | Integrasi Midtrans Snap via WebView |
| `app_links: ^7.0.0` | Deep link handling |
| `flutter_native_splash: ^2.4.0` | Splash screen native |
| `introduction_screen: ^4.0.0` | Onboarding screen |

### 2.4 Fonts

- **Inter** — font default seluruh aplikasi
- **Newsreader** — heading / branding

---

## 3. Arsitektur — Clean Architecture + GetX

### 3.1 Prinsip Utama

**Aliran data WAJIB:**
```
DataSource → Repository → UseCase → Controller → UI
```

**Aturan mutlak:**
- 🚫 Dilarang memanggil Appwrite SDK langsung dari UI atau Controller
- ✅ Controller hanya memanggil UseCase
- ✅ Repository selalu return `Either<Failure, T>`
- ✅ DataSource hanya menangani query Appwrite, parsing, dan mapping
- 🚫 `import 'package:appwrite/appwrite.dart'` hanya boleh ada di layer `DataSource`

### 3.2 Struktur Umum per Feature

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   └── <feature>_remote_datasource.dart
│   ├── models/
│   │   └── <feature>_model.dart         (fromDocument / toJson / toEntity)
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <feature>_entity.dart
│   ├── repositories/
│   │   └── <feature>_repository.dart    (abstract contract)
│   └── usecases/
│       └── get_<feature>.dart
│       └── create_<feature>.dart
│       └── ... (satu file per use case)
└── presentation/
    ├── bindings/
    │   └── <feature>_binding.dart
    ├── controllers/
    │   └── <feature>_controller.dart
    ├── pages/
    │   └── <feature>_page.dart
    └── widgets/
        └── <feature>_card.dart
        └── ... (widget reusable)
```

### 3.3 Binding Order (DI Best Practice)

Urutan dependency di `bindings/` — **WAJIB diikuti**:

```dart
// Contoh: CampaignBinding
class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource
    Get.lazyPut<CampaignRemoteDataSource>(
      () => CampaignRemoteDataSourceImpl(
        databases: AppwriteService.databases,
        functions: AppwriteService.functions,
      ),
    );

    // 2. Repository
    Get.lazyPut<CampaignRepository>(
      () => CampaignRepositoryImpl(
        dataSource: Get.find<CampaignRemoteDataSource>(),
      ),
    );

    // 3. UseCase
    Get.lazyPut(() => GetCampaignsUseCase(Get.find()));
    Get.lazyPut(() => CreateCampaignUseCase(Get.find()));

    // 4. Controller
    Get.lazyPut<CampaignController>(
      () => CampaignController(
        getCampaignsUseCase: Get.find(),
        createCampaignUseCase: Get.find(),
      ),
    );
  }
}
```

---

## 4. Struktur Folder Lengkap

```
lib/
├── main.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       (Appwrite endpoint, project ID, DB ID, collection IDs)
│   │   ├── app_colors.dart          (token warna utama — orange & navy)
│   │   ├── app_text_styles.dart     (token typography Inter + Newsreader)
│   │   ├── app_spacing.dart         (spacing, radius, shadow)
│   │   ├── app_gradients.dart       (preset gradient)
│   │   └── marketiv_constants.dart  (niche list, status label, komisi)
│   │
│   ├── config/
│   │   └── app_config.dart          (AppConfig.useMockData toggle, env reader)
│   │
│   ├── di/
│   │   └── initial_binding.dart     (global DI: Auth, Profile, services)
│   │
│   ├── error/
│   │   ├── failures.dart            (ServerFailure, CacheFailure, dll)
│   │   └── exceptions.dart
│   │
│   ├── mock/
│   │   ├── mock_campaign_datasource.dart
│   │   ├── mock_ratecard_datasource.dart
│   │   └── mock_profile_datasource.dart
│   │
│   ├── routes/
│   │   ├── app_routes.dart          (konstanta nama route)
│   │   └── app_pages.dart           (mapping route → page + binding)
│   │
│   ├── services/
│   │   ├── storage_service.dart     (GetStorage wrapper)
│   │   ├── appwrite_service.dart    (AppwriteClient singleton — Databases, Account, Storage, Realtime, Functions)
│   │   └── deep_link_service.dart   (handle deep link)
│   │
│   └── theme/
│       └── app_theme.dart           (ThemeData global)
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart   (Appwrite Account API)
│   │   │   ├── models/
│   │   │   │   └── user_model.dart               (fromDocument / toJson)
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   └── auth_binding.dart
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       ├── pages/
│   │       │   ├── splash_page.dart
│   │       │   ├── onboarding_page.dart
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── role_selection_page.dart
│   │       └── widgets/
│   │           └── auth_text_field.dart
│   │
│   ├── navigation/
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── main_navigation_controller.dart
│   │       └── pages/
│   │           └── main_navigation_page.dart   (bottom nav + role-based tabs)
│   │
│   ├── campaign/                     (Campaign Mode — UMKM & Kreator)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── job_pool/                     (Job Pool — Kreator)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── rate_card/                    (Rate Card Mode — UMKM & Kreator)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── chat/                         (Live Chat — Rate Card Mode only)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── keuangan/                     (Escrow, Deposit, Withdrawal)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── profile/                      (Profil UMKM & Kreator)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   ├── notification/                 (In-app notification)
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   │
│   └── admin/                        (Admin Panel — role=ADMIN only)
│       ├── data/ ...
│       ├── domain/ ...
│       └── presentation/ ...
│
└── shared/
    └── widgets/
        ├── primary_button.dart
        ├── warning_banner.dart
        ├── status_badge.dart
        ├── loading_shimmer.dart
        └── empty_state_widget.dart
```

---

## 5. Routing & Navigation

### 5.1 Routes

Semua route ada di `lib/core/routes/app_routes.dart` dan `app_pages.dart`.

```dart
// app_routes.dart
abstract class Routes {
  static const splash        = '/splash';
  static const onboarding    = '/onboarding';
  static const login         = '/login';
  static const register      = '/register';
  static const roleSelection = '/role-selection';

  // UMKM
  static const umkmHome        = '/umkm/home';
  static const campaignCreate  = '/umkm/campaign/create';
  static const campaignList    = '/umkm/campaign';
  static const campaignDetail  = '/umkm/campaign/:id';
  static const kreatorDirectory = '/umkm/kreator';
  static const kreatorProfile  = '/umkm/kreator/:id';
  static const negoUMKM        = '/umkm/negosiasi';
  static const negoRoomUMKM    = '/umkm/negosiasi/:id';
  static const keuanganUMKM    = '/umkm/keuangan';

  // Kreator
  static const kreatorHome     = '/kreator/home';
  static const jobPool         = '/kreator/job-pool';
  static const jobPoolDetail   = '/kreator/job-pool/:id';
  static const pekerjaanAktif  = '/kreator/pekerjaan-aktif';
  static const submitBukti     = '/kreator/pekerjaan-aktif/:id';
  static const negoKreator     = '/kreator/negosiasi';
  static const negoRoomKreator = '/kreator/negosiasi/:id';
  static const rateCardManage  = '/kreator/rate-card';
  static const keuanganKreator = '/kreator/keuangan';

  // Admin
  static const adminHome        = '/admin';
  static const adminDisputes    = '/admin/disputes';
  static const adminSubmissions = '/admin/submissions';
  static const adminUsers       = '/admin/users';
  static const adminReports     = '/admin/reports';

  // Shared
  static const editProfile  = '/profile/edit';
  static const notification = '/notification';
}
```

### 5.2 Main Navigation (Role-Based)

```
Role UMKM:
  Tab 1: Home / Dashboard UMKM
  Tab 2: Kampanye (Daftar Campaign)
  Tab 3: Kreator (Direktori Rate Card)
  Tab 4: Keuangan
  Tab 5: Profil

Role KREATOR:
  Tab 1: Home / Dashboard Kreator
  Tab 2: Job Pool
  Tab 3: Pekerjaan Aktif
  Tab 4: Keuangan
  Tab 5: Profil

Role ADMIN:
  Tab 1: Dashboard
  Tab 2: Disputes
  Tab 3: Submissions
  Tab 4: Laporan
```

---

## 6. Environment Variables

File `.env` di root project (TIDAK di-commit ke repository):

```env
# .env — Template (copy dan isi dengan nilai nyata)

# ===== APPWRITE =====
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id-here

# Database & Collection IDs (sesuai yang dibuat di Appwrite Console)
APPWRITE_DATABASE_ID=marketiv_db
APPWRITE_COL_USERS=users
APPWRITE_COL_CAMPAIGNS=campaigns
APPWRITE_COL_SUBMISSIONS=submissions
APPWRITE_COL_RATE_CARDS=rate_cards
APPWRITE_COL_RATE_CARD_ORDERS=rate_card_orders
APPWRITE_COL_TRANSACTIONS=transactions
APPWRITE_COL_MESSAGES=messages

# Storage Buckets
APPWRITE_BUCKET_PROFILE=profile_images
APPWRITE_BUCKET_CAMPAIGN=campaign_assets

# ===== MIDTRANS =====
MIDTRANS_CLIENT_KEY=SB-Mid-client-xxxxxxxxxx
MIDTRANS_IS_PRODUCTION=false

# ===== OPENAI =====
# Catatan: OpenAI API hanya dipanggil via Appwrite Functions,
# JANGAN expose OPENAI_API_KEY ke Flutter client
# OPENAI_API_KEY → simpan di Appwrite Function environment variables (server only)

# ===== APP =====
APP_NAME=Marketiv
```

> **PENTING:** `APPWRITE_API_KEY` (API Key dengan akses penuh) **TIDAK ADA** di file `.env` Flutter. API Key hanya ada di environment variable Appwrite Functions di server.

---

## 7. `main.dart` — Entry Point

```dart
// Urutan inisialisasi saat startup:
// 1. dotenv.load()
// 2. initializeDateFormatting('id_ID')
// 3. StorageService.init()               (GetStorage)
// 4. AppwriteService.initialize()        (singleton: Account, Databases, Storage, Realtime, Functions)
// 5. Get.put(DeepLinkService(), permanent: true)
// 6. runApp(GetMaterialApp(...))

// Theme:
// fontFamily: 'Inter'
// Primary color: orange (AppColors.primary)
// useMaterial3: true

// Initial route: Routes.splash
```

---

## 8. Core Layer Detail

### 8.1 Constants & Tokens

Lokasi: `lib/core/constants/`

- `app_constants.dart` — Appwrite endpoint, project ID, database ID, collection IDs, bucket IDs, komisi rates
- `app_colors.dart` — token warna (primary orange, secondary navy, semantic)
- `app_text_styles.dart` — token typography Inter + Newsreader
- `app_spacing.dart` — spacing + radius + shadow
- `app_gradients.dart` — preset gradient
- `marketiv_constants.dart` — list niche, status campaign, status order, rate komisi

### 8.2 Global DI (Initial Binding)

Lokasi: `lib/core/di/initial_binding.dart`

Register global:
- `AppwriteService` (permanent singleton — sudah include Account, Databases, Storage, Realtime, Functions)
- `StorageService` (permanent)
- `AuthRemoteDataSource` + `AuthRepository`
- `ProfileRemoteDataSource` + `ProfileRepository` + profile use cases
- `ProfileSessionService` — cache nama + avatar di GetStorage

### 8.3 Services

- `StorageService` — kelola session/role cache via GetStorage
- `AppwriteService` — singleton client Appwrite (menggantikan `SupabaseService`)
- `DeepLinkService` — routing berbasis deep link (future feature)
- `MidtransService` — buka WebView Midtrans Snap

---

## 9. Best Practices

- Tambahkan logic baru selalu melalui **UseCase**
- Gunakan `Either<Failure, T>` di setiap repository
- Jangan taruh query Appwrite di UI atau Controller
- Gunakan token desain dari `core/constants/`
- Jaga konsistensi naming route + binding
- **Campaign Mode = ZERO CHAT.** Jika ada request menambah chat di Campaign Mode, tolak
- **File > 100MB** → wajib minta URL eksternal, jangan upload langsung
- **Rate Card maks 3 paket** per kreator — enforce di level aplikasi
- Semua teks UI dalam **Bahasa Indonesia** yang sederhana
- **Appwrite hanya di DataSource.** Controller dan UseCase TIDAK PERNAH import `package:appwrite/appwrite.dart`
- Gunakan `Query.*` dari Appwrite SDK untuk semua filter — jangan construct query string manual

---

*Dokumen ini dikonversi dari spesifikasi web (Next.js) ke Flutter Mobile App.*
*Referensi: SKPL Marketiv v5.0, Proposal P2MW Marketiv — Universitas Nusa Putra, Sukabumi, 2026.*

---

## 10. Progress & Status Implementasi

### Status per Layer

| Layer | Status | Keterangan |
|-------|--------|------------|
| **Core — Fondasi** | ✅ Selesai | StorageService, Failures, Exceptions, NoParams, InitialBinding, main.dart, AppRoutes, AppPages |
| **Core — Constants & Services** | ✅ Selesai | AppConstants, AppColors, AppTextStyles, AppSpacing, AppwriteService |
| **Shared Widgets** | ✅ Selesai | PrimaryButton, LoadingShimmer, EmptyStateWidget, StatusBadge, WarningBanner |
| **Auth — Data Layer** | ✅ Selesai | UserModel, AuthRemoteDataSource, AuthRepositoryImpl |
| **Auth — Domain Layer** | ✅ Selesai | UserEntity, AuthRepository (abstract), LoginUseCase, RegisterUseCase, LogoutUseCase, GetCurrentUserUseCase, SendEmailVerificationUseCase |
| **Auth — Presentation** | ✅ Selesai | AuthController, SplashController, AuthBinding, SplashBinding |
| **Auth — UI** | ✅ Selesai | SplashPage, LoginPage, RegisterPage, RoleSelectionPage, AuthTextField |
| **Campaign — Data Layer** | 🔄 Dalam Pengerjaan | CampaignModel, CampaignRemoteDataSource, CampaignRepositoryImpl |
| **Campaign — Domain Layer** | 🔄 Dalam Pengerjaan | CampaignEntity, CampaignRepository, GetActiveCampaignsUseCase, GetMyCampaignsUseCase, GetCampaignByIdUseCase, CreateCampaignUseCase, GenerateBriefUseCase |
| **Campaign — Presentation** | ⏳ Belum Dimulai | CampaignController, CampaignBinding |
| **Campaign — UI** | ⏳ Belum Dimulai | CampaignListPage, CreateCampaignPage (wizard), CampaignDetailPage |
| **Job Pool — Semua Layer** | ⏳ Belum Dimulai | — |
| **Rate Card Mode — Semua Layer** | ⏳ Belum Dimulai | — |
| **Chat (Realtime) — Semua Layer** | ⏳ Belum Dimulai | — |
| **Keuangan & Escrow — Semua Layer** | ⏳ Belum Dimulai | — |
| **Profile — Semua Layer** | ⏳ Belum Dimulai | — |
| **Admin Panel — Semua Layer** | ⏳ Belum Dimulai | — |
| **Appwrite Functions** | ⏳ Belum Dimulai | claim-campaign-fn, midtrans-webhook-fn, release-escrow-fn, refund-escrow-fn, validate-submission-fn, generate-brief-fn, withdraw-fn, admin-stats-fn |

### Legend
- ✅ Selesai — sudah diimplementasi dan compile
- 🔄 Dalam Pengerjaan — prompt sudah dibuat, sedang dieksekusi
- ⏳ Belum Dimulai — terjadwal, belum ada kode

### Catatan Sesi
- **Setup docs & rules, auth implementation, backend infrastructure & database modeling** — fondasi arsitektur, dokumen spesifikasi, skill Copilot, dan implementasi Auth selesai dalam satu sesi kerja.

