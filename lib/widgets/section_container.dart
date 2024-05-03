import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/theme_hook.dart';

class SectionContainer extends HookWidget {
  final Widget icon;
  final String label;
  final List<Widget> children;
  final Widget divider;

  const SectionContainer({
    super.key,
    required this.icon,
    required this.label,
    required this.children,
    this.divider = const Divider(height: 12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();

    return Container(
      decoration: BoxDecoration(
        color: theme.material.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: IconTheme(
                    data: const IconThemeData(opticalSize: 16),
                    child: icon,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          ...children
              .mapIndexed((index, e) => [
                    Padding(
                      padding: const EdgeInsets.only(left: 44, right: 16),
                      child: e,
                    ),
                    if (index < children.length - 1) divider,
                  ])
              .flattened,
        ],
      ),
    );
  }
}
