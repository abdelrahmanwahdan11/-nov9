import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/item.dart';
import '../../data/models/offer.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../domain/usecases/item_management_usecase.dart';

class ItemsController extends ChangeNotifier {
  ItemsController(this._getItems, this._manage) {
    _subscription = _getItems().listen(_onData);
  }

  final GetItemsUseCase _getItems;
  final ItemManagementUseCase _manage;
  late final StreamSubscription<List<Item>> _subscription;

  final compareList = <Item>[];
  final _items = <Item>[];
  Offer? latestOffer;
  final _conditionScores = <String, double>{};

  List<Item> get items => List.unmodifiable(_items);

  void _onData(List<Item> data) {
    _items
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<void> addItem(Item item) async {
    await _manage.add(item);
  }

  Future<void> updateItem(Item item) async {
    await _manage.update(item);
  }

  Future<void> setForSale(Item item, bool forSale, {double? price}) async {
    await _manage.setForSale(item.id, forSale, price: price);
  }

  Future<void> setTargetPrice(Item item, double? price) async {
    await _manage.setTargetPrice(item.id, price);
  }

  void toggleCompare(Item item) {
    if (compareList.contains(item)) {
      compareList.remove(item);
    } else {
      if (compareList.length == 2) {
        compareList.removeAt(0);
      }
      compareList.add(item);
    }
    notifyListeners();
  }

  void clearCompare() {
    compareList.clear();
    notifyListeners();
  }

  void updateConditionScore(Item item, double score) {
    _conditionScores[item.id] = score;
    notifyListeners();
  }

  double conditionScoreFor(Item item) => _conditionScores[item.id] ?? 100;

  ({String key, Map<String, String> args}) tipFor(Item item) {
    final score = conditionScoreFor(item);
    if (score >= 80) {
      return (key: 'items.tip_high', args: {'name': item.name});
    }
    if (score >= 50) {
      return (key: 'items.tip_medium', args: {'name': item.name});
    }
    return (key: 'items.tip_low', args: {'name': item.name});
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
