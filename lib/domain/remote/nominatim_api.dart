import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:retrofit/http.dart';

part 'nominatim_api.g.dart';

@RestApi()
abstract class _NominatimApi {
  factory _NominatimApi(Dio dio) = __NominatimApi;

  @GET('/search')
  Future<List<AddressInfo>> _search({
    @Query('street') required String address,
    @Query('format') String format = 'json',
    @Query('country') String countryCodes = 'HR',
  });

  @GET('/reverse')
  Future<AddressInfo?> _reverse({
    @Query('format') String format = 'json',
    @Query('country') String countryCodes = 'HR',
    @Query('lat') required double lat,
    @Query('lon') required double lon,
  });
}

class NominatimApi extends __NominatimApi {
  NominatimApi(Dio dio) : super(dio);

  Future<List<AddressInfo>> search({required String address}) {
    return _search(address: address);
  }

  Future<AddressInfo?> reverse({required LatLng position}) {
    return _reverse(lat: position.latitude, lon: position.longitude);
  }
}
