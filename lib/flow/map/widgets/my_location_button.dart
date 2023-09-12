import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/hooks/color_scheme_hook.dart';

class MyLocationButton extends HookWidget {
  final bool isLoading;
  final Function() onPressed;
  final String? label;

  const MyLocationButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useColorScheme();
    final breakpoints = useBreakpoints();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );
    useEffect(() {
      if (isLoading) {
        animationController.repeat();
      } else {
        animationController.reset();
      }
      return null;
    }, [isLoading, animationController]);

    final icon = RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
      child: Icon(
        Icons.my_location_outlined,
        color: isLoading ? colors.primary : colors.onSurface,
      ),
    );

    if (label == null || !breakpoints.isDesktop) {
      return IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: icon,
      );
    }
    return TextButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: icon,
      label: Text(label!),
    );
  }
}
