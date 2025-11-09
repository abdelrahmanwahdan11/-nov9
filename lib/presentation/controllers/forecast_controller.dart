import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../data/services/forecast_service.dart';
import 'events_controller.dart';

class ForecastController extends ChangeNotifier {
  ForecastController(this._service, this._eventsController) {
    _eventsController.addListener(_onEventsChanged);
    _rebuild();
  }

  final ForecastService _service;
  final EventsController _eventsController;

  double _optimism = 0.6;
  double _volatility = 0.4;
  int _horizonDays = 3;
  EventCategory _focus = EventCategory.politics;
  ForecastSummary? _summary;

  double get optimism => _optimism;
  double get volatility => _volatility;
  int get horizonDays => _horizonDays;
  EventCategory get focus => _focus;
  ForecastSummary? get summary => _summary;

  void reset() {
    _optimism = 0.6;
    _volatility = 0.4;
    _horizonDays = 3;
    _focus = EventCategory.politics;
    _rebuild();
  }

  void setOptimism(double value) {
    final next = value.clamp(0, 1).toDouble();
    if (next == _optimism) return;
    _optimism = next;
    _rebuild();
  }

  void setVolatility(double value) {
    final next = value.clamp(0, 1).toDouble();
    if (next == _volatility) return;
    _volatility = next;
    _rebuild();
  }

  void setHorizon(double value) {
    final days = value.round().clamp(1, 7).toInt();
    if (days == _horizonDays) return;
    _horizonDays = days;
    _rebuild();
  }

  void setFocus(EventCategory category) {
    if (category == _focus) return;
    _focus = category;
    _rebuild();
  }

  void _onEventsChanged() {
    _rebuild();
  }

  void _rebuild() {
    final events = _eventsController.events;
    _summary = _service.build(
      events: events,
      optimism: _optimism,
      volatility: _volatility,
      focus: _focus,
      horizonDays: _horizonDays,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _eventsController.removeListener(_onEventsChanged);
    super.dispose();
  }
}
