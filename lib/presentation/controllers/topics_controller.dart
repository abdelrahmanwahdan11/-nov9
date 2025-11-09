import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/preferences/prefs_service.dart';
import '../../data/models/event.dart';
import 'events_controller.dart';

class TopicsController extends ChangeNotifier {
  TopicsController(this._prefs, this._eventsController) {
    _hydrate();
  }

  final PrefsService _prefs;
  final EventsController _eventsController;
  Set<EventCategory> _selected = EventCategory.values.toSet();

  Set<EventCategory> get selected => _selected;

  void toggle(EventCategory category) {
    final updated = Set<EventCategory>.from(_selected);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    if (updated.isEmpty) {
      updated.add(EventCategory.politics);
    }
    _selected = updated;
    _eventsController.updateTopics(_selected);
    _persist();
    notifyListeners();
  }

  void setAll(Set<EventCategory> categories) {
    _selected = categories.isEmpty ? EventCategory.values.toSet() : categories;
    _eventsController.updateTopics(_selected);
    _persist();
    notifyListeners();
  }

  void _hydrate() {
    final stored = _prefs.selectedTopics;
    final parsed = stored.map(_fromName).whereType<EventCategory>().toSet();
    if (parsed.isNotEmpty) {
      _selected = parsed;
      _eventsController.updateTopics(_selected);
    }
    notifyListeners();
  }

  EventCategory? _fromName(String name) {
    for (final category in EventCategory.values) {
      if (category.name == name) {
        return category;
      }
    }
    return null;
  }

  void _persist() {
    unawaited(_prefs.setSelectedTopics(_selected.map((e) => e.name).toList()));
  }
}
