import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/widgets/map_filter.dart';
import 'package:radili/flow/map/widgets/map_page_scaffold.dart';
import 'package:radili/flow/map/widgets/map_popup_menu.dart';
import 'package:radili/flow/map/widgets/map_search.dart';
import 'package:radili/flow/map/widgets/subsidiaries_map.dart';
import 'package:radili/hooks/linker_hook.dart';

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
    final linker = useLinker();
    final query = useState(SubsidiariesQuery(day: DateTime.now().weekday));
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
        query: query.value,
        position: mapPosition.value,
        onPositionChanged: handlePositionChanged,
        onSubsidiaryPressed: handleSubsidiaryPressed,
      ),
      filter: MapFilter(
        query: query.value,
        onQueryChanged: (value) => query.value = value,
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
