import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/local/boxes/meta_box.dart';
import 'package:radili/domain/local/boxes/subsidiaries_box.dart';

final subsidiariesBoxProvider = Provider((ref) => const SubsidiariesBox());
final metaBoxProvider = Provider((ref) => const MetaBox());
