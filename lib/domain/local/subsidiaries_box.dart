import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';

class SubsidiariesBox {
  final LazyBox _box;

  const SubsidiariesBox(this._box);

  Future<void> save(
    List<Subsidiary> subsidiaries, {
    bool deleteOld = true,
  }) async {
    if (deleteOld) await _box.clear();

    final json = subsidiaries.map((subsidiary) => subsidiary.toJson()).toList();
    await _box.put('subsidiaries', jsonEncode(json));
  }

  Future<List<Subsidiary>> getAll(SubsidiariesQuery query) async {
    final records = await _box.get('subsidiaries');
    if (records is! String || records.isEmpty) return [];

    final decoded = jsonDecode(records);
    if (decoded is! List) return [];

    final bounds = query.bounds;
    return decoded.map((it) => Subsidiary.fromJson(it)).where((it) {
      if (bounds == null) return true;

      return bounds.contains(it.coordinates);
    }).toList();
  }

  Future<Subsidiary?> get(String id) async {
    final records = await _box.get('subsidiaries');
    if (records is! List) return null;

    final record = records.firstWhereOrNull(
      (it) {
        final decoded = jsonDecode(it);
        return decoded['id'] == id;
      },
    );

    if (record == null) return null;

    return Subsidiary.fromJson(jsonDecode(record));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
