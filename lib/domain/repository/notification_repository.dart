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
      await PushNotificationService.init();
      token = await PushNotificationService.getToken(
        vapidKey: Env.vapidKey,
      ).timeout(
        const Duration(seconds: 5),
      );
    }
    if (token == null) {
      return;
    }
    await _notificationsApi.subscribeToNotifications(
      email: email,
      pushToken: token,
      coords: coords,
    );
  }
}
