import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/breakpoints_hook.dart';

class MapPageScaffold extends HookWidget {
  final Widget search;
  final Widget map;
  final Widget filter;
  final Widget list;
  final Widget menu;

  const MapPageScaffold({
    super.key,
    required this.search,
    required this.map,
    required this.filter,
    required this.list,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoints = useBreakpoints();
    final size = MediaQuery.of(context).size;

    const sidebarWidth = 335.0;

    final safeArea = MediaQuery.of(context).viewPadding;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: breakpoints.isDesktop ? 80 : 0,
            left: false && breakpoints.isDesktop ? sidebarWidth : 0,
            bottom: 0,
            right: 0,
            child: map,
          ),
          Positioned(
            top: safeArea.top,
            left: 0,
            right: 0,
            bottom: breakpoints.isDesktop ? size.height - 80 : null,
            child: Container(
              color: breakpoints.isDesktop ? Colors.white : null,
              constraints: breakpoints.isDesktop
                  ? const BoxConstraints(maxHeight: 80)
                  : null,
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: breakpoints.isDesktop
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                direction:
                    breakpoints.isDesktop ? Axis.horizontal : Axis.vertical,
                children: [
                  SizedBox(
                    width: breakpoints.isDesktop ? sidebarWidth : null,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: breakpoints.isDesktop ? 0 : 12,
                      ),
                      child: search,
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: filter,
                  ),
                  if (breakpoints.isDesktop) ...[
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 18,
                      ),
                      child: menu,
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (!breakpoints.isDesktop)
            Positioned(
              top: safeArea.top + 18,
              right: 12,
              bottom: breakpoints.isDesktop ? size.height - 80 : null,
              child: menu,
            ),
          if (false)
            Positioned(
              top: breakpoints.isDesktop ? 80 : null,
              left: 0,
              right: breakpoints.isDesktop ? size.width - sidebarWidth : 0,
              bottom: breakpoints.isDesktop ? 0 : 24,
              child: list,
            ),
        ],
      ),
    );
  }
}
