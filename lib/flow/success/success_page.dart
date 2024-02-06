import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/widgets/app_button.dart';

@RoutePage()
class SuccessPage extends HookWidget {
  final String title;
  final String description;
  final Widget image;

  const SuccessPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final t = useTranslations();
    final router = useRouter();
    final theme = useTheme();

    void handleClose() {
      router.pop();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: handleClose,
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.material.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                constraints: const BoxConstraints(maxHeight: 200),
                child: image,
              ),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
              AppButton(
                onPressed: handleClose,
                child: Text(t.ok),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
