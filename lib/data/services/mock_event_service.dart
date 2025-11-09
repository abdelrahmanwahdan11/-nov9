import 'dart:async';

import '../models/event.dart';

class MockEventService {
  MockEventService() {
    _seed();
  }

  final _controller = StreamController<List<Event>>.broadcast();
  final _events = <Event>[];

  Stream<List<Event>> get stream => _controller.stream;

  final _pageSize = 10;
  int _loadedPages = 1;
  Set<EventCategory> _topicsFilter = EventCategory.values.toSet();
  Set<String>? _sourcesFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  void _seed() {
    final seeds = <Event>[
      ..._politicsSeed,
      ..._artsSeed,
      ..._worldSeed,
    ];
    _events
      ..clear()
      ..addAll(seeds);
    _emit();
  }

  Future<void> refresh(List<Event> parsed) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final existingIds = parsed.map((event) => event.id).toSet();
    final remaining = [
      ..._politicsSeed,
      ..._artsSeed,
      ..._worldSeed,
    ].where((event) => !existingIds.contains(event.id));
    _events
      ..clear()
      ..addAll([...parsed, ...remaining]);
    _loadedPages = 1;
    _emit();
  }

  Future<List<Event>> fetchNextPage() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _loadedPages++;
    final filtered = _sorted(_applyFilters());
    final limit = _pageLimit(filtered.length);
    return filtered.take(limit).toList();
  }

  Future<List<Event>> getByDate(DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _sorted(
      _events.where(
        (event) => !event.date.isBefore(start) && event.date.isBefore(end),
      ),
    );
  }

  List<Event> relatedTo(Event event) {
    final related = _events.where((candidate) {
      if (candidate.id == event.id) return false;
      if (candidate.category != event.category) {
        final sharedTags = candidate.tags.toSet().intersection(event.tags.toSet());
        return sharedTags.isNotEmpty;
      }
      return true;
    }).toList();
    return _sorted(related).take(6).toList();
  }

  List<Event> search(
    String query, {
    Set<EventCategory>? categories,
    DateTime? start,
    DateTime? end,
    String? tag,
    Set<String>? sources,
  }) {
    final normalized = query.trim().toLowerCase();
    final matches = _events.where((event) {
      if (categories != null && categories.isNotEmpty && !categories.contains(event.category)) {
        return false;
      }
      if (sources != null && sources.isNotEmpty && !sources.contains(event.source)) {
        return false;
      }
      if (start != null && event.date.isBefore(start)) {
        return false;
      }
      if (end != null && event.date.isAfter(end)) {
        return false;
      }
      if (tag != null && tag.isNotEmpty && !event.tags.contains(tag)) {
        return false;
      }
      if (normalized.isEmpty) {
        return true;
      }
      final haystack = '${event.title} ${event.summary} ${event.details} ${event.tags.join(' ')}'.toLowerCase();
      return haystack.contains(normalized);
    });
    return _sorted(matches);
  }

  void updateTopics(Set<EventCategory> topics) {
    _topicsFilter = topics.isEmpty ? EventCategory.values.toSet() : topics;
    _loadedPages = 1;
    _emit();
  }

  void updateSources(List<String> sources) {
    _sourcesFilter = sources.isEmpty ? null : sources.toSet();
    _loadedPages = 1;
    _emit();
  }

  void updateDateRange({DateTime? start, DateTime? end}) {
    _startDate = start;
    _endDate = end;
    _loadedPages = 1;
    _emit();
  }

  void resetPagination() {
    _loadedPages = 1;
    _emit();
  }

  void _emit() {
    final filtered = _sorted(_applyFilters());
    final limit = _pageLimit(filtered.length);
    _controller.add(filtered.take(limit).toList());
  }

  int _pageLimit(int total) {
    final limit = _loadedPages * _pageSize;
    return limit > total ? total : limit;
  }

  Iterable<Event> _applyFilters() {
    return _events.where((event) {
      if (!_topicsFilter.contains(event.category)) {
        return false;
      }
      if (_sourcesFilter != null && _sourcesFilter!.isNotEmpty && !_sourcesFilter!.contains(event.source)) {
        return false;
      }
      if (_startDate != null && event.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && event.date.isAfter(_endDate!)) {
        return false;
      }
      return true;
    });
  }

  List<Event> _sorted(Iterable<Event> events) {
    final list = events.toList();
    list.sort((a, b) {
      int weight(Event event) {
        switch (event.category) {
          case EventCategory.politics:
            return 0;
          case EventCategory.arts:
            return 1;
          case EventCategory.world:
            return 2;
        }
      }

      final categoryCompare = weight(a).compareTo(weight(b));
      if (categoryCompare != 0) {
        return categoryCompare;
      }
      return b.date.compareTo(a.date);
    });
    return list;
  }

  void dispose() {
    _controller.close();
  }

  static List<Event> get _politicsSeed => List.generate(6, (index) {
        return Event(
          id: 'politics_$index',
          title: 'Policy shift #$index',
          category: EventCategory.politics,
          date: DateTime.now().subtract(Duration(hours: index * 4)),
          imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
          summary: 'Leaders convene to discuss policy shift #$index',
          details: 'Detailed insights about the policy shift #$index and its regional implications.',
          source: 'Global Politics',
          location: 'Capital City',
          tags: ['policy', 'government', 'diplomacy'],
        );
      });

  static List<Event> get _artsSeed => List.generate(6, (index) {
        return Event(
          id: 'arts_$index',
          title: 'Festival highlight #$index',
          category: EventCategory.arts,
          date: DateTime.now().subtract(Duration(hours: index * 5 + 1)),
          imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
          summary: 'Artists collaborate for festival highlight #$index',
          details: 'Artistic narratives and cultural stories from highlight #$index.',
          source: 'Art Daily',
          location: 'Gallery District',
          tags: ['culture', 'art', 'festival'],
        );
      });

  static List<Event> get _worldSeed => List.generate(6, (index) {
        return Event(
          id: 'world_$index',
          title: 'Global watch #$index',
          category: EventCategory.world,
          date: DateTime.now().subtract(Duration(hours: index * 6 + 2)),
          imageUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
          summary: 'Global communities respond to event #$index',
          details: 'Geopolitical insights, climate, and human stories for event #$index.',
          source: 'World Report',
          location: 'Worldwide',
          tags: ['global', 'economy', 'climate'],
        );
      });
}
