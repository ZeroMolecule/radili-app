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

  @EnviedField(varName: 'IP_API_URL')
  static const String ipApiUrl = _Env.ipApiUrl;

  @EnviedField(varName: 'VAPID_KEY')
  static const String vapidKey = _Env.vapidKey;

  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: 'SENTRY_ENVIRONMENT')
  static const String sentryEnvironment = _Env.sentryEnvironment;

  static void init() {
    if (kDebugMode) {
      print('''
      STARTING APP
        API_KEY=$apiKey
        API_URL=$apiUrl
        NOMINATIM_API_URL=$nominatimApiUrl
        IP_API_URL=$ipApiUrl
        VAPID_KEY=$vapidKey
        SENTRY_DSN=$sentryDsn
        SENTRY_ENVIRONMENT=$sentryEnvironment
    ''');
    }
  }
}
