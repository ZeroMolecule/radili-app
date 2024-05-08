import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';

class SubsidiaryMarker extends HookWidget {
  final Subsidiary subsidiary;
  final double markerSize;

  const SubsidiaryMarker({
    super.key,
    required this.subsidiary,
    required this.markerSize,
  });

  @override
  Widget build(BuildContext context) {
    final marker = subsidiary.store.marker?.thumbnailOr.toString() ?? '';
    return CachedNetworkImage(
      imageUrl: marker,
      width: markerSize,
      height: markerSize,
    );
  }
}
