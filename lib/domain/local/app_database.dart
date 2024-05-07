import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  static Future<void> init() async {
    await Hive.initFlutter();
  }
}
