import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class AnimatedMap extends InheritedWidget {
  final AnimatedMapController animatedMapController;

  const AnimatedMap({
    super.key,
    required this.animatedMapController,
    required super.child,
  });

  @override
  bool updateShouldNotify(AnimatedMap oldWidget) {
    return animatedMapController != oldWidget.animatedMapController;
  }

  static AnimatedMapController of(BuildContext context) {
    final AnimatedMap? result =
        context.dependOnInheritedWidgetOfExactType<AnimatedMap>();
    assert(result != null, 'No AnimatedMapProvider found in context');
    return result!.animatedMapController;
  }
}
