import '../../data/models/historical_event.dart';
import '../../data/services/on_this_day_service.dart';

class OnThisDayPayload {
  const OnThisDayPayload({
    required this.events,
    required this.countries,
    required this.types,
  });

  final List<HistoricalEvent> events;
  final List<String> countries;
  final List<HistoricalEventType> types;
}

class GetOnThisDayUseCase {
  const GetOnThisDayUseCase(this._service);

  final MockOnThisDayService _service;

  Future<OnThisDayPayload> call(
    DateTime date, {
    String? country,
    Set<HistoricalEventType>? types,
  }) async {
    final filteredEvents = _service.getEventsFor(
      date,
      country: country,
      types: types,
    );
    final countries = _service.getCountries();
    final availableTypes = _service.getTypes();
    return OnThisDayPayload(
      events: filteredEvents,
      countries: countries,
      types: availableTypes,
    );
  }
}
