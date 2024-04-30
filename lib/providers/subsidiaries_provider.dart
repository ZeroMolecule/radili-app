import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/domain/repository/subsidiaries_repository.dart';
import 'package:radili/providers/di/di.dart';
import 'package:radili/util/extensions/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subsidiaries_provider.g.dart';

@riverpod
class SubsidiariesState extends _$SubsidiariesState {
  late final SubsidiariesRepository _repo = di.get();

  @override
  Stream<List<Subsidiary>> build(SubsidiariesQuery query) async* {
    await ref.debounce(const Duration(milliseconds: 250));
    yield* _repo.watch(query);
  }
}
