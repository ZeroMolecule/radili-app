import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/di/repository_providers.dart';

class AddressSearch extends HookConsumerWidget {
  final AddressInfo? address;
  final Function(AddressInfo option) onOptionSelected;
  final EdgeInsets padding;
  final Widget? suffix;

  const AddressSearch({
    Key? key,
    required this.onOptionSelected,
    this.address,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final repo = ref.watch(storesRepositoryProvider);
    final controller = useTextEditingController(
      text: address?.displayName,
    );

    useValueChanged<String?, void>(address?.displayName, (oldValue, oldResult) {
      final name = address?.displayName;
      if (name != null && name != controller.text) {
        controller.text = name;
      }
    });

    return TypeAheadField<AddressInfo>(
      itemBuilder: (_, AddressInfo option) => ListTile(
        title: Text(option.displayName),
      ),
      debounceDuration: const Duration(seconds: 1),
      suggestionsCallback: repo.searchAddress,
      loadingBuilder: (_) => const SizedBox.shrink(),
      errorBuilder: (_, __) => const SizedBox.shrink(),
      noItemsFoundBuilder: (_) => const SizedBox.shrink(),
      onSuggestionSelected: (option) {
        controller.text = option.displayName;
        onOptionSelected(option);
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: t.mapSearchHint,
          border: InputBorder.none,
          hoverColor: Colors.transparent,
          contentPadding: padding,
          suffixIcon: suffix,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}