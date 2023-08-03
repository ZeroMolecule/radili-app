import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/widgets/store_icon.dart';

class SubsidiaryMarker extends HookWidget {
  final Subsidiary subsidiary;
  final double markerSize;
  const SubsidiaryMarker({
    Key? key,
    required this.subsidiary,
    required this.markerSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: StoreIcon.subsidiary(subsidiary, size: markerSize),
    );
  }
}
