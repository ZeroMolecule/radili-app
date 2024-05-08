import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/converters/uri_converter.dart';
import 'package:radili/domain/data/remote_asset.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    required String id,
    required String name,
    required String slug,
    required RemoteAsset? icon,
    required RemoteAsset? cover,
    required RemoteAsset? marker,
    @uri required Uri? catalogueUrl,
    required bool jelposkupiloSupported,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
}
