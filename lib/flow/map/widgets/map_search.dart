import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/hooks/translations_hook.dart';
import 'package:radili/providers/di/repository_providers.dart';

class MapSearch extends HookConsumerWidget {
  final AddressInfo? address;
  final Function() onNotifyPressed;
  final Function() onShowMorePressed;
  final Function(AddressInfo option) onOptionSelected;

  const MapSearch({
    Key? key,
    required this.onNotifyPressed,
    required this.onShowMorePressed,
    required this.onOptionSelected,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final repo = ref.watch(storesRepositoryProvider);
    final controller = useTextEditingController(
      text: address?.displayName,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<AddressInfo>(
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: t.mapSearchHint,
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
