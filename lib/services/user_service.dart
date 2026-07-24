import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userNameKey = 'user_name';
  static const String _initialsKey = 'user_initials';
  static const String _avatarPathKey = 'user_avatar_path';

  // Store user name after successful signup
  static Future<void> storeUserName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, firstName);
    // Auto-derive and store initials
    if (firstName.isNotEmpty) {
      await prefs.setString(_initialsKey, firstName[0].toUpperCase());
    }
  }

  // Retrieve user name for login screen
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Retrieve initials (first letter of first name)
  static Future<String> getInitials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_initialsKey) ?? '?';
  }

  // Store custom avatar file path (from image_picker)
  static Future<void> storeAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, path);
  }

  // Retrieve avatar file path
  static Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  // Remove custom avatar (revert to initials)
  static Future<void> removeAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarPathKey);
  }

  // Clear all user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_initialsKey);
    await prefs.remove(_avatarPathKey);
  }
}
