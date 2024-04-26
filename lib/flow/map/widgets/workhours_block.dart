import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/util/extensions/date_time_extensions.dart';

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
    final textTheme = useTheme().material.textTheme;
    final t = useTranslations();
    final colors = useColorScheme();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colors.primary.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Text(
        workHours.getForToday() ?? t.noDataForWorkHours,
        style: textTheme.bodySmall?.copyWith(
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
    final textTheme = useTheme().material.textTheme;
    final t = useTranslations();
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
                  t.dayOfTheWeek(dayKey(e.key)),
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  e.value ?? t.noDataForWorkHours,
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
