import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/data/workhours.dart';
import 'package:radili/domain/local/app_hive.dart';

class WorkHoursAdapter extends TypeAdapter<WorkHours> {
  @override
  int get typeId => AppHive.workHoursTypeId;

  @override
  WorkHours read(BinaryReader reader) {
    final string = reader.readString();
    return WorkHours.fromJson(jsonDecode(string));
  }

  @override
  void write(BinaryWriter writer, WorkHours obj) {
    final json = obj.toJson();
    writer.writeString(jsonEncode(json));
  }
}
