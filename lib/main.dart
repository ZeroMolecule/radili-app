import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/firebase_options.dart';
import 'package:radili/generated/l10n.dart';
import 'package:radili/providers/di/navigation_providers.dart';
import 'package:radili/providers/di/theme_providers.dart';
import 'package:radili/util/env.dart';

void main() async {
  await _beforeRun();
  runApp(const ProviderScope(child: App()));
}

Future<void> _beforeRun() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Env.init();
  WidgetsFlutterBinding.ensureInitialized();
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeLight = ref.watch(themeLightProvider);
    final themeDark = ref.watch(themeDarkProvider);

    return MaterialApp.router(
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate(router),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        Translations.delegate,
      ],
      supportedLocales: Translations.delegate.supportedLocales,
      onGenerateTitle: (context) => Translations.of(context).appName,
      theme: themeLight.material,
      darkTheme: themeDark.material,
      themeMode: ThemeMode.light,
    );
  }
}
