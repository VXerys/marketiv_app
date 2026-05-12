---
name: appwrite-datasource
description: >
  Pola lengkap Appwrite DataSource untuk Marketiv Flutter app: query listDocuments dengan filter
  dan pagination, createDocument dengan permissions yang benar, updateDocument, deleteDocument,
  getDocument, memanggil Appwrite Functions, dan error handling AppwriteException.
  Gunakan skill ini SETIAP KALI user meminta kode yang menyentuh Appwrite SDK, termasuk:
  membuat DataSource baru, query collection, upload file ke Storage, subscribe Realtime,
  setup permissions dokumen, atau menangani error dari Appwrite. Juga trigger saat user
  bertanya tentang Query.equal/orderDesc/limit/offset, Permission.read/write/update/delete,
  atau cara memanggil Appwrite Function dari Flutter.
---

# Appwrite DataSource — Marketiv

## Aturan Mutlak

- `import 'package:appwrite/appwrite.dart'` → HANYA di layer DataSource
- Selalu handle `AppwriteException` dan transform ke custom exception
- Setiap `createDocument()` WAJIB sertakan parameter `permissions`
- Flutter client **TIDAK PERNAH** createDocument/updateDocument ke collection `TRANSACTIONS`
- Model di-parse dari `document.data` (Map<String, dynamic>), bukan dari JSON string

---

## Template DataSource Lengkap

```dart
// lib/features/<fitur>/data/datasources/<fitur>_remote_datasource.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/<fitur>_model.dart';

abstract class <Fitur>RemoteDataSource {
  Future<List<<Fitur>Model>> getAll({String? filter, int limit = 20, int offset = 0});
  Future<<Fitur>Model> getById(String id);
  Future<<Fitur>Model> create(Map<String, dynamic> data, String ownerUserId);
  Future<void> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
}

class <Fitur>RemoteDataSourceImpl implements <Fitur>RemoteDataSource {
  final Databases _databases;
  final Functions _functions; // hapus jika tidak butuh Functions

  <Fitur>RemoteDataSourceImpl({
    required Databases databases,
    required Functions functions,
  })  : _databases = databases,
        _functions = functions;

  @override
  Future<List<<Fitur>Model>> getAll({
    String? filter,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queries = [
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
        Query.offset(offset),
      ];

      if (filter != null) queries.add(Query.equal('status', filter));

      final result = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.col<Fitur>s, // sesuaikan nama konstanta
        queries: queries,
      );

      return result.documents
          .map((d) => <Fitur>Model.fromDocument(d.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<<Fitur>Model> getById(String id) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.col<Fitur>s,
        documentId: id,
      );
      return <Fitur>Model.fromDocument(doc.data);
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<<Fitur>Model> create(
    Map<String, dynamic> data,
    String ownerUserId,
  ) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.col<Fitur>s,
        documentId: ID.unique(),
        data: data,
        permissions: [
          // Sesuaikan permissions per kebutuhan — lihat tabel di bawah
          Permission.read(Role.user(ownerUserId)),
          Permission.update(Role.user(ownerUserId)),
          Permission.delete(Role.user(ownerUserId)),
        ],
      );
      return <Fitur>Model.fromDocument(doc.data);
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.col<Fitur>s,
        documentId: id,
        data: data,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.col<Fitur>s,
        documentId: id,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  // Error mapping — WAJIB ada di setiap DataSource
  Exception _mapException(AppwriteException e) {
    switch (e.code) {
      case 401:
        return UnauthorizedException('Sesi habis. Silakan login kembali.');
      case 404:
        return NotFoundException('Data tidak ditemukan.');
      case 409:
        return ConflictException('Data sudah ada atau terjadi konflik.');
      case 429:
        return RateLimitException('Terlalu banyak permintaan. Coba lagi nanti.');
      default:
        return ServerException('Kesalahan server: ${e.message}');
    }
  }
}
```

---

## Query Patterns

### Filter dasar
```dart
Query.equal('status', 'Aktif')           // WHERE status = 'Aktif'
Query.notEqual('status', 'Dibatalkan')
Query.greaterThan('harga', 10000)
Query.greaterThanEqual('harga', 10000)   // >=
Query.lessThan('harga', 50000)
Query.lessThanEqual('harga', 50000)      // <=
Query.between('harga', 10000, 50000)
Query.isNull('niche')
Query.isNotNull('foto_profil_url')
Query.startsWith('judul', 'Sambal')
Query.contains('deskripsi', 'makanan')  // LIKE %makanan%
```

### Sort & Pagination
```dart
Query.orderDesc('\$createdAt')     // terbaru dulu
Query.orderAsc('\$createdAt')      // terlama dulu
Query.orderDesc('harga_per_1000_views')
Query.limit(20)                    // ambil 20 dokumen
Query.offset(0)                    // skip 0 (halaman 1)
Query.offset(20)                   // skip 20 (halaman 2)
```

### Pilih field spesifik (hemat bandwidth)
```dart
Query.select(['\$id', 'judul_campaign', 'status', 'harga_per_1000_views', '\$createdAt'])
```

### Multiple filter (AND logic)
```dart
final queries = [
  Query.equal('status', 'Aktif'),
  Query.equal('niche', 'Kuliner'),
  Query.greaterThanEqual('harga_per_1000_views', 2000.0),
  Query.lessThanEqual('harga_per_1000_views', 5000.0),
  Query.orderDesc('\$createdAt'),
  Query.limit(20),
  Query.offset(offset),
];
```

### Cek duplikasi (enforce uniqueness)
```dart
// Cek apakah kreator sudah klaim campaign ini
Future<bool> _isAlreadyClaimed(String campaignId, String kreatorId) async {
  final result = await _databases.listDocuments(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.colSubmissions,
    queries: [
      Query.equal('campaign_id', campaignId),
      Query.equal('kreator_id', kreatorId),
      Query.limit(1),
    ],
  );
  return result.total > 0;
}
```

---

## Permissions Patterns

### Pemilik saja (dokumen pribadi)
```dart
permissions: [
  Permission.read(Role.user(userId)),
  Permission.update(Role.user(userId)),
  Permission.delete(Role.user(userId)),
]
```

### Publik read (campaign di Job Pool)
```dart
permissions: [
  Permission.read(Role.users()),           // semua user terautentikasi
  Permission.update(Role.user(umkmId)),    // hanya UMKM pemilik
]
```

### Dua pihak (chat, order)
```dart
permissions: [
  Permission.read(Role.user(umkmId)),
  Permission.read(Role.user(kreatorId)),
  Permission.update(Role.user(umkmId)),
  Permission.update(Role.user(kreatorId)),
]
```

### Referensi lengkap Permission per Collection Marketiv
→ Lihat DATABASE.md §10 untuk tabel lengkap

---

## Appwrite Functions — Cara Panggil dari DataSource

```dart
// Panggil Appwrite Function dan handle response
Future<Map<String, dynamic>> _callFunction(
  String functionId,
  Map<String, dynamic> body,
) async {
  try {
    final execution = await _functions.createExecution(
      functionId: functionId,
      body: jsonEncode(body),
      method: 'POST',
    );

    if (execution.responseStatusCode != 200) {
      final errData = jsonDecode(execution.responseBody);
      throw ServerException(errData['error'] ?? 'Gagal menjalankan operasi.');
    }

    return jsonDecode(execution.responseBody) as Map<String, dynamic>;
  } on AppwriteException catch (e) {
    throw _mapException(e);
  }
}

// Contoh penggunaan:
Future<SubmissionModel> claimCampaign(String campaignId, String kreatorId) async {
  final data = await _callFunction('claim-campaign-fn', {
    'campaign_id': campaignId,
    'kreator_id': kreatorId,
  });
  return SubmissionModel.fromDocument(data['submission'] as Map<String, dynamic>);
}
```

---

## Storage — Upload File

```dart
// Upload foto profil (HANYA gambar ≤5MB, compress dulu)
Future<String> uploadProfileImage(File file, String userId) async {
  try {
    final result = await _storage.createFile(
      bucketId: AppConstants.bucketProfileImage,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: file.path,
        filename: 'profile_$userId.jpg',
      ),
      permissions: [
        Permission.read(Role.any()),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );

    return '${AppConstants.appwriteEndpoint}'
        '/storage/buckets/${AppConstants.bucketProfileImage}'
        '/files/${result.$id}/view'
        '?project=${AppConstants.appwriteProjectId}';
  } on AppwriteException catch (e) {
    throw _mapException(e);
  }
}

// Validasi ukuran file SEBELUM upload (wajib — batas 100MB campaign assets)
void _validateFileSize(File file, {int maxMB = 100}) {
  final sizeInMB = file.lengthSync() / (1024 * 1024);
  if (sizeInMB > maxMB) {
    throw FileTooLargeException(
      'File melebihi ${maxMB}MB. Gunakan link Google Drive/Dropbox untuk file besar.'
    );
  }
}
```

---

## Realtime — Subscribe Chat (HANYA di ChatDataSource)

```dart
// Realtime subscription hanya untuk ChatRoomPage (Rate Card Mode)
// JANGAN aktifkan Realtime di halaman lain

class ChatRemoteDataSource {
  final Databases _databases;
  final Realtime _realtime;
  RealtimeSubscription? _subscription;

  void subscribeToMessages(String orderId, Function(List<MessageModel>) onUpdate) {
    _subscription = _realtime.subscribe([
      'databases.${AppConstants.databaseId}'
      '.collections.${AppConstants.colMessages}.documents',
    ]);

    _subscription!.stream.listen((event) {
      final data = event.payload;
      if (data['order_id'] == orderId) {
        // Trigger reload untuk orderId ini
        fetchMessages(orderId).then(onUpdate);
      }
    });
  }

  void cancelSubscription() {
    _subscription?.close();
    _subscription = null;
  }

  Future<List<MessageModel>> fetchMessages(String orderId) async {
    final result = await _databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.colMessages,
      queries: [
        Query.equal('order_id', orderId),
        Query.orderAsc('\$createdAt'),
        Query.limit(100),
      ],
    );
    return result.documents
        .map((d) => MessageModel.fromDocument(d.data))
        .toList();
  }
}
```

---

## Custom Exceptions (core/error/exceptions.dart)

```dart
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}

class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);
}

class RateLimitException implements Exception {
  final String message;
  const RateLimitException(this.message);
}

class FileTooLargeException implements Exception {
  final String message;
  const FileTooLargeException(this.message);
}
```

## Failures (core/error/failures.dart)

```dart
abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
```

---

## Checklist Sebelum Commit

- [ ] Tidak ada `import 'package:appwrite/...'` di luar DataSource
- [ ] Semua `AppwriteException` di-catch dan di-map ke custom exception
- [ ] Setiap `createDocument()` ada parameter `permissions`
- [ ] Validasi ukuran file sebelum upload ke Storage
- [ ] Realtime subscription hanya di ChatRemoteDataSource
- [ ] Collection `TRANSACTIONS` tidak ada `createDocument` / `updateDocument` dari Flutter client
- [ ] Pagination menggunakan `Query.limit()` + `Query.offset()`
- [ ] Field `$id` dan `$createdAt` di-parse dengan backslash escape: `data['\$id']`
