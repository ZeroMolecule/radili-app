import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:radili/hooks/provider_hook.dart';
import 'package:radili/providers/di/theme_providers.dart';
import 'package:radili/theme/app_theme.dart';

AppTheme useTheme() {
  final light = useProvider(themeLightProvider);
  final dark = useProvider(themeDarkProvider);

  final context = useContext();
  final brightness = Theme.of(context).brightness;

  if (brightness == Brightness.light) {
    return light;
  } else {
    return dark;
  }
}