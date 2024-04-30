import 'package:radili/domain/repository/notification_repository.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/domain/repository/subsidiaries_repository.dart';
import 'package:radili/domain/repository/support_repository.dart';
import 'package:radili/providers/di/di.dart';

void injectRepositories() {
  di.registerSingleton(StoresRepository(
    di.get(),
    di.get(),
    di.get(),
  ));

  di.registerSingleton(SubsidiariesRepository(
    di.get(),
    di.get(),
    di.get(),
  ));

  di.registerSingleton(NotificationsRepository(
    di.get(),
    di.get(),
  ));

  di.registerSingleton(SupportRepository(di.get()));
}
