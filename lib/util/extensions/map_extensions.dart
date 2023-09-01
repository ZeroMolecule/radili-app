import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

extension AnimatedMapControllerExtensions on AnimatedMapController {
  bool get isAttached {
    try {
      // try to access properties of the controller
      return mapController.zoom >= 0.0;
    } catch (e) {
      return false;
    }
  }

  MapController? get mapControllerOrNull {
    if (isAttached) {
      return mapController;
    }
    return null;
  }
}
