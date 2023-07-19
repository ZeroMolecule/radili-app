import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/util/debouncer.dart';

Debouncer useDebouncer({
  Duration debounceTime = const Duration(seconds: 1),
  List<Object?>? keys,
}) {
  return use(_DebouncerHook(
    debounceTime: debounceTime,
    keys: keys,
  ));
}

class _DebouncerHook extends Hook<Debouncer> {
  final Duration debounceTime;

  const _DebouncerHook({
    required this.debounceTime,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<Debouncer, _DebouncerHook> createState() {
    return _DebouncerHookState();
  }
}

class _DebouncerHookState extends HookState<Debouncer, _DebouncerHook> {
  late Debouncer debouncer;

  @override
  void initHook() {
    super.initHook();
    debouncer = Debouncer(debounceTime: hook.debounceTime);
  }

  @override
  void dispose() {
    debouncer.dispose();
    super.dispose();
  }

  @override
  Debouncer build(BuildContext context) => debouncer;
}
