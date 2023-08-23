import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/theme_hook.dart';

void Function(String message) useShowSnackBar({
  bool clearPrevious = true,
  Color? backgroundColor,
}) {
  final context = useContext();
  final colorScheme = useTheme().material.colorScheme;
  backgroundColor ??= colorScheme.primary;

  final scaffoldMessenger = useMemoized(
    () => ScaffoldMessenger.of(context),
    [context],
  );

  return useCallback((String message) {
    if (clearPrevious) scaffoldMessenger.clearSnackBars();
    final sb = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    scaffoldMessenger.showSnackBar(sb);
  }, [scaffoldMessenger, clearPrevious, backgroundColor]);
}
