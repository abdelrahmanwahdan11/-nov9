import 'package:flutter/material.dart';

import '../../data/models/scenario_plan.dart';
import '../../domain/usecases/get_scenarios_usecase.dart';
import 'events_controller.dart';
import 'items_controller.dart';

class ScenarioController extends ChangeNotifier {
  ScenarioController(this._getScenarios, this._eventsController, this._itemsController) {
    _eventsController.addListener(_rebuild);
    _itemsController.addListener(_rebuild);
    _rebuild();
  }

  final GetScenariosUseCase _getScenarios;
  final EventsController _eventsController;
  final ItemsController _itemsController;

  ScenarioFocus _focus = ScenarioFocus.politics;
  double _ambition = 0.55;
  double _resilience = 0.5;
  List<ScenarioPlan> _scenarios = const [];

  ScenarioFocus get focus => _focus;
  double get ambition => _ambition;
  double get resilience => _resilience;
  List<ScenarioPlan> get scenarios => List.unmodifiable(_scenarios);

  void setFocus(ScenarioFocus value) {
    if (_focus == value) return;
    _focus = value;
    _rebuild();
  }

  void setAmbition(double value) {
    final next = value.clamp(0, 1).toDouble();
    if (next == _ambition) return;
    _ambition = next;
    _rebuild();
  }

  void setResilience(double value) {
    final next = value.clamp(0, 1).toDouble();
    if (next == _resilience) return;
    _resilience = next;
    _rebuild();
  }

  void reset() {
    _focus = ScenarioFocus.politics;
    _ambition = 0.55;
    _resilience = 0.5;
    _rebuild();
  }

  void _rebuild() {
    final events = _eventsController.events;
    final items = _itemsController.items;
    _scenarios = _getScenarios(
      events: events,
      items: items,
      focus: _focus,
      ambition: _ambition,
      resilience: _resilience,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _eventsController.removeListener(_rebuild);
    _itemsController.removeListener(_rebuild);
    super.dispose();
  }
}
