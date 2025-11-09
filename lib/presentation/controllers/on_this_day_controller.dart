import 'package:flutter/material.dart';

import '../../data/models/historical_event.dart';
import '../../domain/usecases/get_on_this_day_usecase.dart';

class OnThisDayController extends ChangeNotifier {
  OnThisDayController(this._useCase);

  final GetOnThisDayUseCase _useCase;

  DateTime _selectedDate = DateTime.now();
  String? _selectedCountry;
  final Set<HistoricalEventType> _selectedTypes = {};
  bool _loading = false;
  List<HistoricalEvent> _events = const [];
  List<String> _countries = const [];
  List<HistoricalEventType> _types = HistoricalEventType.values;
  bool _initialized = false;

  DateTime get selectedDate => _selectedDate;
  String? get selectedCountry => _selectedCountry;
  Set<HistoricalEventType> get selectedTypes => Set.unmodifiable(_selectedTypes);
  bool get isLoading => _loading;
  bool get initialized => _initialized;
  List<HistoricalEvent> get events => List.unmodifiable(_events);
  List<String> get countries => List.unmodifiable(_countries);
  List<HistoricalEventType> get types => List.unmodifiable(_types);

  Future<void> load({bool force = false}) async {
    if (_loading) return;
    if (!force && _initialized) {
      await _refresh();
      notifyListeners();
      return;
    }
    _loading = true;
    notifyListeners();
    await _refresh();
    _loading = false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> _refresh() async {
    try {
      final payload = await _useCase(
        _selectedDate,
        country: _selectedCountry,
        types: _selectedTypes.isEmpty ? null : _selectedTypes,
      );
      _events = payload.events;
      _countries = payload.countries;
      _types = payload.types;
    } catch (_) {
      _events = const [];
    }
  }

  Future<void> setDate(DateTime date) async {
    _selectedDate = DateTime(date.year, date.month, date.day);
    await load(force: true);
  }

  Future<void> selectToday() async {
    await setDate(DateTime.now());
  }

  Future<void> setCountry(String? country) async {
    final normalized = country == null || country.isEmpty ? null : country;
    if (_selectedCountry == normalized) {
      return;
    }
    _selectedCountry = normalized;
    await load(force: true);
  }

  Future<void> toggleType(HistoricalEventType type) async {
    if (_selectedTypes.contains(type)) {
      _selectedTypes.remove(type);
    } else {
      _selectedTypes.add(type);
    }
    await load(force: true);
  }

  Future<void> clearTypes() async {
    if (_selectedTypes.isEmpty) return;
    _selectedTypes.clear();
    await load(force: true);
  }
}

extension HistoricalEventTypeX on HistoricalEventType {
  String localizationKey() {
    switch (this) {
      case HistoricalEventType.political:
        return 'historical_type_political';
      case HistoricalEventType.artistic:
        return 'historical_type_artistic';
      case HistoricalEventType.geographic:
        return 'historical_type_geographic';
      case HistoricalEventType.naturalDisaster:
        return 'historical_type_natural_disaster';
      case HistoricalEventType.holiday:
        return 'historical_type_holiday';
      case HistoricalEventType.social:
        return 'historical_type_social';
      case HistoricalEventType.scientific:
        return 'historical_type_scientific';
      case HistoricalEventType.economic:
        return 'historical_type_economic';
      case HistoricalEventType.cultural:
        return 'historical_type_cultural';
    }
  }
}
