import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/event.dart';
import '../../../data/models/historical_event.dart';
import '../../../data/models/item.dart';
import '../../../data/models/saved_filter.dart';
import '../../../data/services/stats_service.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/items_controller.dart';
import '../../controllers/on_this_day_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/trends_controller.dart';

class BriefingPage extends StatelessWidget {
  const BriefingPage({
    super.key,
    required this.routerState,
    required this.eventsController,
    required this.itemsController,
    required this.trendsController,
    required this.bookmarksController,
    required this.onThisDayController,
    required this.filtersController,
    required this.searchController,
    required this.onSelectTab,
  });

  final AppRouterState routerState;
  final EventsController eventsController;
  final ItemsController itemsController;
  final TrendsController trendsController;
  final BookmarksController bookmarksController;
  final OnThisDayController onThisDayController;
  final FiltersController filtersController;
  final SearchPageController searchController;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        eventsController,
        itemsController,
        trendsController,
        bookmarksController,
        onThisDayController,
        filtersController,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final events = eventsController.events;
        final snapshot = trendsController.snapshot;
        final categoryStats = snapshot?.categoryStats ?? const <CategoryStat>[];
        final leadCategory = categoryStats.isNotEmpty
            ? categoryStats.reduce((value, element) => element.count > value.count ? element : value)
            : null;
        final leadCategoryLabel = leadCategory != null && leadCategory.count > 0
            ? l10n.translate(leadCategory.category.name)
            : l10n.translate('briefing_metric_none');
        final topTags = snapshot?.topTags ?? const <TagStat>[];
        final savedFilters = filtersController.filters;
        final bookmarkedEvents = bookmarksController.bookmarks
            .map(eventsController.findById)
            .whereType<Event>()
            .toList();
        final trackedItems = itemsController.items;
        final timelinePreview = onThisDayController.events;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('briefing_title')),
            actions: [
              IconButton(
                tooltip: l10n.translate('briefing_open_search'),
                icon: const Icon(IconlyLight.search),
                onPressed: () => routerState.push(AppPage.search),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            physics: const BouncingScrollPhysics(),
            children: [
              _BriefingHeader(
                totalEvents: events.length,
                totalItems: trackedItems.length,
                leadCategory: leadCategoryLabel,
                l10n: l10n,
              ),
              const SizedBox(height: 24),
              _QuickActions(
                l10n: l10n,
                onShowSearch: () => onSelectTab(2),
                onOpenIngest: () => routerState.push(AppPage.ingest),
                onShowTimeline: () => onSelectTab(3),
                onShowInventory: () => onSelectTab(5),
                onOpenTrends: () => routerState.push(AppPage.trends),
                onOpenShare: () => routerState.push(AppPage.sharePoster),
              ),
              if (categoryStats.isNotEmpty) ...[
                const SizedBox(height: 24),
                _CategoryBreakdown(stats: categoryStats, l10n: l10n),
              ],
              if (topTags.isNotEmpty) ...[
                const SizedBox(height: 24),
                _TagCloud(tags: topTags, l10n: l10n),
              ],
              const SizedBox(height: 24),
              _SavedFiltersCard(
                l10n: l10n,
                filters: savedFilters,
                onManage: () => onSelectTab(2),
                onApply: (filter) => _applyFilter(context, filter, l10n),
              ),
              const SizedBox(height: 24),
              _BookmarksPreview(
                events: bookmarkedEvents,
                l10n: l10n,
                onOpenAll: () => routerState.push(AppPage.bookmarks),
              ),
              const SizedBox(height: 24),
              _ItemsPreview(
                items: trackedItems,
                l10n: l10n,
                onOpenInventory: () => onSelectTab(5),
              ),
              const SizedBox(height: 24),
              _HistoricalPreview(
                events: timelinePreview,
                l10n: l10n,
                onOpenTimeline: () => onSelectTab(3),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(BuildContext context, SavedFilter filter, AppLocalizations l10n) {
    searchController.applySavedFilter(filter);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.translateWithArgs('search_saved_filter_applied', {'name': filter.name}),
        ),
      ),
    );
    onSelectTab(2);
  }
}

class _BriefingHeader extends StatelessWidget {
  const _BriefingHeader({
    required this.totalEvents,
    required this.totalItems,
    required this.leadCategory,
    required this.l10n,
  });

  final int totalEvents;
  final int totalItems;
  final String leadCategory;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      color: theme.colorScheme.primary.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('briefing_intro'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 18,
              runSpacing: 12,
              children: [
                _MetricTile(
                  icon: IconlyLight.paper,
                  label: l10n.translate('briefing_metric_events'),
                  value: totalEvents.toString(),
                ),
                _MetricTile(
                  icon: IconlyLight.bag,
                  label: l10n.translate('briefing_metric_items'),
                  value: totalItems.toString(),
                ),
                _MetricTile(
                  icon: IconlyLight.star,
                  label: l10n.translate('briefing_metric_lead_category'),
                  value: leadCategory,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.l10n,
    required this.onShowSearch,
    required this.onOpenIngest,
    required this.onShowTimeline,
    required this.onShowInventory,
    required this.onOpenTrends,
    required this.onOpenShare,
  });

  final AppLocalizations l10n;
  final VoidCallback onShowSearch;
  final VoidCallback onOpenIngest;
  final VoidCallback onShowTimeline;
  final VoidCallback onShowInventory;
  final VoidCallback onOpenTrends;
  final VoidCallback onOpenShare;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(IconlyLight.search, l10n.translate('briefing_action_search'), onShowSearch),
      _QuickAction(IconlyLight.edit, l10n.translate('briefing_action_ingest'), onOpenIngest),
      _QuickAction(IconlyLight.calendar, l10n.translate('briefing_action_on_this_day'), onShowTimeline),
      _QuickAction(IconlyLight.category, l10n.translate('briefing_action_inventory'), onShowInventory),
      _QuickAction(IconlyLight.activity, l10n.translate('briefing_action_trends'), onOpenTrends),
      _QuickAction(IconlyLight.send, l10n.translate('briefing_action_share'), onOpenShare),
    ];
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('briefing_quick_actions'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions
              .map(
                (action) => ActionChip(
                  avatar: Icon(action.icon, size: 18),
                  label: Text(action.label),
                  onPressed: action.onPressed,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.onPressed);

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.stats, required this.l10n});

  final List<CategoryStat> stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final total = stats.fold<int>(0, (previousValue, element) => previousValue + element.count);
    if (total == 0) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('briefing_category_breakdown'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ...stats.map((stat) {
              final ratio = stat.count / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate(stat.category.name), style: theme.textTheme.labelLarge),
                        Text(stat.count.toString(), style: theme.textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: ratio),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TagCloud extends StatelessWidget {
  const _TagCloud({required this.tags, required this.l10n});

  final List<TagStat> tags;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('briefing_top_tags'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text('#${tag.tag} · ${tag.count}'),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedFiltersCard extends StatelessWidget {
  const _SavedFiltersCard({
    required this.l10n,
    required this.filters,
    required this.onManage,
    required this.onApply,
  });

  final AppLocalizations l10n;
  final List<SavedFilter> filters;
  final VoidCallback onManage;
  final ValueChanged<SavedFilter> onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.translate('search_saved_filters'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onManage,
                  child: Text(l10n.translate('briefing_manage_filters')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filters.isEmpty)
              Text(
                l10n.translate('briefing_no_saved_filters'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              )
            else
              Column(
                children: filters.take(3).map((filter) {
                  final kindLabel = filter.kind == SavedFilterKind.events
                      ? l10n.translate('search_events')
                      : l10n.translate('search_items');
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(filter.name, style: theme.textTheme.titleMedium),
                    subtitle: Text(kindLabel),
                    trailing: const Icon(IconlyLight.arrow_right_2),
                    onTap: () => onApply(filter),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookmarksPreview extends StatelessWidget {
  const _BookmarksPreview({required this.events, required this.l10n, required this.onOpenAll});

  final List<Event> events;
  final AppLocalizations l10n;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.translate('briefing_bookmarks_title'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onOpenAll,
                  child: Text(l10n.translate('briefing_bookmarks_more')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              Text(
                l10n.translate('briefing_bookmarks_empty'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              )
            else
              Column(
                children: events.take(3).map((event) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.imageUrl),
                    ),
                    title: Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(event.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: onOpenAll,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemsPreview extends StatelessWidget {
  const _ItemsPreview({required this.items, required this.l10n, required this.onOpenInventory});

  final List<Item> items;
  final AppLocalizations l10n;
  final VoidCallback onOpenInventory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.translate('briefing_items_title'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onOpenInventory,
                  child: Text(l10n.translate('briefing_items_manage')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              Text(
                l10n.translate('briefing_items_empty'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              )
            else
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length > 6 ? 6 : items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ItemCard(item: item);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  item.condition.name.replaceAll('_', ' '),
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoricalPreview extends StatelessWidget {
  const _HistoricalPreview({required this.events, required this.l10n, required this.onOpenTimeline});

  final List<HistoricalEvent> events;
  final AppLocalizations l10n;
  final VoidCallback onOpenTimeline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.translate('briefing_historical_title'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onOpenTimeline,
                  child: Text(l10n.translate('briefing_history_open')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              Text(
                l10n.translate('briefing_historical_empty'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              )
            else
              Column(
                children: events.take(3).map((event) {
                  final formattedDate = MaterialLocalizations.of(context).formatMediumDate(event.date);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.imageUrl),
                    ),
                    title: Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('$formattedDate · ${event.country}'),
                    onTap: onOpenTimeline,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
