import 'package:dio/dio.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/util/errors/form_error.dart';

class ErrorParser {
  final AppTranslations _translations;

  ErrorParser(this._translations);

  String parse(Object? error) {
    try {
      if (error is DioException) {
        return error.response?.data?['error']?['message'] ?? error.message;
      }
      if (error is String) {
        return error;
      }
      if (error is FormError) {
        return error.message;
      }
    } catch (e) {
      // something went wrong with parsing the error
    }
    return _translations.common.error;
  }
}
