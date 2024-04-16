import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/providers/location_provider.dart';

Stream<AppLocation> useLocationStream() {
  final context = useContext();
  final scope = ProviderScope.containerOf(context);

  return useMemoized(() {
    final provider = locationProvider.select((it) => it.valueOrNull);
    return Stream.multi((controller) {
      ProviderSubscription? subscription;
      controller.onCancel = () {
        subscription?.close();
      };
      final current = scope.read(provider);
      if (current != null) controller.add(current);

      subscription = scope.listen<AppLocation?>(
        provider,
        (previous, next) {
          if (next != null) controller.add(next);
        },
      );
    });
  }, [scope]);
}
