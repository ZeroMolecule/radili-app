import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/hooks/show_subsidiary_marker_hook.dart';
import 'package:radili/flow/map/providers/map_state.dart';
import 'package:radili/flow/map/widgets/map_filter.dart';
import 'package:radili/flow/map/widgets/map_location_button.dart';
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

    final mapState = ref.watch(mapStateProvider);
    final mapStateNotifier = ref.watch(mapStateProvider.notifier);

    void handleAddressPressed(AddressInfo? address) {
      mapStateNotifier.setState(
        position: address?.latLng,
        dirty: false,
      );
    }

    void handleSubsidiaryPressed(Subsidiary? subsidiary) {
      mapStateNotifier.setState(
        position: subsidiary?.coordinates,
        dirty: false,
      );
      if (subsidiary != null) {
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
      actionButton: MapLocationButton(
        onMyLocationFetched: (position) {
          mapStateNotifier.setState(position: position);
        },
      ),
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
