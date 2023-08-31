import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/domain/local/app_hive.dart';
import 'package:radili/domain/local/collections/store_collection.dart';

part 'subsidiary_collection.freezed.dart';
part 'subsidiary_collection.g.dart';

@Freezed(fromJson: false, toJson: false)
@HiveType(typeId: AppHive.subsidiaryTypeId)
class SubsidiaryCollection with _$SubsidiaryCollection {
  const SubsidiaryCollection._();

  const factory SubsidiaryCollection({
    @HiveField(0) required int id,
    @HiveField(1) required String? label,
    @HiveField(2) required String? address,
    @HiveField(3) required bool isWorkingOnSunday,
    @HiveField(4) required StoreCollection store,
    @HiveField(5) required double lat,
    @HiveField(6) required double lng,
    @HiveField(7) required WorkHours workHours,
  }) = _SubsidiaryCollection;

  factory SubsidiaryCollection.fromSubsidiary(Subsidiary subsidiary) =>
      SubsidiaryCollection(
        id: subsidiary.id,
        label: subsidiary.label,
        address: subsidiary.address,
        isWorkingOnSunday: subsidiary.isWorkingOnSunday,
        store: StoreCollection.fromStore(subsidiary.store),
        lat: subsidiary.lat,
        lng: subsidiary.lng,
        workHours: subsidiary.workHours,
      );
}
