import 'package:latlong2/latlong.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/util/notification_service.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;

  const NotificationsRepository(
    this._notificationsApi,
  );

  Future<void> subscribeToNotifications({
    String? email,
    required bool isPushNotificationsSelected,
    required LatLng coords,
  }) async {
    String? token;
    if (isPushNotificationsSelected) {
      await PushNotificationService.init();
      token = await PushNotificationService.getToken().timeout(
        const Duration(seconds: 5),
      );
    }
    await _notificationsApi.subscribeToNotifications(
      email: email,
      pushToken: token,
      coords: coords,
    );
  }
}
