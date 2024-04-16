import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/translations_hook.dart';

class MapPopupMenu extends HookWidget {
  final Function() onNotifyMePressed;
  final Function() onSupportPressed;
  final Function() onSubmitTicketPressed;
  final Function() onProjectPagePressed;

  final bool isNotifyMeEnabled;

  const MapPopupMenu({
    super.key,
    required this.onNotifyMePressed,
    required this.onSupportPressed,
    required this.onSubmitTicketPressed,
    required this.isNotifyMeEnabled,
    required this.onProjectPagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = useTranslations();

    void handleSelected(_Option option) {
      switch (option) {
        case _Option.notifyMe:
          onNotifyMePressed();
          break;
        case _Option.showSupport:
          onSupportPressed();
          break;
        case _Option.submitTicket:
          onSubmitTicketPressed();
          break;
        case _Option.projectPage:
          onProjectPagePressed();
      }
    }

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_outlined),
      onSelected: handleSelected,
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: _Option.showSupport,
          child: _PopupMenuItem(
            icon: Icons.launch_outlined,
            text: t.support,
          ),
        ),
        PopupMenuItem(
          value: _Option.submitTicket,
          child: _PopupMenuItem(
            icon: Icons.support_agent_outlined,
            text: t.supportTitle,
          ),
        ),
        PopupMenuItem(
          value: _Option.projectPage,
          child: _PopupMenuItem(
            icon: Icons.public_outlined,
            text: t.projectPage,
          ),
        ),
      ],
    );
  }
}

class _PopupMenuItem extends HookWidget {
  final String text;
  final IconData? icon;

  const _PopupMenuItem({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(icon),
          ),
      ],
    );
  }
}

enum _Option {
  notifyMe,
  showSupport,
  submitTicket,
  projectPage,
}
