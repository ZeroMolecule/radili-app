import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  static Future<AsyncValue<T>> guard<T>(
    Future<T> Function() future, {
    AsyncValue<T>? previous,
    bool previousOnError = true,
    bool previousOnData = false,
  }) async {
    try {
      final result = await future();
      var data = AsyncData<T>(result);
      if (previous != null && previousOnData) {
        data = data.copyWithPrevious(previous);
      }
      return data;
    } catch (e, stack) {
      var error = AsyncError<T>(e, stack);
      if (previous != null && previousOnError) {
        error = error.copyWithPrevious(previous);
      }
      return error;
    }
  }
}
