import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/strategy_note.dart';
import '../../domain/usecases/manage_notes_usecase.dart';

class NotebookController extends ChangeNotifier {
  NotebookController(this._useCase);

  final ManageNotesUseCase _useCase;

  List<StrategyNote> _notes = const [];
  String _query = '';
  StrategyFocus? _focusFilter;
  final Set<String> _tagFilters = {};

  List<StrategyNote> get notes => List.unmodifiable(_notes);

  List<StrategyNote> get filteredNotes {
    final lowerQuery = _query.trim().toLowerCase();
    return _notes
        .where((note) {
          final matchesQuery = lowerQuery.isEmpty
              ? true
              : note.title.toLowerCase().contains(lowerQuery) ||
                  note.summary.toLowerCase().contains(lowerQuery) ||
                  note.details.toLowerCase().contains(lowerQuery) ||
                  note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
          final matchesFocus = _focusFilter == null || note.focus == _focusFilter;
          final matchesTags = _tagFilters.isEmpty || note.tags.any(_tagFilters.contains);
          return matchesQuery && matchesFocus && matchesTags;
        })
        .toList()
      ..sort(
        (a, b) => b.effectiveDate.compareTo(a.effectiveDate),
      );
  }

  String get query => _query;

  StrategyFocus? get focusFilter => _focusFilter;

  Set<String> get activeTags => Set.unmodifiable(_tagFilters);

  int get totalNotes => _notes.length;

  double get averageConfidence {
    if (_notes.isEmpty) return 0;
    final total = _notes.fold<double>(0, (sum, note) => sum + note.confidence);
    return total / _notes.length;
  }

  StrategyNote? get topConfidenceNote {
    if (_notes.isEmpty) return null;
    return _notes.reduce((value, element) => value.confidence >= element.confidence ? value : element);
  }

  List<String> get availableTags {
    final tags = <String>{};
    for (final note in _notes) {
      tags.addAll(note.tags);
    }
    final sorted = tags.toList()..sort();
    return sorted;
  }

  List<MapEntry<String, int>> get tagHeat {
    final counts = <String, int>{};
    for (final note in _notes) {
      for (final tag in note.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Future<void> initialize() async {
    _notes = await _useCase.loadNotes();
    notifyListeners();
  }

  Future<void> createNote({
    required String title,
    required String summary,
    required String details,
    required StrategyFocus focus,
    required double confidence,
    required List<String> tags,
  }) async {
    final sanitizedTags = tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toSet().toList();
    final note = await _useCase.createNote(
      title: title,
      summary: summary,
      details: details,
      focus: focus,
      confidence: confidence.clamp(0.0, 1.0),
      tags: sanitizedTags,
    );
    _notes = [..._notes, note];
    notifyListeners();
  }

  Future<void> updateNote(
    StrategyNote note, {
    required String title,
    required String summary,
    required String details,
    required StrategyFocus focus,
    required double confidence,
    required List<String> tags,
  }) async {
    final sanitizedTags = tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toSet().toList();
    final updated = note.copyWith(
      title: title,
      summary: summary,
      details: details,
      focus: focus,
      confidence: confidence.clamp(0.0, 1.0),
      tags: sanitizedTags,
      updatedAt: DateTime.now(),
    );
    final persisted = await _useCase.updateNote(updated);
    _notes = _notes.map((existing) => existing.id == persisted.id ? persisted : existing).toList();
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _useCase.deleteNote(id);
    _notes = _notes.where((note) => note.id != id).toList();
    notifyListeners();
  }

  void search(String query) {
    if (_query == query) return;
    _query = query;
    notifyListeners();
  }

  void setFocusFilter(StrategyFocus? focus) {
    if (_focusFilter == focus) return;
    _focusFilter = focus;
    notifyListeners();
  }

  void toggleTagFilter(String tag) {
    if (_tagFilters.contains(tag)) {
      _tagFilters.remove(tag);
    } else {
      _tagFilters.add(tag);
    }
    notifyListeners();
  }

  void clearFilters() {
    _focusFilter = null;
    _tagFilters.clear();
    notifyListeners();
  }

  String focusLabel(AppLocalizations l10n, StrategyFocus focus) {
    return l10n.translate(focus.localizationKey);
  }

  String confidenceLabel(AppLocalizations l10n, double confidence) {
    final percentage = (confidence * 100).round();
    final bucket = percentage >= 80
        ? l10n.translate('notebook_confidence_high')
        : percentage >= 55
            ? l10n.translate('notebook_confidence_medium')
            : l10n.translate('notebook_confidence_low');
    return '$bucket • $percentage%';
  }

  Color confidenceColor(ThemeData theme, double confidence) {
    final normalized = confidence.clamp(0.0, 1.0);
    return Color.lerp(theme.colorScheme.error, theme.colorScheme.primary, normalized)!;
  }

  StrategyNote randomSuggestion(Random random) {
    if (_notes.isEmpty) {
      throw StateError('No notes available');
    }
    return _notes[random.nextInt(_notes.length)];
  }
}
