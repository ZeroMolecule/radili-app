import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/converters/latlng_converter.dart';
import 'package:radili/domain/data/store.dart';

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
    @JsonKey(name: 'coordinates') required Map<String, dynamic> coordinatesRaw,
  }) = _Subsidiary;

  factory Subsidiary.fromJson(Map<String, Object?> json) =>
      _$SubsidiaryFromJson(json);

  LatLng get coordinates => const LatLngConverter().fromJson(coordinatesRaw)!;
}
