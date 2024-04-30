import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/local/app_box.dart';
import 'package:radili/domain/local/subsidiaries_box.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/domain/remote/stores_api.dart';

class SubsidiariesRepository {
  final StoresApi _api;

  final SubsidiariesBox _box;
  final AppBox _appBox;

  const SubsidiariesRepository(this._api, this._box, this._appBox);

  Stream<List<Subsidiary>> watch(SubsidiariesQuery query) async* {
    final stored = await _box.getAll(query);
    if (stored.isNotEmpty) yield stored;

    final lastFetchedAt = await _appBox.getSubsidiariesRefreshAt();

    if (_shouldRefresh(lastFetchedAt)) {
      final refreshAt = DateTime.now();

      // fetch nearby first
      if (query.northeast != null && query.southwest != null) {
        yield await _api.getNearbySubsidiaries(
          northeast: query.northeast!,
          southwest: query.southwest!,
        );
      }

      final all = await _api.getNearbySubsidiaries(
        northeast: const LatLng(47, 20),
        southwest: const LatLng(41, 12),
      );
      await _box.save(all);

      // mark fetched
      await _appBox.saveSubsidiariesRefreshAt(refreshAt);
    }
  }
}

bool _shouldRefresh(DateTime? lastFetchedAt) {
  if (lastFetchedAt == null) return true;

  final lastFetchedMin = lastFetchedAt.minute;
  final currentMin = DateTime.now().minute;

  // check if they're in the same fraction of the hour (0, 15, 30, 45)
  return lastFetchedMin ~/ 15 != currentMin ~/ 15;
}
