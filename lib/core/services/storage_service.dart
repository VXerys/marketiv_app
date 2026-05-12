import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const _keyRole = 'role';
  static const _keyUserId = 'user_id';
  static const _keyNama = 'nama_lengkap';
  static const _keyAvatar = 'avatar_url';
  static const _keyFirstLaunch = 'first_launch';

  static final _box = GetStorage();

  static Future<StorageService> init() async {
    await GetStorage.init();
    return StorageService();
  }

  static void saveRole(String role) => _box.write(_keyRole, role);
  static void saveUserId(String id) => _box.write(_keyUserId, id);
  static void saveNama(String nama) => _box.write(_keyNama, nama);
  static void saveAvatar(String url) => _box.write(_keyAvatar, url);

  static String? getRole() => _box.read<String>(_keyRole);
  static String? getUserId() => _box.read<String>(_keyUserId);
  static String? getNama() => _box.read<String>(_keyNama);
  static String? getAvatar() => _box.read<String>(_keyAvatar);

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
