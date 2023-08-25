import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:radili/domain/data/notification_subscription.dart';
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
  Future<void> deleteNotificationSubscription(@Path('id') int id);
}

class NotificationsApi extends __NotificationsApi {
  NotificationsApi(Dio dio) : super(dio);

  Future<NotificationSubscription> subscribeToNotifications({
    String? email,
    String? pushToken,
    String? address,
    int? id,
    required LatLng coordinates,
  }) async {
    final response = await _subscribeToNotifications(
      body: {
        'data': {
          'id': id,
          'email': email,
          'pushToken': pushToken,
          'address': address,
          'coordinates': {
            'lat': coordinates.latitude,
            'lng': coordinates.longitude,
          },
        },
      },
    );

    final settings = NotificationSubscription.fromJson(
      Strapi.parseData(response.raw),
    );

    return settings;
  }

  Future<NotificationSubscription?> getNotificationSubscriptions({
    String? email,
    String? pushToken,
    String? id,
  }) async {
    final response = await _getNotificationSubscriptions(
      email: email,
      pushToken: pushToken,
      id: id,
    );

    return NotificationSubscription.fromJson(
      Strapi.parseData(response.raw),
    );
  }
}
