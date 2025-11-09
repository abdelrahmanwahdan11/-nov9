import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/design_tokens.dart';

class AppTheme {
  AppTheme({Color? dynamicPrimary})
      : _dynamicPrimary = dynamicPrimary ?? DesignTokens.colors['dynamic_primary']!;

  final Color _dynamicPrimary;

  ThemeData get light => _baseTheme(Brightness.light).copyWith(
        scaffoldBackgroundColor: DesignTokens.colors['paper'],
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
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
    );

    final displayFont = GoogleFonts.urbanistTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: displayFont,
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
            : Colors.white,
        elevation: DesignTokens.elevations['md'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? Colors.white.withOpacity(0.12)
            : DesignTokens.colors['mint']!,
        selectedColor: _dynamicPrimary.withOpacity(0.8),
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
    );
  }
}
