import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/generated/i18n/translations.g.dart';

class SupportPrompt extends HookWidget {
  final Function() onSendPressed;

  const SupportPrompt({
    super.key,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.bleachedSilk,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.support.prompt.title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onSendPressed,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
