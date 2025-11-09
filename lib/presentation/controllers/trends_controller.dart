import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../data/services/stats_service.dart';

class TrendsController extends ChangeNotifier {
  TrendsController(this._statsService);

  final StatsService _statsService;
  StatsSnapshot? _snapshot;

  StatsSnapshot? get snapshot => _snapshot;

  void update(List<Event> events) {
    _snapshot = _statsService.buildSnapshot(events);
    notifyListeners();
  }
}
