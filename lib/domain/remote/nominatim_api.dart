import 'dart:io';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_type.dart';
import 'package:radili/util/extensions/iterable_extensions.dart';
import 'package:retrofit/http.dart';

part 'nominatim_api.g.dart';

@RestApi()
abstract class _NominatimApi {
  factory _NominatimApi(Dio dio) = __NominatimApi;

  @GET('/search')
  Future<List<AddressInfo>> _search({
    @Query('q') required String query,
    @Query('format') String format = 'json',
    @Query('addressdetails') int addressDetails = 1,
    @Header(HttpHeaders.acceptLanguageHeader) String language = 'hr',
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

  Future<List<AddressInfo>> search({required String query}) async {
    final results = await _search(query: '$query,hrvatska');
    return results
        .distinctBy((it) => it.details)
        .where(
          (it) =>
              (it.type == AddressType.city &&
                  it.details.place.trim().isNotEmpty) ||
              (it.type == AddressType.other &&
                  it.details.combined(place: false).trim().isNotEmpty),
        )
        .toList();
  }

  Future<AddressInfo?> reverse({required LatLng position}) {
    return _reverse(lat: position.latitude, lon: position.longitude);
  }
}
