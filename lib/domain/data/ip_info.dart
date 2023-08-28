import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'ip_info.freezed.dart';
part 'ip_info.g.dart';

@freezed
class IpInfo with _$IpInfo {
  const IpInfo._();

  const factory IpInfo({
    required double lat,
    required double lon,
  }) = _IpInfo;

  factory IpInfo.fromJson(Map<String, dynamic> json) => _$IpInfoFromJson(json);

  LatLng get position => LatLng(lat, lon);
}
