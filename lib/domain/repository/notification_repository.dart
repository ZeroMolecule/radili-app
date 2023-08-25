import 'package:latlong2/latlong.dart';
import 'package:radili/domain/app_shared_preferences.dart';
import 'package:radili/domain/data/notification_subscription.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/util/notification_service.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;
  final AppSharedPreferences _sharedPreferences;

  const NotificationsRepository(
    this._notificationsApi,
    this._sharedPreferences,
  );

  Future<NotificationSubscription> createSubscription({
    String? email,
    required bool isPushNotificationsSelected,
    required LatLng coordinates,
    String? address,
  }) async {
    String? token;
    if (isPushNotificationsSelected) {
      await PushNotificationService.init();
      token = await PushNotificationService.getToken().timeout(
        const Duration(seconds: 5),
      );
    }
    final stored = await _sharedPreferences.getNotificationSubscription();
    final subscription = await _notificationsApi.subscribeToNotifications(
      id: stored?.id,
      email: email,
      pushToken: token,
      coordinates: coordinates,
      address: address,
    );

    await _sharedPreferences.setNotificationSubscription(subscription);

    return subscription;
  }

  Future<void> deleteSubscription() async {
    final subscription = await _sharedPreferences.getNotificationSubscription();
    if (subscription != null) {
      await _notificationsApi.deleteNotificationSubscription(subscription.id);
      await _sharedPreferences.setNotificationSubscription(null);
    }
  }

  Future<NotificationSubscription?> getSubscription() async {
    final stored = await _sharedPreferences.getNotificationSubscription();
    if (stored == null) {
      return null;
    }
    final subscription = await _notificationsApi.getNotificationSubscriptions(
      email: stored.email,
      pushToken: stored.pushToken,
      id: stored.id.toString(),
    );

    await _sharedPreferences.setNotificationSubscription(subscription);

    return subscription;
  }
}
