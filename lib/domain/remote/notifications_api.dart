import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api.g.dart';

@RestApi()
abstract class _NotificationsApi {
  factory _NotificationsApi(Dio dio) = __NotificationsApi;

  @POST('/notification-subscriptions/upsert')
  Future<void> _subscribeToNotifications({
    @Body() required Map<String, dynamic> body,
  });
}

class NotificationsApi extends __NotificationsApi {
  NotificationsApi(Dio dio) : super(dio);

  Future<void> subscribeToNotifications({
    String? email,
    required String pushToken,
    required LatLng coords,
  }) async {
    await _subscribeToNotifications(
      body: {
        'data': {
          'email': email,
          'pushToken': pushToken,
          'coordinates': {
            'lat': coords.latitude,
            'lng': coords.longitude,
          },
        },
      },
    );
  }
}
