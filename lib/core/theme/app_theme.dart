import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/design_tokens.dart';

class AuraTheme extends ThemeExtension<AuraTheme> {
  const AuraTheme({
    required this.backgroundGradient,
    required this.cardGradient,
    required this.dropShadows,
  });

  final Gradient backgroundGradient;
  final Gradient cardGradient;
  final List<BoxShadow> dropShadows;

  @override
  AuraTheme copyWith({
    Gradient? backgroundGradient,
    Gradient? cardGradient,
    List<BoxShadow>? dropShadows,
  }) {
    return AuraTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      dropShadows: dropShadows ?? this.dropShadows,
    );
  }

  @override
  AuraTheme lerp(ThemeExtension<AuraTheme>? other, double t) {
    if (other is! AuraTheme) {
      return this;
    }
    final maxLength = dropShadows.length > other.dropShadows.length
        ? dropShadows.length
        : other.dropShadows.length;
    final lerpedShadows = <BoxShadow>[];
    for (var index = 0; index < maxLength; index++) {
      final from = index < dropShadows.length ? dropShadows[index] : dropShadows.last;
      final to = index < other.dropShadows.length ? other.dropShadows[index] : other.dropShadows.last;
      final value = BoxShadow.lerp(from, to, t);
      if (value != null) {
        lerpedShadows.add(value);
      }
    }
    return AuraTheme(
      backgroundGradient: Gradient.lerp(backgroundGradient, other.backgroundGradient, t) ?? backgroundGradient,
      cardGradient: Gradient.lerp(cardGradient, other.cardGradient, t) ?? cardGradient,
      dropShadows: lerpedShadows,
    );
  }
}

class AppTheme {
  AppTheme({Color? dynamicPrimary, Locale? locale})
      : _dynamicPrimary = dynamicPrimary ?? DesignTokens.colors['dynamic_primary']!,
        _locale = locale ?? const Locale('en');

  final Color _dynamicPrimary;
  final Locale _locale;

  ThemeData get light => _buildTheme(Brightness.light);

  ThemeData get dark => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final isArabic = _locale.languageCode == 'ar';
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _dynamicPrimary,
      brightness: brightness,
      background: brightness == Brightness.dark ? const Color(0xFF0B0C0E) : DesignTokens.colors['paper'],
    ).copyWith(
      secondary: DesignTokens.colors['sky'],
      tertiary: DesignTokens.colors['pink'],
      surface: brightness == Brightness.dark ? const Color(0xFF121821) : Colors.white.withOpacity(0.94),
      surfaceTint: _dynamicPrimary.withOpacity(brightness == Brightness.dark ? 0.18 : 0.38),
      outlineVariant: DesignTokens.colors['ink']!.withOpacity(brightness == Brightness.dark ? 0.24 : 0.08),
    );

    final base = ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      useMaterial3: true,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final bodyTheme = isArabic
        ? GoogleFonts.cairoTextTheme(base.textTheme)
        : GoogleFonts.interTextTheme(base.textTheme);
    final displayTheme = isArabic
        ? GoogleFonts.tajawalTextTheme(bodyTheme)
        : GoogleFonts.urbanistTextTheme(bodyTheme);

    final tooltipShadows = brightness == Brightness.dark
        ? DesignTokens.softShadowsDark
        : DesignTokens.softShadowsLight;

    final auraTheme = AuraTheme(
      backgroundGradient: brightness == Brightness.dark
          ? DesignTokens.gradients['background_dark']!
          : DesignTokens.gradients['background_light']!,
      cardGradient: brightness == Brightness.dark
          ? DesignTokens.gradients['card_dark']!
          : DesignTokens.gradients['card_light']!,
      dropShadows: brightness == Brightness.dark
          ? DesignTokens.softShadowsDark
          : DesignTokens.softShadowsLight,
    );

    final textColor = brightness == Brightness.dark ? Colors.white : DesignTokens.colors['ink'];

    var theme = base.copyWith(
      textTheme: displayTheme,
      primaryTextTheme: displayTheme,
      fontFamily: displayTheme.bodyMedium?.fontFamily,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? const Color(0xFF0B0C0E)
          : Color.alphaBlend(
              _dynamicPrimary.withOpacity(0.1),
              DesignTokens.colors['paper']!,
            ),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        systemOverlayStyle: brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        elevation: DesignTokens.elevations['md'],
        clipBehavior: Clip.antiAlias,
        shadowColor: colorScheme.shadow.withOpacity(brightness == Brightness.dark ? 0.4 : 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: colorScheme.surface,
      ),
      iconTheme: base.iconTheme.copyWith(
        color: brightness == Brightness.dark ? Colors.white : Colors.black.withOpacity(0.78),
      ),
      dividerColor: colorScheme.outlineVariant,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _dynamicPrimary,
        foregroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
        shape: const StadiumBorder(),
        elevation: DesignTokens.elevations['md'],
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark ? const Color(0x33FFFFFF) : DesignTokens.colors['mint']!,
        selectedColor: _dynamicPrimary.withOpacity(0.9),
        disabledColor: colorScheme.surfaceVariant.withOpacity(0.4),
        labelStyle: displayTheme.labelLarge?.copyWith(
          color: brightness == Brightness.dark ? Colors.white : textColor,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const StadiumBorder(),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.35 : 0.92),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: _dynamicPrimary, width: 1.6),
        ),
        labelStyle: displayTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.disabled)
                ? colorScheme.onSurfaceVariant.withOpacity(0.4)
                : _dynamicPrimary,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
          textStyle: MaterialStateProperty.all(displayTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
          side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(MaterialState.disabled)
                  ? colorScheme.outlineVariant
                  : _dynamicPrimary,
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        tileColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.5 : 0.75),
        selectedTileColor: _dynamicPrimary.withOpacity(0.12),
        iconColor: _dynamicPrimary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.94 : 0.96),
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(36))),
        showDragHandle: true,
      ),
      dialogTheme: DialogTheme(
        elevation: 6,
        backgroundColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.95 : 0.98),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface.withOpacity(0.92),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: displayTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: displayTheme.labelMedium?.copyWith(color: Colors.white),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: colorScheme.onSurface.withOpacity(0.9),
          shadows: tooltipShadows,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(false),
        thickness: MaterialStateProperty.all(4),
        radius: const Radius.circular(12),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _dynamicPrimary,
        circularTrackColor: colorScheme.surfaceVariant.withOpacity(0.4),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 74,
        elevation: 0,
        indicatorColor: _dynamicPrimary.withOpacity(0.15),
        backgroundColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.78 : 0.86),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final baseStyle = displayTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600);
          final color = states.contains(MaterialState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant.withOpacity(0.8);
          return baseStyle?.copyWith(color: color);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final color = states.contains(MaterialState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant.withOpacity(0.75);
          return IconThemeData(color: color, size: 24);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: _dynamicPrimary.withOpacity(0.18),
        useIndicator: true,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        selectedLabelTextStyle: displayTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelTextStyle: displayTheme.labelLarge,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: colorScheme.outlineVariant,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: colorScheme.outlineVariant),
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? _dynamicPrimary : colorScheme.surfaceVariant,
        ),
        checkColor: MaterialStateProperty.all(
          brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(_dynamicPrimary),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
          (states) => states.contains(MaterialState.selected) ? const Icon(Icons.check, size: 14) : null,
        ),
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colorScheme.onPrimary
              : colorScheme.surfaceVariant,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? _dynamicPrimary.withOpacity(0.6)
              : colorScheme.surfaceVariant.withOpacity(0.6),
        ),
      ),
      sliderTheme: base.sliderTheme.copyWith(
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        activeTrackColor: _dynamicPrimary,
        inactiveTrackColor: colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      extensions: <ThemeExtension<dynamic>>[auraTheme],
    );

    theme = theme.copyWith(
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: colorScheme.surface.withOpacity(brightness == Brightness.dark ? 0.75 : 0.9),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
      ),
    );

    return theme;
  }
}
