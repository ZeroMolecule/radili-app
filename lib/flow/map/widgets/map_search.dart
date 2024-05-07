import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/domain/queries/addresses_query.dart';
import 'package:radili/domain/queries/subsidiaries_query.dart';
import 'package:radili/flow/map/widgets/map_search_results.dart';
import 'package:radili/generated/i18n/translations.g.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/hooks/memoized_disposable_hook.dart';
import 'package:radili/hooks/theme_hook.dart';
import 'package:radili/providers/addresses_provider.dart';
import 'package:radili/providers/subsidiaries_provider.dart';

class MapSearch extends HookConsumerWidget {
  final Function(AddressInfo address) onAddressPressed;
  final Function(Subsidiary subsidiary) onSubsidiaryPressed;

  const MapSearch({
    super.key,
    required this.onAddressPressed,
    required this.onSubsidiaryPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppTranslations.of(context);
    final theme = useTheme();
    final breakpoint = useBreakpoints();

    final inputNode = useMemoizedDisposable(
      () => FocusNode(),
      (node) => node.dispose(),
    );
    final controller = useTextEditingController();
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
      inputNode.unfocus();
      controller.text = address.details.combined(place: false);
      onAddressPressed(address);
    }

    void handleSubsidiaryPressed(Subsidiary subsidiary) {
      inputNode.unfocus();
      controller.text = subsidiary.display ?? '';
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
      child: Container(
        margin: EdgeInsets.only(
          left: breakpoint.isDesktop ? 24 : 8,
          right: breakpoint.isDesktop ? 24 : 8,
        ),
        decoration: BoxDecoration(
          boxShadow: [theme.shadow],
          borderRadius: BorderRadius.circular(2),
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
            hintText: t.map.search.placeholder,
            border: InputBorder.none,
            hoverColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
