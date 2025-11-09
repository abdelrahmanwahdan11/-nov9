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
    final normalized = query.trim().toLowerCase();
    final results = events
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
            score: _matchScore(normalized, [
              event.title,
              event.summary,
              event.details,
              event.tags.join(' '),
            ]),
          ),
        )
        .where((result) => result.score > 0)
        .toList();
    results.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return b.item.date.compareTo(a.item.date);
    });
    return results;
  }

  List<SearchResult<Item>> searchItems(
    List<Item> items,
    String query, {
    Set<ItemCondition>? conditions,
    bool? forSale,
    double? minPrice,
    double? maxPrice,
  }) {
    final normalized = query.trim().toLowerCase();
    final results = items
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
            score: _matchScore(normalized, [
              item.name,
              item.specs.values.join(' '),
              item.notes ?? '',
              item.offers.map((offer) => offer.message ?? '').join(' '),
            ]),
          ),
        )
        .where((result) => result.score > 0)
        .toList();
    results.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      if (a.item.forSale != b.item.forSale) {
        return b.item.forSale ? 1 : -1;
      }
      final aPrice = a.item.askingPrice ?? a.item.targetPrice ?? 0;
      final bPrice = b.item.askingPrice ?? b.item.targetPrice ?? 0;
      return bPrice.compareTo(aPrice);
    });
    return results;
  }

  double _matchScore(String query, List<String> haystacks) {
    if (query.isEmpty) {
      return 1;
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
