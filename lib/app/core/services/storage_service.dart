import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    return this;
  }

  // Keys
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyIsFirstTime = 'is_first_time';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';

  // Auth Token
  String? get token => _box.read(_keyToken);
  Future<void> saveToken(String token) => _box.write(_keyToken, token);
  Future<void> removeToken() => _box.remove(_keyToken);

  // User Data
  Map<String, dynamic>? get userData => _box.read(_keyUser);
  Future<void> saveUserData(Map<String, dynamic> data) => _box.write(_keyUser, data);
  Future<void> removeUserData() => _box.remove(_keyUser);

  // First Time
  bool get isFirstTime => _box.read(_keyIsFirstTime) ?? true;
  Future<void> setFirstTime(bool value) => _box.write(_keyIsFirstTime, value);

  // Login Status
  bool get isLoggedIn => _box.read(_keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) => _box.write(_keyIsLoggedIn, value);

  // Theme Mode
  String get themeMode => _box.read(_keyThemeMode) ?? 'light';
  Future<void> saveThemeMode(String mode) => _box.write(_keyThemeMode, mode);

  // Language
  String get language => _box.read(_keyLanguage) ?? 'en';
  Future<void> saveLanguage(String lang) => _box.write(_keyLanguage, lang);

  // Clear all data
  Future<void> clearAll() => _box.erase();

  // Logout
  Future<void> logout() async {
    await removeToken();
    await removeUserData();
    await setLoggedIn(false);
  }
}
