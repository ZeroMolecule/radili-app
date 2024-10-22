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

  @EnviedField(varName: 'URL_DISCOUNTS_PAGE')
  static const String urlDiscountsPage = _Env.urlDiscountsPage;

  @EnviedField(varName: 'URL_BUG_REPORT_PAGE')
  static const String urlBugReportPage = _Env.urlBugReportPage;

  @EnviedField(varName: 'URL_IDEAS_PAGE')
  static const String urlIdeasPage = _Env.urlIdeasPage;

  static final Uri uriSupportPage = Uri.parse(urlSupportPage);

  static final Uri uriProjectPage = Uri.parse(urlProjectPage);

  static final Uri uriDiscountsPage = Uri.parse(urlDiscountsPage);

  static final Uri uriBugReportPage = Uri.parse(urlBugReportPage);

  static final Uri uriIdeasPage = Uri.parse(urlIdeasPage);

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
        URL_DISCOUNTS_PAGE=$urlDiscountsPage
        URL_BUG_REPORT_PAGE=$urlBugReportPage
        URL_IDEAS_PAGE=$urlIdeasPage
    ''');
    }
  }
}
