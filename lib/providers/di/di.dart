import 'package:get_it/get_it.dart';
import 'package:radili/providers/di/network_di.dart';
import 'package:radili/providers/di/repository_di.dart';
import 'package:radili/providers/di/service_di.dart';
import 'package:radili/providers/di/storage_di.dart';

final di = GetIt.instance;

Future<void> injectDependencies() async {
  await injectStorage();
  injectNetwork();
  injectServices();
  injectRepositories();
}
