import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../domain/usecases/get_events_usecase.dart';

class HistoryController extends ChangeNotifier {
  HistoryController(this._getEvents) {
    loadFor(DateTime.now());
  }

  final GetEventsUseCase _getEvents;
  DateTime _selectedDate = DateTime.now();
  List<Event> _events = const [];
  bool _loading = false;

  DateTime get selectedDate => _selectedDate;
  List<Event> get events => _events;
  bool get isLoading => _loading;

  Future<void> loadFor(DateTime date) async {
    _loading = true;
    notifyListeners();
    final fetched = await _getEvents.getByDate(date);
    _events = fetched;
    _selectedDate = date;
    _loading = false;
    notifyListeners();
  }
}
