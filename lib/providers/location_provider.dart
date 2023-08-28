import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/service_providers.dart';

final locationProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<AppLocation?>>(
  (ref) => LocationNotifier(ref.watch(locationServiceProvider)),
);

class LocationNotifier extends StateNotifier<AsyncValue<AppLocation?>> {
  final LocationService _locationService;

  LocationNotifier(this._locationService) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    state = await AsyncValue.guard(_locationService.getCurrent);
  }

  Future<void> fetch() async {
    state = const AsyncLoading<AppLocation?>().copyWithPrevious(state);
    state = await AsyncValue.guard(_locationService.getCurrent);
  }
}
