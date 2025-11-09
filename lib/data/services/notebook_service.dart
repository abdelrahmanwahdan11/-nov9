import '../models/strategy_note.dart';
import '../../core/preferences/prefs_service.dart';

class NotebookService {
  NotebookService(this._prefs);

  final PrefsService _prefs;
  final List<StrategyNote> _notes = [];
  bool _initialized = false;

  static final List<StrategyNote> _seedNotes = [
    StrategyNote(
      id: 'seed-briefing',
      title: 'Morning policy follow-up',
      summary: 'Track cabinet response to climate summit outcomes.',
      details:
          'Coordinate a briefing deck summarizing summit statements and outline talking points for regional partners. Watch for legal amendments signalled in today\'s politics feed.',
      focus: StrategyFocus.politics,
      confidence: 0.72,
      tags: const ['policy', 'climate', 'summit'],
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    StrategyNote(
      id: 'seed-arts',
      title: 'Festival collaboration idea',
      summary: 'Cross-promote art residency with new festival coverage.',
      details:
          'Reach out to residency leads with today\'s arts highlight for a co-branded stream. Include visual references from the digest gallery.',
      focus: StrategyFocus.arts,
      confidence: 0.64,
      tags: const ['arts', 'partnership', 'residency'],
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    StrategyNote(
      id: 'seed-world',
      title: 'Logistics alert checklist',
      summary: 'World desk preparing relief tracker.',
      details:
          'Assemble supply requirements based on global disruption coverage. Sync with scenario studio recommendations before 18:00.',
      focus: StrategyFocus.world,
      confidence: 0.81,
      tags: const ['logistics', 'relief', 'monitoring'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
    ),
    StrategyNote(
      id: 'seed-inventory',
      title: 'Collector outreach script',
      summary: 'Convert recent offers into secure consignments.',
      details:
          'Prepare bilingual template referencing target prices from inventory spotlight. Highlight restoration plan from My Items condition insights.',
      focus: StrategyFocus.inventory,
      confidence: 0.69,
      tags: const ['inventory', 'offers', 'consignment'],
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    ),
    StrategyNote(
      id: 'seed-timeline',
      title: 'Anniversary feature pitch',
      summary: 'Leverage On This Day stories for evening newsletter.',
      details:
          'Draft a carousel narrative linking today\'s 50 spotlight events with local civic milestones. Include callouts for regional social posts.',
      focus: StrategyFocus.timeline,
      confidence: 0.77,
      tags: const ['timeline', 'newsletter', 'engagement'],
      createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
    ),
  ];

  Future<List<StrategyNote>> loadNotes() async {
    if (_initialized) {
      return List.unmodifiable(_notes);
    }
    final stored = _prefs.loadStrategyNotes();
    if (stored.isEmpty) {
      _notes
        ..clear()
        ..addAll(_seedNotes);
      await _persist();
    } else {
      _notes
        ..clear()
        ..addAll(stored.map(StrategyNote.fromJson));
    }
    _initialized = true;
    return List.unmodifiable(_notes);
  }

  Future<StrategyNote> createNote({
    required String title,
    required String summary,
    required String details,
    required StrategyFocus focus,
    required double confidence,
    required List<String> tags,
  }) async {
    await loadNotes();
    final note = StrategyNote(
      id: 'note-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      summary: summary,
      details: details,
      focus: focus,
      confidence: confidence,
      tags: tags,
      createdAt: DateTime.now(),
    );
    _notes.add(note);
    await _persist();
    return note;
  }

  Future<StrategyNote> updateNote(StrategyNote note) async {
    await loadNotes();
    final index = _notes.indexWhere((element) => element.id == note.id);
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    await _persist();
    return note;
  }

  Future<void> deleteNote(String id) async {
    await loadNotes();
    _notes.removeWhere((element) => element.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs.saveStrategyNotes(_notes.map((note) => note.toJson()).toList());
  }
}
