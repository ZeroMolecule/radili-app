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

  static void init() {
    if (kDebugMode) {
      print('''
      STARTING APP
        API_KEY=$apiKey
        API_URL=$apiUrl
        NOMINATIM_API_URL=$nominatimApiUrl
    ''');
    }
  }
}
