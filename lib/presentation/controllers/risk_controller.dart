import 'package:flutter/material.dart';

import '../../data/models/risk_signal.dart';
import '../../data/services/risk_service.dart';
import 'events_controller.dart';
import 'items_controller.dart';

class RiskController extends ChangeNotifier {
  RiskController(this._service, this._eventsController, this._itemsController) {
    _eventsController.addListener(_onSourceChanged);
    _itemsController.addListener(_onSourceChanged);
  }

  final RiskService _service;
  final EventsController _eventsController;
  final ItemsController _itemsController;

  RiskOutlook _outlook = const RiskOutlook(
    signals: [],
    heatMap: {},
    averageSeverity: 0,
    watchlist: [],
    momentum: [],
  );
  bool _isLoading = false;
  bool _hasPending = false;
  RiskCategory? _focus;

  bool get isLoading => _isLoading;
  Map<RiskCategory, double> get heatMap => _outlook.heatMap;
  double get averageSeverity => _outlook.averageSeverity;
  RiskCategory? get focus => _focus;
  List<RiskMomentumPoint> get momentum => _outlook.momentum;

  List<RiskSignal> get signals {
    if (_focus == null) {
      return _outlook.signals;
    }
    return _outlook.signals.where((signal) => signal.category == _focus).toList();
  }

  List<RiskSignal> get spotlightSignals => (signals.toList()
        ..sort((a, b) => b.severity.compareTo(a.severity)))
      .take(3)
      .toList();

  List<RiskSignal> get watchlist => _outlook.watchlist;

  List<String> get recommendedActions => signals.map((signal) => signal.recommendation).toSet().toList();

  Future<void> initialize() async => _recompute();

  Future<void> refresh() async => _recompute();

  void setFocus(RiskCategory? category) {
    if (_focus == category) {
      return;
    }
    _focus = category;
    notifyListeners();
  }

  void _onSourceChanged() {
    if (_isLoading) {
      _hasPending = true;
      return;
    }
    _recompute();
  }

  Future<void> _recompute() async {
    _isLoading = true;
    notifyListeners();
    final outlook = _service.buildOutlook(
      events: _eventsController.events,
      items: _itemsController.items,
    );
    _outlook = outlook;
    _isLoading = false;
    notifyListeners();
    if (_hasPending) {
      _hasPending = false;
      await _recompute();
    }
  }

  @override
  void dispose() {
    _eventsController.removeListener(_onSourceChanged);
    _itemsController.removeListener(_onSourceChanged);
    super.dispose();
  }
}
