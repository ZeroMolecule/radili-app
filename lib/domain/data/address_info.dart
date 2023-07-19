import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'address_info.freezed.dart';
part 'address_info.g.dart';

@freezed
class AddressInfo with _$AddressInfo {
  const AddressInfo._();

  factory AddressInfo({
    @protected @JsonKey(name: 'lat') required String rawLat,
    @protected @JsonKey(name: 'lon') required String rawLon,
    @JsonKey(name: 'display_name') required String displayName,
  }) = _AddressInfo;

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);

  LatLng get latLng => LatLng(
        double.tryParse(rawLat) ?? 0.0,
        double.tryParse(rawLon) ?? 0.0,
      );
}
