import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/theme_hook.dart';

class AppCard extends HookWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final BorderRadius? borderRadius;

  final Widget child;

  const AppCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? theme.material.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        boxShadow: [theme.shadow],
      ),
      child: Material(
        color: color ?? theme.material.colorScheme.surface,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        child: child,
      ),
    );
  }
}
