import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'support_api.g.dart';

@RestApi()
abstract class _SupportApi {
  factory _SupportApi(Dio dio) = __SupportApi;

  @POST('/tickets')
  Future<void> _createTicket(@Body() Map<String, dynamic> body);
}

class SupportApi extends __SupportApi {
  SupportApi(super.dio);

  Future<void> createTicket({
    required String email,
    required String? name,
    required String summary,
    required String? subsidiaryId,
  }) async {
    await _createTicket({
      'data': {
        'reporterEmail': email,
        'reporterName': name,
        'summary': summary,
        'subsidiary': subsidiaryId,
      }
    });
  }
}
