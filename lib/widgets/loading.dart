import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/generated/assets.gen.dart';

class Loading extends HookWidget {
  final LottieGenImage? animation;
  final BoxConstraints constraints;

  const Loading({
    Key? key,
    this.animation,
    this.constraints = const BoxConstraints(),
  }) : super(key: key);

  factory Loading.map({
    BoxConstraints constraints = const BoxConstraints(),
  }) =>
      Loading(
        constraints: constraints,
        animation: Assets.animations.radiliMap,
      );

  @override
  Widget build(BuildContext context) {
    final animation = this.animation ?? Assets.animations.radiliLoading;
    return Container(
      constraints: constraints,
      child: animation.lottie(
        alignment: Alignment.center,
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        fit: BoxFit.contain,
      ),
    );
  }
}
