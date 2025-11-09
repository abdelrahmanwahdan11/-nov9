import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import '../../data/models/item.dart';
import '../../data/services/search_service.dart';
import '../../domain/usecases/search_usecase.dart';

class SearchPageController extends ChangeNotifier {
  SearchPageController(this._useCase);

  final SearchUseCase _useCase;

  final queryController = TextEditingController();
  List<SearchResult<Event>> eventResults = const [];
  List<SearchResult<Item>> itemResults = const [];
  String _query = '';

  void search(List<Event> events, List<Item> items) {
    _query = queryController.text;
    final results = _useCase(events, items, _query);
    eventResults = results.events;
    itemResults = results.items;
    notifyListeners();
  }

  String get query => _query;

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }
}
