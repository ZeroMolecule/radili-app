import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/marker_cluster.dart';
import 'package:radili/flow/map/widgets/subsidiary_marker.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/providers/location_provider.dart';

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

  const SubsidiariesMap({
    Key? key,
    required this.subsidiaries,
    this.position,
    this.zoom = 16,
    this.onPositionChanged,
    this.onSubsidiaryPressed,
    this.subsidiary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const markerSize = 45.0;
    const clusterSize = 50.0;

    final controller = useMapControllerAnimated();
    final location = ref.watch(locationProvider);

    useEffect(() {
      if (position != null) {
        controller.animateTo(dest: position!);
      }
      return null;
    }, [position, controller]);

    useEffect(() {
      if (location.valueOrNull != null) {
        controller.mapController.move(location.value!.latLng, 13);
      }
    }, [location, controller]);

    final markers = useMemoized(() {
      return subsidiaries
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
    }, [subsidiaries]);

    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        maxZoom: 17,
        minZoom: 8,
        bounds: LatLngBounds(
          const LatLng(42.3649, 13.3836),
          const LatLng(46.5547, 19.4481),
        ),
        onPositionChanged: (position, _) {
          final latLng = position.center;
          final bounds = position.bounds;
          if (latLng != null && bounds != null) {
            onPositionChanged?.call(latLng, bounds.northEast, bounds.southWest);
          }
        },
        onTap: (_, __) => onSubsidiaryPressed?.call(null),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          tileDisplay: const TileDisplay.instantaneous(),
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: clusterSize.round() * 3,
            size: const Size(clusterSize, clusterSize),
            anchorPos: AnchorPos.align(AnchorAlign.center),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(50),
              maxZoom: 15,
            ),
            markers: markers,
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
          ),
        ),
      ],
    );
  }
}
