import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/widgets/app_card.dart';

class MapPopupMenu extends HookWidget {
  final Function() onProjectPagePressed;
  final Function() onBugReportPressed;
  final Function() onSuggestIdeasPressed;

  const MapPopupMenu({
    super.key,
    required this.onProjectPagePressed,
    required this.onBugReportPressed,
    required this.onSuggestIdeasPressed,
  });

  @override
  Widget build(BuildContext context) {
    final visible = useState(false);

    return PortalTarget(
      visible: visible.value,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => visible.value = false,
      ),
      child: PortalTarget(
        visible: visible.value,
        anchor: const Aligned(
          follower: Alignment.topRight,
          target: Alignment.bottomRight,
          widthFactor: 6,
        ),
        portalFollower: _Menu(
          onProjectPagePressed: () {
            visible.value = false;
            onProjectPagePressed();
          },
          onBugReportPressed: () {
            visible.value = false;
            onBugReportPressed();
          },
          onSuggestIdeasPressed: () {
            visible.value = false;
            onSuggestIdeasPressed();
          },
        ),
        child: AppCard(
          shadow: const [],
          borderRadius: BorderRadius.circular(2),
          child: InkWell(
            onTap: () => visible.value = !visible.value,
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.menu_rounded, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

class _Menu extends HookWidget {
  final Function() onProjectPagePressed;
  final Function() onBugReportPressed;
  final Function() onSuggestIdeasPressed;

  const _Menu({
    super.key,
    required this.onProjectPagePressed,
    required this.onBugReportPressed,
    required this.onSuggestIdeasPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuItem(
            icon: Icons.public_outlined,
            text: t.map.menu.about,
            onPressed: onProjectPagePressed,
          ),
          _MenuItem(
            icon: Icons.bug_report_outlined,
            text: t.map.menu.bugReport,
            onPressed: onBugReportPressed,
          ),
          _MenuItem(
            icon: Icons.lightbulb_outline,
            text: t.map.menu.suggestIdeas,
            onPressed: onSuggestIdeasPressed,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends HookWidget {
  final String text;
  final IconData? icon;
  final Function()? onPressed;

  const _MenuItem({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: onPressed,
      leading: icon != null ? Icon(icon, size: 18) : null,
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      horizontalTitleGap: 12,
      title: Text(text),
    );
  }
}
