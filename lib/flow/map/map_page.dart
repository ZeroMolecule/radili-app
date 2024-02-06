import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/nearby_subsidiaries_query.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/providers/address_selected_provider.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/map/widgets/map_popup_menu.dart';
import 'package:radili/flow/map/widgets/my_location_button.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/flow/notification_subscription/providers/notification_subscription_provider.dart';
import 'package:radili/hooks/async_action_hook.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/debouncer_hook.dart';
import 'package:radili/hooks/linker_hook.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/navigation/app_router.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/providers/nearby_subsidiaries_provider.dart';

@RoutePage()
class MapPage extends HookConsumerWidget {
  final bool openSunday;
  final bool openNow;

  const MapPage({
    super.key,
    @queryParam this.openSunday = false,
    @queryParam this.openNow = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final router = useRouter();
    final colors = useColorScheme();
    final debouncer = useDebouncer();
    final linker = useLinker();
    final mapController = useMapControllerAnimated();

    final actionFetchAddress = useAsyncAction();

    final selectedSubsidiary = useState<Subsidiary?>(null);
    final query = useState(
      NearbySubsidiariesQuery(openNow: openNow, openSunday: openSunday),
    );

    final addressSelectedNotifier = ref.watch(addressSelectedProvider.notifier);
    final subsidiariesNotifier = ref.watch(
      nearbySubsidiariesProvider(query.value).notifier,
    );
    final location = ref.watch(locationProvider);
    final address = ref.watch(addressSelectedProvider).valueOrNull;
    final subsidiaries = ref.watch(nearbySubsidiariesProvider(query.value));
    final showSubsidiary = useShowSubsidiaryMarker();
    final subscription = ref.watch(notificationSubscriptionProvider);

    void handleFindNearby(LatLng northeast, LatLng southwest) {
      debouncer
          .debounceAsync(
            () => subsidiariesNotifier.fetch(
              northeast: northeast,
              southwest: southwest,
            ),
          )
          .ignore();
    }

    void handleUseMyCurrentLocation() {
      actionFetchAddress.run(() async {
        await addressSelectedNotifier.setCurrent();
      });
    }

    void handleEditNotificationSubscription() {
      router.navigate(
        NotificationSubscriptionRoute(address: address),
      );
    }

    void handleShowSupport() {
      linker.launchSupportPage();
    }

    void onSubsidiarySelected(Subsidiary? subsidiary) {
      selectedSubsidiary.value = subsidiary;
      if (subsidiary != null) {
        showSubsidiary(subsidiary);
      }
    }

    void handleSubmitTicket() {
      router.push(TicketCreateRoute());
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
            child: SafeArea(
              bottom: false,
              child: AddressSearch(
                isLoading: subsidiaries.isLoading || location.isLoading,
                address: address,
                onOptionSelected: addressSelectedNotifier.set,
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyLocationButton(
                      isLoading: location.isLoading,
                      label: t.myLocation,
                      onPressed: handleUseMyCurrentLocation,
                    ),
                    MapPopupMenu(
                      onNotifyMePressed: handleEditNotificationSubscription,
                      onSupportPressed: handleShowSupport,
                      onSubmitTicketPressed: handleSubmitTicket,
                      isNotifyMeEnabled: subscription.valueOrNull != null,
                    ),
                  ],
                ),
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
              controller: mapController,
              actions: [
                ChoiceChip(
                  label: Text(t.openNow),
                  selected: query.value.openNow,
                  onSelected: (value) {
                    query.value = NearbySubsidiariesQuery(openNow: value);
                  },
                ),
                ChoiceChip(
                  label: Text(t.openSunday),
                  selected: query.value.openSunday,
                  onSelected: (value) {
                    query.value = NearbySubsidiariesQuery(openSunday: value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
