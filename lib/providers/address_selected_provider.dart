import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/providers/di/service_providers.dart';

final addressSelectedProvider =
    StateNotifierProvider.autoDispose<AddressSelectedNotifier, AddressInfo?>(
  (ref) => AddressSelectedNotifier(
    ref.watch(locationServiceProvider),
    ref.watch(storesRepositoryProvider),
  ),
);

class AddressSelectedNotifier extends StateNotifier<AddressInfo?> {
  final LocationService _locationService;
  final StoresRepository _storesRepository;

  AddressSelectedNotifier(
    this._locationService,
    this._storesRepository,
  ) : super(null);

  void select(AddressInfo? address) {
    state = address;
  }

  Future<void> selectCurrent() async {
    final location = await _locationService.getCurrent();
    if (location != null) {
      final address = await _storesRepository.reverseSearchAddress(
        location.latLng,
      );
      if (address != null) {
        state = address;
      }
    }
  }
}
