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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
