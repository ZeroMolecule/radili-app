import 'package:freezed_annotation/freezed_annotation.dart';

part 'strapi_response.freezed.dart';
part 'strapi_response.g.dart';

@freezed
class StrapiResponse with _$StrapiResponse {
  const factory StrapiResponse({
    required Map<String, Object?> raw,
  }) = _StrapiResponse;

  factory StrapiResponse.fromJson(Map<String, Object?> json) =>
      StrapiResponse(raw: json);
}
