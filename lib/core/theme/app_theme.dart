import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/design_tokens.dart';

class AppTheme {
  AppTheme({Color? dynamicPrimary, Locale? locale})
      : _dynamicPrimary = dynamicPrimary ?? DesignTokens.colors['dynamic_primary']!,
        _locale = locale ?? const Locale('en');

  final Color _dynamicPrimary;
  final Locale _locale;

  ThemeData get light => _baseTheme(Brightness.light).copyWith(
        scaffoldBackgroundColor: Color.lerp(
          DesignTokens.colors['paper'],
          _dynamicPrimary.withOpacity(0.35),
          0.4,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _dynamicPrimary,
          brightness: Brightness.light,
          primary: _dynamicPrimary,
          background: DesignTokens.colors['paper'],
        ),
      );

  ThemeData get dark => _baseTheme(Brightness.dark).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0C0E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _dynamicPrimary,
          brightness: Brightness.dark,
          primary: _dynamicPrimary,
          background: const Color(0xFF0B0C0E),
        ),
      );

  ThemeData _baseTheme(Brightness brightness) {
    final isArabic = _locale.languageCode == 'ar';
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    );

    final bodyTheme = isArabic
        ? GoogleFonts.cairoTextTheme(base.textTheme)
        : GoogleFonts.interTextTheme(base.textTheme);
    final displayTheme = isArabic
        ? GoogleFonts.tajawalTextTheme(bodyTheme)
        : GoogleFonts.urbanistTextTheme(bodyTheme);

    return base.copyWith(
      textTheme: displayTheme,
      primaryTextTheme: displayTheme,
      fontFamily: displayTheme.bodyMedium?.fontFamily,
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: brightness == Brightness.dark
            ? Colors.white
            : DesignTokens.colors['ink'],
      ),
      cardTheme: CardTheme(
        color: brightness == Brightness.dark
            ? const Color(0xFF173B3F)
            : Colors.white.withOpacity(0.92),
        elevation: DesignTokens.elevations['md'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? Colors.white.withOpacity(0.12)
            : DesignTokens.colors['mint']!,
        selectedColor: _dynamicPrimary.withOpacity(0.85),
        labelStyle: TextStyle(
          color: brightness == Brightness.dark
              ? Colors.white
              : DesignTokens.colors['ink'],
          fontWeight: FontWeight.w600,
        ),
        shape: const StadiumBorder(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _dynamicPrimary,
        foregroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
      ),
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? const Color(0xFF0B0C0E)
          : Color.alphaBlend(_dynamicPrimary.withOpacity(0.12), DesignTokens.colors['paper']!),
      dividerColor: Colors.black.withOpacity(0.08),
      iconTheme: base.iconTheme.copyWith(
        color: brightness == Brightness.dark ? Colors.white : Colors.black87,
      ),
    );
  }
}
