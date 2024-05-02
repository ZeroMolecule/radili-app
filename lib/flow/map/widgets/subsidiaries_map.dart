import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/providers/animated_map.dart';
import 'package:radili/flow/map/widgets/map_markers_layer.dart';
import 'package:radili/flow/map/widgets/map_tile_layer.dart';
import 'package:radili/flow/map/widgets/map_user_marker_layer.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/on_value_changed_hook.dart';
import 'package:radili/providers/location_provider.dart';

class SubsidiariesMap extends HookConsumerWidget {
  final LatLng? position;
  final List<Subsidiary>? subsidiaries;
  final Function(LatLng northeast, LatLng southwest) onPositionChanged;
  final Function(Subsidiary?) onSubsidiaryPressed;

  const SubsidiariesMap({
    super.key,
    this.position,
    this.subsidiaries,
    required this.onPositionChanged,
    required this.onSubsidiaryPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMapControllerAnimated();
    final cameraBounds = useState<LatLngBounds?>(null);
    final location = ref.watch(locationProvider).valueOrNull;

    final subsidiaries = useValueChanged<List<Subsidiary>?, List<Subsidiary>?>(
      this.subsidiaries,
      (oldValue, oldResult) {
        if (this.subsidiaries == null && oldResult != null) {
          return oldResult;
        }
        return this.subsidiaries;
      },
    );

    void moveMapFocus(LatLng? coordinates, {double? zoom}) {
      if (coordinates != null) {
        controller.animateTo(dest: coordinates, zoom: zoom);
      }
    }

    useOnValueChanged(location?.latLng, () {
      moveMapFocus(location?.latLng);
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
          minZoom: 8,
          maxZoom: 18,
          initialCameraFit: CameraFit.insideBounds(
            bounds: LatLngBounds(
              const LatLng(42.3649, 13.3836),
              const LatLng(46.5547, 19.4481),
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
