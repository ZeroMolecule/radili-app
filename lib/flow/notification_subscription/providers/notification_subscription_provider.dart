import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/notification_subscription.dart';
import 'package:radili/domain/repository/notification_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';

final notificationSubscriptionProvider = StateNotifierProvider.autoDispose<
    NotificationSubscriptionNotifier, AsyncValue<NotificationSubscription?>>(
  (ref) => NotificationSubscriptionNotifier(
    ref.read(notificationRepositoryProvider),
  ),
);

class NotificationSubscriptionNotifier
    extends StateNotifier<AsyncValue<NotificationSubscription?>> {
  final NotificationsRepository _repository;

  NotificationSubscriptionNotifier(
    this._repository,
  ) : super(const AsyncLoading()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = await AsyncValue.guard(_repository.getSubscription);
  }

  Stream<AsyncValue<NotificationSubscription?>> save({
    required bool isPushNotificationsSelected,
    required AddressInfo address,
    String? email,
  }) async* {
    yield state =
        const AsyncLoading<NotificationSubscription?>().copyWithPrevious(state);

    yield state = await AsyncValue.guard(() async {
      if (isPushNotificationsSelected || email != null) {
        return await _repository.createSubscription(
          isPushNotificationsSelected: isPushNotificationsSelected,
          email: email,
          address: address,
        );
      } else {
        await _repository.deleteSubscription();
        return null;
      }
    });
  }
}
