import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/remote/strapi/strapi.dart';
import 'package:radili/domain/remote/strapi/strapi_response.dart';
import 'package:retrofit/http.dart';

part 'stores_api.g.dart';

@RestApi()
abstract class _StoresApi {
  factory _StoresApi(Dio dio) = __StoresApi;

  @GET('/stores')
  Future<StrapiResponse> _getStores({
    @Queries() Map<String, dynamic>? query,
  });

  @GET('/subsidiaries/nearby')
  Future<StrapiResponse> _getNearbySubsidiaries({
    @Queries() Map<String, dynamic>? query,
  });
}

class StoresApi extends __StoresApi {
  StoresApi(Dio dio) : super(dio);

  Future<List<Store>> getStores() async {
    final response = await _getStores(query: {'populate': '*'});
    return Strapi.parseList(response.raw, fromJson: Store.fromJson);
  }

  Future<List<Subsidiary>> getNearbySubsidiaries(LatLng latLng) async {
    final response = await _getNearbySubsidiaries(query: {
      'populate[store][populate][0]': 'icon',
      'populate[store][populate][1]': 'cover',
      'lat': latLng.latitude,
      'lng': latLng.longitude,
    });
    return Strapi.parseList(response.raw, fromJson: Subsidiary.fromJson);
  }
}
