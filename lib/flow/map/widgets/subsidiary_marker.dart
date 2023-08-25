import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';

class SubsidiaryMarker extends HookWidget {
  final Subsidiary subsidiary;
  final double markerSize;
  final Function(Subsidiary)? onMarkerPressed;
  final Function(Subsidiary)? onMarkerDoublePressed;

  const SubsidiaryMarker({
    Key? key,
    required this.subsidiary,
    required this.markerSize,
    this.onMarkerPressed,
    this.onMarkerDoublePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = subsidiary.store.icon?.thumbnailOr?.toString() ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(markerSize / 2),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () => onMarkerPressed?.call(subsidiary),
        onDoubleTap: () => onMarkerDoublePressed?.call(subsidiary),
        child: CachedNetworkImage(
          imageUrl: icon.toString(),
          width: markerSize,
          height: markerSize,
        ),
      ),
    );
  }
}
