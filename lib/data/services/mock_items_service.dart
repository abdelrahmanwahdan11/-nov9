import 'dart:async';
import 'dart:math';

import '../../core/preferences/prefs_service.dart';
import '../models/item.dart';
import '../models/offer.dart';

class MockItemsService {
  MockItemsService(this._prefs) {
    _load();
  }

  final PrefsService _prefs;
  final _items = <Item>[];
  final _controller = StreamController<List<Item>>.broadcast();
  final _notificationController = StreamController<Offer>.broadcast();

  Stream<List<Item>> get itemsStream => _controller.stream;
  Stream<Offer> get notifications => _notificationController.stream;

  void _load() {
    final stored = _prefs.loadItems();
    if (stored.isEmpty) {
      _items
        ..clear()
        ..addAll(_seed);
    } else {
      _items
        ..clear()
        ..addAll(stored.map(Item.fromJson));
    }
    _emit();
  }

  Future<void> addItem(Item item) async {
    _items.add(item);
    await _persist();
    _emit();
  }

  Future<void> updateItem(Item item) async {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _items[index] = item;
      await _persist();
      _emit();
    }
  }

  Future<void> setForSale(String id, bool forSale, {double? price}) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index != -1) {
      final updated = _items[index].copyWith(forSale: forSale, askingPrice: price);
      _items[index] = updated;
      await _persist();
      _emit();
      if (forSale) {
        _mockOffer(updated);
      }
    }
  }

  Future<void> setTargetPrice(String id, double? price) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index != -1) {
      final updated = _items[index].copyWith(targetPrice: price);
      _items[index] = updated;
      await _persist();
      _emit();
      if (price != null) {
        _notificationController.add(
          Offer(
            itemId: updated.id,
            amount: price,
            from: 'Target watcher',
            message: 'Buyers alerted to your target price of ${price.toStringAsFixed(0)}',
            time: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> _mockOffer(Item item) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final offer = Offer(
      itemId: item.id,
      amount: (item.askingPrice ?? 80) * (0.8 + Random().nextDouble() * 0.4),
      from: 'Collector ${Random().nextInt(900) + 100}',
      message: 'Interested in your ${item.name}',
      time: DateTime.now(),
    );
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      final offers = [..._items[index].offers, offer];
      _items[index] = _items[index].copyWith(offers: offers);
      await _persist();
      _notificationController.add(offer);
      final target = _items[index].targetPrice;
      if (target != null && offer.amount >= target) {
        _notificationController.add(
          Offer(
            itemId: item.id,
            amount: offer.amount,
            from: 'Target watcher',
            message: 'Offer met your target price!',
            time: DateTime.now(),
          ),
        );
      }
      _emit();
    }
  }

  Future<void> _persist() async {
    await _prefs.saveItems(_items.map((item) => item.toJson()).toList());
  }

  void _emit() {
    _controller.add(List<Item>.unmodifiable(_items));
  }

  void dispose() {
    _controller.close();
    _notificationController.close();
  }

  List<Item> get _seed => [
        Item(
          id: 'item_1',
          name: 'Vintage Camera',
          specs: {'Brand': 'Zenit', 'Year': '1982', 'Lens': 'Helios 44-2'},
          imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
          condition: ItemCondition.used,
          notes: 'Needs gentle cleaning.',
          forSale: false,
          askingPrice: null,
          targetPrice: 95,
          offers: const [],
        ),
        Item(
          id: 'item_2',
          name: 'Rare Vinyl',
          specs: {'Artist': 'Miles Davis', 'Edition': '1959 Mono'},
          imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
          condition: ItemCondition.like_new,
          notes: 'Stored in climate-controlled sleeve.',
          forSale: true,
          askingPrice: 120.0,
          targetPrice: 150,
          offers: const [],
        ),
      ];
}
