import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

T useProvider<T>(ProviderListenable<T> provider) {
  return use(_UseProviderHook(provider));
}

class _UseProviderHook<T> extends Hook<T> {
  final ProviderListenable<T> provider;

  const _UseProviderHook(this.provider);

  @override
  HookState<T, Hook<T>> createState() {
    return _UseProviderHookState<T>();
  }
}

class _UseProviderHookState<T> extends HookState<T, _UseProviderHook<T>> {
  late T _value = ProviderScope.containerOf(context).read(hook.provider);
  ProviderSubscription? _subscription;

  @override
  void initHook() {
    super.initHook();
    _subscription ??= ProviderScope.containerOf(context, listen: false).listen(
      hook.provider,
          (previous, next) {
        setState(() {
          _value = next;
        });
      },
    );
  }

  @override
  T build(BuildContext context) {
    return _value;
  }

  @override
  String get debugLabel => 'useProvider<$T>';

  @override
  void dispose() {
    _subscription?.close();
    _subscription = null;
    super.dispose();
  }
}