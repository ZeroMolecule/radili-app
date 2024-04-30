import 'package:hive/hive.dart';
import 'package:radili/domain/app_shared_preferences.dart';
import 'package:radili/domain/local/app_box.dart';
import 'package:radili/domain/local/subsidiaries_box.dart';
import 'package:radili/providers/di/di.dart';

Future<void> injectStorage() async {
  di.registerSingleton(AppBox(await Hive.openLazyBox('app')));
  di.registerSingleton(SubsidiariesBox(await Hive.openBox('storesubs')));

  di.registerSingleton(AppSharedPreferences());
}
