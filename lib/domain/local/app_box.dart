import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/data/store.dart';

class AppBox {
  final Box _box;

  const AppBox(this._box);

  Future<void> saveLocation(AppLocation location) async {
    await _box.put('location', location.toJson());
  }

  Future<AppLocation?> getLocation() async {
    final json = _box.get('location');
    if (json is! Map) return null;

    return AppLocation.fromJson(json.cast());
  }

  Future<void> saveSubsidiariesRefreshAt(DateTime timestamp) async {
    await _box.put('subsidiariesRefreshAt', timestamp.millisecondsSinceEpoch);
  }

  Future<DateTime?> getSubsidiariesRefreshAt() async {
    final timestamp = await _box.get('subsidiariesRefreshAt');
    if (timestamp is! int) return null;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> savePreferredStores(List<Store>? stores) async {
    if (stores == null || stores.isEmpty) {
      await _box.delete('preferredStores');
    }
    final json = jsonEncode(stores);
    await _box.put('preferredStores', json);
  }

  Future<List<Store>?> getPreferredStores() async {
    return getPreferredStoresSync();
  }

  List<Store>? getPreferredStoresSync() {
    final raw = _box.get('preferredStores');
    if (raw is! String || raw.isEmpty) return null;

    final json = jsonDecode(raw);
    if (json is List) {
      return json.map((e) => Store.fromJson(e)).toList();
    }
    return null;
  }
}
