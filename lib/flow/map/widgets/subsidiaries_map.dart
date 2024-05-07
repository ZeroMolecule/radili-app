import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/flow/map/providers/animated_map.dart';
import 'package:radili/flow/map/widgets/map_markers_layer.dart';
import 'package:radili/flow/map/widgets/map_tile_layer.dart';
import 'package:radili/flow/map/widgets/map_user_marker_layer.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/on_value_changed_hook.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/providers/subsidiaries_provider.dart';

class SubsidiariesMap extends HookConsumerWidget {
  final LatLng? position;
  final SubsidiariesQuery query;

  final Function(LatLng northeast, LatLng southwest) onPositionChanged;
  final Function(Subsidiary?) onSubsidiaryPressed;

  const SubsidiariesMap({
    super.key,
    this.position,
    required this.query,
    required this.onPositionChanged,
    required this.onSubsidiaryPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsidiariesState = ref.watch(subsidiariesProvider(query));
    final controller = useMapControllerAnimated();
    final cameraBounds = useState<LatLngBounds?>(null);
    final location = ref.watch(locationProvider).valueOrNull;

    final subsidiaries =
        useValueChanged<AsyncValue<List<Subsidiary>>, List<Subsidiary>?>(
      subsidiariesState,
      (_, oldResult) {
        if (subsidiariesState.isLoading) return oldResult;

        return subsidiariesState.valueOrNull;
      },
    );

    void moveMapFocus(LatLng? coordinates, {double? zoom}) {
      if (coordinates != null) {
        controller.animateTo(dest: coordinates, zoom: zoom);
      }
    }

    useOnValueChanged(location?.latLng, () {
      moveMapFocus(
        location?.latLng,
        zoom: controller.mapController.camera.zoom < 15 ? 15 : null,
      );
    });

    useOnValueChanged(position, () {
      moveMapFocus(
        position,
        zoom: controller.mapController.camera.zoom < 15 ? 15 : null,
      );
    });

    return AnimatedMap(
      animatedMapController: controller,
      child: FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          minZoom: 7,
          maxZoom: 18,
          initialCameraFit: CameraFit.insideBounds(
            bounds: LatLngBounds(
              const LatLng(46.639041, 23.63818),
              const LatLng(42.252754, 10.145589),
            ),
          ),
          onPositionChanged: (position, _) {
            final bounds = position.bounds;
            if (bounds != null) {
              onPositionChanged(
                bounds.northEast,
                bounds.southWest,
              );
            }
          },
          interactionOptions: const InteractionOptions(
            enableMultiFingerGestureRace: true,
            enableScrollWheel: true,
            flags: InteractiveFlag.pinchMove |
                InteractiveFlag.drag |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.flingAnimation,
          ),
          onTap: (_, __) => onSubsidiaryPressed(null),
        ),
        children: [
          const MapTileLayer(),
          const MapUserMarkerLayer(),
          if (subsidiaries != null)
            MapMarkersLayer(
              subsidiaries: subsidiaries,
              cameraBounds: cameraBounds.value,
              onSubsidiaryPressed: onSubsidiaryPressed,
            ),
        ],
      ),
    );
  }
}
