import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:radili/domain/local/app_hive.dart';
import 'package:radili/firebase_options.dart';
import 'package:radili/generated/l10n.dart';
import 'package:radili/providers/di/navigation_providers.dart';
import 'package:radili/providers/di/theme_providers.dart';
import 'package:radili/util/env.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.beforeSend = (SentryEvent event, {Hint? hint}) async {
        if (kDebugMode) {
          return null;
        }
        return event;
      };
    },
    appRunner: () async {
      await _beforeRun();
      runApp(const ProviderScope(child: App()));
    },
  );
}

Future<void> _beforeRun() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Env.init();
  await AppHive.init();
  FlutterNativeSplash.remove();
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeLight = ref.watch(themeLightProvider);
    final themeDark = ref.watch(themeDarkProvider);

    return PointerInterceptor(
      child: MaterialApp.router(
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
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 600, name: PHONE),
            const Breakpoint(start: 601, end: 900, name: TABLET),
            const Breakpoint(start: 901, end: double.infinity, name: DESKTOP),
          ],
        ),
      ),
    );
  }
}
