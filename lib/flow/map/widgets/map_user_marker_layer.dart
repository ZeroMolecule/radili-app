import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:radili/hooks/location_stream_hook.dart';
import 'package:rxdart/rxdart.dart';

class MapUserMarkerLayer extends HookWidget {
  const MapUserMarkerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final locationStream = useLocationStream();
    final locationMarkerStream = useMemoized(() {
      return locationStream
          .where((it) => !it.isMock)
          // hack because current location layer has no binding check
          .delay(const Duration(milliseconds: 1))
          .map(
            (event) => LocationMarkerPosition(
              latitude: event.latitude,
              longitude: event.longitude,
              accuracy: event.accuracy,
            ),
          );
    }, [locationStream]);

    return CurrentLocationLayer(positionStream: locationMarkerStream);
  }
}
