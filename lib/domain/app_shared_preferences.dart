import 'dart:convert';

import 'package:radili/domain/data/notification_subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String _keyNotificationSettings = 'notification_settings';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<NotificationSubscription?> getNotificationSubscription() async {
    final prefs = await _getPrefs();
    final json = prefs.getString(_keyNotificationSettings);
    if (json == null) {
      return null;
    }
    return NotificationSubscription.fromJson(jsonDecode(json));
  }

  Future<void> setNotificationSubscription(
    NotificationSubscription? value,
  ) async {
    final prefs = await _getPrefs();
    if (value == null) {
      await prefs.remove(_keyNotificationSettings);
    } else {
      final json = jsonEncode(value.toJson());
      await prefs.setString(_keyNotificationSettings, json);
    }
  }
}
