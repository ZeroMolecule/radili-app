import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/address_search_provider.dart';
import 'package:radili/widgets/loading.dart';

class AddressSearch extends HookConsumerWidget {
  final AddressInfo? address;
  final Function(AddressInfo option) onOptionSelected;
  final EdgeInsets padding;
  final Widget? suffix;
  final bool isLoading;
  final bool showSearchIcon;

  const AddressSearch({
    Key? key,
    required this.onOptionSelected,
    this.isLoading = false,
    this.address,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.suffix,
    this.showSearchIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final addresses = ref.watch(addressSearchProvider);
    final notifier = ref.watch(addressSearchProvider.notifier);
    final controller = useTextEditingController(
      text: address?.displayName,
    );

    useValueChanged<String?, void>(address?.displayName, (oldValue, oldResult) {
      final name = address?.displayName;
      if (name != null && name != controller.text) {
        controller.text = name;
      }
    });

    final Widget? prefix;
    if (isLoading) {
      prefix = const SizedBox(
        width: 36,
        height: 36,
        child: Loading(
          constraints: BoxConstraints(maxWidth: 36),
        ),
      );
    } else if (showSearchIcon) {
      prefix = const Icon(Icons.search);
    } else {
      prefix = null;
    }

    return TypeAheadField<AddressInfo>(
      itemBuilder: (_, AddressInfo option) => ListTile(
        title: Text(option.displayName),
      ),
      debounceDuration: const Duration(seconds: 1),
      suggestionsCallback: (query) => notifier
          .search(query)
          .firstWhere((element) => !element.isLoading)
          .then((value) => value.valueOrNull ?? []),
      loadingBuilder: (_) => const SizedBox.shrink(),
      errorBuilder: (_, __) => const SizedBox.shrink(),
      noItemsFoundBuilder: (_) => const SizedBox.shrink(),
      onSuggestionSelected: (option) {
        controller.text = option.displayName;
        onOptionSelected(option);
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
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
