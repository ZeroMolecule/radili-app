import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/local/adapters/remote_asset_adapter.dart';
import 'package:radili/domain/local/adapters/work_hours_adapter.dart';
import 'package:radili/domain/local/collections/store_collection.dart';
import 'package:radili/domain/local/collections/subsidiary_collection.dart';

class AppHive {
  // collections
  static const int storeTypeId = 0;
  static const int subsidiaryTypeId = 1;

  // custom types
  static const int remoteAssetTypeId = 100;
  static const int workHoursTypeId = 101;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StoreCollectionAdapter());
    Hive.registerAdapter(SubsidiaryCollectionAdapter());

    Hive.registerAdapter(RemoteAssetAdapter());
    Hive.registerAdapter(WorkHoursAdapter());
  }
}
