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
  Set<EventCategory> _topics = EventCategory.values.toSet();
  Set<String> _sources = {};
  DateTimeRange? _dateRange;
  String? _activeTag;

  List<Event> get events => _filteredEvents();
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  EventCategory? get filter => _filter;
  Set<EventCategory> get topics => _topics;
  Set<String> get sources => _sources;
  DateTimeRange? get dateRange => _dateRange;
  String? get activeTag => _activeTag;

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

  void setTagFilter(String? tag) {
    _activeTag = tag;
    notifyListeners();
  }

  void updateTopics(Set<EventCategory> topics) {
    _topics = topics.isEmpty ? EventCategory.values.toSet() : topics;
    _getEvents.updateTopics(_topics);
    _getEvents.resetPagination();
    notifyListeners();
  }

  void updateSources(Set<String> sources) {
    _sources = sources;
    _getEvents.updateSources(sources.toList());
    _getEvents.resetPagination();
    notifyListeners();
  }

  void updateDateRange(DateTimeRange? range) {
    _dateRange = range;
    _getEvents.updateDateRange(start: range?.start, end: range?.end);
    _getEvents.resetPagination();
    notifyListeners();
  }

  List<Event> relatedFor(Event event) => _getEvents.relatedTo(event);

  List<Event> search(
    String query, {
    Set<EventCategory>? categories,
    DateTime? start,
    DateTime? end,
    String? tag,
    Set<String>? sources,
  }) {
    return _getEvents.search(
      query,
      categories: categories,
      start: start,
      end: end,
      tag: tag,
      sources: sources,
    );
  }

  List<Event> _filteredEvents() {
    Iterable<Event> data = _events;
    if (_filter != null) {
      data = data.where((event) => event.category == _filter);
    }
    if (_activeTag != null && _activeTag!.isNotEmpty) {
      data = data.where((event) => event.tags.contains(_activeTag));
    }
    return data.toList();
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
