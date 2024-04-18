import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_details.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_search_results.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/hooks/debouncer_hook.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/address_search_provider.dart';
import 'package:radili/widgets/loading.dart';
import 'package:radili/widgets/store_icon.dart';

class AddressSearch extends HookConsumerWidget {
  final AddressInfo? address;
  final Function(AddressInfo option) onAddressSelected;
  final Function(Subsidiary subsidiary) onSubsidiarySelected;
  final EdgeInsets padding;
  final Widget? suffix;
  final bool isLoading;
  final bool showSearchIcon;

  const AddressSearch({
    super.key,
    required this.onAddressSelected,
    required this.onSubsidiarySelected,
    this.isLoading = false,
    this.address,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.suffix,
    this.showSearchIcon = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final query = useState('');
    final searchResults = ref.watch(addressSearchProvider(query.value));
    final controller = useTextEditingController(
      text: address?.details.combined(place: false),
    );
    final key = useRef(GlobalKey());
    final debouncer = useDebouncer();

    void handleSearch(String value) {
      debouncer.debounce(() => query.value = value);
    }

    useValueChanged<AddressDetails?, void>(
      address?.details,
      (oldValue, oldResult) {
        final name = address?.details.combined(place: false);
        if (name != null && name != controller.text) {
          controller.text = name;
        }
      },
    );

    final Widget? prefix;
    if (isLoading || searchResults.isLoading) {
      prefix = const SizedBox(
        width: 36,
        height: 36,
        child: Loading(constraints: BoxConstraints(maxWidth: 36)),
      );
    } else if (showSearchIcon) {
      prefix = const Icon(Icons.search);
    } else {
      prefix = null;
    }

    return _AddressSearchResults(
      data: searchResults.valueOrNull ?? AddressSearchResults.empty,
      onAddressSelected: onAddressSelected,
      onSubsidiarySelected: onSubsidiarySelected,
      child: TextField(
        key: key.value,
        controller: controller,
        onChanged: handleSearch,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        decoration: InputDecoration(
          prefixIcon: prefix,
          hintText: t.mapSearchHint,
          border: InputBorder.none,
          hoverColor: Colors.transparent,
          suffixIcon: suffix,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _AddressSearchResults extends HookWidget {
  final AddressSearchResults data;
  final Widget child;
  final Function(AddressInfo option) onAddressSelected;
  final Function(Subsidiary option) onSubsidiarySelected;

  const _AddressSearchResults({
    super.key,
    required this.data,
    required this.child,
    required this.onAddressSelected,
    required this.onSubsidiarySelected,
  });

  @override
  Widget build(BuildContext context) {
    final show = useState(false);

    useValueChanged<AddressSearchResults, void>(
      data,
      (_, __) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          show.value = data.isNotEmpty;
        });
      },
    );

    useValueChanged<bool, void>(show.value, (_, __) {
      if (!show.value) {
        FocusScope.of(context).unfocus();
      }
    });

    void handleAddressPressed(AddressInfo address) {
      show.value = false;
      onAddressSelected(address);
    }

    void handleSubsidiaryPressed(Subsidiary subsidiary) {
      show.value = false;
      onSubsidiarySelected(subsidiary);
    }

    return PortalTarget(
      visible: show.value,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => show.value = false,
      ),
      child: PortalTarget(
        visible: show.value,
        anchor: const Aligned(
          follower: Alignment.topLeft,
          target: Alignment.bottomLeft,
          widthFactor: 1,
        ),
        portalFollower: Card(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              if (data.subsidiaries.isNotEmpty)
                SliverList.builder(
                  itemCount: data.subsidiaries.length,
                  itemBuilder: (ctx, index) {
                    final subsidiary = data.subsidiaries[index];
                    return ListTile(
                      leading: StoreIcon.subsidiary(subsidiary, size: 24),
                      onTap: () => handleSubsidiaryPressed(subsidiary),
                      title: Text(subsidiary.address ?? subsidiary.label ?? ''),
                      subtitle: Text(subsidiary.store.name),
                    );
                  },
                ),
              if (data.cities.isNotEmpty)
                SliverList.builder(
                  itemCount: data.cities.length,
                  itemBuilder: (ctx, index) {
                    final city = data.cities[index];
                    return ListTile(
                      onTap: () => handleAddressPressed(city),
                      title: Text(city.details.place),
                      leading: const Icon(Icons.location_city_outlined),
                    );
                  },
                ),
              if (data.addresses.isNotEmpty)
                SliverList.builder(
                  itemCount: data.addresses.length,
                  itemBuilder: (ctx, index) {
                    final address = data.addresses[index];
                    return ListTile(
                      onTap: () => handleAddressPressed(address),
                      title: Text(address.details.combined(place: false)),
                      subtitle: Text(address.details.place),
                      leading: const Icon(Icons.location_on_outlined),
                    );
                  },
                ),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
