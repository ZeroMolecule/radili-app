import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/repository/notification_repository.dart';
import 'package:radili/providers/di/repository_providers.dart';

final notificationSettingsProvider =
    StateNotifierProvider.autoDispose<NotificationSettingsNotifier, void>(
  (ref) => NotificationSettingsNotifier(
    ref.read(notificationRepositoryProvider),
  ),
);

class NotificationSettingsNotifier extends StateNotifier<void> {
  final NotificationsRepository _repository;
  NotificationSettingsNotifier(
    this._repository,
  ) : super(null);

  Future<void> saveSettings({
    required bool isEmailNotificationsSelected,
    required bool isPushNotificationsSelected,
    required LatLng coords,
    String? email,
  }) async {
    await _repository.subscribeToNotifications(
      isEmailNotificationsSelected: isEmailNotificationsSelected,
      isPushNotificationsSelected: isPushNotificationsSelected,
      email: email,
      coords: coords,
    );
  }
}
