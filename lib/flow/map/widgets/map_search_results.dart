import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/domain/data/address_type.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/widgets/store_icon.dart';

class MapSearchResults extends HookWidget {
  final List<AddressInfo>? addresses;
  final List<Subsidiary>? subsidiaries;
  final Function(AddressInfo) onAddressPressed;
  final Function(Subsidiary) onSubsidiaryPressed;

  const MapSearchResults({
    super.key,
    required this.addresses,
    required this.subsidiaries,
    required this.onAddressPressed,
    required this.onSubsidiaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          if (addresses != null && addresses!.isNotEmpty)
            SliverList.builder(
              itemCount: addresses!.length,
              itemBuilder: (ctx, index) {
                final address = addresses![index];
                return ListTile(
                  onTap: () => onAddressPressed(address),
                  title: Text(
                    address.type == AddressType.city
                        ? address.details.place
                        : address.details.combined(place: false),
                  ),
                  leading: Icon(
                    address.type == AddressType.city
                        ? Icons.location_city_outlined
                        : Icons.location_on_outlined,
                  ),
                );
              },
            ),
          if (subsidiaries != null && subsidiaries!.isNotEmpty)
            SliverList.builder(
              itemCount: subsidiaries!.length,
              itemBuilder: (ctx, index) {
                final subsidiary = subsidiaries![index];
                return ListTile(
                  leading: StoreIcon.subsidiary(subsidiary, size: 24),
                  onTap: () => onSubsidiaryPressed(subsidiary),
                  title: Text(
                    subsidiary.display ?? '',
                  ),
                  subtitle: Text(
                    subsidiary.store.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
