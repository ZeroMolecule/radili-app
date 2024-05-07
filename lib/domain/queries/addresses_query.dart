import 'package:freezed_annotation/freezed_annotation.dart';

part 'addresses_query.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class AddressesQuery with _$AddressesQuery {
  static const empty = AddressesQuery();

  const AddressesQuery._();

  const factory AddressesQuery({
    String? search,
    @Default(3) int limit,
  }) = _AddressesQuery;
}
