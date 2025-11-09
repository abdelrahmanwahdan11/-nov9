import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../../data/models/item.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/items_controller.dart';

class SharePosterPage extends StatefulWidget {
  const SharePosterPage({
    super.key,
    required this.eventsController,
    required this.itemsController,
  });

  final EventsController eventsController;
  final ItemsController itemsController;

  @override
  State<SharePosterPage> createState() => _SharePosterPageState();
}

class _SharePosterPageState extends State<SharePosterPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey _eventPosterKey = GlobalKey();
  final GlobalKey _itemPosterKey = GlobalKey();
  String? _selectedEventId;
  String? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([widget.eventsController, widget.itemsController, _tabController]),
      builder: (context, _) {
        final events = widget.eventsController.events;
        final items = widget.itemsController.items;
        _selectedEventId ??= events.isNotEmpty ? events.first.id : null;
        _selectedItemId ??= items.isNotEmpty ? items.first.id : null;
        Event? selectedEvent;
        if (_selectedEventId != null) {
          for (final event in events) {
            if (event.id == _selectedEventId) {
              selectedEvent = event;
              break;
            }
          }
        }
        selectedEvent ??= events.isNotEmpty ? events.first : null;
        Item? selectedItem;
        if (_selectedItemId != null) {
          for (final item in items) {
            if (item.id == _selectedItemId) {
              selectedItem = item;
              break;
            }
          }
        }
        selectedItem ??= items.isNotEmpty ? items.first : null;
        final empty = events.isEmpty && items.isEmpty;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('share_poster'))),
          body: empty
              ? Center(
                  child: Text(
                    l10n.translate('share_poster_none'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: l10n.translate('share_poster_event_tab')),
                        Tab(text: l10n.translate('share_poster_item_tab')),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _PosterConfigurator<Event>(
                            title: l10n.translate('share_poster_event'),
                            options: events,
                            selectedId: _selectedEventId,
                            displayLabel: (event) => event.title,
                            onChanged: (value) => setState(() => _selectedEventId = value),
                            poster: _PosterPreview(
                              posterKey: _eventPosterKey,
                              event: selectedEvent,
                              l10n: l10n,
                            ),
                          ),
                          _PosterConfigurator<Item>(
                            title: l10n.translate('share_poster_item'),
                            options: items,
                            selectedId: _selectedItemId,
                            displayLabel: (item) => item.name,
                            onChanged: (value) => setState(() => _selectedItemId = value),
                            poster: _PosterPreview(
                              posterKey: _itemPosterKey,
                              item: selectedItem,
                              l10n: l10n,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: FilledButton.icon(
                        onPressed: () => _exportPoster(l10n),
                        icon: const Icon(Icons.download),
                        label: Text(l10n.translate('share_poster_export')),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _exportPoster(AppLocalizations l10n) async {
    final key = _tabController.index == 0 ? _eventPosterKey : _itemPosterKey;
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null || !mounted) return;
    final sizeKb = (byteData.lengthInBytes / 1024).toStringAsFixed(1);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('share_poster_export')),
        content: Text(l10n.translateWithArgs('share_poster_success', {'size': sizeKb})),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.translate('close')),
          ),
        ],
      ),
    );
  }
}

class _PosterConfigurator<T> extends StatelessWidget {
  const _PosterConfigurator({
    required this.title,
    required this.options,
    required this.selectedId,
    required this.displayLabel,
    required this.onChanged,
    required this.poster,
  });

  final String title;
  final List<T> options;
  final String? selectedId;
  final String Function(T value) displayLabel;
  final ValueChanged<String?> onChanged;
  final Widget poster;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (options.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l10n.translate('share_poster_none'), style: Theme.of(context).textTheme.titleMedium),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: selectedId,
            isExpanded: true,
            items: options
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: _idOf(option),
                    child: Text(displayLabel(option)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
          const SizedBox(height: 24),
          Expanded(child: Center(child: poster)),
        ],
      ),
    );
  }

  String _idOf(T value) {
    if (value is Event) return value.id;
    if (value is Item) return value.id;
    throw ArgumentError('Unsupported type for poster configurator');
  }
}

class _PosterPreview extends StatelessWidget {
  const _PosterPreview({
    required this.posterKey,
    this.event,
    this.item,
    required this.l10n,
  });

  final GlobalKey posterKey;
  final Event? event;
  final Item? item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      key: posterKey,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.85),
              theme.colorScheme.primary.withOpacity(0.45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.32),
              blurRadius: 28,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: event != null ? _buildEventPoster(context, event!) : _buildItemPoster(context, item!),
      ),
    );
  }

  Widget _buildEventPoster(BuildContext context, Event event) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(context).formatFullDate(event.date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('today_digest'),
          style: theme.textTheme.labelLarge?.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Text(
          event.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(date, style: theme.textTheme.labelLarge?.copyWith(color: Colors.black87)),
        const Spacer(),
        Text(
          event.summary,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: event.tags.take(3).map((tag) => Chip(label: Text('#$tag'))).toList(),
        ),
      ],
    );
  }

  Widget _buildItemPoster(BuildContext context, Item item) {
    final theme = Theme.of(context);
    final price = item.askingPrice ?? item.targetPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('catalog'),
          style: theme.textTheme.labelLarge?.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: item.specs.entries
              .map(
                (entry) => Chip(
                  label: Text('${entry.key}: ${entry.value}'),
                ),
              )
              .toList(),
        ),
        const Spacer(),
        if (price != null)
          Text(
            l10n.translateWithArgs('items_offer_amount', {'amount': price.toStringAsFixed(0)}),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
