import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

AsyncAction<T> useAsyncAction<T>({bool preserveFuture = false}) {
  final future = useState<Future<T>?>(null);
  final snapshot = useFuture(
    future.value,
    preserveState: preserveFuture,
  );

  return useMemoized(
    () => AsyncAction(future, snapshot),
    [future, snapshot],
  );
}

class AsyncAction<T> {
  final ValueNotifier<Future<T>?> future;
  final AsyncSnapshot<T> snapshot;

  AsyncAction(this.future, this.snapshot);

  void run(Future<T> Function() action) {
    future.value = action();
  }
}

extension AsyncSnapshotExtensions<T> on AsyncSnapshot<T> {
  bool get isDone => connectionState == ConnectionState.done;

  bool get isWaiting => connectionState == ConnectionState.waiting;

  bool get isSuccess => !hasError && isDone;
}
