import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkerCluster extends HookWidget {
  final double size;
  final int count;

  const MarkerCluster({
    Key? key,
    this.size = 45,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF212121);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.5),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}