import '../../data/models/event.dart';
import '../../data/models/item.dart';
import '../../data/services/search_service.dart';

class SearchUseCase {
  const SearchUseCase(this._service);

  final SearchService _service;

  ({List<SearchResult<Event>> events, List<SearchResult<Item>> items}) call(
    List<Event> events,
    List<Item> items,
    String query,
  ) {
    return (
      events: _service.searchEvents(events, query),
      items: _service.searchItems(items, query),
    );
  }
}
