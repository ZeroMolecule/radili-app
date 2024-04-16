import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/generated/l10n.dart';

Translations useTranslations() {
  return Translations.of(useContext());
}
