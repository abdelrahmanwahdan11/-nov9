import '../../data/models/event.dart';
import '../../data/models/item.dart';
import '../../data/models/scenario_plan.dart';
import '../../data/services/scenario_service.dart';

class GetScenariosUseCase {
  const GetScenariosUseCase(this._service);

  final ScenarioService _service;

  List<ScenarioPlan> call({
    required List<Event> events,
    required List<Item> items,
    required ScenarioFocus focus,
    required double ambition,
    required double resilience,
  }) {
    return _service.generate(
      events: events,
      items: items,
      focus: focus,
      ambition: ambition,
      resilience: resilience,
    );
  }
}
