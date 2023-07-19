import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

class LatLngConverter extends JsonConverter<LatLng?, Map<String, dynamic>?> {
  const LatLngConverter();
  @override
  LatLng? fromJson(Map<String, dynamic>? json) {
    if (json is Map && json != null) {
      final lat = double.parse(json['lat'].toString());
      final lng = double.parse(json['lng'].toString());
      return LatLng(lat, lng);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson(LatLng? object) {
    return {
      'lat': object?.latitude,
      'lng': object?.longitude,
    };
  }
}
