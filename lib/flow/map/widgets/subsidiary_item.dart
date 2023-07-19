import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/widgets/store_icon.dart';

class SubsidiaryItem extends HookWidget {
  final Subsidiary subsidiary;

  const SubsidiaryItem({
    Key? key,
    required this.subsidiary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = useTheme().material.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subsidiary.store.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: StoreIcon.subsidiary(subsidiary),
          ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  subsidiary.store.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                subsidiary.address ?? subsidiary.label ?? subsidiary.store.name,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
