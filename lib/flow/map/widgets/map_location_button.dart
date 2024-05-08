import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/flow/map/providers/map_state.dart';
import 'package:radili/hooks/async_action_hook.dart';
import 'package:radili/hooks/on_value_changed_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/providers/location_provider.dart';

class MapLocationButton extends HookConsumerWidget {
  final Function(LatLng) onMyLocationFetched;

  const MapLocationButton({
    super.key,
    required this.onMyLocationFetched,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationNotifier = ref.watch(locationProvider.notifier);
    final actionRefreshLocation = useAsyncAction<AppLocation?>();
    final mapStateNotifier = ref.watch(mapStateProvider.notifier);

    void handleRefreshLocation() {
      mapStateNotifier.setState(dirty: false);
      actionRefreshLocation.run(locationNotifier.fetch);
    }

    useOnValueChanged(actionRefreshLocation.snapshot, () {
      if (actionRefreshLocation.snapshot.isSuccess) {
        final location = actionRefreshLocation.snapshot.data;
        if (location != null) {
          onMyLocationFetched(location.latLng);
        }
      }
    });

    return FloatingActionButton.small(
      onPressed: handleRefreshLocation,
      child: _RotatingIcon(rotate: actionRefreshLocation.snapshot.isWaiting),
    );
  }
}

class _RotatingIcon extends HookWidget {
  final bool rotate;

  const _RotatingIcon({
    required this.rotate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();
    final rotationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    useEffect(() {
      if (rotate) {
        rotationController.repeat();
      } else {
        rotationController.reset();
      }
      return null;
    }, [rotate]);

    return RotationTransition(
      turns: rotationController,
      child: Icon(
        Icons.my_location_rounded,
        size: 18,
        color: rotate
            ? theme.material.colorScheme.primary
            : theme.material.colorScheme.onSurface,
      ),
    );
  }
}
