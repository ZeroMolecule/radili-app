import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/local/app_hive.dart';

class LocationAdapter extends TypeAdapter<AppLocation> {
  @override
  int get typeId => AppHive.locationTypeId;

  @override
  AppLocation read(BinaryReader reader) {
    final json = reader.readMap();
    return AppLocation.fromJson(json.cast());
  }

  @override
  void write(BinaryWriter writer, AppLocation obj) {
    writer.writeMap(obj.toJson());
  }
}
