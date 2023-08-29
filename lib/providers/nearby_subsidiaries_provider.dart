import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/util/extensions/iterable_extensions.dart';

final nearbySubsidiariesProvider = StateNotifierProvider.autoDispose<
    NearbySubsidiariesProvider, AsyncValue<List<Subsidiary>>>((ref) {
  final repository = ref.watch(storesRepositoryProvider);
  return NearbySubsidiariesProvider(repository);
});

class NearbySubsidiariesProvider
    extends StateNotifier<AsyncValue<List<Subsidiary>>> {
  final StoresRepository _repository;

  NearbySubsidiariesProvider(this._repository)
      : super(const AsyncValue.data([]));

  Future<void> fetch({
    required LatLng center,
    required LatLng northeast,
    required LatLng southwest,
  }) async {
    state = const AsyncLoading<List<Subsidiary>>().copyWithPrevious(state);
    try {
      final nearby = await _repository.searchNearbySubsidiaries(
        northeast: northeast,
        southwest: southwest,
      );
      state = AsyncData(
        [...nearby, ...?state.valueOrNull].distinctBy((e) => e.id).toList(),
      );
    } catch (e, stack) {
      state = AsyncError<List<Subsidiary>>(e, stack).copyWithPrevious(state);
    }
  }
}
