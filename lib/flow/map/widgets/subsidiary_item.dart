import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/workhours_block.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/widgets/store_icon.dart';

class SubsidiaryItem extends HookWidget {
  final Subsidiary subsidiary;
  final bool isSelected;

  const SubsidiaryItem({
    Key? key,
    required this.subsidiary,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = useTheme().material.textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subsidiary.store.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: StoreIcon.subsidiary(
                  subsidiary,
                  size: 24,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      subsidiary.store.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    subsidiary.address ??
                        subsidiary.label ??
                        subsidiary.store.name,
                    style: textTheme.bodySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: WorkHoursBlock(
                      workHours: subsidiary.workHours,
                      expanded: isSelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
