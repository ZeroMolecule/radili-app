import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/converters/uri_converter.dart' hide uri;

part 'remote_asset.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class RemoteAsset with _$RemoteAsset {
  const RemoteAsset._();

  const factory RemoteAsset({
    @JsonKey(name: 'url') required Uri uri,
    Uri? thumbnail,
    Uri? small,
    Uri? medium,
    Uri? large,
  }) = _RemoteAsset;

  factory RemoteAsset.fromJson(Map<String, dynamic> json) {
    return _RemoteAsset(
      uri: Uri.parse(json['url']),
      thumbnail: json['formats']?['thumbnail'] != null
          ? Uri.tryParse(json['formats']['thumbnail']['url'])
          : null,
      small: json['formats']?['small'] != null
          ? Uri.tryParse(json['formats']['small']['url'])
          : null,
      medium: json['formats']?['medium'] != null
          ? Uri.tryParse(json['formats']['medium']['url'])
          : null,
      large: json['formats']?['large'] != null
          ? Uri.tryParse(json['formats']['large']['url'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': uri.toString(),
      'formats': {
        'thumbnail': thumbnail != null ? {'url': thumbnail.toString()} : null,
        'small': small != null ? {'url': small.toString()} : null,
        'medium': medium != null ? {'url': medium.toString()} : null,
        'large': large != null ? {'url': large.toString()} : null,
      },
    };
  }

  Uri get thumbnailOr => thumbnail ?? this.uri;

  Uri get smallOr => small ?? this.uri;

  Uri get mediumOr => medium ?? this.uri;

  Uri get largeOr => large ?? this.uri;
}

Uri? _extractUri(
  dynamic value, [
  String? format,
]) {
  if (value is String) return const UriConverter().fromJson(value);
  if (value is Map) {
    if (format != null) {
      final uri = _extractUri(
        value['data'] ??
            value['attributes'] ??
            value['formats'] ??
            value[format] ??
            value['url'],
        format,
      );
      if (value['size'] == null) return null;
      return uri;
    }
    return _extractUri(value['url']);
  }
  return null;
}
