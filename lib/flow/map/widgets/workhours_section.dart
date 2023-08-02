import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';

class WorkHoursSection extends HookWidget {
  final WorkHours workHours;
  final bool isSelected;

  const WorkHoursSection({
    Key? key,
    required this.workHours,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? _ExpandedWorkHours(workHours: workHours)
        : _CollapsedWorkHours(workHours: workHours);
  }
}

class _CollapsedWorkHours extends HookWidget {
  final WorkHours workHours;

  const _CollapsedWorkHours({
    Key? key,
    required this.workHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = useTheme().material.textTheme;
    final t = useTranslations();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppColors.workingHoursBackground.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Text(
        workHours.getToday() ?? t.noDataForWorkHours,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.workingHoursText,
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
    Key? key,
    required this.workHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = useTheme().material.textTheme;
    final t = useTranslations();

    final workHoursByDay = useMemoized(() {
      return workHours.getMapped().entries.map<Widget>(
        (e) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  t.dayOfTheWeek(e.key),
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
          );
        },
      ).toList();
    }, [workHours, t, textTheme]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            t.workingHours,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...workHoursByDay],
          ),
        ),
      ],
    );
  }
}
