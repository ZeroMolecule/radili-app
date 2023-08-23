import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radili/generated/colors.gen.dart';

class AppTheme {
  final ThemeData material;

  const AppTheme._(this.material);

  factory AppTheme.light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.darkBlue,
      background: Colors.white,
      primaryContainer: AppColors.background,
      surface: Colors.white,
      surfaceTint: Colors.white,
    );
    return AppTheme._(
      _themeData.copyWith(
        colorScheme: colorScheme,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          hoverColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: AppColors.darkGrey,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 36,
            ),
            minimumSize: const Size(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tapTargetSize: MaterialTapTargetSize.padded,
            elevation: 0,
            side: BorderSide.none,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          extendedSizeConstraints: const BoxConstraints(
            minWidth: 200,
            minHeight: 50,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            iconColor: colorScheme.primary,
            foregroundColor: colorScheme.onSurface,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.primary,
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
    labelSmall: TextStyle(fontSize: 14),
  ),
);

final _themeData = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
);
