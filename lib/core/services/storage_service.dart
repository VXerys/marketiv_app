import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _keyRole = 'role';
  static const String _keyUserId = 'user_id';
  static const String _keyNama = 'nama';
  static const String _keyAvatarUrl = 'avatar_url';

  static final _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static void saveSession({
    required String role,
    required String userId,
    required String nama,
    String? avatarUrl,
  }) {
    saveRole(role);
    saveUserId(userId);
    saveNama(nama);
    if (avatarUrl != null) {
      saveAvatar(avatarUrl);
    }
  }

  static void saveRole(String role) => _box.write(_keyRole, role);
  static void saveUserId(String userId) => _box.write(_keyUserId, userId);
  static void saveNama(String nama) => _box.write(_keyNama, nama);
  static void saveAvatar(String url) => _box.write(_keyAvatarUrl, url);

  static String? getRole() => _box.read<String>(_keyRole);
  static String? getUserId() => _box.read<String>(_keyUserId);
  static String? getNama() => _box.read<String>(_keyNama);
  static String? getAvatarUrl() => _box.read<String>(_keyAvatarUrl);

  static bool isLoggedIn() => getUserId() != null;

  static void clearAll() {
    _box.erase();
  }
}
