import '../../data/models/item.dart';
import '../../data/models/offer.dart';
import '../../data/services/mock_items_service.dart';

class ItemManagementUseCase {
  ItemManagementUseCase(this._service);

  final MockItemsService _service;

  Future<void> add(Item item) => _service.addItem(item);

  Future<void> update(Item item) => _service.updateItem(item);

  Future<void> setForSale(String id, bool forSale, {double? price}) =>
      _service.setForSale(id, forSale, price: price);

  Future<void> setTargetPrice(String id, double? price) => _service.setTargetPrice(id, price);

  Stream<Offer> get notifications => _service.notifications;
}
