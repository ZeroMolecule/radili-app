import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_details.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class AddressDetails with _$AddressDetails {
  const AddressDetails._();

  const factory AddressDetails({
    required String address,
    required String addressNumber,
    required String place,
  }) = _AddressDetails;

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    var place = json['place'] ??
        json['city'] ??
        json['town'] ??
        json['village'] ??
        json['hamlet'] ??
        json['city_district'] ??
        json['district'] ??
        json['borough'] ??
        json['suburb'] ??
        json['subdivision'] ??
        json['croft'] ??
        json['isolated_dwelling'] ??
        '';
    place = place.toString().replaceAll(_placeRegex, '');

    final address = json['address'] ??
        json['road'] ??
        json['city_block'] ??
        json['residential'] ??
        json['farm'] ??
        json['farmyard'] ??
        json['industrial'] ??
        json['commercial'] ??
        json['retail'] ??
        json['neigbourhood'] ??
        json['allotments'] ??
        json['quarter'] ??
        '';

    final addressNumber = json['addressNumber'] ??
        json['house_number'] ??
        json['house_name'] ??
        '';

    return AddressDetails(
      address: address,
      addressNumber: addressNumber,
      place: place,
    );
  }

  String combined({
    bool address = true,
    bool number = true,
    place = true,
  }) {
    return [
      if (address) this.address,
      if (number) addressNumber,
      if (place) this.place,
    ].join(' ').trim();
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'addressNumber': addressNumber,
        'place': place,
      };
}

final _placeRegex = RegExp(r'(grad|općina)\s+', caseSensitive: false);
