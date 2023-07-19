import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';

MapController useMapController() {
  return use(const _MapControllerHook());
}

class _MapControllerHook extends Hook<MapController> {
  const _MapControllerHook();

  @override
  HookState<MapController, Hook<MapController>> createState() {
    return _MapControllerHookState();
  }
}

class _MapControllerHookState
    extends HookState<MapController, _MapControllerHook> {
  late MapController _mapController;

  @override
  void initHook() {
    super.initHook();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  MapController build(BuildContext context) => _mapController;
}
