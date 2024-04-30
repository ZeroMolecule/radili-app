import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/store.dart';

part 'subsidiaries_query.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class SubsidiariesQuery with _$SubsidiariesQuery {
  static final empty = SubsidiariesQuery(
    day: DateTime.now().weekday,
    stores: [],
    northeast: null,
    southwest: null,
  );

  const SubsidiariesQuery._();

  const factory SubsidiariesQuery({
    required int day,
    required List<Store> stores,
    required LatLng? northeast,
    required LatLng? southwest,
  }) = _SubsidiariesQuery;

  LatLngBounds? get bounds => northeast != null && southwest != null
      ? LatLngBounds(southwest!, northeast!)
      : null;
}
