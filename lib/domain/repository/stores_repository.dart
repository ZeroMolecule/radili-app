import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/local/boxes/subsidiaries_box.dart';
import 'package:radili/domain/queries/nearby_subsidiaries_query.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/domain/remote/stores_api.dart';

class StoresRepository {
  final NominatimApi _nominatimApi;
  final StoresApi _storesApi;
  final SubsidiariesBox _subsidiariesBox;

  StoresRepository(this._nominatimApi, this._storesApi, this._subsidiariesBox);

  Future<List<AddressInfo>> searchAddress(String query) {
    return _nominatimApi.search(query: query);
  }

  Future<AddressInfo?> reverseSearchAddress(LatLng position) {
    return _nominatimApi.reverse(position: position);
  }

  Future<List<Subsidiary>> searchNearbySubsidiaries({
    required LatLng northeast,
    required LatLng southwest,
    NearbySubsidiariesQuery? query,
  }) async {
    final subsidiaries = await _storesApi.getNearbySubsidiaries(
      northeast: northeast,
      southwest: southwest,
    );
    await _subsidiariesBox.upsert(subsidiaries);
    if (query == null) {
      return subsidiaries;
    }
    return subsidiaries.where((s) => query.validateSubsidiary(s)).toList();
  }

  Stream<List<Subsidiary>> watchSubsidiaries([
    NearbySubsidiariesQuery? query,
  ]) async* {
    yield await _subsidiariesBox.getAll(query);
    yield* _subsidiariesBox.watchAll(query).distinct();
  }

  Future<List<Subsidiary>> searchSubsidiaries(String query) async {
    final subsidiaries = await _storesApi.searchSubsidiaries(query);
    await _subsidiariesBox.upsert(subsidiaries);
    return subsidiaries;
  }
}
