import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/marker_cluster.dart';
import 'package:radili/flow/map/widgets/subsidiary_marker.dart';
import 'package:radili/hooks/location_permission_enabled_hook.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/supercluster_mutable_controller_hook.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:rxdart/rxdart.dart';

class SubsidiariesMap extends HookConsumerWidget {
  final List<Subsidiary> subsidiaries;
  final Function(LatLng position)? onPositionChanged;
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

    final locationNotifier = ref.watch(locationProvider.notifier);
    final controller = useMapControllerAnimated();
    final clusterController = useSuperClusterMutableController();
    final onSubsidiaryPressedRef = useRef(onSubsidiaryPressed)
      ..value = onSubsidiaryPressed;

    final isLocationPermissionEnabled = useIsLocationPermissionEnabled();

    final currentLocationLayer = useMemoized(() {
      final locationStream = locationNotifier.stream
          .map((event) => event.valueOrNull)
          .whereNotNull()
          .distinct();

      final headingStream = locationStream.map(
        (location) => LocationMarkerHeading(
          heading: location.heading,
          accuracy: location.accuracy,
        ),
      );

      final positionStream = locationStream.map(
        (location) => LocationMarkerPosition(
          latitude: location.latitude,
          longitude: location.longitude,
          accuracy: location.accuracy,
        ),
      );

      return CurrentLocationLayer(
        positionStream: positionStream,
        headingStream: headingStream,
      );
    }, [locationNotifier.stream]);

    useEffect(() {
      if (position != null) {
        controller.animateTo(dest: position!);
      }
      return null;
    }, [position, controller, zoom]);

    final markers = useMemoized(() {
      return subsidiaries
          .map(
            (subsidiary) => Marker(
              point: subsidiary.coordinates,
              width: markerSize,
              height: markerSize,
              builder: (ctx) => SubsidiaryMarker(
                subsidiary: subsidiary,
                markerSize: markerSize,
                onMarkerPressed: (subsidiary) =>
                    onSubsidiaryPressedRef.value?.call(subsidiary),
              ),
            ),
          )
          .toList();
    }, [subsidiaries]);

    useValueChanged<List<Marker>, void>(markers, (oldMarkers, _) {
      final added = markers.where((marker) => !oldMarkers.contains(marker));
      final removed = oldMarkers.where((marker) => !markers.contains(marker));
      for (final marker in added) {
        clusterController.add(marker);
      }
      for (final marker in removed) {
        clusterController.remove(marker);
      }
    });

    useEffect(() {
      locationNotifier.watch();
      return locationNotifier.stopWatching;
    }, [locationNotifier, isLocationPermissionEnabled]);

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
        onTap: (_, __) => onSubsidiaryPressedRef.value?.call(null),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          // Subdomains for the tile layer
          retinaMode: kIsWeb,
          additionalOptions: const {'ext': 'svg'},
          tileDisplay: const TileDisplay.instantaneous(),
        ),
        currentLocationLayer,
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
