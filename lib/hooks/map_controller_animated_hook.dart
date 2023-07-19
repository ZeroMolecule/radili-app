import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:radili/hooks/controller_hook.dart';
import 'package:radili/hooks/ticker_provider_hook.dart';

AnimatedMapController useMapControllerAnimated({
  TickerProvider? vsync,
  Curve curve = Curves.fastOutSlowIn,
  Duration duration = const Duration(milliseconds: 500),
  MapController? mapController,
}) {
  final tickerProvider = useTickerProvider();
  return useController(
    () => AnimatedMapController(
      vsync: vsync ?? tickerProvider,
      curve: curve,
      duration: duration,
      mapController: mapController,
    ),
    (c) => c.dispose(),
  );
}
