import '../models/event.dart';

class LocalArticleParser {
  const LocalArticleParser();

  static const _keepKeywords = [
    'politics',
    'government',
    'election',
    'diplomacy',
    'law',
    'art',
    'film',
    'music',
    'culture',
    'festival',
    'tech',
    'technology',
    'innovation',
    'economy',
    'geopolitics',
    'disaster',
    'climate',
  ];

  List<Event> parse(String article) {
    final lines = article.split(RegExp(r'\n{2,}'));
    final events = <Event>[];
    var index = 0;
    for (final paragraph in lines) {
      final lower = paragraph.toLowerCase();
      final containsKeyword = _keepKeywords.any(lower.contains);
      final containsFiltered = lower.contains('sport') || lower.contains('celebrity') || lower.contains('advert');
      if (paragraph.trim().isEmpty || !containsKeyword || containsFiltered) {
        continue;
      }
      index++;
      final headline = paragraph.split('.').first.trim();
      final summary = paragraph.trim();
      events.add(
        Event(
          id: 'parsed_$index',
          title: headline.isEmpty ? 'Update #$index' : headline,
          category: _detectCategory(lower),
          date: DateTime.now(),
          imageUrl: _imageForCategory(_detectCategory(lower)),
          summary: summary,
          details: summary,
          source: 'User parsed',
          tags: _extractTags(lower),
        ),
      );
    }
    return events;
  }

  EventCategory _detectCategory(String text) {
    if (text.contains('art') || text.contains('film') || text.contains('music') || text.contains('culture')) {
      return EventCategory.arts;
    }
    if (text.contains('world') || text.contains('global') || text.contains('disaster') || text.contains('economy')) {
      return EventCategory.world;
    }
    return EventCategory.politics;
  }

  List<String> _extractTags(String text) {
    final tags = <String>[];
    for (final keyword in _keepKeywords) {
      if (text.contains(keyword)) {
        tags.add(keyword);
      }
    }
    return tags.isEmpty ? ['daily', 'update'] : tags;
  }

  String _imageForCategory(EventCategory category) {
    switch (category) {
      case EventCategory.politics:
        return 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee';
      case EventCategory.arts:
        return 'https://images.unsplash.com/photo-1469474968028-56623f02e42e';
      case EventCategory.world:
        return 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d';
    }
  }
}
