import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/provider_hook.dart';
import 'package:radili/providers/di/service_providers.dart';

bool useIsLocationPermissionEnabled([
  Duration refreshPeriod = const Duration(seconds: 1),
]) {
  final service = useProvider(locationServiceProvider);
  final stream = useMemoized(() {
    return Stream.periodic(refreshPeriod)
        .asyncMap((event) => service.isPermissionEnabled())
        .distinct();
  }, [refreshPeriod, service]);
  final value = useStream(stream);
  return value.hasData && value.data == true;
}
