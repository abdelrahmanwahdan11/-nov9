import '../models/event.dart';
import '../models/item.dart';

class SearchResult<T> {
  const SearchResult({required this.item, required this.score});
  final T item;
  final double score;
}

class SearchService {
  const SearchService();

  List<SearchResult<Event>> searchEvents(List<Event> events, String query) {
    final lower = query.toLowerCase();
    return events
        .map(
          (event) => SearchResult(
            item: event,
            score: _matchScore(lower, [
              event.title,
              event.summary,
              event.details,
              event.tags.join(' '),
            ]),
          ),
        )
        .where((result) => result.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  List<SearchResult<Item>> searchItems(List<Item> items, String query) {
    final lower = query.toLowerCase();
    return items
        .map(
          (item) => SearchResult(
            item: item,
            score: _matchScore(lower, [
              item.name,
              item.specs.values.join(' '),
              item.notes ?? '',
              item.offers.map((offer) => offer.message ?? '').join(' '),
            ]),
          ),
        )
        .where((result) => result.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  double _matchScore(String query, List<String> haystacks) {
    if (query.isEmpty) {
      return 0;
    }
    var score = 0.0;
    for (final text in haystacks) {
      final lower = text.toLowerCase();
      if (lower.contains(query)) {
        score += query.length / (lower.length + 1);
      }
    }
    return score;
  }
}
