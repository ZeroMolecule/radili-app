import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void Function() useStreamCallback<T>(
  Stream<T> Function() cb, {
  Function(T value)? onListen,
}) {
  final subscription = useRef(CompositeSubscription());

  useEffect(() => subscription.value.dispose, [subscription]);

  return () {
    subscription.value.clear();
    final stream = cb();
    subscription.value.add(
      stream.listen((value) {
        onListen?.call(value);
      }),
    );
  };
}

void Function(A arg) useStreamCallbackArg<T, A>(
  Stream<T> Function(A arg) cb, {
  Function(T value)? onListen,
}) {
  final subscription = useRef(CompositeSubscription());

  useEffect(() => subscription.value.dispose, [subscription]);

  return (A arg) {
    subscription.value.clear();
    final stream = cb(arg);
    subscription.value.add(
      stream.listen((value) {
        onListen?.call(value);
      }),
    );
  };
}

void Function(Map args) useStreamCallbackArgs<T>(
  Stream<T> Function(Map args) cb, {
  Function(T value)? onListen,
}) {
  final subscription = useRef(CompositeSubscription());

  useEffect(() => subscription.value.dispose, [subscription]);

  return (Map args) {
    subscription.value.clear();
    final stream = cb(args);
    subscription.value.add(
      stream.listen((value) {
        onListen?.call(value);
      }),
    );
  };
}
