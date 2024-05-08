import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/data/subsidiary.dart';

part 'subsidiaries_query.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class SubsidiariesQuery with _$SubsidiariesQuery {
  static const empty = SubsidiariesQuery();

  const SubsidiariesQuery._();

  const factory SubsidiariesQuery({
    int? day,
    List<Store>? stores,
    LatLng? northeast,
    LatLng? southwest,
    String? search,
    LatLng? location,
    int? limit,
  }) = _SubsidiariesQuery;

  LatLngBounds? get bounds => northeast != null && southwest != null
      ? LatLngBounds(southwest!, northeast!)
      : null;

  bool isMatch(Subsidiary subsidiary) {
    final day = this.day;
    final stores = this.stores;
    final bounds = this.bounds;
    final search = this.search?.toLowerCase();

    if (bounds != null && !bounds.contains(subsidiary.coordinates)) {
      return false;
    }

    if (search != null && search.isNotEmpty) {
      final hasMatch = [
        subsidiary.label?.toLowerCase(),
        subsidiary.address?.toLowerCase()
      ].any((it) => it?.contains(search) == true);

      if (!hasMatch) return false;
    }

    if (stores != null && stores.isNotEmpty) {
      final hasMatch = stores.any((it) => it.slug == subsidiary.store.slug);
      if (!hasMatch) return false;
    }

    if (day != null) {
      final hasMatch = subsidiary.workHours.byDay()[day] != null;
      if (!hasMatch) return false;
    }

    return true;
  }
}
