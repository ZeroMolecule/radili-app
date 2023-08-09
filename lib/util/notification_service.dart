import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static late final PushNotificationService _instance =
      PushNotificationService._();

  factory PushNotificationService.instance() => _instance;

  PushNotificationService._();

  static void init() async {
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
      await PushNotificationService.initFirebaseMessaging();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> initFirebaseMessaging() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
