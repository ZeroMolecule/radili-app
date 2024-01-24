import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'meta_box';
const _keyLastCacheCleared = 'last_cache_cleared';

class MetaBox {
  const MetaBox();

  Future<Box> _box() {
    return Hive.openBox(_boxName);
  }

  Future<DateTime?> getLastCacheCleared() async {
    final box = await _box();
    return box.get(_keyLastCacheCleared);
  }

  Future<void> setLastCacheCleared(DateTime value) async {
    final box = await _box();
    await box.put(_keyLastCacheCleared, value);
  }
}
