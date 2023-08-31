import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/util/extensions/iterable_extensions.dart';
import 'package:rxdart/rxdart.dart';

final nearbySubsidiariesProvider = StateNotifierProvider.autoDispose<
    NearbySubsidiariesProvider, AsyncValue<List<Subsidiary>>>((ref) {
  final repository = ref.watch(storesRepositoryProvider);
  return NearbySubsidiariesProvider(repository);
});

class NearbySubsidiariesProvider
    extends StateNotifier<AsyncValue<List<Subsidiary>>> {
  final StoresRepository _repository;
  final CompositeSubscription _subscriptions = CompositeSubscription();

  NearbySubsidiariesProvider(this._repository) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    _subscriptions.add(_repository.watchSubsidiaries().listen((event) {
      state = AsyncData(event);
    }));
  }

  Stream<AsyncValue<List<Subsidiary>>> fetch({
    required LatLng center,
    required LatLng northeast,
    required LatLng southwest,
  }) async* {
    yield state =
        const AsyncLoading<List<Subsidiary>>().copyWithPrevious(state);
    yield state = await AsyncValue.guard(
      () async {
        final subsidiaries = await _repository.searchNearbySubsidiaries(
          northeast: northeast,
          southwest: southwest,
        );
        return [...?state.valueOrNull, ...subsidiaries]
            .distinctBy((it) => it.id)
            .toList();
      },
    );
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    super.dispose();
  }
}
