---
name: clean-architecture-getx
description: >
  Template lengkap Clean Architecture + GetX untuk setiap fitur baru di Marketiv Flutter app.
  Gunakan skill ini SETIAP KALI user meminta membuat fitur baru, modul baru, layer baru
  (DataSource, Repository, UseCase, Controller, Binding, Page, Widget), atau bertanya tentang
  struktur folder/arsitektur proyek Marketiv. Juga trigger saat ada pertanyaan tentang
  cara inject dependency, cara buat controller GetX, cara buat use case dengan Either,
  atau saat user minta scaffold/boilerplate kode untuk fitur apapun di Marketiv.
---

# Clean Architecture + GetX — Marketiv

## Prinsip Utama

**Aliran data WAJIB (tidak boleh dilangkahi):**
```
DataSource → Repository → UseCase → Controller → UI
```

**Aturan import:**
- `import 'package:appwrite/appwrite.dart'` → HANYA di DataSource
- Controller → hanya panggil UseCase
- Repository → selalu return `Either<Failure, T>`
- UI → hanya baca dari Controller (Obx / GetX widget)

---

## Struktur Folder per Fitur

```
lib/features/<nama_fitur>/
├── data/
│   ├── datasources/
│   │   └── <fitur>_remote_datasource.dart
│   ├── models/
│   │   └── <fitur>_model.dart
│   └── repositories/
│       └── <fitur>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <fitur>_entity.dart
│   ├── repositories/
│   │   └── <fitur>_repository.dart       ← abstract contract
│   └── usecases/
│       └── get_<fitur>_usecase.dart      ← satu file per use case
│       └── create_<fitur>_usecase.dart
└── presentation/
    ├── bindings/
    │   └── <fitur>_binding.dart
    ├── controllers/
    │   └── <fitur>_controller.dart
    ├── pages/
    │   └── <fitur>_page.dart
    └── widgets/
        └── <fitur>_card.dart
```

---

## Template Lengkap (copy & sesuaikan nama)

### 1. Entity (domain layer)

```dart
// lib/features/<fitur>/domain/entities/<fitur>_entity.dart
class <Fitur>Entity {
  final String id;           // Appwrite document $id
  final String namaField;
  // ... field lainnya

  const <Fitur>Entity({
    required this.id,
    required this.namaField,
  });
}
```

### 2. Model (data layer) — PENTING: fromDocument bukan fromJson

```dart
// lib/features/<fitur>/data/models/<fitur>_model.dart
import '../../domain/entities/<fitur>_entity.dart';

class <Fitur>Model {
  final String id;
  final String namaField;
  // ... field lainnya

  const <Fitur>Model({
    required this.id,
    required this.namaField,
  });

  // WAJIB: parse dari Appwrite document.data (Map<String, dynamic>)
  // Gunakan $id untuk ID dokumen, $createdAt untuk timestamp
  factory <Fitur>Model.fromDocument(Map<String, dynamic> data) {
    return <Fitur>Model(
      id: data['\$id'],
      namaField: data['nama_field'] as String,
      // Untuk nullable field: data['field'] as String?
      // Untuk num: (data['harga'] as num).toDouble()
      // Untuk DateTime: DateTime.parse(data['\$createdAt'])
    );
  }

  Map<String, dynamic> toJson() => {
    'nama_field': namaField,
    // JANGAN masukkan $id — Appwrite generate otomatis
  };

  <Fitur>Entity toEntity() => <Fitur>Entity(
    id: id,
    namaField: namaField,
  );
}
```

### 3. Repository Abstract (domain layer)

```dart
// lib/features/<fitur>/domain/repositories/<fitur>_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/<fitur>_entity.dart';

abstract class <Fitur>Repository {
  Future<Either<Failure, List<<Fitur>Entity>>> getAll();
  Future<Either<Failure, <Fitur>Entity>> getById(String id);
  Future<Either<Failure, <Fitur>Entity>> create(Create<Fitur>Params params);
  Future<Either<Failure, void>> update(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> delete(String id);
}
```

### 4. Repository Impl (data layer)

```dart
// lib/features/<fitur>/data/repositories/<fitur>_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/<fitur>_entity.dart';
import '../../domain/repositories/<fitur>_repository.dart';
import '../datasources/<fitur>_remote_datasource.dart';

class <Fitur>RepositoryImpl implements <Fitur>Repository {
  final <Fitur>RemoteDataSource _dataSource;
  
  <Fitur>RepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<<Fitur>Entity>>> getAll() async {
    try {
      final models = await _dataSource.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan tidak terduga.'));
    }
  }

  // Implementasikan method lainnya dengan pola yang sama
}
```

### 5. UseCase (satu file per use case)

```dart
// lib/features/<fitur>/domain/usecases/get_<fitur>_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/<fitur>_entity.dart';
import '../repositories/<fitur>_repository.dart';

class Get<Fitur>UseCase {
  final <Fitur>Repository _repository;
  Get<Fitur>UseCase(this._repository);

  Future<Either<Failure, List<<Fitur>Entity>>> call(NoParams params) {
    return _repository.getAll();
  }
}

// Untuk use case dengan params:
class Create<Fitur>Params {
  final String namaField;
  // ... parameter lainnya
  const Create<Fitur>Params({required this.namaField});
}
```

### 6. Controller (presentation layer)

```dart
// lib/features/<fitur>/presentation/controllers/<fitur>_controller.dart
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/<fitur>_entity.dart';
import '../../domain/usecases/get_<fitur>_usecase.dart';
import '../../domain/usecases/create_<fitur>_usecase.dart';

class <Fitur>Controller extends GetxController {
  final Get<Fitur>UseCase _getUseCase;
  final Create<Fitur>UseCase _createUseCase;

  <Fitur>Controller({
    required Get<Fitur>UseCase getUseCase,
    required Create<Fitur>UseCase createUseCase,
  })  : _getUseCase = getUseCase,
        _createUseCase = createUseCase;

  // State — SELALU private Rx dengan public getter
  final _items = <Fitur>Entity>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _selectedItem = Rxn<<Fitur>Entity>();

  List<<Fitur>Entity> get items => _items;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  <Fitur>Entity? get selectedItem => _selectedItem.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _getUseCase(NoParams());
    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        Get.snackbar(
          'Gagal Memuat Data',
          failure.message,
          backgroundColor: AppColors.danger,
          colorText: const Color(0xFFFFFFFF),
        );
      },
      (data) => _items.value = data,
    );

    _isLoading.value = false;
  }

  Future<void> createItem(Create<Fitur>Params params) async {
    _isLoading.value = true;

    final result = await _createUseCase(params);
    result.fold(
      (failure) => Get.snackbar(
        'Gagal Menyimpan',
        failure.message,
        backgroundColor: AppColors.danger,
        colorText: const Color(0xFFFFFFFF),
      ),
      (newItem) {
        _items.insert(0, newItem);
        Get.back();
        Get.snackbar('Berhasil', 'Data berhasil disimpan.',
          backgroundColor: AppColors.success,
          colorText: const Color(0xFFFFFFFF),
        );
      },
    );

    _isLoading.value = false;
  }

  @override
  void onClose() {
    // Cleanup: cancel stream subscription jika ada
    super.onClose();
  }
}
```

### 7. Binding (DI — urutan WAJIB)

```dart
// lib/features/<fitur>/presentation/bindings/<fitur>_binding.dart
import 'package:get/get.dart';
import '../../../../core/services/appwrite_service.dart';
import '../../data/datasources/<fitur>_remote_datasource.dart';
import '../../data/repositories/<fitur>_repository_impl.dart';
import '../../domain/repositories/<fitur>_repository.dart';
import '../../domain/usecases/get_<fitur>_usecase.dart';
import '../../domain/usecases/create_<fitur>_usecase.dart';
import '../controllers/<fitur>_controller.dart';

class <Fitur>Binding extends Bindings {
  @override
  void dependencies() {
    // URUTAN WAJIB: DataSource → Repository → UseCase → Controller

    // 1. DataSource
    Get.lazyPut<<Fitur>RemoteDataSource>(
      () => <Fitur>RemoteDataSourceImpl(
        databases: AppwriteService.databases,
        functions: AppwriteService.functions, // hapus jika tidak pakai Functions
      ),
    );

    // 2. Repository
    Get.lazyPut<<Fitur>Repository>(
      () => <Fitur>RepositoryImpl(
        Get.find<<Fitur>RemoteDataSource>(),
      ),
    );

    // 3. UseCase
    Get.lazyPut(() => Get<Fitur>UseCase(Get.find()));
    Get.lazyPut(() => Create<Fitur>UseCase(Get.find()));

    // 4. Controller
    Get.lazyPut<<Fitur>Controller>(
      () => <Fitur>Controller(
        getUseCase: Get.find(),
        createUseCase: Get.find(),
      ),
    );
  }
}
```

### 8. Page (3 state wajib: loading, error, data)

```dart
// lib/features/<fitur>/presentation/pages/<fitur>_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../controllers/<fitur>_controller.dart';
import '../widgets/<fitur>_card.dart';

class <Fitur>Page extends StatelessWidget {
  const <Fitur>Page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<<Fitur>Controller>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Judul Halaman', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Obx(() {
        // State 1: Loading
        if (controller.isLoading) {
          return const LoadingShimmer(); // gunakan widget shimmer, bukan CircularProgressIndicator
        }

        // State 2: Error
        if (controller.hasError) {
          return EmptyStateWidget(
            message: controller.errorMessage,
            onRetry: controller.loadItems,
          );
        }

        // State 3: Empty
        if (controller.items.isEmpty) {
          return const EmptyStateWidget(
            message: 'Belum ada data.',
          );
        }

        // State 4: Data tampil
        return RefreshIndicator(
          onRefresh: controller.loadItems,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              return <Fitur>Card(item: controller.items[index]);
            },
          ),
        );
      }),
    );
  }
}
```

---

## Menambahkan Route

```dart
// Di lib/core/routes/app_pages.dart:
GetPage(
  name: Routes.<namaRoute>,
  page: () => const <Fitur>Page(),
  binding: <Fitur>Binding(),
),

// Di lib/core/routes/app_routes.dart:
static const <namaRoute> = '/path/ke/halaman';
```

---

## Checklist Sebelum Submit Kode

- [ ] `import 'package:appwrite/...'` hanya ada di DataSource
- [ ] Repository return `Either<Failure, T>` di setiap method
- [ ] Binding order: DataSource → Repository → UseCase → Controller
- [ ] Model parse dari `data['\$id']` bukan `data['id']`
- [ ] Page punya 3 state: loading (shimmer), error (retry button), data (ListView.builder)
- [ ] Controller state: private Rx, public getter
- [ ] Semua teks UI dalam Bahasa Indonesia
- [ ] Tidak ada hardcode warna — gunakan AppColors
- [ ] Tidak ada Column + children loop untuk list dinamis — gunakan ListView.builder

---

## Referensi Tambahan

Untuk pola DataSource lengkap dengan Appwrite SDK (query, permissions, error handling):
→ Lihat `/mnt/skills/user/appwrite-datasource/SKILL.md`

Untuk pola fitur spesifik:
→ Campaign Mode: `/mnt/skills/user/campaign-mode/SKILL.md`
→ Rate Card + Chat: `/mnt/skills/user/rate-card-mode/SKILL.md`
→ Keuangan & Escrow: `/mnt/skills/user/escrow-keuangan/SKILL.md`
