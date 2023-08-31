import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/domain/local/collections/subsidiary_collection.dart';

part 'subsidiary.freezed.dart';
part 'subsidiary.g.dart';

@freezed
class Subsidiary with _$Subsidiary {
  const Subsidiary._();

  const factory Subsidiary({
    required int id,
    required String? label,
    required String? address,
    required bool isWorkingOnSunday,
    required Store store,
    required WorkHours workHours,
    required double lat,
    required double lng,
  }) = _Subsidiary;

  factory Subsidiary.fromJson(Map<String, Object?> json) =>
      _$SubsidiaryFromJson(json);

  factory Subsidiary.fromCollection(SubsidiaryCollection collection) =>
      Subsidiary(
        id: collection.id,
        label: collection.label,
        address: collection.address,
        isWorkingOnSunday: collection.isWorkingOnSunday,
        store: Store.fromCollection(collection.store),
        workHours: collection.workHours,
        lat: collection.lat,
        lng: collection.lng,
      );

  LatLng get coordinates => LatLng(lat, lng);
}
