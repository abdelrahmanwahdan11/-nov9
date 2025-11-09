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
}
