import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:radili/domain/data/notification_settings.dart';
import 'package:radili/domain/remote/strapi/strapi.dart';
import 'package:radili/domain/remote/strapi/strapi_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api.g.dart';

@RestApi()
abstract class _NotificationsApi {
  factory _NotificationsApi(Dio dio) = __NotificationsApi;

  @POST('/notification-subscriptions/upsert')
  Future<StrapiResponse> _subscribeToNotifications({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/notification-subscriptions/by')
  Future<StrapiResponse> _getNotificationSubscriptions({
    @Query('email') String? email,
    @Query('pushToken') String? pushToken,
    @Query('id') String? id,
  });

  @DELETE('/notification-subscriptions/{id}')
  Future<void> _deleteNotificationSubscription(@Path('id') int id);
}

class NotificationsApi extends __NotificationsApi {
  NotificationsApi(Dio dio) : super(dio);

  Future<NotificationSettings> subscribeToNotifications({
    String? email,
    String? pushToken,
    String? address,
    int? id,
    required LatLng coords,
  }) async {
    final response = await _subscribeToNotifications(
      body: {
        'data': {
          'id': id,
          'email': email,
          'pushToken': pushToken,
          'address': address,
          'coordinates': {
            'lat': coords.latitude,
            'lng': coords.longitude,
          },
        },
      },
    );

    final settings = NotificationSettings.fromJson(
      Strapi.parseData(response.raw),
    );

    return settings;
  }

  Future<void> deleteNotificationSubscription(int id) async {
    await _deleteNotificationSubscription(id);
  }

  Future<NotificationSettings?> getNotificationSubscriptions({
    String? email,
    String? pushToken,
    String? id,
  }) async {
    final response = await _getNotificationSubscriptions(
      email: email,
      pushToken: pushToken,
      id: id,
    );

    final notificationSettings = NotificationSettings.fromJson(
      Strapi.parseData(response.raw),
    );

    if (notificationSettings.coordinatesRaw == null) {
      return null;
    }

    return notificationSettings;
  }
}
