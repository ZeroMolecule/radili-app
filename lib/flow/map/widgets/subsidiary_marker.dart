import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/widgets/store_icon.dart';

class SubsidiaryMarker extends HookWidget {
  final Subsidiary subsidiary;
  final double markerSize;
  final Function(Subsidiary)? onMarkerPressed;

  const SubsidiaryMarker({
    Key? key,
    required this.subsidiary,
    required this.markerSize,
    this.onMarkerPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onMarkerPressed?.call(subsidiary),
      child: StoreIcon.subsidiary(subsidiary, size: markerSize),
    );
  }
}
