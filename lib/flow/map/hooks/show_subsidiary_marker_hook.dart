import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/domain/data/subsidiary.dart';
import 'package:radili/flow/map/widgets/subsidiary_item.dart';
import 'package:radili/hooks/breakpoints_hook.dart';
import 'package:radili/hooks/color_scheme_hook.dart';
import 'package:radili/hooks/router_hook.dart';
import 'package:radili/hooks/translations_hook.dart';

FutureOr Function(Subsidiary subsidiary) useShowSubsidiaryMarker() {
  final t = useTranslations();
  final router = useRouter();
  final context = useContext();
  final colors = useColorScheme();
  final mediaQuery = MediaQuery.of(context);
  final breakpoints = useBreakpoints();
  final constraints = useMemoized(() {
    if (breakpoints.isDesktop) {
      return const BoxConstraints(maxWidth: 600);
    }
    if (breakpoints.isTablet) {
      return BoxConstraints(maxWidth: mediaQuery.size.width * 0.8);
    }
    return const BoxConstraints(maxWidth: 450);
  }, [breakpoints]);

  return (Subsidiary subsidiary) async {
    void handleSupportPressed() async {}

    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: constraints,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Card(
                    margin: const EdgeInsets.only(
                      bottom: 16,
                      left: 12,
                      right: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SubsidiaryItem(
                        subsidiary: subsidiary,
                        isSelected: true,
                        onSupportPressed: handleSupportPressed,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded),
                  color: colors.onSurface,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surface,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };
}
