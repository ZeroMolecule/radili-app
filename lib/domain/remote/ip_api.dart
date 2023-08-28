import 'package:dio/dio.dart';
import 'package:radili/domain/data/ip_info.dart';
import 'package:retrofit/http.dart';

part 'ip_api.g.dart';

@RestApi()
abstract class _IpApi {
  factory _IpApi(Dio dio) = __IpApi;

  @GET('/{ip}')
  Future<IpInfo> _getInfo({
    @Path('ip') required String ip,
    @Query('fields') String fields = 'lat,lon',
  });
}

class IpApi extends __IpApi {
  IpApi(Dio dio) : super(dio);

  Future<IpInfo> getInfo({required String ip}) {
    return _getInfo(ip: ip);
  }
}
