import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/preferences/prefs_service.dart';

class BookmarksController extends ChangeNotifier {
  BookmarksController(this._prefs) {
    _hydrate();
  }

  final PrefsService _prefs;
  final _bookmarks = <String>{};

  Set<String> get bookmarks => _bookmarks;

  bool isBookmarked(String id) => _bookmarks.contains(id);

  void toggle(String id) {
    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
    } else {
      _bookmarks.add(id);
    }
    _persist();
    notifyListeners();
  }

  void setAll(Iterable<String> ids) {
    _bookmarks
      ..clear()
      ..addAll(ids);
    _persist();
    notifyListeners();
  }

  void _hydrate() {
    final stored = _prefs.bookmarks;
    _bookmarks
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  void _persist() {
    unawaited(_prefs.setBookmarks(_bookmarks.toList()));
  }
}
