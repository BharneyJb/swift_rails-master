import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A lightweight notification store backed by SharedPreferences.
/// Designed as a drop-in shim: when the backend (FCM / OneSignal) is ready,
/// replace [addNotification] and [getAll] calls with real API logic; the rest
/// of the app (badge counts, notification screen) stays unchanged.
class NotificationService {
  static const String _countKey = 'notification_count';
  static const String _listKey = 'notification_list';

  /// Returns the current unread badge count.
  static Future<int> getCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_countKey) ?? 0;
  }

  /// Stores a new notification and increments the badge count.
  static Future<void> addNotification({
    required String title,
    required String body,
    DateTime? timestamp,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final String raw = prefs.getString(_listKey) ?? '[]';
    final List<dynamic> list = jsonDecode(raw);

    list.insert(0, {
      'title': title,
      'body': body,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      'read': false,
    });

    await prefs.setString(_listKey, jsonEncode(list));
    await prefs.setInt(_countKey, (prefs.getInt(_countKey) ?? 0) + 1);
  }

  /// Returns all stored notifications, newest first.
  static Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString(_listKey) ?? '[]';
    final List<dynamic> list = jsonDecode(raw);
    return list.cast<Map<String, dynamic>>();
  }

  /// Marks all notifications as read and resets the badge count to 0.
  static Future<void> markAllRead() async {
    final prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString(_listKey) ?? '[]';
    final List<dynamic> list = jsonDecode(raw);
    final updated = list.map((n) => {...n, 'read': true}).toList();
    await prefs.setString(_listKey, jsonEncode(updated));
    await prefs.setInt(_countKey, 0);
  }

  /// Deletes all stored notifications and resets the badge count.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listKey);
    await prefs.setInt(_countKey, 0);
  }
}
