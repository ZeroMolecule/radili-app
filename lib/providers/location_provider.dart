import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/providers/di/service_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
Stream<AppLocation> location(LocationRef ref) async* {
  final service = ref.watch(locationServiceProvider);
  yield await service.getCurrent(accuracy: LocationAccuracy.low);
  yield await service.getCurrent(accuracy: LocationAccuracy.high);
}
