import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'app_location.freezed.dart';
part 'app_location.g.dart';

@freezed
class AppLocation with _$AppLocation {
  const AppLocation._();

  factory AppLocation({
    required double latitude,
    required double longitude,
    required double accuracy,
    required double heading,
    required bool isMock,
  }) = _AppLocation;

  factory AppLocation.fromJson(Map<String, dynamic> json) =>
      _$AppLocationFromJson(json);

  factory AppLocation.fromLatLng(LatLng latLng) => AppLocation(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        accuracy: 0.0,
        heading: 0.0,
        isMock: false,
      );

  LatLng get latLng => LatLng(latitude, longitude);
}
