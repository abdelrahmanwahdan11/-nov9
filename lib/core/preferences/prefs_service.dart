import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsKeys {
  static const themeMode = 'theme_mode';
  static const language = 'language';
  static const primaryColor = 'primary_color';
  static const items = 'items';
  static const viewedTips = 'viewed_tips';
}

class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsService(prefs);
  }

  ThemeMode get themeMode {
    final value = _prefs.getString(PrefsKeys.themeMode);
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(PrefsKeys.themeMode, mode.name);
  }

  Locale get locale {
    final value = _prefs.getString(PrefsKeys.language);
    if (value == null) {
      return const Locale('en');
    }
    return Locale(value);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(PrefsKeys.language, locale.languageCode);
  }

  Color? get primaryColor {
    final value = _prefs.getString(PrefsKeys.primaryColor);
    if (value == null) return null;
    return Color(int.parse(value));
  }

  Future<void> setPrimaryColor(Color color) async {
    await _prefs.setString(PrefsKeys.primaryColor, color.value.toString());
  }

  List<String> get viewedTips => _prefs.getStringList(PrefsKeys.viewedTips) ?? <String>[];

  Future<void> setViewedTips(List<String> tips) async {
    await _prefs.setStringList(PrefsKeys.viewedTips, tips);
  }

  Future<void> clearMockData() async {
    await _prefs.remove(PrefsKeys.items);
  }

  Future<void> saveItems(List<Map<String, dynamic>> items) async {
    await _prefs.setString(PrefsKeys.items, jsonEncode(items));
  }

  List<Map<String, dynamic>> loadItems() {
    final data = _prefs.getString(PrefsKeys.items);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
