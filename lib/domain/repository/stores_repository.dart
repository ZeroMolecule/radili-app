import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/domain/remote/stores_api.dart';

class StoresRepository {
  final NominatimApi _nominatimApi;
  final StoresApi _storesApi;

  StoresRepository(this._nominatimApi, this._storesApi);

  Future<List<AddressInfo>> searchAddress(String address) {
    return _nominatimApi.search(address: address);
  }

  Future<List<Subsidiary>> searchNearbySubsidiaries(LatLng position) {
    return _storesApi.getNearbySubsidiaries(position);
  }
}
