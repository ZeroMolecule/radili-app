import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:radili/domain/data/store.dart';

class StoresBox {
  final Box<String> _box;

  const StoresBox(this._box);

  Future<void> save(
    List<Store> stores, {
    bool deleteOld = true,
  }) async {
    if (deleteOld) await _box.clear();

    await _box.putAll({
      for (final store in stores) store.id: jsonEncode(store.toJson()),
    });
  }

  Future<List<Store>> getAll() async {
    return _box.values.map((it) => Store.fromJson(jsonDecode(it))).toList();
  }

  Future<Store?> get(String id) async {
    final record = _box.get(id);

    if (record == null) return null;

    return Store.fromJson(jsonDecode(record));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
