import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:radili/hooks/controller_hook.dart';

SuperclusterMutableController useSuperClusterMutableController() {
  return useController(
    () => SuperclusterMutableController(),
    (c) => c.dispose(),
  );
}
