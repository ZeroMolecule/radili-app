import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/repository/notification_repository.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/domain/repository/support_repository.dart';
import 'package:radili/providers/di/database_providers.dart';
import 'package:radili/providers/di/network_providers.dart';
import 'package:radili/providers/di/store_providers.dart';

final storesRepositoryProvider = Provider(
  (ref) => StoresRepository(
    ref.watch(nominatimApiProvider),
    ref.watch(storesApiProvider),
    ref.watch(subsidiariesBoxProvider),
  ),
);

final notificationRepositoryProvider = Provider(
  (ref) => NotificationsRepository(
    ref.watch(notificationsApiProvider),
    ref.read(sharedPreferencesProvider),
  ),
);

final supportRepositoryProvider = Provider(
  (ref) => SupportRepository(ref.watch(supportApiProvider)),
);
