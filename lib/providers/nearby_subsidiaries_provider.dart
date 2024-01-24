import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/nearby_subsidiaries_query.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';
import 'package:radili/util/extensions/iterable_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearby_subsidiaries_provider.g.dart';

@riverpod
class NearbySubsidiaries extends _$NearbySubsidiaries {
  StoresRepository get _storesRepository => ref.read(storesRepositoryProvider);

  @override
  Stream<List<Subsidiary>> build(NearbySubsidiariesQuery query) {
    return _storesRepository.watchSubsidiaries(query);
  }

  Future<void> fetch({
    required LatLng northeast,
    required LatLng southwest,
  }) async {
    final nearby = await _storesRepository.searchNearbySubsidiaries(
      northeast: northeast,
      southwest: southwest,
      query: query,
    );

    await update(
      (value) => [...value, ...nearby].distinctBy((it) => it.id).toList(),
    );
  }
}
