import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/util/linker.dart';

Linker useLinker() {
  return useMemoized(() => Linker());
}
