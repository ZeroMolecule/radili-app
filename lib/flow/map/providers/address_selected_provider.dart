import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_selected_provider.g.dart';

@riverpod
class AddressSelected extends _$AddressSelected {
  StoresRepository get _storesRepository => ref.read(storesRepositoryProvider);

  @override
  Future<AddressInfo?> build() async {
    return null;
  }

  Future<void> setCurrent() async {
    final location = await ref.refresh(locationProvider.future);
    await update(
      (_) => _storesRepository.reverseSearchAddress(location.latLng),
    );
  }

  void set(AddressInfo? address) {
    update((_) => address);
  }
}
