import 'package:latlong2/latlong.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_state.g.dart';

@riverpod
class MapState extends _$MapState {
  @override
  MapStateData build() {
    return (
      position: ref.read(locationProvider).valueOrNull?.latLng,
      dirty: false,
    );
  }

  void setState({
    LatLng? position,
    bool? dirty,
  }) {
    state = (
      position: position ?? state.position,
      dirty: dirty ?? state.dirty,
    );
  }
}

typedef MapStateData = ({
  LatLng? position,
  bool dirty,
});
