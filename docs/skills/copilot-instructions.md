# .github/copilot-instructions.md — Marketiv

> File ini siap di-copy ke `.github/copilot-instructions.md` di root repo Marketiv.
> Dibaca Copilot secara otomatis di setiap chat request.

---

```markdown
# Marketiv — GitHub Copilot Instructions

Marketiv adalah Flutter mobile app (hybrid marketplace) yang menghubungkan UMKM dengan kreator
mikro untuk pemasaran konten video pendek (TikTok/Instagram Reels). Ada dua mode operasional:
Campaign Mode (performance-based, ZERO CHAT) dan Rate Card Mode (fixed price, ada live chat).

---

## Tech Stack

- Flutter SDK ^3.10.7 + Dart
- State management, routing, DI: GetX (get: ^4.7.3)
- Backend: Appwrite Cloud (Auth, Databases, Storage, Realtime, Functions) — BUKAN Supabase
- Error handling: dartz (Either<Failure, T>)
- Local cache: get_storage
- Payment: Midtrans Snap via WebView
- AI: OpenAI gpt-4o-mini via Appwrite Function (tidak pernah dipanggil langsung dari Flutter)

---

## Arsitektur Wajib — Clean Architecture + GetX

Aliran data: DataSource → Repository → UseCase → Controller → UI

**Aturan import — paling penting:**
- `import 'package:appwrite/appwrite.dart'` HANYA boleh ada di layer DataSource
- Controller TIDAK PERNAH import appwrite atau memanggil Appwrite SDK langsung
- Repository SELALU return `Either<Failure, T>` — tidak ada unhandled exception

**Binding order — selalu ikuti urutan ini:**
```dart
// 1. DataSource
Get.lazyPut<XRemoteDataSource>(() => XRemoteDataSourceImpl(databases: AppwriteService.databases));
// 2. Repository
Get.lazyPut<XRepository>(() => XRepositoryImpl(Get.find()));
// 3. UseCase
Get.lazyPut(() => GetXUseCase(Get.find()));
// 4. Controller
Get.lazyPut<XController>(() => XController(getUseCase: Get.find()));
```

---

## Appwrite Conventions

**Parse document — gunakan fromDocument(), bukan fromJson():**
```dart
factory XModel.fromDocument(Map<String, dynamic> data) => XModel(
  id: data['\$id'],                          // dollar sign dengan escape
  createdAt: DateTime.parse(data['\$createdAt']),
  namaField: data['nama_field'] as String,
  nilaiNullable: data['nullable'] as String?,
  harga: (data['harga'] as num).toDouble(),
);
```

**createDocument — WAJIB sertakan permissions:**
```dart
await databases.createDocument(
  databaseId: AppConstants.databaseId,
  collectionId: AppConstants.colXxx,
  documentId: ID.unique(),
  data: model.toJson(),
  permissions: [
    Permission.read(Role.user(ownerUserId)),
    Permission.update(Role.user(ownerUserId)),
  ],
);
```

**Error mapping — wajib di setiap DataSource:**
```dart
on AppwriteException catch (e) {
  switch (e.code) {
    case 401: throw UnauthorizedException('Sesi habis. Silakan login kembali.');
    case 404: throw NotFoundException('Data tidak ditemukan.');
    case 409: throw ConflictException('Data sudah ada atau terjadi konflik.');
    default:  throw ServerException('Kesalahan server: ${e.message}');
  }
}
```

**Collection TRANSACTIONS — Flutter client hanya boleh READ:**
Flutter TIDAK PERNAH createDocument atau updateDocument ke collection `transactions`.
Semua pergerakan dana via Appwrite Function (server-side).

---

## UI Conventions

**3 state wajib di setiap halaman yang fetch data:**
```dart
Obx(() {
  if (controller.isLoading) return const LoadingShimmer();       // shimmer, bukan CircularProgressIndicator
  if (controller.hasError) return EmptyStateWidget.error(        // dengan tombol retry
    message: controller.errorMessage, onRetry: controller.load);
  if (controller.items.isEmpty) return const EmptyStateWidget(   // empty state
    message: 'Belum ada data.');
  return ListView.builder(...);                                   // bukan Column + children.map()
})
```

**Design tokens — selalu gunakan konstanta, jangan hardcode:**
```dart
// Warna
AppColors.primary500    // orange utama #F97316
AppColors.secondary500  // navy #1E3A5F
AppColors.success       // #16A34A
AppColors.danger        // #DC2626
AppColors.background    // #FAFAFA
AppColors.surface       // #FFFFFF

// Spacing
AppSpacing.xs=4, sm=8, md=16, lg=24, xl=32

// Typography
AppTextStyles.h3          // Newsreader 20 SemiBold
AppTextStyles.bodyMedium  // Inter 14 Regular
AppTextStyles.labelMedium // Inter 14 Medium
AppTextStyles.buttonText  // Inter 16 SemiBold
```

**CachedNetworkImage — selalu untuk gambar remote:**
```dart
CachedNetworkImage(
  imageUrl: url,
  errorWidget: (_, __, ___) => Icon(Icons.image_outlined, color: AppColors.grey300),
)
```

**Bahasa Indonesia — semua teks UI, snackbar, label, dialog wajib Bahasa Indonesia sederhana.**

---

## State Management (GetX)

State selalu private Rx dengan public getter:
```dart
final _items = <XEntity>[].obs;
final _isLoading = false.obs;
final _errorMessage = ''.obs;

List<XEntity> get items => _items;
bool get isLoading => _isLoading.value;
String get errorMessage => _errorMessage.value;
bool get hasError => _errorMessage.value.isNotEmpty;
```

Snackbar error:
```dart
Get.snackbar('Judul', failure.message,
  backgroundColor: AppColors.danger, colorText: Colors.white);
```

---

## Keamanan — Tidak Boleh Dilanggar

- OPENAI_API_KEY → hanya di Appwrite Function env vars, TIDAK di Flutter
- MIDTRANS_SERVER_KEY → hanya di Appwrite Function env vars, TIDAK di Flutter
- APPWRITE_API_KEY (full access) → hanya di Appwrite Function env vars, TIDAK di Flutter
- Flutter hanya boleh punya: APPWRITE_ENDPOINT + APPWRITE_PROJECT_ID
- GetStorage hanya untuk: role, user_id, nama_lengkap, avatar_url — BUKAN token/password

---

## Larangan Mutlak (Hard Constraints)

1. **Campaign Mode = ZERO CHAT** — tidak ada tombol chat, WhatsApp, atau komunikasi apapun
2. **Appwrite Realtime** — hanya aktif di ChatController (Rate Card Mode), tidak di tempat lain
3. **File > 100MB** — wajib URL eksternal (Google Drive/Dropbox), tidak upload ke Storage
4. **Rate Card maks 3 paket per kreator** — enforce di RateCardController sebelum createDocument
5. **1 kreator 1x per campaign** — query dulu sebelum createDocument submission
6. **Tidak ada video player built-in** — buka via url_launcher ke browser eksternal
7. **Tidak ada fitur review/rating** — tidak ada di MVP

---

## Struktur Folder

```
lib/
├── core/
│   ├── constants/     (AppColors, AppSpacing, AppTextStyles, AppConstants)
│   ├── error/         (failures.dart, exceptions.dart)
│   ├── routes/        (app_routes.dart, app_pages.dart)
│   └── services/      (appwrite_service.dart, storage_service.dart)
├── features/
│   ├── auth/          (login, register, splash, role selection)
│   ├── campaign/      (UMKM: buat campaign, lihat campaign miliknya)
│   ├── job_pool/      (Kreator: browse & klaim campaign)
│   ├── rate_card/     (direktori kreator, manajemen paket)
│   ├── chat/          (live chat Rate Card Mode only)
│   ├── keuangan/      (deposit, withdrawal, riwayat transaksi)
│   ├── profile/       (profil UMKM & Kreator)
│   └── admin/         (dashboard admin, disputes, submissions)
└── shared/
    └── widgets/       (PrimaryButton, StatusBadge, LoadingShimmer, EmptyStateWidget, WarningBanner)
```

---

## Konstanta Penting

```dart
AppConstants.databaseId         // 'marketiv_db'
AppConstants.colUsers           // 'users'
AppConstants.colCampaigns       // 'campaigns'
AppConstants.colSubmissions     // 'submissions'
AppConstants.colRateCards       // 'rate_cards'
AppConstants.colRateCardOrders  // 'rate_card_orders'
AppConstants.colTransactions    // 'transactions'
AppConstants.colMessages        // 'messages'
AppConstants.campaignFeePercent  // 0.15 (15%)
AppConstants.rateCardFeePercent  // 0.10 (10%)
```

---

## Model Bisnis

- Campaign Mode: UMKM bayar budget + 15% komisi platform
- Rate Card Mode: UMKM bayar harga kontrak + 10% platform fee
- Kreator menerima harga penuh tanpa potongan di Rate Card Mode
- Semua dana transit via Escrow (collection TRANSACTIONS) sebelum cair ke kreator
```