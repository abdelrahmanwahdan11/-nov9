
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../../data/models/item.dart';
import '../../../data/models/saved_filter.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/search_controller.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/item_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.controller,
    required this.filtersController,
    required this.events,
    required this.items,
    required this.bookmarksController,
  });

  final SearchPageController controller;
  final FiltersController filtersController;
  final List<Event> events;
  final List<Item> items;
  final BookmarksController bookmarksController;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.syncData(widget.events, widget.items);
  }

  @override
  void didUpdateWidget(SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller.syncData(widget.events, widget.items);
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
      animation: Listenable.merge([
        widget.controller,
        widget.filtersController,
        widget.bookmarksController,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final chips = _activeFilterChips(context, l10n);
        final controller = widget.controller;
        final hasResultsContext = controller.hasResults || controller.query.isNotEmpty || controller.hasActiveFilters;
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: TextField(
              controller: widget.controller.queryController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint'),
                border: InputBorder.none,
                prefixIcon: const Icon(IconlyLight.search),
                suffixIcon: widget.controller.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: widget.controller.clearQuery,
                      ),
              ),
              onChanged: widget.controller.onQueryChanged,
              onSubmitted: (_) => widget.controller.triggerSearch(),
              textInputAction: TextInputAction.search,
            ),
            actions: [
              IconButton(
                icon: const Icon(IconlyLight.filter),
                onPressed: () => _openFiltersSheet(context),
              ),
            ],
            bottom: chips.isEmpty
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(children: chips),
                      ),
                    ),
                  ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: hasResultsContext
                ? _ResultsView(
                    controller: widget.controller,
                    palette: palette,
                    onEventTap: _showEventPreview,
                    onItemTap: _showItemPreview,
                    bookmarksController: widget.bookmarksController,
                  )
                : _SuggestionsView(
                    controller: widget.controller,
                    filtersController: widget.filtersController,
                    focusNode: _focusNode,
                    onOpenFilters: () => _openFiltersSheet(context),
                  ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: widget.controller.triggerSearch,
            icon: const Icon(IconlyLight.search),
            label: Text(l10n.translate('search')),
          ),
        );
      },
    );
  }

  List<Widget> _activeFilterChips(BuildContext context, AppLocalizations l10n) {
    final controller = widget.controller;
    final chips = <Widget>[];
    if (controller.eventCategories.length != EventCategory.values.length) {
      final label = controller.eventCategories.map((e) => l10n.translate(e.name)).join(', ');
      chips.add(_ActiveChip(
        label: label,
        onDeleted: () => controller.setEventCategories(EventCategory.values.toSet()),
      ));
    }
    if (controller.eventDateRange != null) {
      final range = controller.eventDateRange!;
      chips.add(_ActiveChip(
        label: '${_formatDate(range.start)} – ${_formatDate(range.end)}',
        onDeleted: () => controller.setEventDateRange(null),
      ));
    }
    if (controller.eventTags.isNotEmpty) {
      chips.add(_ActiveChip(
        label: controller.eventTags.join(', '),
        onDeleted: () => controller.setEventTags({}),
      ));
    }
    if (controller.eventSources.isNotEmpty) {
      chips.add(_ActiveChip(
        label: controller.eventSources.join(', '),
        onDeleted: () => controller.setEventSources({}),
      ));
    }
    if (controller.itemConditions.length != ItemCondition.values.length) {
      final label = controller.itemConditions.map((e) => e.name.replaceAll('_', ' ')).join(', ');
      chips.add(_ActiveChip(
        label: label,
        onDeleted: () => controller.setItemConditions(ItemCondition.values.toSet()),
      ));
    }
    if (controller.itemsForSale != null) {
      final label = controller.itemsForSale!
          ? l10n.translate('search_filters_sale_state_for_sale')
          : l10n.translate('search_filters_sale_state_keep');
      chips.add(_ActiveChip(
        label: label,
        onDeleted: () => controller.setItemsForSale(null),
      ));
    }
    if (controller.minPrice != null || controller.maxPrice != null) {
      final min = controller.minPrice?.toStringAsFixed(0) ?? controller.priceFloor.toStringAsFixed(0);
      final max = controller.maxPrice?.toStringAsFixed(0) ?? controller.priceCeiling.toStringAsFixed(0);
      chips.add(_ActiveChip(
        label: 'USD $min – USD $max',
        onDeleted: () => controller.setPriceRange(),
      ));
    }
    if (chips.isEmpty) {
      return chips;
    }
    final spaced = <Widget>[];
    for (final chip in chips) {
      spaced..add(chip)..add(const SizedBox(width: 8));
    }
    spaced.removeLast();
    return spaced;
  }

  static String _formatDate(DateTime value) {
    return '${value.month}/${value.day}';
  }

  void _openFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _FiltersSheet(
        controller: widget.controller,
        filtersController: widget.filtersController,
      ),
    );
  }

  void _showEventPreview(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EventPreviewSheet(event: event),
    );
  }

  void _showItemPreview(Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ItemPreviewSheet(item: item),
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView({
    required this.controller,
    required this.filtersController,
    required this.focusNode,
    required this.onOpenFilters,
  });

  final SearchPageController controller;
  final FiltersController filtersController;
  final FocusNode focusNode;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final savedFilters = filtersController.filters;
    final suggestions = controller.quickSuggestions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Text(
          l10n.translate('search_intro'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        if (savedFilters.isNotEmpty) ...[
          Text(l10n.translate('search_saved_filters'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: savedFilters
                .map(
                  (filter) => InputChip(
                    label: Text(filter.name),
                    onPressed: () {
                      controller.applySavedFilter(filter);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.translateWithArgs('search_saved_filter_applied', {'name': filter.name}),
                          ),
                        ),
                      );
                    },
                    onDeleted: () => _confirmDelete(context, filter),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ] else ...[
          Text(
            l10n.translate('search_saved_filters_empty'),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
        ],
        if (suggestions.isNotEmpty) ...[
          Text(l10n.translate('search_suggestions'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: suggestions
                .map(
                  (suggestion) => ActionChip(
                    label: Text(suggestion),
                    onPressed: () {
                      controller.replaceQuery(suggestion);
                      focusNode.requestFocus();
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        FilledButton.icon(
          onPressed: onOpenFilters,
          icon: const Icon(IconlyLight.filter),
          label: Text(l10n.translate('search_open_filters')),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, SavedFilter filter) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.translate('search_delete_filter')),
            content: Text(l10n.translateWithArgs('search_filters_delete_confirm', {'name': filter.name})),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.translate('cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.translate('confirm')),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) {
      filtersController.deleteFilter(filter.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('search_filter_deleted'))),
      );
    }
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.controller,
    required this.palette,
    required this.onEventTap,
    required this.onItemTap,
    required this.bookmarksController,
  });

  final SearchPageController controller;
  final List<Color> palette;
  final ValueChanged<Event> onEventTap;
  final ValueChanged<Item> onItemTap;
  final BookmarksController bookmarksController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final eventResults = controller.eventResults;
    final itemResults = controller.itemResults;
    final total = eventResults.length + itemResults.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Text(
          l10n.translateWithArgs('search_results_count', {'count': total.toString()}),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        if (eventResults.isNotEmpty) ...[
          Text(l10n.translate('search_events'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...eventResults.map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventTile(
                event: result.item,
                palette: palette,
                onTap: () => onEventTap(result.item),
                onBookmark: () => bookmarksController.toggle(result.item.id),
                isBookmarked: bookmarksController.isBookmarked(result.item.id),
              ),
            ),
          ),
        ],
        if (itemResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.translate('search_items'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...itemResults.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ItemTile(
                item: entry.value.item,
                onTap: () => onItemTap(entry.value.item),
                onLongPress: () {},
                color: palette[entry.key % palette.length],
              ),
            ),
          ),
        ],
        if (total == 0)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(IconlyLight.search, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(l10n.translate('no_results'), style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
      ],
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.controller, required this.filtersController});

  final SearchPageController controller;
  final FiltersController filtersController;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  final TextEditingController _nameController = TextEditingController();
  late Set<EventCategory> _eventCategories;
  DateTimeRange? _eventDateRange;
  late Set<String> _eventTags;
  late Set<String> _eventSources;
  late Set<ItemCondition> _itemConditions;
  bool? _itemsForSale;
  RangeValues? _priceRange;
  SavedFilterKind _selectedKind = SavedFilterKind.events;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    _eventCategories = {...controller.eventCategories};
    _eventDateRange = controller.eventDateRange;
    _eventTags = {...controller.eventTags};
    _eventSources = {...controller.eventSources};
    _itemConditions = {...controller.itemConditions};
    _itemsForSale = controller.itemsForSale;
    if (controller.hasPriceData) {
      _priceRange = RangeValues(
        controller.effectiveMinPrice,
        controller.effectiveMaxPrice,
      );
    }
    _nameController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = widget.controller;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.translate('search_filters_title'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.translate('search_filters_categories'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: EventCategory.values
                    .map(
                      (category) => FilterChip(
                        label: Text(l10n.translate(category.name)),
                        selected: _eventCategories.contains(category),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _eventCategories.add(category);
                          } else {
                            _eventCategories.remove(category);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.translate('search_filters_date_range')),
                subtitle: Text(
                  _eventDateRange == null
                      ? l10n.translate('search_filters_any_time')
                      : '${_SearchPageState._formatDate(_eventDateRange!.start)} – ${_SearchPageState._formatDate(_eventDateRange!.end)}',
                ),
                trailing: const Icon(IconlyLight.calendar),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: now.subtract(const Duration(days: 365)),
                    lastDate: now.add(const Duration(days: 365)),
                    initialDateRange: _eventDateRange,
                  );
                  if (!mounted) return;
                  setState(() => _eventDateRange = picked);
                },
              ),
              const SizedBox(height: 8),
              Text(l10n.translate('search_filters_tags'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.sortedTags
                    .map(
                      (tag) => FilterChip(
                        label: Text(tag),
                        selected: _eventTags.contains(tag),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _eventTags.add(tag);
                          } else {
                            _eventTags.remove(tag);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(l10n.translate('search_filters_sources'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.sortedSources
                    .map(
                      (source) => FilterChip(
                        label: Text(source),
                        selected: _eventSources.contains(source),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _eventSources.add(source);
                          } else {
                            _eventSources.remove(source);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(l10n.translate('search_filters_items_title'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ItemCondition.values
                    .map(
                      (condition) => FilterChip(
                        label: Text(condition.name.replaceAll('_', ' ')),
                        selected: _itemConditions.contains(condition),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _itemConditions.add(condition);
                          } else {
                            _itemConditions.remove(condition);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(l10n.translate('search_filters_sale_state'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.translate('search_filters_sale_state_any')),
                    selected: _itemsForSale == null,
                    onSelected: (_) => setState(() => _itemsForSale = null),
                  ),
                  ChoiceChip(
                    label: Text(l10n.translate('search_filters_sale_state_for_sale')),
                    selected: _itemsForSale == true,
                    onSelected: (_) => setState(() => _itemsForSale = true),
                  ),
                  ChoiceChip(
                    label: Text(l10n.translate('search_filters_sale_state_keep')),
                    selected: _itemsForSale == false,
                    onSelected: (_) => setState(() => _itemsForSale = false),
                  ),
                ],
              ),
              if (controller.hasPriceData) ...[
                const SizedBox(height: 16),
                Text(l10n.translate('search_filters_price_range'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
               Builder(
                 builder: (context) {
                   final values = _priceRange ?? RangeValues(controller.priceFloor, controller.priceCeiling);
                    var divisions = ((controller.priceCeiling - controller.priceFloor) ~/ 10);
                    if (divisions < 1) {
                      divisions = 1;
                    } else if (divisions > 20) {
                      divisions = 20;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RangeSlider(
                          values: values,
                          onChanged: (value) => setState(() => _priceRange = value),
                          min: controller.priceFloor,
                          max: controller.priceCeiling,
                          divisions: divisions,
                          labels: RangeLabels(
                            'USD ${values.start.toStringAsFixed(0)}',
                            'USD ${values.end.toStringAsFixed(0)}',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('search_filters_name_hint'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<SavedFilterKind>(
                    value: _selectedKind,
                    items: SavedFilterKind.values
                        .map(
                          (kind) => DropdownMenuItem(
                            value: kind,
                            child: Text(kind == SavedFilterKind.events
                                ? l10n.translate('search_events')
                                : l10n.translate('search_items')),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedKind = value ?? SavedFilterKind.events),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _applyFilters,
                      child: Text(l10n.translate('search_filters_apply')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      child: Text(l10n.translate('search_filters_reset')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _nameController.text.trim().isEmpty ? null : _saveFilter,
                  icon: const Icon(IconlyLight.bookmark),
                  label: Text(l10n.translate('search_filters_save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    final controller = widget.controller;
    controller.setEventCategories(_eventCategories);
    controller.setEventDateRange(_eventDateRange);
    controller.setEventTags(_eventTags);
    controller.setEventSources(_eventSources);
    controller.setItemConditions(_itemConditions);
    controller.setItemsForSale(_itemsForSale);
    if (_priceRange != null) {
      final floor = controller.priceFloor;
      final ceiling = controller.priceCeiling;
      final start = (_priceRange!.start - floor).abs() < 0.5 ? null : _priceRange!.start;
      final end = (_priceRange!.end - ceiling).abs() < 0.5 ? null : _priceRange!.end;
      controller.setPriceRange(min: start, max: end);
    } else {
      controller.setPriceRange();
    }
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _eventCategories = EventCategory.values.toSet();
      _eventDateRange = null;
      _eventTags.clear();
      _eventSources.clear();
      _itemConditions = ItemCondition.values.toSet();
      _itemsForSale = null;
      _priceRange = widget.controller.hasPriceData
          ? RangeValues(widget.controller.priceFloor, widget.controller.priceCeiling)
          : null;
      _nameController.clear();
    });
    widget.controller.clearFilters();
  }

  Future<void> _saveFilter() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final params = _selectedKind == SavedFilterKind.events
        ? widget.controller.currentEventParams()
        : widget.controller.currentItemParams();
    widget.filtersController.addFilter(name, _selectedKind, params);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('search_filter_saved'))),
    );
    _nameController.clear();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _EventPreviewSheet extends StatelessWidget {
  const _EventPreviewSheet({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(event.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.calendar),
              title: Text(_SearchPageState._formatDate(event.date)),
              subtitle: Text(event.source),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.location),
              title: Text(event.location ?? l10n.translate('search_filters_any_time')),
            ),
            const SizedBox(height: 24),
            Text(event.details),
          ],
        ),
      ),
    );
  }
}

class _ItemPreviewSheet extends StatelessWidget {
  const _ItemPreviewSheet({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.specs.entries
                  .map((entry) => Chip(label: Text('${entry.key}: ${entry.value}')))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.danger_triangle),
              title: Text(item.condition.name.replaceAll('_', ' ')),
            ),
            if (item.askingPrice != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(IconlyLight.wallet),
                title: Text('USD ${item.askingPrice!.toStringAsFixed(0)}'),
                subtitle: Text(l10n.translate('search_filters_sale_state_for_sale')),
              ),
            if (item.targetPrice != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(IconlyLight.tick_square),
                title: Text(l10n.translateWithArgs('items_target_price', {'price': item.targetPrice!.toStringAsFixed(0)})),
              ),
            if (item.notes != null) ...[
              const SizedBox(height: 12),
              Text(item.notes!, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
    );
  }
}
