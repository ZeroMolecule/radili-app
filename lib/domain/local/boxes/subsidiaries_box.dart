import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/local/collections/subsidiary_collection.dart';

const _boxName = 'subsidiaries_box';

class SubsidiariesBox {
  Future<Box<SubsidiaryCollection>> _box() {
    return Hive.openBox(_boxName);
  }

  Future<void> upsert(
    Iterable<Subsidiary> subsidiaries, {
    LatLng? northeast,
    LatLng? southwest,
  }) async {
    final box = await _box();
    final collections = subsidiaries.map(
      (e) => SubsidiaryCollection.fromSubsidiary(e),
    );
    final toDelete = <int>[];
    if (northeast != null && southwest != null) {
      final stored = box.values.where(
        (s) => LatLngBounds(northeast, southwest).contains(
          LatLng(s.lat, s.lng),
        ),
      );
      final missing = stored.whereNot(
        (s) => collections.any((c) => c.id == s.id),
      );
      toDelete.addAll(missing.map((e) => e.id));
    }
    await box.putAll(Map.fromIterable(collections, key: (e) => e.id));
    await box.deleteAll(toDelete);
  }

  Future<List<Subsidiary>> getAll() async {
    final box = await _box();
    return _fromBox(box);
  }

  Stream<List<Subsidiary>> watchAll() async* {
    final box = await _box();
    yield* box.watch().map((event) => _fromBox(box));
  }

  List<Subsidiary> _fromBox(Box<SubsidiaryCollection> box) {
    return box.values.map((e) => Subsidiary.fromCollection(e)).toList();
  }
}
