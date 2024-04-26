import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/util/env.dart';

const uri = UriConverter();

class UriConverter extends JsonConverter<Uri?, String?> {
  const UriConverter();

  @override
  Uri? fromJson(String? json) {
    if (json == null) return null;

    final uri = Uri.tryParse(json);
    if (uri == null) return null;

    if (!uri.isAbsolute) {
      return Uri.parse(Env.apiUrl).resolve(uri.toString());
    }

    return uri;
  }

  @override
  String? toJson(Uri? object) {
    return object?.toString();
  }
}
