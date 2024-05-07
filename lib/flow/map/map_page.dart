import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/widgets/map_filter.dart';
import 'package:radili/flow/map/widgets/map_page_scaffold.dart';
import 'package:radili/flow/map/widgets/map_popup_menu.dart';
import 'package:radili/flow/map/widgets/map_search.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/hooks/linker_hook.dart';
import 'package:radili/providers/subsidiaries_query_provider.dart';

@RoutePage()
class MapPage extends HookConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linker = useLinker();
    final queryNotifier = ref.watch(subsidiariesQueryStateProvider.notifier);
    final query = ref.watch(subsidiariesQueryStateProvider);
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

    return MapPageScaffold(
      search: MapSearch(
        onAddressPressed: handleAddressPressed,
        onSubsidiaryPressed: handleSubsidiaryPressed,
      ),
      map: SubsidiariesMap(
        query: query,
        position: mapPosition.value,
        onPositionChanged: queryNotifier.setBounds,
        onSubsidiaryPressed: handleSubsidiaryPressed,
      ),
      filter: MapFilter(
        stores: query.stores,
        day: query.day,
        onStoresChanged: queryNotifier.setStores,
        onDayChanged: queryNotifier.setDay,
      ),
      menu: MapPopupMenu(
        onProjectPagePressed: linker.launchProjectPage,
        onBugReportPressed: linker.launchBugReportPage,
        onSuggestIdeasPressed: linker.launchIdeasPage,
      ),
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
      child: Center(child: Text(label)),
    );
  }
}
