import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/item.dart';
import '../../controllers/items_controller.dart';
import '../../widgets/comparison_view.dart';
import '../../widgets/item_tile.dart';
import '../../widgets/item_composer_sheet.dart';

enum _CatalogSort { name, condition, priceLowHigh, priceHighLow }

class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    required this.controller,
    this.embedded = false,
    this.showFab = true,
  });

  final ItemsController controller;
  final bool embedded;
  final bool showFab;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _grid = true;
  String _query = '';
  final _conditions = <ItemCondition>{};
  bool _forSaleOnly = false;
  _CatalogSort _sort = _CatalogSort.name;
  RangeValues? _priceRange;
  double? _minPrice;
  double? _maxPrice;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = [
      DesignTokens.colors['sky']!,
      DesignTokens.colors['pink']!,
      DesignTokens.colors['mint']!,
      DesignTokens.colors['blue']!,
      DesignTokens.colors['lime']!,
    ];

    final content = AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final items = widget.controller.items;
        _syncPriceBounds(items);
        final filtered = _applyFilters(items);
        final targetHighlights = items
            .where(
              (item) =>
                  item.targetPrice != null &&
                  _priceOf(item) != null &&
                  _priceOf(item)! >= item.targetPrice! * 0.9 &&
                  _priceOf(item)! <= item.targetPrice! * 1.1,
            )
            .toList();
        final forSaleShowcase = items.where((item) => item.forSale).take(6).toList();
        var recentShowcase = items.reversed.where((item) => !item.forSale).take(6).toList();
        if (recentShowcase.length < 3) {
          recentShowcase = items.reversed.take(6).toList();
        }
        final reversedPalette = palette.reversed.toList();

        final body = CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: _Header(
                    controller: widget.controller,
                    l10n: l10n,
                    query: _query,
                    onQueryChanged: (value) => setState(() => _query = value),
                    searchController: _searchController,
                    selectedConditions: _conditions,
                    onToggleCondition: _toggleCondition,
                    forSaleOnly: _forSaleOnly,
                    onToggleForSale: (value) => setState(() => _forSaleOnly = value),
                    sort: _sort,
                    onSortChanged: (value) => setState(() => _sort = value),
                    minPrice: _minPrice,
                    maxPrice: _maxPrice,
                    priceRange: _priceRange,
                    onPriceChanged: (values) => setState(() => _priceRange = values),
                    gridView: _grid,
                    allItems: items,
                    filteredItems: filtered,
                    targetHighlights: targetHighlights,
                    showLayoutToggle: widget.embedded,
                    onToggleLayout: () => setState(() => _grid = !_grid),
                  ),
                ),
              ),
              if (forSaleShowcase.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 24),
                    child: _SpotlightRail(
                      title: l10n.translate('catalog_spotlight_for_sale'),
                      subtitle: l10n.translate('catalog_spotlight_for_sale_subtitle'),
                      items: forSaleShowcase,
                      palette: palette,
                      controller: widget.controller,
                      onOpenQuickLook: (item) => _showQuickLook(context, item),
                    ),
                  ),
                ),
              if (recentShowcase.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 24),
                    child: _SpotlightRail(
                      title: l10n.translate('catalog_spotlight_recent'),
                      subtitle: l10n.translate('catalog_spotlight_recent_subtitle'),
                      items: recentShowcase,
                      palette: reversedPalette,
                      controller: widget.controller,
                      onOpenQuickLook: (item) => _showQuickLook(context, item),
                    ),
                  ),
                ),
              if (widget.controller.compareList.length == 2)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: ComparisonView(items: widget.controller.compareList, palette: palette),
                  ),
                ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconlyLight.box, size: 48, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.translate('catalog_empty'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else if (_grid)
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    var crossAxisCount = (constraints.crossAxisExtent / 260).floor();
                    if (crossAxisCount < 2) {
                      crossAxisCount = 2;
                    }
                    if (crossAxisCount > 4) {
                      crossAxisCount = 4;
                    }
                    final imageHeight = crossAxisCount >= 3 ? 150.0 : 200.0;
                    final aspectRatio = crossAxisCount >= 3 ? 0.9 : 0.72;
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = filtered[index];
                            return ItemTile(
                              item: item,
                              onTap: () => _showQuickLook(context, item),
                              onLongPress: () => widget.controller.toggleCompare(item),
                              color: palette[index % palette.length],
                              selected: widget.controller.compareList.contains(item),
                              imageHeight: imageHeight,
                            );
                          },
                          childCount: filtered.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: aspectRatio,
                        ),
                      ),
                    );
                  },
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ItemTile(
                            item: item,
                            onTap: () => _showQuickLook(context, item),
                            onLongPress: () => widget.controller.toggleCompare(item),
                            color: palette[index % palette.length],
                            selected: widget.controller.compareList.contains(item),
                            imageHeight: 220,
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        );

        if (widget.embedded) {
          return body;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('catalog')),
            actions: [
              IconButton(
                tooltip: l10n.translate(_grid ? 'catalog_view_list' : 'catalog_view_grid'),
                icon: Icon(_grid ? IconlyLight.paper : IconlyLight.category),
                onPressed: () => setState(() => _grid = !_grid),
              ),
            ],
          ),
          floatingActionButton: widget.showFab
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    final item = await showItemComposerSheet(context);
                    if (item != null) {
                      await widget.controller.addItem(item);
                    }
                  },
                  icon: const Icon(IconlyLight.plus),
                  label: Text(l10n.translate('add_item')),
                )
              : null,
          body: body,
        );
      },
    );

    if (widget.embedded && widget.showFab) {
      return Stack(
        children: [
          content,
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final item = await showItemComposerSheet(context);
                if (item != null) {
                  await widget.controller.addItem(item);
                }
              },
              icon: const Icon(IconlyLight.plus),
              label: Text(AppLocalizations.of(context).translate('add_item')),
            ),
          ),
        ],
      );
    }

    return content;
  }

  void _showQuickLook(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: ItemTile(
            item: item,
            onTap: () => Navigator.of(context).pop(),
            onLongPress: () {},
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            selected: false,
            enableHero: false,
            enableScroll: true,
            imageHeight: 220,
          ),
        );
      },
    );
  }

  void _toggleCondition(ItemCondition condition) {
    setState(() {
      if (_conditions.contains(condition)) {
        _conditions.remove(condition);
      } else {
        _conditions.add(condition);
      }
    });
  }

  void _syncPriceBounds(List<Item> items) {
    final priced = items.map(_priceOf).whereType<double>().toList();
    if (priced.isEmpty) {
      if (_priceRange != null || _minPrice != null || _maxPrice != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _priceRange = null;
            _minPrice = null;
            _maxPrice = null;
          });
        });
      }
      return;
    }
    final min = priced.reduce(math.min);
    final max = priced.reduce(math.max);
    if (_minPrice == min && _maxPrice == max && _priceRange != null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final resolvedMax = max == min ? max + 10 : max;
      setState(() {
        _minPrice = min;
        _maxPrice = resolvedMax;
        _priceRange = RangeValues(min, resolvedMax);
      });
    });
  }

  List<Item> _applyFilters(List<Item> source) {
    final queryLower = _query.trim().toLowerCase();
    final List<Item> filtered = [];
    for (final item in source) {
      if (_forSaleOnly && !item.forSale) {
        continue;
      }
      if (_conditions.isNotEmpty && !_conditions.contains(item.condition)) {
        continue;
      }
      if (_priceRange != null) {
        final price = _priceOf(item);
        if (price == null || price < _priceRange!.start || price > _priceRange!.end) {
          continue;
        }
      }
      if (queryLower.isNotEmpty) {
        final haystack = <String?>[
          item.name,
          item.notes,
          ...item.specs.values,
        ].whereType<String>().join(' ').toLowerCase();
        if (!haystack.contains(queryLower)) {
          continue;
        }
      }
      filtered.add(item);
    }

    filtered.sort((a, b) {
      switch (_sort) {
        case _CatalogSort.name:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case _CatalogSort.condition:
          return a.condition.index.compareTo(b.condition.index);
        case _CatalogSort.priceLowHigh:
          return _comparePrice(a, b);
        case _CatalogSort.priceHighLow:
          return _comparePrice(a, b, descending: true);
      }
    });
    return filtered;
  }

  double? _priceOf(Item item) {
    return item.askingPrice ?? item.targetPrice;
  }

  int _comparePrice(Item a, Item b, {bool descending = false}) {
    final priceA = _priceOf(a);
    final priceB = _priceOf(b);
    if (priceA == null && priceB == null) return 0;
    if (priceA == null) return 1;
    if (priceB == null) return -1;
    final comparison = priceA.compareTo(priceB);
    return descending ? -comparison : comparison;
  }
}

class _SpotlightRail extends StatelessWidget {
  const _SpotlightRail({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.palette,
    required this.controller,
    required this.onOpenQuickLook,
  });

  final String title;
  final String subtitle;
  final List<Item> items;
  final List<Color> palette;
  final ItemsController controller;
  final ValueChanged<Item> onOpenQuickLook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: 260,
                child: ItemTile(
                  item: item,
                  onTap: () => onOpenQuickLook(item),
                  onLongPress: () => controller.toggleCompare(item),
                  color: palette[index % palette.length],
                  selected: controller.compareList.contains(item),
                  imageHeight: 170,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.l10n,
    required this.query,
    required this.onQueryChanged,
    required this.searchController,
    required this.selectedConditions,
    required this.onToggleCondition,
    required this.forSaleOnly,
    required this.onToggleForSale,
    required this.sort,
    required this.onSortChanged,
    required this.minPrice,
    required this.maxPrice,
    required this.priceRange,
    required this.onPriceChanged,
    required this.gridView,
    required this.allItems,
    required this.filteredItems,
    required this.targetHighlights,
    required this.showLayoutToggle,
    required this.onToggleLayout,
  });

  final ItemsController controller;
  final AppLocalizations l10n;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final TextEditingController searchController;
  final Set<ItemCondition> selectedConditions;
  final ValueChanged<ItemCondition> onToggleCondition;
  final bool forSaleOnly;
  final ValueChanged<bool> onToggleForSale;
  final _CatalogSort sort;
  final ValueChanged<_CatalogSort> onSortChanged;
  final double? minPrice;
  final double? maxPrice;
  final RangeValues? priceRange;
  final ValueChanged<RangeValues> onPriceChanged;
  final bool gridView;
  final List<Item> allItems;
  final List<Item> filteredItems;
  final List<Item> targetHighlights;
  final bool showLayoutToggle;
  final VoidCallback onToggleLayout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totals = _Totals.from(allItems);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: onQueryChanged,
                decoration: InputDecoration(
                  hintText: l10n.translate('catalog_search_hint'),
                  prefixIcon: const Icon(IconlyLight.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            onQueryChanged('');
                          },
                        ),
                ),
              ),
            ),
            if (showLayoutToggle) ...[
              const SizedBox(width: 12),
              Tooltip(
                message: l10n.translate(gridView ? 'catalog_view_list' : 'catalog_view_grid'),
                child: FilledButton.tonal(
                  onPressed: onToggleLayout,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(gridView ? IconlyLight.paper : IconlyLight.category),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatChip(label: l10n.translate('catalog_stats_total'), value: totals.total.toString()),
            _StatChip(label: l10n.translate('catalog_stats_for_sale'), value: totals.forSale.toString()),
            _StatChip(label: l10n.translate('catalog_stats_kept'), value: totals.kept.toString()),
            _StatChip(label: l10n.translate('catalog_stats_compare'), value: controller.compareList.length.toString()),
          ],
        ),
        if (targetHighlights.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.18),
                  theme.colorScheme.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(IconlyLight.graph),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('catalog_target_matches'),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        targetHighlights.map((item) => item.name).join(', '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(l10n.translate('catalog_filters_conditions'), style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ItemCondition.values
              .map(
                (condition) => FilterChip(
                  label: Text(l10n.translate('item_condition_${condition.name}')),
                  selected: selectedConditions.contains(condition),
                  onSelected: (_) => onToggleCondition(condition),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: forSaleOnly,
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.translate('catalog_filters_sale_only')),
          onChanged: onToggleForSale,
        ),
        if (priceRange != null && minPrice != null && maxPrice != null) ...[
          const SizedBox(height: 8),
          Text(l10n.translate('catalog_filters_price'), style: theme.textTheme.titleSmall),
          RangeSlider(
            values: priceRange!,
            min: minPrice!,
            max: maxPrice!,
            divisions: math.max(1, (maxPrice! - minPrice!) ~/ 10),
            labels: RangeLabels(
              priceRange!.start.toStringAsFixed(0),
              priceRange!.end.toStringAsFixed(0),
            ),
            onChanged: onPriceChanged,
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<_CatalogSort>(
                value: sort,
                decoration: InputDecoration(
                  labelText: l10n.translate('catalog_sort_label'),
                  prefixIcon: const Icon(IconlyLight.filter),
                ),
                items: [
                  DropdownMenuItem(
                    value: _CatalogSort.name,
                    child: Text(l10n.translate('catalog_sort_name')),
                  ),
                  DropdownMenuItem(
                    value: _CatalogSort.condition,
                    child: Text(l10n.translate('catalog_sort_condition')),
                  ),
                  DropdownMenuItem(
                    value: _CatalogSort.priceLowHigh,
                    child: Text(l10n.translate('catalog_sort_price_low')),
                  ),
                  DropdownMenuItem(
                    value: _CatalogSort.priceHighLow,
                    child: Text(l10n.translate('catalog_sort_price_high')),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Icon(gridView ? IconlyLight.category : IconlyLight.paper),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.translateWithArgs('catalog_results_count', {
            'count': filteredItems.length.toString(),
          }),
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _Totals {
  const _Totals({required this.total, required this.forSale, required this.kept});

  final int total;
  final int forSale;
  final int kept;

  static _Totals from(List<Item> items) {
    var forSale = 0;
    var kept = 0;
    for (final item in items) {
      if (item.forSale) {
        forSale++;
      } else {
        kept++;
      }
    }
    return _Totals(total: items.length, forSale: forSale, kept: kept);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}
