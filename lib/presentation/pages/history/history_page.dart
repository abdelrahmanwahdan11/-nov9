import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/history_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/overlay_sheet.dart';
import '../../widgets/skeleton.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.bookmarksController,
  });

  final HistoryController controller;
  final EventsController eventsController;
  final BookmarksController bookmarksController;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _overlayController = OverlayController();
  EventCategory? _selectedCategory;
  bool _bookmarkedOnly = false;

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = [
      DesignTokens.colors['mint']!,
      DesignTokens.colors['sky']!,
      DesignTokens.colors['pink']!,
      DesignTokens.colors['blue']!,
      DesignTokens.colors['lime']!,
    ];
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final events = widget.controller.events;
        final filtered = _filtered(events);
        final summaryContent = <Widget>[
          _HistorySummaryCard(events: events, l10n: l10n),
          const SizedBox(height: 16),
          Text(
            l10n.translateWithArgs('history_results_count', {
              'count': filtered.length.toString(),
            }),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
        ];

        if (events.isEmpty) {
          summaryContent.add(_HistoryEmptyState(message: l10n.translate('history_empty')));
        } else if (filtered.isEmpty) {
          summaryContent.add(_HistoryEmptyState(message: l10n.translate('history_filtered_empty')));
        } else {
          summaryContent.addAll(
            filtered.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EventTile(
                  event: event,
                  palette: palette,
                  onTap: () => _openEvent(event),
                  onBookmark: () => widget.bookmarksController.toggle(event.id),
                  isBookmarked: widget.bookmarksController.isBookmarked(event.id),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('history'))),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: CalendarDatePicker(
                        initialDate: widget.controller.selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        onDateChanged: widget.controller.loadFor,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('history_filters_heading'),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l10n.translate('all')),
                            selected: _selectedCategory == null,
                            onSelected: (_) => setState(() => _selectedCategory = null),
                          ),
                          ...EventCategory.values.map(
                            (category) => ChoiceChip(
                              label: Text(l10n.translate(category.name)),
                              selected: _selectedCategory == category,
                              onSelected: (selected) =>
                                  setState(() => _selectedCategory = selected ? category : null),
                            ),
                          ),
                          FilterChip(
                            label: Text(l10n.translate('history_bookmarked_only')),
                            selected: _bookmarkedOnly,
                            onSelected: (value) => setState(() => _bookmarkedOnly = value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.controller.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Skeleton(height: 140),
                      ),
                      childCount: 3,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(summaryContent),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Event> _filtered(List<Event> events) {
    Iterable<Event> data = events;
    if (_selectedCategory != null) {
      data = data.where((event) => event.category == _selectedCategory);
    }
    if (_bookmarkedOnly) {
      data = data.where((event) => widget.bookmarksController.isBookmarked(event.id));
    }
    return data.toList();
  }

  void _openEvent(Event event) {
    _overlayController.show(event);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OverlaySheet(
          controller: _overlayController,
          eventsController: widget.eventsController,
          bookmarksController: widget.bookmarksController,
          onTagSelected: (tag) => widget.eventsController.setTagFilter(tag),
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
    ).whenComplete(() {
      _overlayController.hide();
    });
  }
}

class _HistorySummaryCard extends StatelessWidget {
  const _HistorySummaryCard({required this.events, required this.l10n});

  final List<Event> events;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = <EventCategory, int>{
      for (final category in EventCategory.values) category: 0,
    };
    for (final event in events) {
      counts.update(event.category, (value) => value + 1, ifAbsent: () => 1);
    }
    final total = events.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.16),
            Theme.of(context).colorScheme.primary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('history_insights_title'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translateWithArgs('history_insights_total', {'count': total.toString()}),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: counts.entries
                .where((entry) => entry.value > 0)
                .map(
                  (entry) => Chip(
                    label: Text(
                      l10n.translateWithArgs('history_insights_category', {
                        'label': l10n.translate(entry.key.name),
                        'count': entry.value.toString(),
                      }),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
