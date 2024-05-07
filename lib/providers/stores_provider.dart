import 'dart:async';

import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stores_provider.g.dart';

@riverpod
Stream<List<Store>> stores(StoresRef ref) {
  final repository = di.get<StoresRepository>();
  return repository.watchAll();
}
