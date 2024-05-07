import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:overflow_view/overflow_view.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/theme/app_theme.dart';
import 'package:radili/widgets/app_card.dart';

class DropdownPicker<T> extends HookWidget {
  final Widget icon;
  final String label;

  final Iterable<DropdownItem<T>> items;
  final Set<T>? value;

  final ValueChanged<Set<T>?> onChanged;
  final DropdownPickerMode mode;
  final BoxConstraints constraints;

  const DropdownPicker({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.mode,
    this.constraints = const BoxConstraints(minWidth: 200, minHeight: 36),
  });

  @override
  Widget build(BuildContext context) {
    final visible = useState(false);

    void handleChanged(Set<T>? value) {
      if (mode == DropdownPickerMode.single) {
        visible.value = false;
      }
      onChanged(value);
    }

    return PortalTarget(
      visible: visible.value,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => visible.value = false,
      ),
      child: PortalTarget(
        visible: visible.value,
        anchor: const Aligned(
          follower: Alignment.topLeft,
          target: Alignment.bottomLeft,
          widthFactor: 1,
        ),
        portalFollower: _Dropdown(
          value: value,
          items: items,
          mode: mode,
          onChanged: handleChanged,
        ),
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: _Button(
            icon: icon,
            label: label,
            constraints: constraints,
            value: value,
            items: items,
            mode: mode,
            onPressed: () => visible.value = !visible.value,
            visible: visible.value,
          ),
        ),
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;

  const DropdownItem({
    required this.value,
    required this.label,
  });
}

enum DropdownPickerMode {
  single,
  multiple,
}

class _Button<T> extends HookWidget {
  final Widget icon;
  final String label;

  final DropdownPickerMode mode;
  final Iterable<DropdownItem<T>> items;
  final Set<T>? value;
  final Function() onPressed;
  final BoxConstraints constraints;
  final bool visible;

  const _Button({
    super.key,
    required this.value,
    required this.items,
    required this.mode,
    required this.onPressed,
    required this.constraints,
    required this.icon,
    required this.label,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();

    final content = (value ?? <T>{})
        .map((e) => items.firstWhereOrNull((it) => it.value == e))
        .whereNotNull()
        .map((item) {
      if (mode == DropdownPickerMode.single) return Text(item.label);

      return Container(
        decoration: BoxDecoration(
          color: theme.material.colorScheme.primary.withOpacity(.12),
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 12,
              color: theme.material.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              item.label,
              style: TextStyle(
                color: theme.material.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }).toList();

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // Start the animation when the visible value changes
    useEffect(() {
      if (visible) {
        controller.animateTo(0.5);
      } else {
        controller.reverse();
      }
      return null;
    }, [visible]);

    return AppCard(
      child: ConstrainedBox(
        constraints: constraints,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: 12,
                    color: theme.material.colorScheme.primary,
                  ),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: theme.material.colorScheme.primary.withOpacity(
                        .12,
                      ),
                    ),
                    child: icon,
                  ),
                ),
                const SizedBox(width: 12),
                if (content.isEmpty)
                  Expanded(
                    child: Text(label),
                  ),
                if (content.isNotEmpty)
                  Expanded(
                    child: OverflowView.flexible(
                      direction: Axis.horizontal,
                      spacing: 4,
                      children: content,
                      builder: (context, count) => Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: theme.material.colorScheme.primary.withOpacity(
                            .12,
                          ),
                        ),
                        child: Text(
                          '+$count',
                          style: TextStyle(
                            color: theme.material.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                RotationTransition(
                  turns: controller,
                  child: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dropdown<T> extends HookWidget {
  final DropdownPickerMode mode;
  final Iterable<DropdownItem<T>> items;
  final Set<T>? value;
  final ValueChanged<Set<T>?> onChanged;

  const _Dropdown({
    super.key,
    required this.value,
    required this.items,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(top: 8),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) {
              final item = items.elementAt(index);
              return _Item(
                value: item,
                selection: value,
                mode: mode,
                onPressed: (selected) {
                  if (mode == DropdownPickerMode.multiple) {
                    onChanged(selected
                        ? value?.union({item.value})
                        : value?.difference({item.value}));
                  } else {
                    onChanged(selected ? {item.value} : null);
                  }
                },
              );
            },
            itemCount: items.length,
          ),
        ],
      ),
    );
  }
}

class _Item<T> extends HookWidget {
  final DropdownPickerMode mode;
  final DropdownItem<T> value;
  final Set<T>? selection;
  final Function(bool selected) onPressed;

  const _Item({
    super.key,
    required this.value,
    required this.selection,
    required this.mode,
    required this.onPressed,
  });

  bool get isSelected => selection?.contains(value.value) ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();

    return ListTile(
      selectedTileColor: isSelected
          ? theme.material.colorScheme.primary.withOpacity(.12)
          : null,
      selected: isSelected,
      titleTextStyle: TextStyle(
        color: mode == DropdownPickerMode.single && isSelected
            ? theme.material.colorScheme.primary
            : AppColors.doveGrey,
      ),
      visualDensity: VisualDensity.compact,
      dense: true,
      leading: _buildLeading(),
      trailing: _buildTrailing(theme),
      title: Text(value.label),
      onTap: () {
        final selected = selection?.contains(value.value) ?? false;
        onPressed(!selected);
      },
    );
  }

  Widget? _buildLeading() {
    if (mode == DropdownPickerMode.single) return null;

    return SizedBox(
      width: 14,
      height: 14,
      child: Checkbox(
        visualDensity: VisualDensity.compact,
        value: isSelected,
        onChanged: (value) {
          if (value != null) onPressed(value);
        },
        side: const BorderSide(color: AppColors.doveGrey, width: 1),
      ),
    );
  }

  Widget? _buildTrailing(AppTheme theme) {
    if (!isSelected || mode == DropdownPickerMode.multiple) return null;

    return Icon(
      size: 14,
      Icons.check,
      color: theme.material.colorScheme.primary,
    );
  }
}
