import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';

final addressSearchProvider = StateNotifierProvider.autoDispose<
    AddressSearchProvider, AsyncValue<List<AddressInfo>>>(
  (ref) => AddressSearchProvider(ref.watch(storesRepositoryProvider)),
);

class AddressSearchProvider
    extends StateNotifier<AsyncValue<List<AddressInfo>>> {
  final StoresRepository _storesRepository;

  AddressSearchProvider(this._storesRepository)
      : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    state = const AsyncLoading<List<AddressInfo>>().copyWithPrevious(state);
    state = await AsyncValue.guard<List<AddressInfo>>(
      () => _storesRepository.searchAddress(query),
    );
  }
}
