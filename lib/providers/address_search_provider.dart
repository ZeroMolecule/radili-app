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

  Stream<AsyncValue<List<AddressInfo>>> search(String query) async* {
    yield state =
        const AsyncLoading<List<AddressInfo>>().copyWithPrevious(state);
    yield state = await AsyncValue.guard<List<AddressInfo>>(
      () => _storesRepository.searchAddress(query),
    );
  }
}
