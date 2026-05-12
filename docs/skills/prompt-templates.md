# Prompt Templates — Marketiv (Flutter + GetX + Appwrite)

Template siap pakai. Ganti bagian dalam `[KURUNG_KOTAK]` sesuai kebutuhan.

---

## 1. Generate DataSource Baru

```
@workspace Kamu adalah Flutter developer senior yang ahli Clean Architecture + Appwrite.

Buat [NamaFitur]RemoteDataSourceImpl untuk proyek Marketiv.

Collection Appwrite: `[nama_collection]` (ID konstanta: AppConstants.col[NamaFitur]s)

Methods yang dibutuhkan:
- getAll({String? filter, int limit = 20, int offset = 0}) → List<[NamaFitur]Model>
- getById(String id) → [NamaFitur]Model
- create(Map<String, dynamic> data, String ownerUserId) → [NamaFitur]Model
- update(String id, Map<String, dynamic> data) → void
- delete(String id) → void

Rules wajib:
- import 'package:appwrite/appwrite.dart' HANYA di file ini
- Setiap AppwriteException di-catch dan di-map: 401→UnauthorizedException, 404→NotFoundException, 409→ConflictException, default→ServerException
- Setiap createDocument WAJIB sertakan permissions yang sesuai
- Model di-parse dari document.data menggunakan fromDocument(), bukan fromJson()
- Field ID dokumen: data['\$id'], timestamp: data['\$createdAt']

Permissions untuk collection ini: [sebutkan — pemilik saja / publik read / dua pihak]

Gunakan pola dari #file:lib/features/campaign/data/datasources/campaign_remote_datasource.dart
```

---

## 2. Generate Repository Impl

```
@workspace Buat [NamaFitur]RepositoryImpl yang mengimplementasikan [NamaFitur]Repository.

Dependencies: [NamaFitur]RemoteDataSource (inject via constructor)

Setiap method harus:
- Return Either<Failure, T> dari package dartz
- Catch UnauthorizedException → Left(AuthFailure)
- Catch NotFoundException → Left(NotFoundFailure)
- Catch ServerException → Left(ServerFailure)
- Catch semua exception lain → Left(ServerFailure(message: 'Terjadi kesalahan tidak terduga.'))
- Konversi Model ke Entity menggunakan .toEntity()

Lihat abstract contract di #file:lib/features/[nama_fitur]/domain/repositories/[nama_fitur]_repository.dart
Ikuti pola dari #file:lib/features/campaign/data/repositories/campaign_repository_impl.dart
```

---

## 3. Generate UseCase

```
@workspace Buat use case berikut untuk fitur [nama_fitur] di Marketiv:

1. Get[NamaFitur]UseCase — ambil list, return Either<Failure, List<[NamaFitur]Entity>>
2. Get[NamaFitur]ByIdUseCase — ambil satu, parameter: String id
3. Create[NamaFitur]UseCase — buat baru, parameter: Create[NamaFitur]Params

Untuk Create[NamaFitur]Params, field yang diperlukan: [list field]

Satu file per use case. Setiap use case hanya punya satu method `call()`.
Gunakan NoParams dari core/usecases/usecase.dart untuk use case tanpa parameter.

Pola dari #file:lib/features/campaign/domain/usecases/get_campaigns_usecase.dart
```

---

## 4. Generate GetX Controller

```
@workspace Buat [NamaFitur]Controller extends GetxController untuk proyek Marketiv.

Dependencies (inject via constructor):
- Get[NamaFitur]UseCase _getUseCase
- Create[NamaFitur]UseCase _createUseCase

State management rules:
- Semua state PRIVATE Rx: final _items = <[NamaFitur]Entity>[].obs
- Public getter: List<[NamaFitur]Entity> get items => _items
- State wajib: _items, _isLoading, _errorMessage
- Tambahkan: bool get hasError => _errorMessage.value.isNotEmpty

onInit(): panggil loadItems()

loadItems():
1. Set _isLoading = true, _errorMessage = ''
2. Panggil _getUseCase(NoParams())
3. result.fold: failure → set _errorMessage + Get.snackbar dengan AppColors.danger, success → set _items
4. Set _isLoading = false

Get.snackbar error: backgroundColor: AppColors.danger, colorText: Colors.white
Get.snackbar success: backgroundColor: AppColors.success, colorText: Colors.white

onClose(): dispose semua TextEditingController dan StreamController jika ada

Pola dari #file:lib/features/campaign/presentation/controllers/campaign_list_controller.dart
```

---

## 5. Generate Binding

```
@workspace Buat [NamaFitur]Binding extends Bindings untuk proyek Marketiv.

Dependencies yang perlu didaftarkan (URUTAN WAJIB):
1. [NamaFitur]RemoteDataSource → [NamaFitur]RemoteDataSourceImpl(
     databases: AppwriteService.databases,
     functions: AppwriteService.functions,  // hapus jika tidak pakai
   )
2. [NamaFitur]Repository → [NamaFitur]RepositoryImpl(Get.find())
3. Get[NamaFitur]UseCase → Get.lazyPut(() => Get[NamaFitur]UseCase(Get.find()))
4. Create[NamaFitur]UseCase → Get.lazyPut(() => Create[NamaFitur]UseCase(Get.find()))
5. [NamaFitur]Controller → [NamaFitur]Controller(getUseCase: Get.find(), createUseCase: Get.find())

Semua menggunakan Get.lazyPut (bukan Get.put).

Pola dari #file:lib/features/campaign/presentation/bindings/campaign_binding.dart
```

---

## 6. Generate Page (3 State UI)

```
@workspace Buat [NamaFitur]Page sebagai StatelessWidget untuk proyek Marketiv.

Controller: [NamaFitur]Controller (diakses via Get.find())

Layout menggunakan Obx() untuk reaktivitas. WAJIB 3 state:
1. Loading → LoadingShimmer() (dari shared/widgets/loading_shimmer.dart)
   Kondisi: controller.isLoading && controller.items.isEmpty
2. Error → EmptyStateWidget.error(message: controller.errorMessage, onRetry: controller.loadItems)
   Kondisi: controller.hasError
3. Data → ListView.builder (BUKAN Column + children loop)
   Tambahkan RefreshIndicator dengan onRefresh: controller.loadItems

Design tokens:
- Background: AppColors.background
- Surface card: AppColors.surface
- AppBar: elevation: 0, backgroundColor: AppColors.surface
- Padding: EdgeInsets.all(AppSpacing.md) atau symmetric

JANGAN hardcode warna atau ukuran — gunakan AppColors, AppSpacing, AppTextStyles.
Semua teks UI dalam Bahasa Indonesia.

Item card: buat widget terpisah [NamaFitur]Card di folder widgets/.

Pola dari #file:lib/features/job_pool/presentation/pages/job_pool_page.dart
```

---

## 7. Generate Model (Appwrite Document)

```
@workspace Buat [NamaFitur]Model untuk proyek Marketiv.

Collection Appwrite: [nama_collection]
Fields: [list semua field dari DATABASE.md]

Requirements:
- factory fromDocument(Map<String, dynamic> data) — parse dari Appwrite document.data
  - ID dokumen: data['\$id'] (bukan data['id'])
  - Timestamp: DateTime.parse(data['\$createdAt'])
  - Nullable field: data['field'] as String?
  - Numeric field: (data['harga'] as num).toDouble()
- Map<String, dynamic> toJson() — untuk createDocument (JANGAN masukkan \$id)
- [NamaFitur]Entity toEntity() — konversi ke domain entity

Buat juga [NamaFitur]Entity di domain/entities/ dengan field yang sama (final, const constructor).
```

---

## 8. Fix Error Appwrite

```
@workspace /fix

Error Appwrite berikut muncul di #file:[file.dart]:

[PASTE ERROR MESSAGE LENGKAP — termasuk stack trace]

Konteks:
- Operation yang gagal: [createDocument / listDocuments / dll.]
- Collection: [nama collection]
- User yang sedang login: role [UMKM/KREATOR/ADMIN]

Kemungkinan penyebab: [tebakan kamu jika ada]
```

---

## 9. Generate Unit Test

```
@workspace /tests

Buat unit test untuk #file:[path/usecase_atau_repository.dart]

Setup:
- Gunakan flutter_test dan mockito
- @GenerateMocks([dependency yang perlu di-mock])
- setUp(): inisialisasi mock dan class yang ditest

Test cases yang harus ada:
1. Happy path — return Right(data) ketika sukses
2. ServerFailure — ketika DataSource throw ServerException
3. AuthFailure — ketika DataSource throw UnauthorizedException
4. [Edge case spesifik fitur ini jika ada]

Verifikasi dengan: expect(result, Right([expected_data])) atau isA<Left<Failure, T>>()
```

---

## 10. Generate copilot-instructions.md untuk Marketiv

```
@workspace Buat file .github/copilot-instructions.md untuk proyek Marketiv ini.

Analisa seluruh #codebase dan buat instruksi yang mencakup:

## 1. Ringkasan Proyek
- Apa itu Marketiv (2-3 kalimat)
- Tech stack utama

## 2. Arsitektur Wajib
- Aliran data: DataSource → Repository → UseCase → Controller → UI
- Aturan import (appwrite hanya di DataSource)
- Repository selalu return Either<Failure, T>

## 3. Appwrite Conventions
- Cara parse document: data['\$id'], data['\$createdAt']
- Setiap createDocument harus ada permissions
- TRANSACTIONS: Flutter client READ ONLY

## 4. UI Conventions
- 3 state wajib per halaman: loading, error, data
- ListView.builder (bukan Column+map)
- Design tokens: AppColors, AppSpacing, AppTextStyles
- Semua teks UI Bahasa Indonesia

## 5. Larangan Mutlak
- Campaign Mode = ZERO CHAT
- OPENAI_API_KEY, MIDTRANS_SERVER_KEY tidak di Flutter
- Rate Card maks 3 paket

## 6. Binding Order
DataSource → Repository → UseCase → Controller (selalu Get.lazyPut)

Tulis dalam format imperatif yang singkat. Sertakan contoh kode untuk aturan yang tidak obvious.
Maksimal 500 baris.
```

---

## 11. Review Kode untuk Kepatuhan Arsitektur

```
@workspace Review #file:[file.dart] untuk memastikan kepatuhan terhadap arsitektur Marketiv.

Cek poin-poin berikut:
1. ❌ Apakah ada import 'package:appwrite/...' di luar DataSource?
2. ❌ Apakah Repository langsung diakses dari Controller (bukan via UseCase)?
3. ❌ Apakah ada hardcode warna/ukuran (bukan AppColors/AppSpacing)?
4. ❌ Apakah halaman tidak punya 3 state (loading/error/data)?
5. ❌ Apakah list menggunakan Column+map (bukan ListView.builder)?
6. ❌ Apakah ada teks UI dalam Bahasa Inggris?
7. ❌ Apakah createDocument tidak menyertakan permissions?
8. ❌ Apakah Appwrite document di-parse dengan fromJson (bukan fromDocument)?

Untuk setiap pelanggaran, tunjukkan baris yang salah dan cara memperbaikinya.
```

---

## 12. Dokumentasi Inline (KDoc/DartDoc)

```
@workspace /doc #selection

Tambahkan DartDoc documentation untuk kode yang di-highlight.

Format:
- Satu kalimat summary di baris pertama
- @param untuk setiap parameter non-obvious
- @returns untuk return type yang perlu penjelasan
- @throws untuk exception yang mungkin dilempar
- Contoh penggunaan jika method kompleks

Tulis dalam Bahasa Indonesia yang jelas dan ringkas.
```