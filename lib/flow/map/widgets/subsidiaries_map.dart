import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/marker_cluster.dart';
import 'package:radili/flow/map/widgets/subsidiary_marker.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/supercluster_mutable_controller_hook.dart';

class SubsidiariesMap extends HookWidget {
  final List<Subsidiary> subsidiaries;
  final Function(LatLng position)? onPositionChanged;
  final LatLng? position;
  final double zoom;

  const SubsidiariesMap({
    Key? key,
    required this.subsidiaries,
    this.position,
    this.zoom = 16,
    this.onPositionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const markerSize = 45.0;
    const clusterSize = 50.0;

    final controller = useMapControllerAnimated();
    final clusterController = useSuperClusterMutableController();

    useEffect(() {
      if (position != null) {
        controller.animateTo(dest: position!, zoom: zoom);
      }
      return null;
    }, [position, controller, zoom]);

    useEffect(() {
      final markers = subsidiaries.map(
        (subsidiary) => Marker(
          point: subsidiary.coordinates,
          width: markerSize,
          height: markerSize,
          builder: (ctx) => SubsidiaryMarker(
            subsidiary: subsidiary,
            markerSize: markerSize,
          ),
        ),
      );
      clusterController.replaceAll(markers.toList());
      return null;
    }, [subsidiaries, clusterController]);

    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        maxZoom: 17,
        minZoom: 2,
        bounds: LatLngBounds(
          const LatLng(42.3649, 13.3836),
          const LatLng(46.5547, 19.4481),
        ),
        onPositionChanged: (position, _) {
          final latLng = position.center;
          if (latLng != null) {
            onPositionChanged?.call(latLng);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          // Subdomains for the tile layer
          retinaMode: kIsWeb,
          additionalOptions: const {'ext': 'svg'},
          tileDisplay: const TileDisplay.fadeIn(),
        ),
        SuperclusterLayer.mutable(
          controller: clusterController,
          clusterWidgetSize: const Size(clusterSize, clusterSize),
          indexBuilder: IndexBuilders.rootIsolate,
          calculateAggregatedClusterData: true,
          loadingOverlayBuilder: (_) => const SizedBox.shrink(),
          moveMap: (position, zoom) {
            controller.animateTo(dest: position, zoom: zoom);
          },
          builder: (_, __, markerCount, ___) => MarkerCluster(
            count: markerCount,
            size: clusterSize,
          ),
        ),
      ],
    );
  }
}