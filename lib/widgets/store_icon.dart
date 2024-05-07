import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/util/extensions/string_extensions.dart';

const _defaultSize = 50.0;

class StoreIcon extends HookWidget {
  final Uri? uri;
  final String? label;
  final double size;

  const StoreIcon({
    super.key,
    this.uri,
    this.label,
    this.size = _defaultSize,
  }) : assert(uri != null || label != null);

  factory StoreIcon.store(
    Store store, {
    double size = _defaultSize,
  }) {
    return StoreIcon(
      uri: store.icon?.thumbnailOr ?? Uri.parse(''),
      size: size,
    );
  }

  factory StoreIcon.subsidiary(
    Subsidiary subsidiary, {
    double size = _defaultSize,
  }) {
    return StoreIcon(
      uri: subsidiary.store.icon?.thumbnailOr ?? Uri.parse(''),
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: uri != null
          ? _Icon(uri: uri!, size: size)
          : _Label(label: label!, size: size),
    );
  }
}

class _Icon extends HookWidget {
  final Uri uri;
  final double size;

  const _Icon({
    super.key,
    required this.uri,
    this.size = _defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CachedNetworkImage(
        imageUrl: uri.toString(),
        width: size,
        height: size,
        placeholder: (context, url) => _Placeholder(size: size),
      ),
    );
  }
}

class _Label extends HookWidget {
  final String label;
  final double size;

  const _Label({
    super.key,
    required this.label,
    this.size = _defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child: Text(
          label.getInitials(1),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.7,
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends HookWidget {
  final double size;

  const _Placeholder({
    super.key,
    this.size = _defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}
