import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/util/error_parser.dart';

ErrorParser useErrorParser() {
  final t = useTranslations();
  return useMemoized(() => ErrorParser(t), [t]);
}
