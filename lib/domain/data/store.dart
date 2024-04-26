import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/converters/uri_converter.dart';
import 'package:radili/domain/data/remote_asset.dart';
import 'package:radili/domain/local/collections/store_collection.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    required int id,
    required String name,
    required String slug,
    required RemoteAsset? icon,
    required RemoteAsset? cover,
    required RemoteAsset? marker,
    @uri required Uri? catalogueUrl,
    required bool jelposkupiloSupported,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);

  factory Store.fromCollection(StoreCollection collection) => Store(
        id: collection.id,
        name: collection.name,
        slug: collection.slug,
        icon: collection.icon,
        cover: collection.cover,
        marker: collection.marker,
        catalogueUrl: collection.catalogueUrl != null &&
                collection.catalogueUrl!.isNotEmpty
            ? Uri.tryParse(collection.catalogueUrl!)
            : null,
        jelposkupiloSupported: collection.jelposkupiloSupported ?? false,
      );
}
