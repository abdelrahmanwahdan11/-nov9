import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/preferences/prefs_service.dart';
import '../../data/models/saved_filter.dart';

class FiltersController extends ChangeNotifier {
  FiltersController(this._prefs) {
    _hydrate();
  }

  final PrefsService _prefs;
  final _filters = <SavedFilter>[];

  List<SavedFilter> get filters => List.unmodifiable(_filters);

  void addFilter(String name, SavedFilterKind kind, Map<String, dynamic> params) {
    final filter = SavedFilter(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      kind: kind,
      params: params,
    );
    _filters.add(filter);
    _persist();
    notifyListeners();
  }

  void updateFilter(SavedFilter filter) {
    final index = _filters.indexWhere((element) => element.id == filter.id);
    if (index != -1) {
      _filters[index] = filter;
      _persist();
      notifyListeners();
    }
  }

  void deleteFilter(String id) {
    _filters.removeWhere((filter) => filter.id == id);
    _persist();
    notifyListeners();
  }

  SavedFilter? byId(String id) {
    for (final filter in _filters) {
      if (filter.id == id) {
        return filter;
      }
    }
    return null;
  }

  void _hydrate() {
    final stored = _prefs.loadSavedFilters();
    _filters
      ..clear()
      ..addAll(stored.map(SavedFilter.fromJson));
    notifyListeners();
  }

  void _persist() {
    unawaited(_prefs.saveFilters(_filters.map((f) => f.toJson()).toList()));
  }
}
