import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_search_results.dart';
import 'package:radili/domain/data/address_type.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';

final addressSearchProvider = StateNotifierProvider.autoDispose<
    AddressSearchProvider, AsyncValue<AddressSearchResults>>(
  (ref) => AddressSearchProvider(ref.watch(storesRepositoryProvider)),
);

class AddressSearchProvider
    extends StateNotifier<AsyncValue<AddressSearchResults>> {
  final StoresRepository _storesRepository;

  AddressSearchProvider(this._storesRepository)
      : super(const AsyncValue.data(AddressSearchResults.empty));

  Stream<AsyncValue<AddressSearchResults>> search(String query) async* {
    yield state =
        const AsyncLoading<AddressSearchResults>().copyWithPrevious(state);
    yield state = await AsyncValue.guard<AddressSearchResults>(
      () async {
        if (query.trim().isEmpty) {
          return AddressSearchResults.empty;
        }
        final results = await _storesRepository.searchAddress(query);
        final List<AddressInfo> cities = [];
        final List<AddressInfo> addresses = [];
        for (var it in results) {
          if (it.type == AddressType.city) {
            cities.add(it);
          } else {
            addresses.add(it);
          }
        }
        return AddressSearchResults(
          cities: cities.take(5).toList(),
          addresses: addresses.take(5).toList(),
          subsidiaries: [],
        );
      },
    );
  }
}
