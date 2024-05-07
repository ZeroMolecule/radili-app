import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/local/app_box.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/providers/di/di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subsidiaries_query_provider.g.dart';

@riverpod
class SubsidiariesQueryState extends _$SubsidiariesQueryState {
  AppBox get _appBox => di.get();

  @override
  SubsidiariesQuery build() {
    final preferredStores = _appBox.getPreferredStoresSync();
    return SubsidiariesQuery(stores: preferredStores);
  }

  void setBounds(LatLng northeast, LatLng southwest) {
    state = state.copyWith(
      northeast: northeast,
      southwest: southwest,
    );
  }

  void setDay(int? day) {
    state = state.copyWith(day: day);
  }

  void setStores(List<Store>? stores) async {
    await _appBox.savePreferredStores(stores);
    state = state.copyWith(stores: stores);
  }
}
