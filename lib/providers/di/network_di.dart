import 'package:dio/dio.dart';
import 'package:radili/domain/remote/interceptors/authorization_interceptor.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/domain/remote/stores_api.dart';
import 'package:radili/domain/remote/support_api.dart';
import 'package:radili/providers/di/di.dart';
import 'package:radili/util/env.dart';

void injectNetwork() {
  di.registerSingleton(
    Dio()
      ..options = BaseOptions(baseUrl: Env.apiUrl)
      ..interceptors.add(AuthorizationInterceptor()),
  );

  di.registerSingleton(
    Dio()..options = BaseOptions(baseUrl: Env.nominatimApiUrl),
    instanceName: 'nominatimDio',
  );

  di.registerSingleton(StoresApi(di.get()));
  di.registerSingleton(SupportApi(di.get()));
  di.registerSingleton(NotificationsApi(di.get()));

  di.registerSingleton(NominatimApi(di.get(instanceName: 'nominatimDio')));
}
