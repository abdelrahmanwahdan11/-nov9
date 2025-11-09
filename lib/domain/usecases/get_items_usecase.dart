import '../../data/models/item.dart';
import '../../data/services/mock_items_service.dart';

class GetItemsUseCase {
  GetItemsUseCase(this._service);

  final MockItemsService _service;

  Stream<List<Item>> call() => _service.itemsStream;
}
