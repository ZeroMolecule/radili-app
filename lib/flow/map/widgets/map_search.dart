import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/addresses_query.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/flow/map/widgets/map_search_results.dart';
import 'package:radili/hooks/memoized_disposable_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/addresses_provider.dart';
import 'package:radili/providers/subsidiaries_provider.dart';

class MapSearch extends HookConsumerWidget {
  final String? search;

  final Function(AddressInfo address) onAddressPressed;
  final Function(Subsidiary subsidiary) onSubsidiaryPressed;

  const MapSearch({
    super.key,
    required this.onAddressPressed,
    required this.onSubsidiaryPressed,
    required this.search,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final inputNode = useMemoizedDisposable(
      () => FocusNode(),
      (node) => node.dispose(),
    );
    final controller = useTextEditingController(text: this.search);
    final search = useListenableSelector(controller, () => controller.text);

    final subsidiariesQuery = useMemoized(
      () => SubsidiariesQuery(search: search, limit: 3),
      [search],
    );
    final addressesQuery = useMemoized(
      () => AddressesQuery(search: search),
      [search],
    );

    final subsidiaries = ref.watch(subsidiariesProvider(subsidiariesQuery));
    final addresses = ref.watch(addressesProvider(addressesQuery));

    void handleAddressPressed(AddressInfo address) {
      onAddressPressed(address);
    }

    void handleSubsidiaryPressed(Subsidiary subsidiary) {
      onSubsidiaryPressed(subsidiary);
    }

    return PortalTarget(
      visible: useListenableSelector(inputNode, () => inputNode.hasFocus),
      anchor: const Aligned(
        follower: Alignment.topLeft,
        target: Alignment.bottomLeft,
        widthFactor: 1,
      ),
      portalFollower: MapSearchResults(
        addresses: addresses.valueOrNull,
        subsidiaries: subsidiaries.valueOrNull,
        onAddressPressed: handleAddressPressed,
        onSubsidiaryPressed: handleSubsidiaryPressed,
      ),
      child: TextField(
        focusNode: inputNode,
        controller: controller,
        onTapOutside: (_) {
          inputNode.unfocus();
        },
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        decoration: InputDecoration(
          hintText: t.mapSearchHint,
          border: InputBorder.none,
          hoverColor: Colors.transparent,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
