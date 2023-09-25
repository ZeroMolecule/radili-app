import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';

part 'address_search_results.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class AddressSearchResults with _$AddressSearchResults {
  static const AddressSearchResults empty = AddressSearchResults(
    cities: [],
    addresses: [],
    subsidiaries: [],
  );

  const AddressSearchResults._();

  const factory AddressSearchResults({
    required List<AddressInfo> cities,
    required List<AddressInfo> addresses,
    required List<Subsidiary> subsidiaries,
  }) = _AddressSearchResults;

  bool get isEmpty =>
      cities.isEmpty && addresses.isEmpty && subsidiaries.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
