import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/data/app_location.dart';

const _boxName = 'location_box';
const _keyLocation = 'location';

class LocationBox {
  const LocationBox();

  Future<Box> _box() {
    return Hive.openBox(_boxName);
  }

  Future<AppLocation?> getLocation() async {
    final box = await _box();
    return box.get(_keyLocation);
  }

  Future<void> setLocation(AppLocation value) async {
    final box = await _box();
    await box.put(_keyLocation, value);
  }
}
