import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
class Location extends _$Location {
  LocationService get _service => di.get();

  @override
  Stream<AppLocation> build() async* {
    final cached = await _service.getCached();
    if (cached != null) yield cached;

    final inaccurate =
        await _service.getCurrent(accuracy: LocationAccuracy.low);
    if (inaccurate != null) yield inaccurate;

    final accurate = await _service.getCurrent(accuracy: LocationAccuracy.high);
    if (accurate != null) yield accurate;

    if (cached == null && inaccurate == null && accurate == null) {
      yield await _service.getFallback();
    }
  }

  Future<AppLocation?> fetch([
    LocationAccuracy accuracy = LocationAccuracy.balanced,
  ]) async {
    final updated = await _service.getCurrent(accuracy: accuracy);
    if (updated != null) {
      state = AsyncData(updated).copyWithPrevious(state);
      return updated;
    }
    return null;
  }
}
