import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/util/error_parser.dart';

ErrorParser useErrorParser() {
  final t = AppTranslations.of(useContext());
  return useMemoized(() => ErrorParser(t), [t]);
}
