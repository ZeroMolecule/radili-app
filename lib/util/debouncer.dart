import 'dart:async';

import 'package:rxdart/rxdart.dart';

class _Event {
  final FutureOr Function() primaryHandler;
  final Function(Object, StackTrace?)? errorHandler;

  _Event(this.primaryHandler, this.errorHandler);
}

class Debouncer {
  final Duration debounceTime;

  late final StreamSubscription _subscription;
  late final StreamController<_Event> _stream = StreamController.broadcast();
  Completer? _debounceCompleter;

  Debouncer({this.debounceTime = const Duration(seconds: 1)}) {
    _subscription = _stream.stream.debounceTime(debounceTime).listen(
      (event) async {
        try {
          await event.primaryHandler();
          if (_debounceCompleter?.isCompleted == false) {
            _debounceCompleter?.complete();

            _debounceCompleter = null;
          }
        } catch (error, stack) {
          if (_debounceCompleter?.isCompleted == false) {
            _debounceCompleter?.completeError(error, stack);
            _debounceCompleter = null;
          }
          if (event.errorHandler != null) {
            event.errorHandler!.call(error, stack);
          } else {
            rethrow;
          }
        }
      },
    );
  }

  void debounce(
    FutureOr Function() function, {
    Function(Object, StackTrace?)? onError,
  }) {
    _stream.add(_Event(function, onError));
  }

  Future<void> debounceAsync(
    Future Function() function, {
    Function(Object, StackTrace?)? onError,
  }) async {
    _debounceCompleter ??= Completer();
    debounce(function, onError: onError);
    await _debounceCompleter?.future;
  }

  Future<void> dispose() async {
    _subscription.cancel();
    if (_debounceCompleter?.isCompleted == false) {
      _debounceCompleter?.complete();
      _debounceCompleter = null;
    }
  }
}
