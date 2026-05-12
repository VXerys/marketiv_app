---
name: auth-rbac
description: >
  Pola lengkap autentikasi dan Role-Based Access Control (RBAC) untuk Marketiv Flutter app.
  Gunakan skill ini SETIAP KALI user meminta kode terkait: login, register, logout, splash screen
  session check, redirect berdasarkan role, guard halaman berdasarkan role (UMKM/KREATOR/ADMIN),
  email verifikasi, lupa password, atau menyimpan/membaca role dari GetStorage.
  Juga trigger saat user bertanya "bagaimana cara cek apakah user sudah login", "cara redirect
  sesuai role", atau "cara protect halaman agar hanya bisa diakses role tertentu".
---

# Auth & RBAC — Marketiv

## Role System

| Role | Nilai String | Akses |
|------|-------------|-------|
| UMKM | `'UMKM'` | Buat campaign, direktori kreator, top-up |
| Kreator | `'KREATOR'` | Job Pool, submit bukti, withdraw, rate card |
| Admin | `'ADMIN'` | Dashboard admin, disputes, submissions, laporan |

**GetStorage keys yang boleh disimpan:** `role`, `user_id`, `nama_lengkap`, `avatar_url`
**JANGAN simpan:** token JWT, password, API key apapun

---

## 1. Splash Screen — Cek Session

```dart
// lib/features/auth/presentation/controllers/splash_controller.dart
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 800)); // animasi splash
    try {
      await AppwriteService.account.get(); // lempar AppwriteException(401) jika tidak ada session
      final role = StorageService.getRole();
      if (role == null) {
        // Session ada tapi role belum di-cache — fetch dari Appwrite
        await _fetchAndCacheUserRole();
      } else {
        _redirectByRole(role);
      }
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        final isFirstLaunch = StorageService.isFirstLaunch();
        Get.offAllNamed(isFirstLaunch ? Routes.onboarding : Routes.login);
      } else {
        Get.offAllNamed(Routes.login);
      }
    }
  }

  Future<void> _fetchAndCacheUserRole() async {
    try {
      final account = await AppwriteService.account.get();
      final result = await AppwriteService.databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [Query.equal('user_id', account.$id), Query.limit(1)],
      );
      if (result.documents.isNotEmpty) {
        final data = result.documents.first.data;
        StorageService.saveRole(data['role'] as String);
        StorageService.saveUserId(account.$id);
        StorageService.saveNama(data['nama_lengkap'] as String);
        _redirectByRole(data['role'] as String);
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (_) {
      Get.offAllNamed(Routes.login);
    }
  }

  void _redirectByRole(String role) {
    switch (role) {
      case 'UMKM':    Get.offAllNamed(Routes.umkmHome);    break;
      case 'KREATOR': Get.offAllNamed(Routes.kreatorHome); break;
      case 'ADMIN':   Get.offAllNamed(Routes.adminHome);   break;
      default:        Get.offAllNamed(Routes.login);
    }
  }
}
```

---

## 2. Register

```dart
// AuthRemoteDataSource
Future<UserModel> register(RegisterParams params) async {
  try {
    // 1. Buat Appwrite account
    final account = await AppwriteService.account.create(
      userId: ID.unique(),
      email: params.email,
      password: params.password,
      name: params.namaLengkap,
    );

    // 2. Buat session langsung (auto-login setelah register)
    await AppwriteService.account.createEmailPasswordSession(
      email: params.email,
      password: params.password,
    );

    // 3. Buat document di collection users
    final doc = await AppwriteService.databases.createDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.colUsers,
      documentId: ID.unique(),
      data: {
        'user_id': account.$id,
        'role': params.role,           // 'UMKM' atau 'KREATOR'
        'nama_lengkap': params.namaLengkap,
        'nomor_whatsapp': params.nomorWhatsapp,
        'dompet_saldo': 0.0,
        'is_verified': false,
      },
      permissions: [
        Permission.read(Role.user(account.$id)),
        Permission.update(Role.user(account.$id)),
      ],
    );

    // 4. Kirim email verifikasi (fire and forget)
    AppwriteService.account.createVerification(
      url: 'https://marketiv.app/verify', // deep link
    ).catchError((_) {}); // jangan block register jika gagal

    return UserModel.fromDocument(doc.data);
  } on AppwriteException catch (e) {
    if (e.code == 409) throw ConflictException('Email sudah terdaftar. Silakan login.');
    throw ServerException('Gagal mendaftar: ${e.message}');
  }
}
```

---

## 3. Login

```dart
// AuthRemoteDataSource
Future<UserModel> login(String email, String password) async {
  try {
    final session = await AppwriteService.account.createEmailPasswordSession(
      email: email,
      password: password,
    );

    // Ambil data user dari collection users
    final result = await AppwriteService.databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.colUsers,
      queries: [Query.equal('user_id', session.userId), Query.limit(1)],
    );

    if (result.documents.isEmpty) throw NotFoundException('Profil pengguna tidak ditemukan.');
    return UserModel.fromDocument(result.documents.first.data);
  } on AppwriteException catch (e) {
    if (e.code == 401) throw UnauthorizedException('Email atau password salah.');
    throw ServerException('Gagal login: ${e.message}');
  }
}
```

---

## 4. AuthController

```dart
class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase;

  final _isLoading = false.obs;
  final _user = Rxn<UserEntity>();

  bool get isLoading => _isLoading.value;
  UserEntity? get user => _user.value;

  Future<void> login(String email, String password) async {
    _isLoading.value = true;
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => Get.snackbar(
        'Gagal Login', failure.message,
        backgroundColor: AppColors.danger, colorText: Colors.white,
      ),
      (user) {
        _user.value = user;
        // Cache di GetStorage
        StorageService.saveRole(user.role);
        StorageService.saveUserId(user.userId);
        StorageService.saveNama(user.namaLengkap);
        if (user.fotoProfilUrl != null) StorageService.saveAvatar(user.fotoProfilUrl!);
        _redirectByRole(user.role);
      },
    );
    _isLoading.value = false;
  }

  Future<void> logout() async {
    _isLoading.value = true;
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => Get.snackbar('Gagal Logout', failure.message),
      (_) {
        StorageService.clearAll();
        _user.value = null;
        Get.offAllNamed(Routes.login);
      },
    );
    _isLoading.value = false;
  }

  void _redirectByRole(String role) {
    switch (role) {
      case 'UMKM':    Get.offAllNamed(Routes.umkmHome);    break;
      case 'KREATOR': Get.offAllNamed(Routes.kreatorHome); break;
      case 'ADMIN':   Get.offAllNamed(Routes.adminHome);   break;
    }
  }
}
```

---

## 5. StorageService — Cache Role & User Info

```dart
// lib/core/services/storage_service.dart
class StorageService extends GetxService {
  static const _keyRole      = 'role';
  static const _keyUserId    = 'user_id';
  static const _keyNama      = 'nama_lengkap';
  static const _keyAvatar    = 'avatar_url';
  static const _keyFirstLaunch = 'first_launch';

  static final _box = GetStorage();

  static Future<StorageService> init() async {
    await GetStorage.init();
    return StorageService();
  }

  static void saveRole(String role)       => _box.write(_keyRole, role);
  static void saveUserId(String id)       => _box.write(_keyUserId, id);
  static void saveNama(String nama)       => _box.write(_keyNama, nama);
  static void saveAvatar(String url)      => _box.write(_keyAvatar, url);

  static String? getRole()               => _box.read<String>(_keyRole);
  static String? getUserId()             => _box.read<String>(_keyUserId);
  static String? getNama()               => _box.read<String>(_keyNama);
  static String? getAvatar()             => _box.read<String>(_keyAvatar);

  static bool isFirstLaunch() {
    final launched = _box.read<bool>(_keyFirstLaunch) ?? false;
    if (!launched) _box.write(_keyFirstLaunch, true);
    return !launched;
  }

  static void clearAll() {
    _box.remove(_keyRole);
    _box.remove(_keyUserId);
    _box.remove(_keyNama);
    _box.remove(_keyAvatar);
    // JANGAN hapus _keyFirstLaunch agar tidak tampil onboarding lagi
  }
}
```

---

## 6. RBAC — Guard Widget per Role

```dart
// Cara 1: Guard di halaman — cek role di onInit controller
@override
void onInit() {
  super.onInit();
  final role = StorageService.getRole();
  if (role != 'UMKM') {
    Get.back();
    Get.snackbar('Akses Ditolak', 'Halaman ini hanya untuk pemilik UMKM.');
    return;
  }
  _loadData();
}

// Cara 2: Widget kondisional berdasarkan role
Widget _buildActionButton() {
  final role = StorageService.getRole();
  if (role == 'KREATOR') {
    return PrimaryButton(label: 'Klaim Job Ini', onPressed: _claimJob);
  }
  return const SizedBox.shrink();
}

// Cara 3: Middleware route (GetX)
class RoleMiddleware extends GetMiddleware {
  final String requiredRole;
  RoleMiddleware(this.requiredRole);

  @override
  RouteSettings? redirect(String? route) {
    final role = StorageService.getRole();
    if (role != requiredRole) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

// Daftarkan di app_pages.dart:
GetPage(
  name: Routes.adminHome,
  page: () => const AdminHomePage(),
  middlewares: [RoleMiddleware('ADMIN')],
),
```

---

## 7. RBAC Table Lengkap (FEATURES.md §1.5)

| Fitur | UMKM | KREATOR | ADMIN |
|-------|:----:|:-------:|:-----:|
| Buat Campaign | ✅ | ❌ | ❌ |
| Lihat Job Pool | ❌ | ✅ | ✅ |
| Klaim Job | ❌ | ✅ | ❌ |
| Submit URL Bukti | ❌ | ✅ | ❌ |
| Direktori Kreator | ✅ | ❌ | ✅ |
| Live Chat | ✅ | ✅ | ❌ |
| Kirim Custom Offer | ✅ | ❌ | ❌ |
| Buat Rate Card | ❌ | ✅ | ❌ |
| Top-up / Deposit | ✅ | ❌ | ❌ |
| Withdraw Saldo | ❌ | ✅ | ❌ |
| Dashboard Admin | ❌ | ❌ | ✅ |
| Batalkan Escrow | ❌ | ❌ | ✅ |

---

## 8. RegisterParams & LoginParams

```dart
class RegisterParams {
  final String namaLengkap;
  final String email;
  final String password;
  final String role;           // 'UMKM' atau 'KREATOR'
  final String? nomorWhatsapp;

  const RegisterParams({
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.role,
    this.nomorWhatsapp,
  });
}

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}
```
