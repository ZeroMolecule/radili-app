import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/providers/stores_provider.dart';
import 'package:radili/util/extensions/date_time_extensions.dart';
import 'package:radili/widgets/dropdown_picker.dart';

class MapFilter extends HookConsumerWidget {
  final SubsidiariesQuery query;
  final Function(SubsidiariesQuery query) onQueryChanged;

  const MapFilter({
    super.key,
    required this.query,
    required this.onQueryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppTranslations.of(context);
    final breakpoints = useBreakpoints();
    final screenWidth = MediaQuery.of(context).size.width;

    final storesState = ref.watch(storesProvider);
    final stores = storesState.valueOrNull ?? [];
    final days = useMemoized(() {
      final now = DateTime.now();
      final firstDay = now.subtract(Duration(days: now.weekday - 1));
      return List<DateTime>.generate(
        7,
        (i) => DateTime(
          firstDay.year,
          firstDay.month,
          firstDay.day + i,
        ),
      );
    });

    final constraints = BoxConstraints(
      maxWidth: breakpoints.isDesktop ? 260 : (screenWidth - 16 - 8) / 2,
      minWidth: breakpoints.isDesktop ? 0 : (screenWidth - 16 - 8) / 2,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          ConstrainedBox(
            constraints: constraints,
            child: DropdownPicker<int>(
              icon: const Icon(Icons.schedule_outlined),
              label: t.map.filter.day.label,
              mode: DropdownPickerMode.single,
              items: days.map(
                (day) => DropdownItem(
                  value: day.weekday,
                  label: t.map.filter.day.withDate(
                    day: t.enums.dayShort[day.weekday],
                    date: day.toFormattedString(),
                  ),
                ),
              ),
              value: {if (query.day != null) query.day!},
              onChanged: (stores) {
                onQueryChanged(query.copyWith(day: stores?.firstOrNull));
              },
            ),
          ),
          ConstrainedBox(
            constraints: constraints,
            child: DropdownPicker<Store>(
              icon: const Icon(Icons.store_outlined),
              label: t.map.filter.store,
              mode: DropdownPickerMode.multiple,
              items: stores.map(
                (store) => DropdownItem(
                  value: store,
                  label: store.name,
                ),
              ),
              value: query.stores?.toSet() ?? {},
              onChanged: (stores) {
                onQueryChanged(query.copyWith(stores: stores?.toList()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
