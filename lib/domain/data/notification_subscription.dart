import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/data/address_info.dart';

part 'notification_subscription.freezed.dart';
part 'notification_subscription.g.dart';

@freezed
class NotificationSubscription with _$NotificationSubscription {
  const NotificationSubscription._();

  const factory NotificationSubscription({
    required int id,
    required String? email,
    required String? pushToken,
    required AddressInfo address,
  }) = _NotificationSubscription;

  factory NotificationSubscription.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubscriptionFromJson(json);
}
