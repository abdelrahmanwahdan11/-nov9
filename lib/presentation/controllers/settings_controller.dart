import 'package:flutter/material.dart';

import '../../core/preferences/prefs_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs);

  final PrefsService _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  Color? _primaryColor;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  Color? get primaryColor => _primaryColor;

  Future<void> load() async {
    _themeMode = _prefs.themeMode;
    _locale = _prefs.locale;
    _primaryColor = _prefs.primaryColor;
    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;
    await _prefs.setLocale(locale);
    notifyListeners();
  }

  Future<void> changePrimary(Color color) async {
    _primaryColor = color;
    await _prefs.setPrimaryColor(color);
    notifyListeners();
  }

  Future<void> clearData() async {
    await _prefs.clearMockData();
    notifyListeners();
  }
}
