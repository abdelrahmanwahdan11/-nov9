import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/refresh_events_usecase.dart';

class EventsController extends ChangeNotifier {
  EventsController(this._getEvents, this._refresh) {
    _subscription = _getEvents().listen(_onData);
  }

  final GetEventsUseCase _getEvents;
  final RefreshEventsUseCase _refresh;
  late final StreamSubscription<List<Event>> _subscription;

  final _events = <Event>[];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  EventCategory? _filter;

  List<Event> get events => _filteredEvents();
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  EventCategory? get filter => _filter;

  void _onData(List<Event> data) {
    _events
      ..clear()
      ..addAll(_sortByCategory(data));
    notifyListeners();
  }

  Future<void> refresh({String? article}) async {
    _isLoading = true;
    notifyListeners();
    await _refresh.call(article: article);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    _isFetchingMore = true;
    notifyListeners();
    final next = await _getEvents.fetchNext();
    _events
      ..clear()
      ..addAll(_sortByCategory(next));
    _isFetchingMore = false;
    notifyListeners();
  }

  void setFilter(EventCategory? category) {
    _filter = category;
    notifyListeners();
  }

  List<Event> _filteredEvents() {
    if (_filter == null) return List<Event>.unmodifiable(_events);
    return _events.where((event) => event.category == _filter).toList();
  }

  List<Event> _sortByCategory(List<Event> events) {
    final politics = events.where((event) => event.category == EventCategory.politics);
    final arts = events.where((event) => event.category == EventCategory.arts);
    final world = events.where((event) => event.category == EventCategory.world);
    return [
      ...politics,
      ...arts,
      ...world,
    ];
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
