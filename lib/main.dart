import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:radili/domain/local/app_database.dart';
import 'package:radili/firebase_options.dart';
import 'package:radili/generated/l10n.dart';
import 'package:radili/providers/di/di.dart';
import 'package:radili/providers/di/navigation_providers.dart';
import 'package:radili/providers/di/theme_providers.dart';
import 'package:radili/util/env.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  await _beforeRun();
  runApp(const ProviderScope(child: App()));
}

Future<void> _beforeRun() async {
  usePathUrlStrategy();

  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    AppDatabase.init(),
  ]);

  FirebaseAnalytics.instance.setConsent();
  Env.init();

  await injectDependencies();

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
      child: Portal(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}
