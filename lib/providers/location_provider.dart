import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/service_providers.dart';
import 'package:rxdart/rxdart.dart';

final locationProvider = StateNotifierProvider(
  (ref) => LocationNotifier(ref.watch(locationServiceProvider)),
);

class LocationNotifier extends StateNotifier<AsyncValue<AppLocation?>> {
  final LocationService _locationService;
  final CompositeSubscription _streamSubscriptions = CompositeSubscription();

  LocationNotifier(this._locationService) : super(const AsyncLoading()) {
    fetch();
  }

  Future<void> _init() async {
    state = await AsyncValue.guard(_locationService.getCurrent);
  }

  Future<void> fetch() async {
    state = const AsyncLoading<AppLocation?>().copyWithPrevious(state);
    state = await AsyncValue.guard(_locationService.getCurrent);
  }

  void watch() {
    _streamSubscriptions.clear();
    _streamSubscriptions.add(
      _locationService.watchCurrent().listen((event) {
        state = AsyncData(event);
      }),
    );
  }

  void stopWatching() {
    _streamSubscriptions.clear();
  }

  @override
  void dispose() {
    _streamSubscriptions.dispose();
    super.dispose();
  }
}
