import 'package:dio/dio.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/domain/remote/strapi/strapi.dart';
import 'package:radili/domain/remote/strapi/strapi_response.dart';
import 'package:radili/util/extensions/date_time_extensions.dart';
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

  Future<List<Subsidiary>> getNearbySubsidiaries(
    SubsidiariesQuery query,
  ) async {
    final response = await _getNearbySubsidiaries(where: {
      if (query.northeast != null)
        'northeast': [
          query.northeast!.latitude,
          query.northeast!.longitude,
        ].join(','),
      if (query.southwest != null)
        'southwest': [
          query.southwest!.latitude,
          query.southwest!.longitude,
        ].join(','),
      if (query.stores != null && query.stores!.isNotEmpty)
        'store': {
          'slug': {
            'in': {
              for (var i = 0; i < query.stores!.length; i++)
                i.toString(): query.stores![i].slug
            },
          }
        },
      if (query.day != null) 'workHours': dayKey(query.day!)
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
