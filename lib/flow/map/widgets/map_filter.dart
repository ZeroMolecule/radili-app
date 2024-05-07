import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/providers/stores_provider.dart';
import 'package:radili/util/extensions/date_time_extensions.dart';
import 'package:radili/widgets/dropdown_picker.dart';

class MapFilter extends HookConsumerWidget {
  final List<Store>? stores;
  final int? day;

  final Function(List<Store>? stores) onStoresChanged;
  final Function(int? day) onDayChanged;

  const MapFilter({
    super.key,
    required this.stores,
    required this.day,
    required this.onStoresChanged,
    required this.onDayChanged,
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
      minHeight: breakpoints.isDesktop ? 48 : 42,
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
          DropdownPicker<int>(
            constraints: constraints,
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
            value: {if (day != null) day!},
            onChanged: (days) {
              onDayChanged(days?.firstOrNull);
            },
          ),
          DropdownPicker<Store>(
            constraints: constraints,
            icon: const Icon(Icons.store_outlined),
            label: t.map.filter.store,
            mode: DropdownPickerMode.multiple,
            areItemsEqual: (a, b) => a.id == b.id,
            items: stores.map(
              (store) => DropdownItem(
                value: store,
                label: store.name,
              ),
            ),
            value: {...?this.stores},
            onChanged: (stores) {
              onStoresChanged(stores?.toList());
            },
          ),
        ],
      ),
    );
  }
}
