import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/hooks/theme_hook.dart';

class WorkHoursBlock extends HookWidget {
  final WorkHours workHours;
  final bool expanded;

  const WorkHoursBlock({
    super.key,
    required this.workHours,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return expanded
        ? _ExpandedWorkHours(workHours: workHours)
        : _CollapsedWorkHours(workHours: workHours);
  }
}

class _CollapsedWorkHours extends HookWidget {
  final WorkHours workHours;

  const _CollapsedWorkHours({
    super.key,
    required this.workHours,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final theme = useTheme();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.material.colorScheme.primary.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Text(
        workHours.getForToday() ?? t.subsidiary.workHours.closed,
        style: theme.material.textTheme.bodySmall?.copyWith(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _ExpandedWorkHours extends HookWidget {
  final WorkHours workHours;

  const _ExpandedWorkHours({
    super.key,
    required this.workHours,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final textTheme = useTheme().material.textTheme;
    final currentWeekDay = DateTime.now().weekday;

    final workHoursByDay = useMemoized(() {
      return workHours.byDay().entries.map((e) {
        final BoxDecoration? decoration;
        if (currentWeekDay == e.key) {
          decoration = BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.backgroundGreen.withOpacity(0.2),
          );
        } else {
          decoration = null;
        }
        return Container(
          decoration: decoration,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  t.enums.day[e.key],
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  e.value ?? t.subsidiary.workHours.closed,
                  style: textTheme.bodySmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }, [workHours, t, textTheme, currentWeekDay]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workHoursByDay,
    );
  }
}
