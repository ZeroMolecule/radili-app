import 'package:dio/dio.dart';
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
}

class NominatimApi extends __NominatimApi {
  NominatimApi(Dio dio) : super(dio);

  Future<List<AddressInfo>> search({required String address}) {
    return _search(address: address);
  }
}
