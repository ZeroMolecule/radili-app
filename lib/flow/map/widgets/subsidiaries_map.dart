import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/marker_cluster.dart';
import 'package:radili/flow/map/widgets/subsidiary_marker.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/util/extensions/map_extensions.dart';

class SubsidiariesMap extends HookConsumerWidget {
  final List<Subsidiary> subsidiaries;
  final Function(
    LatLng center,
    LatLng northeast,
    LatLng southwest,
  )? onPositionChanged;
  final Function(Subsidiary?)? onSubsidiaryPressed;
  final LatLng? position;
  final Subsidiary? subsidiary;
  final double zoom;
  final List<Widget>? actions;
  final AnimatedMapController? controller;

  const SubsidiariesMap({
    Key? key,
    required this.subsidiaries,
    this.position,
    this.zoom = 16,
    this.onPositionChanged,
    this.onSubsidiaryPressed,
    this.subsidiary,
    this.actions,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const markerSize = 45.0;
    const clusterSize = 50.0;
    const clusterRadius = 90;

    final localController = useMapControllerAnimated();
    final controller = this.controller ?? localController;
    final cameraBounds = useState<LatLngBounds?>(null);
    final location = ref.watch(locationProvider);
    final isLoading = location.isLoading && !location.hasValue;

    useEffect(() {
      if (position != null && controller.isAttached) {
        controller.animateTo(dest: position!);
      }
      return null;
    }, [position, controller]);

    useEffect(() {
      final latLng = location.valueOrNull?.latLng;
      final mapController = controller.mapControllerOrNull;
      if (latLng != null && mapController != null) {
        mapController.move(latLng, 13);
      }
      return null;
    }, [location, controller]);

    final markers = useMemoized(() {
      return subsidiaries
          .where((it) {
            final bounds = cameraBounds.value;
            return bounds == null || bounds.contains(it.coordinates);
          })
          .map(
            (subsidiary) => Marker(
              key: ValueKey(subsidiary),
              point: subsidiary.coordinates,
              width: markerSize,
              height: markerSize,
              builder: (ctx) => SubsidiaryMarker(
                subsidiary: subsidiary,
                markerSize: markerSize,
              ),
            ),
          )
          .toList();
    }, [subsidiaries, cameraBounds.value]);

    final spiderfyCluster = useMemoized(
      () {
        final zoom = controller.mapControllerOrNull?.zoom;
        return zoom != null && zoom > 17;
      },
      [controller.mapControllerOrNull?.zoom],
    );

    void handleMove(
      LatLng latLng, {
      double? zoom,
      bool autoZoom = true,
      bool animate = true,
    }) {
      final mapController = controller.mapControllerOrNull;
      if (mapController != null) {
        final currentZoom = mapController.zoom;
        if (zoom == null && autoZoom) {
          zoom = min(currentZoom * 1.2, 18.0);
        }

        if (animate) {
          controller.animateTo(dest: latLng, zoom: zoom);
        } else {
          mapController.move(latLng, zoom ?? currentZoom);
        }
      }
    }

    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        minZoom: 8,
        maxZoom: 18,
        bounds: LatLngBounds(
          const LatLng(42.3649, 13.3836),
          const LatLng(46.5547, 19.4481),
        ),
        onPositionChanged: (position, _) {
          cameraBounds.value = position.bounds;
          final latLng = position.center;
          final bounds = position.bounds;
          if (latLng != null && bounds != null) {
            onPositionChanged?.call(latLng, bounds.northEast, bounds.southWest);
          }
        },
        enableMultiFingerGestureRace: true,
        onTap: (_, __) => onSubsidiaryPressed?.call(null),
        interactiveFlags: InteractiveFlag.pinchMove |
            InteractiveFlag.drag |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.doubleTapZoom |
            InteractiveFlag.flingAnimation,
      ),
      children: [
        if (!isLoading)
          TileLayer(
            urlTemplate:
                'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            tileDisplay: const TileDisplay.instantaneous(),
          ),
        if (!isLoading)
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: clusterRadius,
              size: const Size(clusterSize, clusterSize),
              anchorPos: AnchorPos.align(AnchorAlign.center),
              fitBoundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
                maxZoom: 15,
              ),
              animationsOptions: const AnimationsOptions(
                spiderfy: Duration(milliseconds: 0),
                centerMarker: Duration(milliseconds: 0),
                fitBound: Duration(milliseconds: 0),
                zoom: Duration(milliseconds: 0),
              ),
              markers: markers,
              spiderfyCluster: spiderfyCluster,
              builder: (_, markers) => MarkerCluster(
                count: markers.length,
                size: clusterSize,
              ),
              centerMarkerOnClick: true,
              onMarkerTap: (marker) {
                final key = marker.key;
                if (key is ValueKey<Subsidiary>) {
                  onSubsidiaryPressed?.call(key.value);
                }
              },
              onClusterTap: (node) {
                handleMove(node.bounds.center);
              },
            ),
          ),
        if (!isLoading && actions != null)
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 13),
            child: Wrap(runSpacing: 12, spacing: 12, children: actions!),
          ),
      ],
    );
  }
}
