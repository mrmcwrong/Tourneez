import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cached display styles — building GoogleFonts styles inside `build` methods
/// re-resolves the font on every frame, which shows up as scroll jank.
class TourneezText {
  static final brand = GoogleFonts.fraunces(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static final section = GoogleFonts.fraunces(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final heading = GoogleFonts.fraunces(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
}

class TourneezTheme {
  static const seed = Color(0xFF0B6E4F);
  static const secondary = Color(0xFFC45C26);
  static const _surface = Color(0xFFF2F5F3);
  static const _ink = Color(0xFF122019);
  static const _darkSurface = Color(0xFF0E1512);
  static const _darkCard = Color(0xFF18221D);
  static const _darkInk = Color(0xFFE6EDE8);

  // ColorScheme.fromSeed + GoogleFonts resolution are expensive; build once.
  static ThemeData? _lightCache;
  static ThemeData? _darkCache;

  static ThemeData light() => _lightCache ??= _light();

  static ThemeData dark() => _darkCache ??= _dark();

  static ThemeData _light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: _surface,
    ).copyWith(
      primary: seed,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      surface: _surface,
      surfaceContainerHighest: const Color(0xFFE4EBE6),
      outline: _ink.withValues(alpha: 0.14),
    );

    return _build(
      scheme: scheme,
      ink: _ink,
      scaffold: _surface,
      card: Colors.white,
      inputFill: Colors.white,
      fabBg: seed,
    );
  }

  static ThemeData _dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: _darkSurface,
    ).copyWith(
      primary: const Color(0xFF3D9B75),
      onPrimary: Colors.white,
      secondary: const Color(0xFFE07A45),
      onSecondary: Colors.white,
      surface: _darkSurface,
      surfaceContainerHighest: const Color(0xFF24302A),
      outline: _darkInk.withValues(alpha: 0.16),
    );

    return _build(
      scheme: scheme,
      ink: _darkInk,
      scaffold: _darkSurface,
      card: _darkCard,
      inputFill: _darkCard,
      fabBg: const Color(0xFF3D9B75),
    );
  }

  static ThemeData _build({
    required ColorScheme scheme,
    required Color ink,
    required Color scaffold,
    required Color card,
    required Color inputFill,
    required Color fabBg,
  }) {
    final textTheme = GoogleFonts.dmSansTextTheme(
      scheme.brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    ).apply(bodyColor: ink, displayColor: ink);

    final radius = BorderRadius.circular(18);

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold.withValues(alpha: 0.92),
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.55)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: fabBg,
        foregroundColor: Colors.white,
        elevation: 2,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide.none,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: ink.withValues(alpha: 0.55),
        indicatorColor: scheme.primary,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: radius),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.45),
        space: 1,
      ),
    );
  }
}
