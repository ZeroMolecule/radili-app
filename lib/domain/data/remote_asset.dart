import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/converters/uri_converter.dart';

part 'remote_asset.freezed.dart';
part 'remote_asset.g.dart';

@Freezed(fromJson: false, toJson: true)
class RemoteAsset with _$RemoteAsset {
  const RemoteAsset._();

  const factory RemoteAsset({
    @UriConverter() @JsonKey(name: 'url') required Uri uri,
    @UriConverter() Uri? thumbnail,
    @UriConverter() Uri? small,
    @UriConverter() Uri? medium,
    @UriConverter() Uri? large,
  }) = _RemoteAsset;

  factory RemoteAsset.fromJson(Map<String, Object?> json) {
    return _RemoteAsset(
      uri: _extractUri(json)!,
      thumbnail: _extractUri(json, 'thumbnail'),
      small: _extractUri(json, 'small'),
      medium: _extractUri(json, 'medium'),
      large: _extractUri(json, 'large'),
    );
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
      return _extractUri(
        value['data'] ??
            value['attributes'] ??
            value['formats'] ??
            value[format] ??
            value['url'],
        format,
      );
    }
    return _extractUri(
      value['data'] ?? value['attributes'] ?? value['url'],
    );
  }
  return null;
}
