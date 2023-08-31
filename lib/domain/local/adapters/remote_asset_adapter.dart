import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:radili/domain/data/remote_asset.dart';
import 'package:radili/domain/local/app_hive.dart';

class RemoteAssetAdapter extends TypeAdapter<RemoteAsset> {
  @override
  int get typeId => AppHive.remoteAssetTypeId;

  @override
  RemoteAsset read(BinaryReader reader) {
    final string = reader.readString();
    return RemoteAsset.fromJson(jsonDecode(string));
  }

  @override
  void write(BinaryWriter writer, RemoteAsset obj) {
    final json = obj.toJson();
    writer.writeString(jsonEncode(json));
  }
}
