import 'dart:io';

import 'package:dio/dio.dart';
import 'package:radili/util/env.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      HttpHeaders.authorizationHeader: 'bearer ${Env.apiKey}',
    });

    return handler.next(options);
  }
}
