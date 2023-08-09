import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/address_search.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/flow/map/widgets/subsidiaries_sidebar.dart';
import 'package:radili/generated/colors.gen.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/debouncer_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/navigation/app_router.dart';
import 'package:radili/providers/nearby_subsidiaries_provider.dart';

@RoutePage()
class MapPage extends HookConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final colors = useColorScheme();
    final debouncer = useDebouncer();
    final address = useState<AddressInfo?>(null);
    final selectedSubsidiary = useState<Subsidiary?>(null);

    final subsidiariesNotifier = ref.watch(nearbySubsidiariesProvider.notifier);
    final subsidiaries = ref.watch(nearbySubsidiariesProvider);

    void handleOptionSelected(AddressInfo option) {
      address.value = option;
    }

    void handleFindNearby(LatLng position) {
      debouncer.debounce(
        () => subsidiariesNotifier.fetch(position),
      );
    }

    void onSubsidiarySelected(Subsidiary subsidiary) {
      if (subsidiary == selectedSubsidiary.value) {
        selectedSubsidiary.value = null;
      } else if (subsidiary.address != null) {
        address.value = AddressInfo(
          rawLat: subsidiary.coordinates.latitude.toString(),
          rawLon: subsidiary.coordinates.longitude.toString(),
          displayName: subsidiary.address!,
        );
        selectedSubsidiary.value = subsidiary;
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 3,
                  child: AddressSearch(
                    onOptionSelected: handleOptionSelected,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextButton.icon(
                    onPressed: () => AutoRouter.of(context).navigate(
                      NotificationSettingsRoute(
                        address: address.value,
                      ),
                    ),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.lightBlue,
                    ),
                    label: Text(
                      t.notifyMe,
                      style: TextStyle(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Stack(
              children: [
                SubsidiariesMap(
                  position: address.value?.latLng,
                  subsidiaries: subsidiaries.valueOrNull ?? [],
                  onPositionChanged: handleFindNearby,
                  onSubsidiaryPressed: onSubsidiarySelected,
                ),
                if (subsidiaries.valueOrNull?.isNotEmpty == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(flex: 3),
                      Flexible(
                        flex: 1,
                        child: SubsidiariesSidebar(
                          subsidiaries: subsidiaries.valueOrNull!,
                          onSubsidiarySelected: onSubsidiarySelected,
                          selectedSubsidiary: selectedSubsidiary.value,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
