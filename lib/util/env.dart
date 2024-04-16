import 'package:envied/envied.dart';
import 'package:flutter/foundation.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;

  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'NOMINATIM_API_URL')
  static const String nominatimApiUrl = _Env.nominatimApiUrl;

  @EnviedField(varName: 'VAPID_KEY')
  static const String vapidKey = _Env.vapidKey;

  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: 'SENTRY_ENVIRONMENT')
  static const String sentryEnvironment = _Env.sentryEnvironment;

  @EnviedField(varName: 'URL_SUPPORT_PAGE')
  static const String urlSupportPage = _Env.urlSupportPage;

  @EnviedField(varName: 'URL_PROJECT_PAGE')
  static const String urlProjectPage = _Env.urlProjectPage;

  static final Uri uriSupportPage = Uri.parse(urlSupportPage);

  static final Uri uriProjectPage = Uri.parse(urlProjectPage);

  static void init() {
    if (kDebugMode) {
      print('''
      STARTING APP
        API_KEY=$apiKey
        API_URL=$apiUrl
        NOMINATIM_API_URL=$nominatimApiUrl
        VAPID_KEY=$vapidKey
        SENTRY_DSN=$sentryDsn
        SENTRY_ENVIRONMENT=$sentryEnvironment
        URL_SUPPORT_PAGE=$urlSupportPage
        URL_PROJECT_PAGE=$urlProjectPage
    ''');
    }
  }
}
