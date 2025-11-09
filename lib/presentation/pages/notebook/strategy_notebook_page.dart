import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/strategy_note.dart';
import '../../controllers/notebook_controller.dart';

class StrategyNotebookPage extends StatefulWidget {
  const StrategyNotebookPage({super.key, required this.controller});

  final NotebookController controller;

  @override
  State<StrategyNotebookPage> createState() => _StrategyNotebookPageState();
}

class _StrategyNotebookPageState extends State<StrategyNotebookPage> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.controller.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final notes = widget.controller.filteredNotes;
        final focusFilter = widget.controller.focusFilter;
        final tags = widget.controller.availableTags;
        final activeTags = widget.controller.activeTags;
        final hasFilters = focusFilter != null || activeTags.isNotEmpty || widget.controller.query.isNotEmpty;
        if (_searchController.text != widget.controller.query) {
          _searchController.value = TextEditingValue(
            text: widget.controller.query,
            selection: TextSelection.collapsed(offset: widget.controller.query.length),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('notebook_title')),
            actions: [
              IconButton(
                tooltip: l10n.translate('notebook_clear_filters'),
                icon: const Icon(Icons.filter_alt_off_outlined),
                onPressed: hasFilters ? widget.controller.clearFilters : null,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openComposer(context),
            label: Text(l10n.translate('notebook_add_note')),
            icon: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('notebook_description'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
                            ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onChanged: widget.controller.search,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: l10n.translate('notebook_search_hint'),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    widget.controller.search('');
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _FocusFilterBar(
                        controller: widget.controller,
                        l10n: l10n,
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _TagFilterWrap(
                          tags: tags,
                          activeTags: activeTags,
                          onToggle: widget.controller.toggleTagFilter,
                          l10n: l10n,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _NotebookMetrics(controller: widget.controller, l10n: l10n),
                    ],
                  ),
                ),
              ),
              if (notes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        l10n.translate('notebook_empty'),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final note = notes[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20, index == 0 ? 0 : 12, 20, index == notes.length - 1 ? 120 : 0),
                        child: _NotebookEntryCard(
                          note: note,
                          controller: widget.controller,
                          l10n: l10n,
                          onEdit: () => _openComposer(context, note: note),
                          onDelete: () => _confirmDelete(context, note),
                        ),
                      );
                    },
                    childCount: notes.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, StrategyNote note) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.translate('notebook_delete_confirm')),
            content: Text(l10n.translate('notebook_delete_message')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.translate('notebook_cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.translate('notebook_delete')),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await widget.controller.deleteNote(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('notebook_delete_success'))),
    );
  }

  Future<void> _openComposer(BuildContext context, {StrategyNote? note}) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final titleController = TextEditingController(text: note?.title ?? '');
    final summaryController = TextEditingController(text: note?.summary ?? '');
    final detailsController = TextEditingController(text: note?.details ?? '');
    final tagsController = TextEditingController(text: note?.tags.join(', ') ?? '');
    var focus = note?.focus ?? widget.controller.focusFilter ?? StrategyFocus.global;
    var confidence = note?.confidence ?? 0.68;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate(note == null ? 'notebook_add_note' : 'notebook_edit_note'),
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (note != null)
                          IconButton(
                            tooltip: l10n.translate('notebook_delete'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _confirmDelete(context, note);
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('notebook_title_label'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: summaryController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: l10n.translate('notebook_summary_label'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: detailsController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: l10n.translate('notebook_details_label'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<StrategyFocus>(
                      value: focus,
                      decoration: InputDecoration(labelText: l10n.translate('notebook_focus_label')),
                      items: StrategyFocus.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(widget.controller.focusLabel(l10n, value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => focus = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.translate('notebook_confidence_label'), style: theme.textTheme.titleSmall),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: confidence,
                            onChanged: (value) => setState(() => confidence = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(widget.controller.confidenceLabel(l10n, confidence)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: tagsController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('notebook_tags_hint'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.translate('notebook_cancel')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final title = titleController.text.trim();
                              final summary = summaryController.text.trim();
                              final details = detailsController.text.trim();
                              if (title.isEmpty || summary.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.translate('notebook_validation_error'))),
                                );
                                return;
                              }
                              if (note == null) {
                                await widget.controller.createNote(
                                  title: title,
                                  summary: summary,
                                  details: details,
                                  focus: focus,
                                  confidence: confidence,
                                  tags: tagsController.text.split(','),
                                );
                              } else {
                                await widget.controller.updateNote(
                                  note,
                                  title: title,
                                  summary: summary,
                                  details: details,
                                  focus: focus,
                                  confidence: confidence,
                                  tags: tagsController.text.split(','),
                                );
                              }
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.translate('notebook_save_success'))),
                              );
                            },
                            child: Text(l10n.translate('notebook_save')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FocusFilterBar extends StatelessWidget {
  const _FocusFilterBar({required this.controller, required this.l10n});

  final NotebookController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focus = controller.focusFilter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.translate('notebook_filters'), style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: Text(l10n.translate('notebook_filter_all')),
              selected: focus == null,
              onSelected: (_) => controller.setFocusFilter(null),
            ),
            for (final option in StrategyFocus.values)
              ChoiceChip(
                label: Text(controller.focusLabel(l10n, option)),
                selected: focus == option,
                onSelected: (_) => controller.setFocusFilter(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _TagFilterWrap extends StatelessWidget {
  const _TagFilterWrap({
    required this.tags,
    required this.activeTags,
    required this.onToggle,
    required this.l10n,
  });

  final List<String> tags;
  final Set<String> activeTags;
  final ValueChanged<String> onToggle;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.translate('notebook_tag_filters'), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (tag) => FilterChip(
                  label: Text('#$tag'),
                  selected: activeTags.contains(tag),
                  onSelected: (_) => onToggle(tag),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _NotebookMetrics extends StatelessWidget {
  const _NotebookMetrics({required this.controller, required this.l10n});

  final NotebookController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final average = (controller.averageConfidence * 100).toStringAsFixed(0);
    final total = controller.notes.length;
    final random = controller.notes.isEmpty ? null : controller.randomSuggestion(Random());
    final focusCounts = <StrategyFocus, int>{};
    for (final note in controller.notes) {
      focusCounts[note.focus] = (focusCounts[note.focus] ?? 0) + 1;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      color: theme.colorScheme.primary.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.translate('notebook_metrics_overview'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _MetricChip(
                  label: l10n.translateWithArgs('notebook_average_confidence', {'value': average}),
                  icon: Icons.insights_outlined,
                ),
                _MetricChip(
                  label: l10n.translateWithArgs('notebook_summary_metric', {
                    'count': total.toString(),
                    'confidence': average,
                  }),
                  icon: Icons.library_books_outlined,
                ),
              ],
            ),
            if (focusCounts.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.translate('notebook_focus_breakdown'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: focusCounts.entries
                    .map(
                      (entry) => Chip(
                        label: Text('${controller.focusLabel(l10n, entry.key)} · ${entry.value}'),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (random != null) ...[
              const SizedBox(height: 16),
              Text(l10n.translate('notebook_highlight_random'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(
                l10n.translateWithArgs('notebook_highlight_from', {'title': random.title}),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                random.summary,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Flexible(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _NotebookEntryCard extends StatelessWidget {
  const _NotebookEntryCard({
    required this.note,
    required this.controller,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
  });

  final StrategyNote note;
  final NotebookController controller;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confidenceColor = controller.confidenceColor(theme, note.confidence);
    final confidenceLabel = controller.confidenceLabel(l10n, note.confidence);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.focusLabel(l10n, note.focus),
                      style: theme.textTheme.labelMedium?.copyWith(color: confidenceColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(note.title, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.translate('notebook_edit_note'))),
                  PopupMenuItem(value: 'delete', child: Text(l10n.translate('notebook_delete'))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(note.summary, style: theme.textTheme.bodyMedium),
          if (note.details.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              note.details,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: note.tags
                .map(
                  (tag) => Chip(
                    label: Text('#$tag'),
                    backgroundColor: confidenceColor.withOpacity(0.08),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: confidenceColor),
              const SizedBox(width: 8),
              Text(confidenceLabel, style: theme.textTheme.bodySmall?.copyWith(color: confidenceColor)),
              const Spacer(),
              Text(
                l10n.translateWithArgs('notebook_updated_label', {
                  'time': _timeAgo(l10n, note.effectiveDate),
                }),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return l10n.translate('time_just_now');
    } else if (difference.inMinutes < 60) {
      return l10n.translateWithArgs('time_minutes', {'value': difference.inMinutes.toString()});
    } else if (difference.inHours < 24) {
      return l10n.translateWithArgs('time_hours', {'value': difference.inHours.toString()});
    }
    return l10n.translateWithArgs('time_days', {'value': difference.inDays.toString()});
  }
}
