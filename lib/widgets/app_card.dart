import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/theme_hook.dart';

class AppCard extends HookWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final double elevation;

  final Widget child;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.borderRadius,
    this.padding,
    this.elevation = 0,
    this.shadow,
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
        boxShadow: shadow ?? [theme.shadow],
      ),
      child: Material(
        color: color ?? theme.material.colorScheme.surface,
        elevation: elevation,
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        shadowColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
