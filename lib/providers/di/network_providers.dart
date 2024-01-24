import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/remote/interceptors/authorization_interceptor.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/domain/remote/notifications_api.dart';
import 'package:radili/domain/remote/stores_api.dart';
import 'package:radili/util/env.dart';

final _dioProvider = Provider<Dio>((ref) {
  return Dio()
    ..options = BaseOptions(baseUrl: Env.apiUrl)
    ..interceptors.add(AuthorizationInterceptor());
});

final _nominatimDioProvider = Provider<Dio>((ref) {
  final dio = Dio()..options = BaseOptions(baseUrl: Env.nominatimApiUrl);
  return dio;
});

final nominatimApiProvider = Provider<NominatimApi>((ref) {
  return NominatimApi(ref.watch(_nominatimDioProvider));
});

final storesApiProvider = Provider<StoresApi>((ref) {
  return StoresApi(ref.watch(_dioProvider));
});

final notificationsApiProvider = Provider<NotificationsApi>((ref) {
  return NotificationsApi(ref.watch(_dioProvider));
});
