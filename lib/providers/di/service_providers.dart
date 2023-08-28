import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/network_providers.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(
    Location(),
    ref.watch(ipApiProvider),
    ref.watch(utilApiProvider),
  );
});
