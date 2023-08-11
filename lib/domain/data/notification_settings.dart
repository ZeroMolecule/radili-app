import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/converters/latlng_converter.dart';
import 'package:radili/domain/data/address_info.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

@freezed
class NotificationSettings with _$NotificationSettings {
  const NotificationSettings._();

  const factory NotificationSettings({
    required int id,
    required String? email,
    required String? pushToken,
    @JsonKey(name: 'coordinates') required Map<String, dynamic>? coordinatesRaw,
    required String? address,
  }) = _NotificationSettings;

  LatLng get coordinates => const LatLngConverter().fromJson(coordinatesRaw)!;

  AddressInfo? get addressInfo {
    return AddressInfo(
      rawLat: coordinates.latitude.toString(),
      rawLon: coordinates.longitude.toString(),
      displayName: address ?? '',
    );
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
