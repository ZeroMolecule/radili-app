import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/data/remote_asset.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    required int id,
    required String name,
    required String slug,
    RemoteAsset? icon,
    RemoteAsset? cover,
    RemoteAsset? marker,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
}
