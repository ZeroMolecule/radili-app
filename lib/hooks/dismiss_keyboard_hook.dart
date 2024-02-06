import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void Function() useDismissKeyboard() {
  final context = useContext();
  final scope = FocusScope.of(context);

  return useCallback(() {
    dismissKeyboard(context);
  }, [scope, context]);
}

void dismissKeyboard(BuildContext context) {
  final scope = FocusScope.of(context);
  scope.unfocus();
}
