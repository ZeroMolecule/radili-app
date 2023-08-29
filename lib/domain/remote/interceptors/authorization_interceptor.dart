import 'dart:io';

import 'package:dio/dio.dart';
import 'package:radili/util/env.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.remove(HttpHeaders.userAgentHeader);
    options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer ${Env.apiKey}',
    });

    return handler.next(options);
  }
}
