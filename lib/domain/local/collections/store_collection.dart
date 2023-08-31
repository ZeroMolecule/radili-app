import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:radili/domain/data/remote_asset.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/local/app_hive.dart';

part 'store_collection.freezed.dart';
part 'store_collection.g.dart';

@Freezed(fromJson: false, toJson: false)
@HiveType(typeId: AppHive.storeTypeId)
class StoreCollection with _$StoreCollection {
  const StoreCollection._();

  const factory StoreCollection({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String slug,
    @HiveField(3) RemoteAsset? icon,
    @HiveField(4) RemoteAsset? cover,
    @HiveField(5) RemoteAsset? marker,
  }) = _StoreCollection;

  factory StoreCollection.fromStore(Store store) => StoreCollection(
        id: store.id,
        name: store.name,
        slug: store.slug,
        icon: store.icon,
        cover: store.cover,
        marker: store.marker,
      );
}
