import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';

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
    final marker = subsidiary.store.marker?.thumbnailOr.toString() ?? '';
    return CachedNetworkImage(
      imageUrl: marker,
      width: markerSize,
      height: markerSize,
    );
  }
}
