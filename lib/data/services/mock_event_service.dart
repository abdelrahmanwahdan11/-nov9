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
  int _currentPage = 0;

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
    _events
      ..clear()
      ..addAll([...parsed, ..._politicsSeed, ..._artsSeed, ..._worldSeed]);
    _currentPage = 0;
    _emit();
  }

  Future<List<Event>> fetchNextPage() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final start = _currentPage * _pageSize;
    final end = start + _pageSize;
    _currentPage++;
    return _events.sublist(0, end > _events.length ? _events.length : end);
  }

  void _emit() {
    final end = (_currentPage + 1) * _pageSize;
    final current = _events.sublist(0, end > _events.length ? _events.length : end);
    _controller.add(current);
  }

  void dispose() {
    _controller.close();
  }

  static List<Event> get _politicsSeed => List.generate(6, (index) {
        return Event(
          id: 'politics_$index',
          title: 'Policy shift #$index',
          category: EventCategory.politics,
          date: DateTime.now(),
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
          date: DateTime.now(),
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
          date: DateTime.now(),
          imageUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
          summary: 'Global communities respond to event #$index',
          details: 'Geopolitical insights, climate, and human stories for event #$index.',
          source: 'World Report',
          location: 'Worldwide',
          tags: ['global', 'economy', 'climate'],
        );
      });
}
