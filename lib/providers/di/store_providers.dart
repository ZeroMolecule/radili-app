import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/app_shared_preferences.dart';

final sharedPreferencesProvider = Provider<AppSharedPreferences>((ref) {
  return AppSharedPreferences();
});
