import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/converters/latlng_converter.dart';
import 'package:radili/domain/data/address_info.dart';

part 'notification_subscription.freezed.dart';
part 'notification_subscription.g.dart';

@freezed
class NotificationSubscription with _$NotificationSubscription {
  const NotificationSubscription._();

  const factory NotificationSubscription({
    required int id,
    required String? email,
    required String? pushToken,
    @JsonKey(name: 'coordinates') required Map<String, dynamic>? coordinatesRaw,
    required String? address,
  }) = _NotificationSubscription;

  LatLng get coordinates => const LatLngConverter().fromJson(coordinatesRaw)!;

  AddressInfo? get addressInfo {
    return AddressInfo(
      rawLat: coordinates.latitude.toString(),
      rawLon: coordinates.longitude.toString(),
      displayName: address ?? '',
    );
  }

  factory NotificationSubscription.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubscriptionFromJson(json);
}
