import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/widgets/loading.dart';

class AppButton extends HookWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isLoading) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Loading(
            constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
          ),
          const SizedBox(width: 8),
          this.child,
        ],
      );
    } else {
      child = this.child;
    }
    return ElevatedButton(
      style: style,
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}
