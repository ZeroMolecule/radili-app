import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/domain/repository/subsidiaries_repository.dart';
import 'package:radili/providers/di/di.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/util/extensions/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subsidiaries_provider.g.dart';

@riverpod
Stream<List<Subsidiary>> subsidiaries(
  SubsidiariesRef ref,
  SubsidiariesQuery query,
) async* {
  await ref.debounce(const Duration(milliseconds: 250));
  final repo = di.get<SubsidiariesRepository>();

  final location = ref.read(locationProvider).valueOrNull;

  yield* repo.watch(query.copyWith(location: location?.latLng));
}
