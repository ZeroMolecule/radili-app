import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/remote/interceptors/authorization_interceptor.dart';
import 'package:radili/domain/remote/nominatim_api.dart';
import 'package:radili/domain/remote/stores_api.dart';
import 'package:radili/util/env.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio()
    ..options = BaseOptions(baseUrl: Env.apiUrl)
    ..interceptors.add(AuthorizationInterceptor());
});

final nominatimDioProvider = Provider<Dio>((ref) {
  final dio = Dio()..options = BaseOptions(baseUrl: Env.nominatimApiUrl);
  return dio;
});

final nominatimApiProvider = Provider<NominatimApi>((ref) {
  return NominatimApi(ref.watch(nominatimDioProvider));
});

final storesApiProvider = Provider<StoresApi>((ref) {
  return StoresApi(ref.watch(dioProvider));
});
