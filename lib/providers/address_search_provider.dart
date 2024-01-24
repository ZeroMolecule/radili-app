import 'package:collection/collection.dart';
import 'package:maps_toolkit/maps_toolkit.dart' hide LatLng;
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_search_results.dart';
import 'package:radili/domain/data/address_type.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/util/extensions/latlng_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_search_provider.g.dart';

@riverpod
Future<AddressSearchResults> addressSearch(
  AddressSearchRef ref,
  String query,
) async {
  final repo = ref.watch(storesRepositoryProvider);
  final location = ref.watch(locationProvider).valueOrNull;
  query = query.trim();
  if (query.isEmpty) return AddressSearchResults.empty;

  final (cities, addresses) = await _searchPlaces(repo, query);
  final subsidiaries = await repo.searchSubsidiaries(query);

  return AddressSearchResults(
    cities: _sortPlaces(cities, location),
    addresses: _sortPlaces(addresses.take(5), location),
    subsidiaries: _sortSubsidiaries(subsidiaries.take(5), location),
  );
}

Future<(List<AddressInfo> cities, List<AddressInfo> addresses)> _searchPlaces(
  StoresRepository repo,
  String query,
) async {
  final results = await repo.searchAddress(query);
  final List<AddressInfo> cities = [];
  final List<AddressInfo> addresses = [];
  for (var it in results) {
    if (it.type == AddressType.city) {
      cities.add(it);
    } else {
      addresses.add(it);
    }
  }
  return (cities, addresses);
}

List<AddressInfo> _sortPlaces(
  Iterable<AddressInfo> places,
  AppLocation? location,
) {
  if (location == null) return places.toList();

  final point = location.latLng.toMapToolkitLatLng();

  return places.sortedBy(
    (it) => SphericalUtil.computeDistanceBetween(
      it.latLng.toMapToolkitLatLng(),
      point,
    ),
  );
}

List<Subsidiary> _sortSubsidiaries(
  Iterable<Subsidiary> subsidiaries,
  AppLocation? location,
) {
  if (location == null) return subsidiaries.toList();

  final point = location.latLng.toMapToolkitLatLng();

  return subsidiaries.sortedBy(
    (it) => SphericalUtil.computeDistanceBetween(
      it.coordinates.toMapToolkitLatLng(),
      point,
    ),
  );
}
