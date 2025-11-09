import '../../data/models/event.dart';
import '../../data/services/local_article_parser.dart';
import '../../data/services/mock_event_service.dart';

class RefreshEventsUseCase {
  RefreshEventsUseCase(this._service, this._parser);

  final MockEventService _service;
  final LocalArticleParser _parser;

  Future<void> call({String? article}) async {
    final parsed = article == null || article.isEmpty ? <Event>[] : _parser.parse(article);
    await _service.refresh(parsed);
  }
}
