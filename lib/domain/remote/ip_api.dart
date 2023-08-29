import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:radili/domain/remote/strapi/strapi.dart';
import 'package:radili/domain/remote/strapi/strapi_response.dart';
import 'package:retrofit/http.dart';

part 'ip_api.g.dart';

@RestApi()
abstract class _IpApi {
  factory _IpApi(Dio dio) = __IpApi;

  @GET('/ip-location/lookup')
  Future<StrapiResponse> _getLocation();
}

class IpApi extends __IpApi {
  IpApi(Dio dio) : super(dio);

  Future<LatLng> getLocation() async {
    final response = await _getLocation();
    final json = Strapi.parseData(response.raw);
    return LatLng(json['lat'], json['lng']);
  }
}
