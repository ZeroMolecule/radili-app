import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useOnValueChanged<T>(
  T value,
  void Function() onListen, {
  bool postFrame = true,
}) {
  useValueChanged<T, void>(
    value,
    (_, __) {
      if (postFrame) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onListen();
        });
      } else {
        onListen();
      }
    },
  );
}
