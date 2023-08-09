import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> Function() useAsyncCallback<T>(
  Future<T> Function() callback, {
  List<Object?> keys = const [],
  Function()? onLoading,
  Function()? onDone,
  Function(T)? onData,
  Function(Object error)? onError,
  Function()? onElse,
  Function()? onEnd,
  Function()? onStart,
  Future Function()? whileCallback,
  ValueNotifier<AsyncValue<T>?>? stateValue,
  String? debugKey,
}) {
  final onLoadingRef = useRef(onLoading)..value = onLoading;
  final onDoneRef = useRef(onDone)..value = onDone;
  final onDataRef = useRef(onData)..value = onData;
  final onErrorRef = useRef(onError)..value = onError;
  final onElseRef = useRef(onElse)..value = onElse;
  final onEndRef = useRef(onEnd)..value = onEnd;
  final onStartRef = useRef(onStart)..value = onStart;
  final stateValueRef = useRef(stateValue)..value = stateValue;
  final whileCallbackRef = useRef(whileCallback)..value = whileCallback;

  return useMemoized(
    () => () async {
      await onStartRef.value?.call();

      /// loading
      if (debugKey != null) log('Action[$debugKey] loading');
      final onLoading = onLoadingRef.value ?? onElseRef.value;
      stateValueRef.value?.value = const AsyncValue.loading();
      onLoading?.call();

      try {
        /// execute
        whileCallbackRef.value?.call().ignore();
        final result = await callback();

        stateValueRef.value?.value = AsyncValue.data(result);

        /// data
        if (result is! Never) {
          onDataRef.value?.call(result);
        }

        /// done
        if (debugKey != null) log('Action[$debugKey] done');
        final onDone = onDoneRef.value ?? onElseRef.value;
        await onDone?.call();
      } catch (error, stackTrace) {
        /// error
        if (debugKey != null) {
          log('Action[$debugKey] error', error: error);
        }
        stateValueRef.value?.value = AsyncValue.error(error, stackTrace);
        if (onErrorRef.value != null) {
          await onErrorRef.value?.call(error);
        } else if (onElseRef.value != null) {
          await onElseRef.value?.call();
        }
      }
      await onEndRef.value?.call();
    },
    keys,
  );
}

Future<void> Function(A a) useAsyncCallbackArg<T, A>(
  Future<T> Function(A arg1) callback, {
  List<Object?> keys = const [],
  Function()? onLoading,
  Function()? onDone,
  Function(T)? onData,
  Function(Object error)? onError,
  Function()? onElse,
  Function()? onEnd,
  Function()? onStart,
  ValueNotifier<AsyncValue<T>?>? stateValue,
  String? debugKey,
}) {
  final onLoadingRef = useRef(onLoading)..value = onLoading;
  final onDoneRef = useRef(onDone)..value = onDone;
  final onDataRef = useRef(onData)..value = onData;
  final onErrorRef = useRef(onError)..value = onError;
  final onElseRef = useRef(onElse)..value = onElse;
  final onEndRef = useRef(onEnd)..value = onEnd;
  final onStartRef = useRef(onStart)..value = onStart;
  final stateValueRef = useRef(stateValue)..value = stateValue;

  return useMemoized(
    () => (A a) async {
      await onStartRef.value?.call();

      /// loading
      if (debugKey != null) log('Action[$debugKey] loading');
      final onLoading = onLoadingRef.value ?? onElseRef.value;
      onLoading?.call();
      stateValueRef.value?.value = const AsyncValue.loading();

      try {
        /// execute
        final result = await callback(a);

        /// data
        if (result is! Never) {
          onDataRef.value?.call(result);
        }

        stateValueRef.value?.value = AsyncValue.data(result);

        /// done
        if (debugKey != null) log('Action[$debugKey] done');
        final onDone = onDoneRef.value ?? onElseRef.value;
        onDone?.call();
      } catch (error, stackTrace) {
        /// error
        if (debugKey != null) {
          log('Action[$debugKey] error');
          log(error.toString());
        }
        stateValueRef.value?.value = AsyncValue.error(error, stackTrace);
        if (onErrorRef.value != null) {
          onErrorRef.value?.call(error);
        } else if (onElseRef.value != null) {
          onElseRef.value?.call();
        }
      }
      await onEndRef.value?.call();
    },
    keys,
  );
}

Future<void> Function(Map<String, dynamic> args) useAsyncCallbackArgs<T>(
  Future<T> Function(Map<String, dynamic> args) callback, {
  List<Object?> keys = const [],
  Function()? onLoading,
  Function()? onDone,
  Function()? onEnd,
  Function(T)? onData,
  Function(Object error)? onError,
  Function()? onElse,
  Function()? onStart,
  ValueNotifier<AsyncValue<T>?>? stateValue,
  String? debugKey,
}) {
  return useAsyncCallbackArg<T, Map<String, dynamic>>(
    callback,
    keys: keys,
    onLoading: onLoading,
    onDone: onDone,
    onData: onData,
    onError: onError,
    onElse: onElse,
    onEnd: onEnd,
    onStart: onStart,
    stateValue: stateValue,
    debugKey: debugKey,
  );
}
