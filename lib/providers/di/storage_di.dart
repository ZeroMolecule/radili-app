import 'package:hive/hive.dart';
import 'package:radili/domain/local/app_box.dart';
import 'package:radili/domain/local/stores_box.dart';
import 'package:radili/domain/local/subsidiaries_box.dart';
import 'package:radili/providers/di/di.dart';

Future<void> injectStorage() async {
  final boxes = await Future.wait([
    Hive.openBox('app'),
    Hive.openBox<String>('storesubs'),
    Hive.openBox<String>('stores'),
  ]);
  di.registerSingleton(AppBox(boxes[0]));
  di.registerSingleton(SubsidiariesBox(boxes[1] as Box<String>));
  di.registerSingleton(StoresBox(boxes[2] as Box<String>));
}
