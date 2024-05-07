import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/util/extensions/latlng_extensions.dart';

class SubsidiariesBox {
  final Box<String> _box;

  const SubsidiariesBox(this._box);

  Future<void> save(
    List<Subsidiary> subsidiaries, {
    bool deleteOld = true,
  }) async {
    if (deleteOld) await _box.clear();

    await _box.putAll({
      for (var subsidiary in subsidiaries)
        subsidiary.id: jsonEncode(subsidiary.toJson()),
    });
  }

  Future<List<Subsidiary>> getAll(SubsidiariesQuery query) async {
    var result = _box.values
        .map((it) => Subsidiary.fromJson(jsonDecode(it)))
        .where(query.isMatch);
    if (query.location != null) {
      result = result.sortedBy(
        (it) => it.coordinates.distanceTo(query.location!).abs(),
      );
    }
    if (query.limit != null) {
      result = result.take(query.limit!);
    }
    return result.toList();
  }

  Future<Subsidiary?> get(String id) async {
    final record = _box.get(id);

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
