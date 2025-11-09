
import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../data/models/item.dart';
import '../../data/models/saved_filter.dart';
import '../../data/services/search_service.dart';
import '../../domain/usecases/search_usecase.dart';

class SearchPageController extends ChangeNotifier {
  SearchPageController(this._useCase);

  final SearchUseCase _useCase;

  final queryController = TextEditingController();
  List<SearchResult<Event>> eventResults = const [];
  List<SearchResult<Item>> itemResults = const [];
  String _query = '';
  Timer? _debounce;
  List<Event> _events = const [];
  List<Item> _items = const [];

  Set<EventCategory> eventCategories = EventCategory.values.toSet();
  DateTimeRange? eventDateRange;
  Set<String> eventTags = {};
  Set<String> eventSources = {};

  Set<ItemCondition> itemConditions = ItemCondition.values.toSet();
  bool? itemsForSale;
  double? minPrice;
  double? maxPrice;

  Set<String> _availableTags = {};
  Set<String> _availableSources = {};
  double? _priceFloor;
  double? _priceCeiling;

  void configure(List<Event> events, List<Item> items) {
    syncData(events, items, forceRefresh: true);
  }

  void syncData(List<Event> events, List<Item> items, {bool forceRefresh = false}) {
    final eventsChanged = !identical(_events, events);
    final itemsChanged = !identical(_items, items);
    if (!eventsChanged && !itemsChanged && !forceRefresh) {
      return;
    }
    _events = events;
    _items = items;
    _collectFacets();
    if (_query.isNotEmpty || hasActiveFilters || forceRefresh) {
      _performSearch();
    } else {
      notifyListeners();
    }
  }

  void triggerSearch() {
    _performSearch();
  }

  void replaceQuery(String value) {
    if (queryController.text != value) {
      queryController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    onQueryChanged(value);
  }

  void clearQuery() {
    if (queryController.text.isEmpty) {
      return;
    }
    queryController.clear();
    onQueryChanged('');
  }

  void onQueryChanged(String value) {
    _query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 320), _performSearch);
  }

  void setEventCategories(Set<EventCategory> categories) {
    eventCategories = categories.isEmpty ? EventCategory.values.toSet() : categories;
    _performSearch();
  }

  void setEventDateRange(DateTimeRange? range) {
    eventDateRange = range;
    _performSearch();
  }

  void setEventTags(Set<String> tags) {
    eventTags = tags;
    _performSearch();
  }

  void setEventSources(Set<String> sources) {
    eventSources = sources;
    _performSearch();
  }

  void setItemConditions(Set<ItemCondition> conditions) {
    itemConditions = conditions.isEmpty ? ItemCondition.values.toSet() : conditions;
    _performSearch();
  }

  void setItemsForSale(bool? value) {
    itemsForSale = value;
    _performSearch();
  }

  void setPriceRange({double? min, double? max}) {
    minPrice = min;
    maxPrice = max;
    _performSearch();
  }

  void applySavedFilter(SavedFilter filter) {
    if (filter.kind == SavedFilterKind.events) {
      final params = filter.params;
      eventCategories = _parseCategories(params['categories'] as List<dynamic>?);
      eventDateRange = _parseDateRange(params['start'], params['end']);
      eventTags = _parseStringSet(params['tags']);
      eventSources = _parseStringSet(params['sources']);
    } else {
      final params = filter.params;
      itemConditions = _parseConditions(params['conditions'] as List<dynamic>?);
      itemsForSale = params['forSale'] as bool?;
      minPrice = (params['minPrice'] as num?)?.toDouble();
      maxPrice = (params['maxPrice'] as num?)?.toDouble();
    }
    _performSearch();
  }

  Map<String, dynamic> currentEventParams() => {
        'categories': eventCategories.map((e) => e.name).toList(),
        'start': eventDateRange?.start.toIso8601String(),
        'end': eventDateRange?.end.toIso8601String(),
        'tags': eventTags.toList(),
        'sources': eventSources.toList(),
      };

  Map<String, dynamic> currentItemParams() => {
        'conditions': itemConditions.map((e) => e.name).toList(),
        'forSale': itemsForSale,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      };

  void clearFilters() {
    eventCategories = EventCategory.values.toSet();
    eventDateRange = null;
    eventTags.clear();
    eventSources.clear();
    itemConditions = ItemCondition.values.toSet();
    itemsForSale = null;
    minPrice = null;
    maxPrice = null;
    _performSearch();
  }

  bool get hasActiveFilters =>
      eventCategories.length != EventCategory.values.length ||
      eventDateRange != null ||
      eventTags.isNotEmpty ||
      eventSources.isNotEmpty ||
      itemConditions.length != ItemCondition.values.length ||
      itemsForSale != null ||
      minPrice != null ||
      maxPrice != null;

  Set<String> get availableTags => _availableTags;
  Set<String> get availableSources => _availableSources;

  List<String> get sortedTags {
    final tags = _availableTags.toList()..sort();
    return tags;
  }

  List<String> get sortedSources {
    final sources = _availableSources.toList()..sort();
    return sources;
  }

  bool get hasPriceData => _priceFloor != null && _priceCeiling != null;

  double get priceFloor => _priceFloor ?? 0;

  double get priceCeiling {
    if (_priceCeiling != null && _priceFloor != null && _priceCeiling! > _priceFloor!) {
      return _priceCeiling!;
    }
    return (_priceFloor ?? 0) + 100;
  }

  double get effectiveMinPrice => minPrice ?? priceFloor;
  double get effectiveMaxPrice => maxPrice ?? priceCeiling;

  List<String> get quickSuggestions {
    final ordered = <String>{};
    ordered.addAll(sortedTags);
    ordered.addAll(sortedSources);
    return ordered.take(6).toList();
  }

  String get query => _query;

  void _performSearch() {
    final results = _useCase(
      _events,
      _items,
      _query,
      eventCategories: eventCategories,
      start: eventDateRange?.start,
      end: eventDateRange?.end,
      eventTags: eventTags,
      eventSources: eventSources,
      itemConditions: itemConditions,
      itemsForSale: itemsForSale,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    eventResults = results.events;
    itemResults = results.items;
    notifyListeners();
  }

  void _collectFacets() {
    _availableTags = _events.expand((event) => event.tags).where((tag) => tag.isNotEmpty).toSet();
    _availableSources = _events.map((event) => event.source).where((source) => source.isNotEmpty).toSet();
    final prices = _items
        .map((item) => item.askingPrice ?? item.targetPrice)
        .whereType<double>()
        .toList()
      ..sort();
    if (prices.isEmpty) {
      _priceFloor = null;
      _priceCeiling = null;
    } else {
      _priceFloor = prices.first.floorToDouble();
      _priceCeiling = prices.last.ceilToDouble();
      if (_priceCeiling == _priceFloor) {
        _priceCeiling = _priceFloor! + 100;
      }
    }
  }

  Set<EventCategory> _parseCategories(List<dynamic>? raw) {
    if (raw == null || raw.isEmpty) {
      return EventCategory.values.toSet();
    }
    final parsed = <EventCategory>{};
    for (final value in raw) {
      final name = value.toString();
      final match = EventCategory.values.firstWhere(
        (category) => category.name == name,
        orElse: () => EventCategory.politics,
      );
      parsed.add(match);
    }
    return parsed;
  }

  Set<String> _parseStringSet(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString()).toSet();
    }
    return {};
  }

  DateTimeRange? _parseDateRange(dynamic startRaw, dynamic endRaw) {
    if (startRaw is String && endRaw is String) {
      return DateTimeRange(start: DateTime.parse(startRaw), end: DateTime.parse(endRaw));
    }
    return null;
  }

  Set<ItemCondition> _parseConditions(List<dynamic>? raw) {
    if (raw == null || raw.isEmpty) {
      return ItemCondition.values.toSet();
    }
    final parsed = <ItemCondition>{};
    for (final value in raw) {
      final name = value.toString();
      final match = ItemCondition.values.firstWhere(
        (condition) => condition.name == name,
        orElse: () => ItemCondition.used,
      );
      parsed.add(match);
    }
    return parsed;
  }

  @override
  void dispose() {
    queryController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
