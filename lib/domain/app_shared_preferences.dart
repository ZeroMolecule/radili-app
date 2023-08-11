import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String _keyUserSubscriptionSettings =
      'user_subscription_settings';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> sync() async {
    final prefs = await _getPrefs();
    await prefs.reload();
  }

  Future<String> getUserSubscriptionSettings() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUserSubscriptionSettings) ?? '';
  }

  Future<void> setUserSubscriptionSettings(String? value) async {
    final prefs = await _getPrefs();
    if (value == null) {
      await prefs.remove(_keyUserSubscriptionSettings);
      return;
    }
    await prefs.setString(_keyUserSubscriptionSettings, value);
  }
}
