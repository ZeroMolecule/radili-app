import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:radili/util/env.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PushNotificationService {
  static late final PushNotificationService _instance =
      PushNotificationService._();

  factory PushNotificationService.instance() => _instance;

  PushNotificationService._();

  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    try {
      await PushNotificationService
          ._setForegroundNotificationPresentationOptions();
    } catch (e) {
      Sentry.captureException(e);
    }
  }

  static Future<void> _setForegroundNotificationPresentationOptions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken(vapidKey: Env.vapidKey);
  }
}
