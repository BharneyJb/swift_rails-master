import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userNameKey = 'user_name';
  
  // Store user name after successful signup
  static Future<void> storeUserName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, firstName);
  }
  
  // Retrieve user name for login screen
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }
  
  // Clear user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }
}

