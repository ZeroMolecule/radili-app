import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_details.dart';
import 'package:radili/domain/data/address_type.dart';

part 'address_info.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class AddressInfo with _$AddressInfo {
  const AddressInfo._();

  factory AddressInfo({
    required LatLng latLng,
    required LatLngBounds boundingBox,
    required AddressDetails details,
    required AddressType type,
  }) = _AddressInfo;

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    final latLng = _parseLatLng(json);
    final boundingBox = _parseBoundingBox(
      json['boundingbox'] ?? json['bounding_box'] ?? json['boundingBox'],
    );
    final details = _parseAddressDetails(json);
    return AddressInfo(
      latLng: latLng,
      boundingBox: boundingBox,
      details: details,
      type: _parseType(json['addresstype'] ?? json['type'] ?? json['class']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coordinates': {
          'lat': latLng.latitude,
          'lng': latLng.longitude,
        },
        'boundingBox': boundingBox,
        'details': details.toJson(),
      };
}

LatLng _parseLatLng(Map<String, dynamic> json) {
  final obj = json['coordinates'] ?? json['latlng'] ?? json;
  return LatLng(
    double.tryParse(obj['lat'] ?? obj['latitude'] ?? '') ?? 0.0,
    double.tryParse(obj['lon'] ?? obj['lng'] ?? obj['longitude'] ?? '') ?? 0.0,
  );
}

LatLngBounds _parseBoundingBox(dynamic json) {
  if (json is Map) {
    return LatLngBounds(
      _parseLatLng(json['southwest']),
      _parseLatLng(json['northeast']),
    );
  }
  final array = (json as List)
      .map(
        (e) => e is double ? e : double.tryParse(e.toString()),
      )
      .whereNotNull();

  final southWest = LatLng(array.elementAt(0), array.elementAt(2));
  final northEast = LatLng(array.elementAt(1), array.elementAt(3));
  return LatLngBounds(southWest, northEast);
}

AddressDetails _parseAddressDetails(Map<String, dynamic> json) {
  final address = json['address'];
  final obj = address is Map ? address as Map<String, dynamic> : json;
  return AddressDetails.fromJson(obj);
}

AddressType _parseType(String? json) {
  if (json == null) {
    return AddressType.other;
  }
  switch (json.trim().toLowerCase()) {
    case 'country':
    case 'state':
      return AddressType.country;
    case 'county':
    case 'city_district':
      return AddressType.county;
    case 'city':
    case 'town':
    case 'village':
    case 'hamlet':
      return AddressType.city;
    default:
      return AddressType.other;
  }
}
