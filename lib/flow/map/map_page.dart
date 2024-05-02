import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/providers/address_selected_provider.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/map/widgets/map_page_scaffold.dart';
import 'package:radili/flow/map/widgets/map_popup_menu.dart';
import 'package:radili/flow/map/widgets/map_search.dart';
import 'package:radili/flow/map/widgets/my_location_button.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/hooks/async_action_hook.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/debouncer_hook.dart';
import 'package:radili/hooks/linker_hook.dart';
import 'package:radili/hooks/map_controller_animated_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/location_provider.dart';
import 'package:radili/providers/subsidiaries_provider.dart';

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
    return _Test();

    final t = useTranslations();
    final router = useRouter();
    final colors = useColorScheme();
    final debouncer = useDebouncer();
    final linker = useLinker();
    final mapController = useMapControllerAnimated();

    final actionFetchAddress = useAsyncAction();

    final selectedSubsidiary = useState<Subsidiary?>(null);

    final query = useState(SubsidiariesQuery.empty);
    final subsidiariesState = ref.watch(subsidiariesProvider(query.value));

    final addressSelectedNotifier = ref.watch(addressSelectedProvider.notifier);
    final location = ref.watch(locationProvider);
    final address = ref.watch(addressSelectedProvider).valueOrNull;
    final showSubsidiary = useShowSubsidiaryMarker();
    final mapPosition = useState<LatLng?>(null);

    void handleUpdatePosition(LatLng northeast, LatLng southwest) {
      query.value = query.value.copyWith(
        northeast: northeast,
        southwest: southwest,
      );
    }

    void handleUseMyCurrentLocation() {
      actionFetchAddress.run(() async {
        await addressSelectedNotifier.setCurrent();
      });
    }

    void handleShowSupport() {
      linker.launchSupportPage();
    }

    void handleShowProjectPage() {
      linker.launchProjectPage();
    }

    void onSubsidiarySelected(Subsidiary? subsidiary) {
      selectedSubsidiary.value = subsidiary;
      if (subsidiary != null) {
        showSubsidiary(subsidiary);
      }
    }

    useValueChanged<Subsidiary?, void>(selectedSubsidiary.value, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final position = selectedSubsidiary.value?.coordinates;
        if (position != null) {
          mapPosition.value = position;
        }
      });
    });

    useValueChanged<AddressInfo?, void>(address, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final position = address?.latLng;
        if (position != null) {
          mapPosition.value = position;
        }
      });
    });

    useValueChanged<AsyncValue, void>(subsidiariesState, (_, __) {
      if (subsidiariesState.hasError) {
        print('Subsidiaries error: ${subsidiariesState.error}');
      }
    });

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
                isLoading: subsidiariesState.isLoading || location.isLoading,
                address: address,
                onAddressSelected: addressSelectedNotifier.set,
                onSubsidiarySelected: onSubsidiarySelected,
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyLocationButton(
                      isLoading: location.isLoading,
                      label: t.myLocation,
                      onPressed: handleUseMyCurrentLocation,
                    ),
                    MapPopupMenu(
                      onSupportPressed: handleShowSupport,
                      onProjectPagePressed: handleShowProjectPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Test extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useState(const SubsidiariesQuery());
    final subsidiaries = ref.watch(subsidiariesProvider(query.value));
    final showSubsidiary = useShowSubsidiaryMarker();

    final mapPosition = useState<LatLng?>(null);

    void handleAddressPressed(AddressInfo? address) {
      if (address != null) {
        mapPosition.value = address.latLng;
      }
    }

    void handleSubsidiaryPressed(Subsidiary? subsidiary) {
      if (subsidiary != null) {
        mapPosition.value = subsidiary.coordinates;
        showSubsidiary(subsidiary);
      }
    }

    void handlePositionChanged(LatLng northeast, LatLng southwest) {
      query.value = query.value.copyWith(
        northeast: northeast,
        southwest: southwest,
      );
    }

    return MapPageScaffold(
      search: MapSearch(
        onAddressPressed: handleAddressPressed,
        onSubsidiaryPressed: handleSubsidiaryPressed,
        search: null,
      ),
      map: SubsidiariesMap(
        subsidiaries: subsidiaries.valueOrNull,
        position: mapPosition.value,
        onPositionChanged: handlePositionChanged,
        onSubsidiaryPressed: handleSubsidiaryPressed,
      ),
      filter: const _Placeholder(label: 'Filter', color: Colors.blue),
      list: const _Placeholder(label: 'List', color: Colors.red),
    );
  }
}

class _Placeholder extends HookWidget {
  final String label;
  final Color color;

  const _Placeholder({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(label),
      ),
    );
  }
}
