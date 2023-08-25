import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/flow/notification_subscription/providers/notification_subscription_provider.dart';
import 'package:radili/hooks/async_callback.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/debouncer_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/navigation/app_router.dart';
import 'package:radili/providers/address_selected_provider.dart';
import 'package:radili/providers/nearby_subsidiaries_provider.dart';
import 'package:radili/widgets/responsive_icon_button.dart';

@RoutePage()
class MapPage extends HookConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final router = useRouter();
    final colors = useColorScheme();
    final debouncer = useDebouncer();
    final address = ref.watch(addressSelectedProvider);
    final selectedSubsidiary = useState<Subsidiary?>(null);

    final addressSelectedNotifier = ref.watch(addressSelectedProvider.notifier);
    final notificationSettings = ref.watch(notificationSubscriptionProvider);
    final subsidiariesNotifier = ref.watch(nearbySubsidiariesProvider.notifier);
    final subsidiaries = ref.watch(nearbySubsidiariesProvider);
    final showSubsidiary = useShowSubsidiaryMarker();

    void handleFindNearby(LatLng position) {
      debouncer.debounce(
        () => subsidiariesNotifier.fetch(position),
      );
    }

    final handleUseMyCurrentLocation = useAsyncCallback(
      addressSelectedNotifier.selectCurrent,
    );

    void handleEditNotificationSubscription() {
      router.navigate(
        NotificationSubscriptionRoute(address: address),
      );
    }

    void onSubsidiarySelected(Subsidiary? subsidiary) {
      selectedSubsidiary.value = subsidiary;
      if (subsidiary != null) {
        addressSelectedNotifier.select(
          AddressInfo(
            rawLat: subsidiary.coordinates.latitude.toString(),
            rawLon: subsidiary.coordinates.longitude.toString(),
            displayName: subsidiary.address ?? '',
          ),
        );
        showSubsidiary(subsidiary);
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.background,
              border: Border(
                bottom: BorderSide(
                  color: colors.onBackground.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: AddressSearch(
              address: address,
              onOptionSelected: addressSelectedNotifier.select,
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResponsiveIconButton(
                    icon: const Icon(Icons.error_outline),
                    label: 'Sruši me',
                    onPressed: () {
                      throw Exception('Test crash');
                    },
                  ),
                  ResponsiveIconButton(
                    icon: const Icon(Icons.my_location_outlined),
                    label: 'Moja lokacija',
                    onPressed: handleUseMyCurrentLocation,
                  ),
                  ResponsiveIconButton(
                    onPressed: handleEditNotificationSubscription,
                    icon: Icon(
                      notificationSettings.valueOrNull != null
                          ? Icons.notifications_active
                          : Icons.notifications_outlined,
                    ),
                    label: t.notifyMe,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SubsidiariesMap(
              position: address?.latLng,
              subsidiaries: subsidiaries.valueOrNull ?? [],
              onPositionChanged: handleFindNearby,
              onSubsidiaryPressed: onSubsidiarySelected,
              subsidiary: selectedSubsidiary.value,
            ),
          ),
        ],
      ),
    );
  }
}
