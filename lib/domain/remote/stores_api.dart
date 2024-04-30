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
  Future<StrapiResponse> _getStores();

  @GET('/subsidiaries/nearby')
  Future<StrapiResponse> _getNearbySubsidiaries({
    @Query('where') Map<String, dynamic>? where,
  });

  @GET('/subsidiaries/search')
  Future<StrapiResponse> _searchSubsidiaries({
    @Query('where') Map<String, dynamic>? where,
  });
}

class StoresApi extends __StoresApi {
  StoresApi(super.dio);

  Future<List<Store>> getStores() async {
    final response = await _getStores();
    return Strapi.parseList(response.raw, fromJson: Store.fromJson);
  }

  Future<List<Subsidiary>> getNearbySubsidiaries({
    required LatLng northeast,
    required LatLng southwest,
  }) async {
    final response = await _getNearbySubsidiaries(where: {
      'northeast': [northeast.latitude, northeast.longitude].join(','),
      'southwest': [southwest.latitude, southwest.longitude].join(','),
    });
    return Strapi.parseList(response.raw, fromJson: Subsidiary.fromJson);
  }

  Future<List<Subsidiary>> searchSubsidiaries(String query) async {
    final response = await _searchSubsidiaries(
      where: {
        'OR': [
          {
            'address': {'contains': query}
          },
          {
            'label': {'contains': query}
          },
        ]
      },
    );
    return Strapi.parseList(
      response.raw,
      fromJson: Subsidiary.fromJson,
    );
  }
}
