import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/notification_settings.dart';
import 'package:radili/domain/repository/notification_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';

final notificationSettingsProvider = StateNotifierProvider.autoDispose<
    NotificationSettingsNotifier, AsyncValue<NotificationSettings?>>(
  (ref) => NotificationSettingsNotifier(
    ref.read(notificationRepositoryProvider),
  ),
);

class NotificationSettingsNotifier
    extends StateNotifier<AsyncValue<NotificationSettings?>> {
  final NotificationsRepository _repository;
  NotificationSettingsNotifier(
    this._repository,
  ) : super(const AsyncLoading()) {
    getSettings();
  }

  Future<void> saveSettings({
    required bool isPushNotificationsSelected,
    required AddressInfo address,
    String? email,
    int? id,
  }) async {
    state = await AsyncValue.guard(
      () => _repository.subscribeToNotifications(
        id: id,
        isPushNotificationsSelected: isPushNotificationsSelected,
        email: email,
        coords: address.latLng,
        address: address.displayName,
      ),
    );
  }

  Future<void> deleteSubscription(int id) async {
    await _repository.deleteNotificationSubscription(id);
    state = const AsyncData(null);
  }

  Future<void> getSettings({
    String? email,
    String? pushToken,
    String? id,
  }) async {
    state = await AsyncValue.guard(
      () => _repository.getNotificationSubscriptions(
        email: email,
        pushToken: pushToken,
        id: id,
      ),
    );
  }
}
