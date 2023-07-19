import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/repository/stores_repository.dart';
import 'package:radili/providers/di/network_providers.dart';

final storesRepositoryProvider = Provider(
  (ref) => StoresRepository(
    ref.watch(nominatimApiProvider),
    ref.watch(storesApiProvider),
  ),
);
