import '../../data/models/event.dart';
import '../../data/services/mock_event_service.dart';

class GetEventsUseCase {
  GetEventsUseCase(this._service);

  final MockEventService _service;

  Stream<List<Event>> call() => _service.stream;

  Future<List<Event>> fetchNext() => _service.fetchNextPage();
}
