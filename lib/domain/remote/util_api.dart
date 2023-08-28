import 'package:dio/dio.dart';
import 'package:radili/domain/remote/strapi/strapi_response.dart';
import 'package:retrofit/http.dart';

part 'util_api.g.dart';

@RestApi()
abstract class _UtilApi {
  factory _UtilApi(Dio dio) = __UtilApi;

  @GET('/util/my-ip')
  Future<StrapiResponse> _getMyIp();
}

class UtilApi extends __UtilApi {
  UtilApi(Dio dio) : super(dio);

  Future<String> getMyIp() async {
    final response = await _getMyIp();
    return response.raw['ip'] as String;
  }
}
