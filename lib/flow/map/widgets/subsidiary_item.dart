import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/workhours_block.dart';
import 'package:radili/hooks/theme_hook.dart';

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
    final cover = subsidiary.store.cover?.largeOr;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cover != null)
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: CachedNetworkImage(imageUrl: cover.toString()),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      subsidiary.store.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    subsidiary.address ??
                        subsidiary.label ??
                        subsidiary.store.name,
                    style: textTheme.bodySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
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
