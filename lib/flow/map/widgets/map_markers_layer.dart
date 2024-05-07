import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/providers/animated_map.dart';
import 'package:radili/flow/map/widgets/marker_cluster.dart';
import 'package:radili/flow/map/widgets/subsidiary_marker.dart';

class MapMarkersLayer extends HookWidget {
  final List<Subsidiary> subsidiaries;
  final LatLngBounds? cameraBounds;

  final Function(Subsidiary?) onSubsidiaryPressed;

  const MapMarkersLayer({
    super.key,
    required this.subsidiaries,
    required this.cameraBounds,
    required this.onSubsidiaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    const markerSize = 36.0;
    const clusterSize = 36.0;

    final animatedController = AnimatedMap.of(context);

    final markers = useMemoized(() {
      return subsidiaries
          .where((it) {
            final bounds = cameraBounds;
            return bounds == null || bounds.contains(it.coordinates);
          })
          .map(
            (subsidiary) => Marker(
              key: ValueKey(subsidiary),
              point: subsidiary.coordinates,
              width: markerSize,
              height: markerSize,
              child: SubsidiaryMarker(
                subsidiary: subsidiary,
                markerSize: markerSize,
              ),
            ),
          )
          .toList();
    }, [subsidiaries, cameraBounds]);

    final spiderfyCluster = useMemoized(
      () {
        final zoom = animatedController.mapController.camera.zoom;
        return zoom > 17;
      },
      [animatedController.mapController.camera.zoom],
    );

    void handleClusterTap(LatLng latLng) {
      final currentZoom = animatedController.mapController.camera.zoom;
      final zoom = min(currentZoom * 1.2, 18.0);
      animatedController.animateTo(dest: latLng, zoom: zoom);
    }

    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 50,
        size: const Size(clusterSize, clusterSize),
        alignment: Alignment.center,
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
        centerMarkerOnClick: false,
        onMarkerTap: (marker) {
          final key = marker.key;
          if (key is ValueKey<Subsidiary>) {
            onSubsidiaryPressed.call(key.value);
          }
        },
        onClusterTap: (node) {
          handleClusterTap(node.bounds.center);
        },
      ),
    );
  }
}
