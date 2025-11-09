import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/overlay_sheet.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({
    super.key,
    required this.bookmarksController,
    required this.eventsController,
  });

  final BookmarksController bookmarksController;
  final EventsController eventsController;

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final _overlayController = OverlayController();
  final TextEditingController _searchController = TextEditingController();
  EventCategory? _selectedCategory;
  _BookmarksSort _sort = _BookmarksSort.newest;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _searchController.dispose();
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
      animation: Listenable.merge([widget.bookmarksController, widget.eventsController]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final events = widget.bookmarksController.bookmarks
            .map(widget.eventsController.findById)
            .whereType<Event>()
            .toList();
        final filtered = _applyFilters(events);
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('bookmarks')),
            actions: [
              if (widget.bookmarksController.bookmarks.isNotEmpty)
                TextButton(
                  onPressed: () => widget.bookmarksController.setAll(const <String>{}),
                  child: Text(l10n.translate('clear_data')),
                ),
              if (events.isNotEmpty)
                PopupMenuButton<_BookmarksSort>(
                  tooltip: l10n.translate('bookmarks_sort_label'),
                  initialValue: _sort,
                  onSelected: (value) => setState(() => _sort = value),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _BookmarksSort.newest,
                      child: Text(l10n.translate('bookmarks_sort_newest')),
                    ),
                    PopupMenuItem(
                      value: _BookmarksSort.oldest,
                      child: Text(l10n.translate('bookmarks_sort_oldest')),
                    ),
                    PopupMenuItem(
                      value: _BookmarksSort.alphabetical,
                      child: Text(l10n.translate('bookmarks_sort_alphabetical')),
                    ),
                  ],
                  icon: const Icon(Icons.sort),
                ),
            ],
          ),
          body: events.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.translate('bookmarks_empty'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(IconlyLight.search),
                        hintText: l10n.translate('bookmarks_search_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.translateWithArgs('bookmarks_results_count', {
                        'count': filtered.length.toString(),
                      }),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    if (filtered.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            l10n.translate('bookmarks_filtered_empty'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    else
                      ...filtered.map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: EventTile(
                            event: event,
                            palette: palette,
                            onTap: () => _openEvent(event),
                            onBookmark: () => widget.bookmarksController.toggle(event.id),
                            isBookmarked: true,
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  List<Event> _applyFilters(List<Event> events) {
    final query = _searchController.text.trim().toLowerCase();
    Iterable<Event> data = events;
    if (_selectedCategory != null) {
      data = data.where((event) => event.category == _selectedCategory);
    }
    if (query.isNotEmpty) {
      data = data.where(
        (event) => '${event.title} ${event.summary} ${event.tags.join(' ')}'.toLowerCase().contains(query),
      );
    }
    final results = data.toList();
    switch (_sort) {
      case _BookmarksSort.newest:
        results.sort((a, b) => b.date.compareTo(a.date));
        break;
      case _BookmarksSort.oldest:
        results.sort((a, b) => a.date.compareTo(b.date));
        break;
      case _BookmarksSort.alphabetical:
        results.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    return results;
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

enum _BookmarksSort { newest, oldest, alphabetical }
