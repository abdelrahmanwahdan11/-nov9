import '../../data/models/event.dart';
import '../../data/models/item.dart';
import '../../data/services/search_service.dart';

class SearchUseCase {
  const SearchUseCase(this._service);

  final SearchService _service;

  ({List<SearchResult<Event>> events, List<SearchResult<Item>> items}) call(
    List<Event> events,
    List<Item> items,
    String query, {
    Set<EventCategory>? eventCategories,
    DateTime? start,
    DateTime? end,
    Set<String>? eventTags,
    Set<String>? eventSources,
    Set<ItemCondition>? itemConditions,
    bool? itemsForSale,
    double? minPrice,
    double? maxPrice,
  }) {
    return (
      events: _service.searchEvents(
        events,
        query,
        categories: eventCategories,
        start: start,
        end: end,
        tags: eventTags,
        sources: eventSources,
      ),
      items: _service.searchItems(
        items,
        query,
        conditions: itemConditions,
        forSale: itemsForSale,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
  }
}
