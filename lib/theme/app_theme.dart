import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radili/generated/colors.gen.dart';

class AppTheme {
  final ThemeData material;

  const AppTheme._(this.material);

  factory AppTheme.light() {
    return AppTheme._(
      _themeData.copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.darkBlue,
        ),
      ),
    );
  }

  factory AppTheme.dark() {
    return AppTheme._(
      _themeData.copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkBlue,
        ),
      ),
    );
  }
}

final _textTheme = GoogleFonts.interTextTheme(
  const TextTheme(
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 14),
  ),
);

final _themeData = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
);
