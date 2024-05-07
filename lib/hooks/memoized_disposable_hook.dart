import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

T useMemoizedDisposable<T>(
  T Function() valueBuilder,
  Function(T) dispose, [
  List<Object?> keys = const <Object>[],
]) {
  return use(_MemoizedDisposableHook<T>(valueBuilder, dispose, keys: keys));
}

class _MemoizedDisposableHook<T> extends Hook<T> {
  const _MemoizedDisposableHook(
    this.valueBuilder,
    this.dispose, {
    required List<Object?> keys,
  }) : super(keys: keys);

  final T Function() valueBuilder;
  final Function(T) dispose;

  @override
  _MemoizedDisposableHookState<T> createState() =>
      _MemoizedDisposableHookState<T>();
}

class _MemoizedDisposableHookState<T>
    extends HookState<T, _MemoizedDisposableHook<T>> {
  late final T value = hook.valueBuilder();

  @override
  T build(BuildContext context) => value;

  @override
  void dispose() {
    hook.dispose(value);
    super.dispose();
  }
}
