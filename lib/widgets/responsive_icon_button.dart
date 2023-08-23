import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/hooks/color_scheme_hook.dart';

class ResponsiveIconButton extends HookWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const ResponsiveIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoints = useBreakpoints();
    final colors = useColorScheme();
    if (!breakpoints.isDesktop) {
      return IconButton(
        onPressed: onPressed,
        icon: icon,
        color: colors.primary,
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
    );
  }
}
