import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/util/env.dart';
import 'package:radili/util/notification_service.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;

  const NotificationsRepository(
    this._notificationsApi,
  );

  Future<void> subscribeToNotifications({
    String? email,
    required bool isPushNotificationsSelected,
    required bool isEmailNotificationsSelected,
    required LatLng coords,
  }) async {
    String? token;
    if (isPushNotificationsSelected) {
      final messaging = FirebaseMessaging.instance;
      token = await messaging.getToken(
        vapidKey: Env.vapidKey,
      );
      print('token: $token');
    }
    if (token == null) {
      return;
    }
    PushNotificationService.init();
    await _notificationsApi.subscribeToNotifications(
      email: email,
      pushToken: token,
      coords: coords,
    );
  }
}
