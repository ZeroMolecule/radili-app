import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/local/adapters/location_adapter.dart';
import 'package:radili/domain/local/adapters/remote_asset_adapter.dart';
import 'package:radili/domain/local/adapters/work_hours_adapter.dart';
import 'package:radili/domain/local/boxes/meta_box.dart';
import 'package:radili/domain/local/boxes/subsidiaries_box.dart';
import 'package:radili/domain/local/collections/store_collection.dart';
import 'package:radili/domain/local/collections/subsidiary_collection.dart';
import 'package:radili/util/extensions/date_time_extensions.dart';

class AppHive {
  // collections
  static const int storeTypeId = 0;
  static const int subsidiaryTypeId = 1;

  // custom types
  static const int remoteAssetTypeId = 100;
  static const int workHoursTypeId = 101;
  static const int locationTypeId = 102;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StoreCollectionAdapter());
    Hive.registerAdapter(SubsidiaryCollectionAdapter());

    Hive.registerAdapter(RemoteAssetAdapter());
    Hive.registerAdapter(WorkHoursAdapter());
    Hive.registerAdapter(LocationAdapter());
  }

  static Future<void> clearStaleData() async {
    const metaBox = MetaBox();
    const subsidiariesBox = SubsidiariesBox();

    final lastCleared = await metaBox.getLastCacheCleared();
    final now = DateTime.now();
    if (lastCleared == null || !lastCleared.isSameWeekAs(now)) {
      await subsidiariesBox.clearAll();
      await metaBox.setLastCacheCleared(now);
    }
  }
}
