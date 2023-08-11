import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:radili/domain/app_shared_preferences.dart';
import 'package:radili/domain/data/notification_settings.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/util/notification_service.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;
  final AppSharedPreferences _sharedPreferences;

  const NotificationsRepository(
    this._notificationsApi,
    this._sharedPreferences,
  );

  Future<NotificationSettings> subscribeToNotifications({
    int? id,
    String? email,
    required bool isPushNotificationsSelected,
    required LatLng coords,
    String? address,
  }) async {
    String? token;
    if (isPushNotificationsSelected) {
      await PushNotificationService.init();
      token = await PushNotificationService.getToken().timeout(
        const Duration(seconds: 5),
      );
    }
    final settings = await _notificationsApi.subscribeToNotifications(
      email: email,
      id: id,
      pushToken: token,
      coords: coords,
      address: address,
    );

    await _sharedPreferences.setUserSubscriptionSettings(
      jsonEncode(settings),
    );

    return settings;
  }

  Future<void> deleteNotificationSubscription(int id) async {
    await _notificationsApi.deleteNotificationSubscription(id);
    await _sharedPreferences.setUserSubscriptionSettings(null);
  }

  Future<NotificationSettings?> getNotificationSubscriptions({
    String? email,
    String? pushToken,
    String? id,
  }) async {
    final settings = await _notificationsApi.getNotificationSubscriptions(
      email: email,
      pushToken: pushToken,
      id: id,
    );

    await _sharedPreferences.setUserSubscriptionSettings(
      jsonEncode(settings),
    );

    return settings;
  }
}
