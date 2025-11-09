import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  static const Map<String, Color> colors = {
    'dynamic_primary': Color(0xFF8CE24F),
    'lime': Color(0xFFD9FF5E),
    'mint': Color(0xFFCFF7E9),
    'sky': Color(0xFFAEE5FF),
    'pink': Color(0xFFFFD7EA),
    'blue': Color(0xFF5BB7FF),
    'ink': Color(0xFF0E0F11),
    'paper': Color(0xFFF7F9FB),
  };

  static const Map<String, Color> darkCardPalette = {
    'politics': Color(0xFF173B3F),
    'arts': Color(0xFF361F35),
    'world': Color(0xFF10253E),
    'accent': Color(0xFF2D3E12),
  };

  static const borderRadius = {
    'sm': Radius.circular(12),
    'md': Radius.circular(20),
    'lg': Radius.circular(28),
    'xl': Radius.circular(36),
  };

  static const spacing = [4.0, 8.0, 12.0, 16.0, 20.0, 24.0, 32.0];

  static const elevations = {
    'sm': 2.0,
    'md': 6.0,
    'lg': 12.0,
  };

  static const Map<String, Gradient> gradients = {
    'background_light': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F9FB),
        Color(0xFFE4FFF4),
        Color(0xFFE1F4FF),
      ],
    ),
    'background_dark': LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0B0C0E),
        Color(0xFF111A23),
        Color(0xFF0F2330),
      ],
    ),
    'card_light': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFEFFDF5),
        Color(0xFFEAF6FF),
      ],
    ),
    'card_dark': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF14202A),
        Color(0xFF172C3B),
        Color(0xFF20354A),
      ],
    ),
  };

  static const softShadowsLight = <BoxShadow>[
    BoxShadow(
      color: Color(0x190E0F11),
      blurRadius: 28,
      spreadRadius: 1,
      offset: Offset(0, 18),
    ),
    BoxShadow(
      color: Color(0x145BB7FF),
      blurRadius: 48,
      spreadRadius: -6,
      offset: Offset(0, 32),
    ),
  ];

  static const softShadowsDark = <BoxShadow>[
    BoxShadow(
      color: Color(0x55000000),
      blurRadius: 36,
      spreadRadius: -4,
      offset: Offset(0, 28),
    ),
  ];
}
