import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Controller useController<Controller>(
  Controller Function() init,
  Function(Controller) dispose,
) {
  return use(_ControllerHook(init, dispose));
}

class _ControllerHook<Controller> extends Hook<Controller> {
  final Controller Function() init;
  final Function(Controller) dispose;

  const _ControllerHook(this.init, this.dispose);

  @override
  _ControllerHookState<Controller> createState() =>
      _ControllerHookState<Controller>();
}

class _ControllerHookState<Controller>
    extends HookState<Controller, _ControllerHook<Controller>> {
  late Controller controller;

  @override
  void initHook() {
    super.initHook();
    controller = hook.init();
  }

  @override
  void dispose() {
    hook.dispose(controller);
    super.dispose();
  }

  @override
  Controller build(BuildContext context) {
    return controller;
  }
}
