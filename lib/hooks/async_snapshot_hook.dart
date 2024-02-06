import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/async_action_hook.dart';

void useAsyncSnapshot<T>(
  AsyncSnapshot<T> snapshot, {
  Function(T? data)? onSuccess,
  Function(Object? error)? onError,
  Function()? onWaiting,
  Function()? onAny,
}) {
  useValueChanged<AsyncSnapshot<T>, void>(snapshot, (old, _) {
    onAny?.call();
    Future.microtask(() {
      if (snapshot.isSuccess) {
        onSuccess?.call(snapshot.data);
      } else if (snapshot.isDone && snapshot.hasError) {
        onError?.call(snapshot.error);
      } else if (snapshot.isWaiting) {
        onWaiting?.call();
      }
    });
  });
}
