import '../models/event.dart';
import '../models/item.dart';

class SearchResult<T> {
  const SearchResult({required this.item, required this.score});
  final T item;
  final double score;
}

class SearchService {
  const SearchService();

  List<SearchResult<Event>> searchEvents(
    List<Event> events,
    String query, {
    Set<EventCategory>? categories,
    DateTime? start,
    DateTime? end,
    Set<String>? tags,
    Set<String>? sources,
  }) {
    final lower = query.toLowerCase();
    return events
        .where((event) {
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
          if (tags != null && tags.isNotEmpty && event.tags.toSet().intersection(tags).isEmpty) {
            return false;
          }
          return true;
        })
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

  List<SearchResult<Item>> searchItems(
    List<Item> items,
    String query, {
    Set<ItemCondition>? conditions,
    bool? forSale,
    double? minPrice,
    double? maxPrice,
  }) {
    final lower = query.toLowerCase();
    return items
        .where((item) {
          if (conditions != null && conditions.isNotEmpty && !conditions.contains(item.condition)) {
            return false;
          }
          if (forSale != null && item.forSale != forSale) {
            return false;
          }
          final price = item.askingPrice ?? item.targetPrice;
          if (minPrice != null && (price == null || price < minPrice)) {
            return false;
          }
          if (maxPrice != null && (price == null || price > maxPrice)) {
            return false;
          }
          return true;
        })
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
