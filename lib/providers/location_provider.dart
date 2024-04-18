import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/providers/di/service_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
Stream<AppLocation> location(LocationRef ref) async* {
  final service = ref.watch(locationServiceProvider);
  final cached = await service.getCached();
  if (cached != null) yield cached;

  final inaccurate = await service.getCurrent(accuracy: LocationAccuracy.low);
  if (inaccurate != null) yield inaccurate;

  final accurate = await service.getCurrent(accuracy: LocationAccuracy.high);
  if (accurate != null) yield accurate;

  if (cached == null && inaccurate == null && accurate == null) {
    yield await service.getFallback();
  }
}
