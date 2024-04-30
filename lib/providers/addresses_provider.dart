import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_type.dart';
import 'package:radili/domain/queries/addresses_query.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/providers/di/di.dart';
import 'package:radili/util/extensions/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'addresses_provider.g.dart';

@riverpod
Future<List<AddressInfo>> addresses(
  AddressesRef ref,
  AddressesQuery query,
) async {
  await ref.debounce(const Duration(milliseconds: 250));

  final api = di.get<NominatimApi>();
  final all = await api.search(query: query.search ?? '');

  final cities = <AddressInfo>[];
  final addresses = <AddressInfo>[];

  for (final address in all) {
    if (cities.length < query.limit && address.type == AddressType.city) {
      cities.add(address);
    } else if (addresses.length < query.limit) {
      addresses.add(address);
    }
    if (cities.length >= query.limit && addresses.length >= query.limit) {
      break;
    }
  }

  return [...cities, ...addresses];
}
