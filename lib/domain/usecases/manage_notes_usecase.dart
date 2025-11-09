import '../../data/models/strategy_note.dart';
import '../../data/services/notebook_service.dart';

class ManageNotesUseCase {
  const ManageNotesUseCase(this._service);

  final NotebookService _service;

  Future<List<StrategyNote>> loadNotes() => _service.loadNotes();

  Future<StrategyNote> createNote({
    required String title,
    required String summary,
    required String details,
    required StrategyFocus focus,
    required double confidence,
    required List<String> tags,
  }) {
    return _service.createNote(
      title: title,
      summary: summary,
      details: details,
      focus: focus,
      confidence: confidence,
      tags: tags,
    );
  }

  Future<StrategyNote> updateNote(StrategyNote note) => _service.updateNote(note);

  Future<void> deleteNote(String id) => _service.deleteNote(id);
}
