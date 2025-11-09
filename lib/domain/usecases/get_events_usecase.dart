import '../../data/models/event.dart';
import '../../data/services/mock_event_service.dart';

class GetEventsUseCase {
  GetEventsUseCase(this._service);

  final MockEventService _service;

  Stream<List<Event>> call() => _service.stream;

  Future<List<Event>> fetchNext() => _service.fetchNextPage();

  void updateTopics(Set<EventCategory> topics) => _service.updateTopics(topics);

  void updateSources(List<String> sources) => _service.updateSources(sources);

  void updateDateRange({DateTime? start, DateTime? end}) =>
      _service.updateDateRange(start: start, end: end);

  void resetPagination() => _service.resetPagination();

  Future<List<Event>> getByDate(DateTime date) => _service.getByDate(date);

  List<Event> relatedTo(Event event) => _service.relatedTo(event);

  List<Event> search(
    String query, {
    Set<EventCategory>? categories,
    DateTime? start,
    DateTime? end,
    String? tag,
    Set<String>? sources,
  }) =>
      _service.search(
        query,
        categories: categories,
        start: start,
        end: end,
        tag: tag,
        sources: sources,
      );
}
