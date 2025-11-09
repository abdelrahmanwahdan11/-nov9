import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/preferences/prefs_service.dart';
import 'events_controller.dart';

class SourcesController extends ChangeNotifier {
  SourcesController(this._prefs, this._eventsController) {
    _hydrate();
  }

  final PrefsService _prefs;
  final EventsController _eventsController;
  Set<String> _enabled = {};

  Set<String> get enabled => _enabled;

  void toggle(String source) {
    final updated = Set<String>.from(_enabled);
    if (updated.contains(source)) {
      updated.remove(source);
    } else {
      updated.add(source);
    }
    _enabled = updated;
    _eventsController.updateSources(_enabled);
    _persist();
    notifyListeners();
  }

  void enableAll(Iterable<String> sources) {
    _enabled = sources.toSet();
    _eventsController.updateSources(_enabled);
    _persist();
    notifyListeners();
  }

  void _hydrate() {
    final stored = _prefs.enabledSources;
    _enabled = stored.toSet();
    _eventsController.updateSources(_enabled);
    notifyListeners();
  }

  void _persist() {
    unawaited(_prefs.setEnabledSources(_enabled.toList()));
  }
}
