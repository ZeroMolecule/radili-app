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
      primaryContainer: AppColors.bleachedSilk,
      surface: Colors.white,
      surfaceTint: Colors.white,
      onSurface: AppColors.dynamicBlack,
      onBackground: AppColors.dynamicBlack,
      surfaceVariant: AppColors.arcLight,
    );
    return AppTheme._(
      _themeData.copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          hoverColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintStyle: TextStyle(fontSize: 14),
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
              borderRadius: BorderRadius.circular(8),
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
          style: IconButton.styleFrom(),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        chipTheme: ChipThemeData(
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: _textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          shadowColor: AppColors.millionGrey.withOpacity(0.2),
          elevation: 4,
          labelPadding: const EdgeInsets.all(4),
          selectedColor: colorScheme.surfaceVariant,
          surfaceTintColor: colorScheme.surfaceVariant,
          checkmarkColor: colorScheme.primary,
          color: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return colorScheme.surfaceVariant;
              }
              return colorScheme.surface;
            },
          ),
        ),
        listTileTheme: const ListTileThemeData(
          subtitleTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        switchTheme: SwitchThemeData(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          trackOutlineColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.onSurface;
          }),
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.onSurface;
          }),
          trackColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          thumbIcon: MaterialStateProperty.all(
            const Icon(
              Icons.circle_outlined,
              size: 0,
              color: Colors.transparent,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.dynamicBlack),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: AppColors.dynamicBlack,
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
    headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelSmall: TextStyle(fontSize: 14),
  ),
);

final _themeData = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
);
