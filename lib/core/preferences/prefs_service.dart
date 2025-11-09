import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsKeys {
  static const themeMode = 'theme_mode';
  static const language = 'language';
  static const primaryColor = 'primary_color';
  static const items = 'items';
  static const viewedTips = 'viewed_tips';
  static const selectedTopics = 'selected_topics';
  static const enabledSources = 'enabled_sources';
  static const bookmarks = 'bookmarks';
  static const savedFilters = 'saved_filters';
  static const seenTips = 'seen_tips';
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

  Future<void> clearPrimaryColor() async {
    await _prefs.remove(PrefsKeys.primaryColor);
  }

  List<String> get viewedTips => _prefs.getStringList(PrefsKeys.viewedTips) ?? <String>[];

  Future<void> setViewedTips(List<String> tips) async {
    await _prefs.setStringList(PrefsKeys.viewedTips, tips);
  }

  List<String> get selectedTopics =>
      _prefs.getStringList(PrefsKeys.selectedTopics) ?? const ['politics', 'arts', 'world'];

  Future<void> setSelectedTopics(List<String> topics) async {
    await _prefs.setStringList(PrefsKeys.selectedTopics, topics);
  }

  List<String> get enabledSources =>
      _prefs.getStringList(PrefsKeys.enabledSources) ?? const ['Global Politics', 'Art Daily', 'World Report'];

  Future<void> setEnabledSources(List<String> sources) async {
    await _prefs.setStringList(PrefsKeys.enabledSources, sources);
  }

  List<String> get bookmarks => _prefs.getStringList(PrefsKeys.bookmarks) ?? <String>[];

  Future<void> setBookmarks(List<String> ids) async {
    await _prefs.setStringList(PrefsKeys.bookmarks, ids);
  }

  List<Map<String, dynamic>> loadSavedFilters() {
    final raw = _prefs.getString(PrefsKeys.savedFilters);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((entry) => Map<String, dynamic>.from(entry as Map)).toList();
  }

  Future<void> saveFilters(List<Map<String, dynamic>> filters) async {
    await _prefs.setString(PrefsKeys.savedFilters, jsonEncode(filters));
  }

  List<String> get seenTips => _prefs.getStringList(PrefsKeys.seenTips) ?? <String>[];

  Future<void> setSeenTips(List<String> tips) async {
    await _prefs.setStringList(PrefsKeys.seenTips, tips);
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

  Future<String> exportBackup() async {
    final backup = <String, dynamic>{
      PrefsKeys.themeMode: _prefs.getString(PrefsKeys.themeMode),
      PrefsKeys.language: _prefs.getString(PrefsKeys.language),
      PrefsKeys.primaryColor: _prefs.getString(PrefsKeys.primaryColor),
      PrefsKeys.items: _prefs.getString(PrefsKeys.items),
      PrefsKeys.viewedTips: _prefs.getStringList(PrefsKeys.viewedTips),
      PrefsKeys.selectedTopics: _prefs.getStringList(PrefsKeys.selectedTopics),
      PrefsKeys.enabledSources: _prefs.getStringList(PrefsKeys.enabledSources),
      PrefsKeys.bookmarks: _prefs.getStringList(PrefsKeys.bookmarks),
      PrefsKeys.savedFilters: _prefs.getString(PrefsKeys.savedFilters),
      PrefsKeys.seenTips: _prefs.getStringList(PrefsKeys.seenTips),
    };
    return jsonEncode(backup);
  }

  Future<void> restoreBackup(String json) async {
    final data = jsonDecode(json) as Map<String, dynamic>;
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value == null) {
        await _prefs.remove(key);
        continue;
      }
      if (value is List) {
        await _prefs.setStringList(key, value.cast<String>());
      } else if (value is String) {
        await _prefs.setString(key, value);
      }
    }
  }
}
