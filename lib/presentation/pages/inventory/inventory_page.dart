import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/item.dart';
import '../../controllers/items_controller.dart';
import '../catalog/catalog_page.dart';
import '../my_items/my_items_page.dart';
import '../../widgets/item_composer_sheet.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key, required this.controller});

  final ItemsController controller;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('inventory_hub_title')),
        actions: [
          IconButton(
            tooltip: l10n.translate('inventory_open_insights'),
            icon: const Icon(IconlyLight.chart),
            onPressed: () => _openInsights(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.translate('inventory_tab_catalog')),
                  Tab(text: l10n.translate('inventory_tab_collection')),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final stats = _InventoryStats.fromItems(widget.controller.items);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StatChip(label: l10n.translate('inventory_stat_total'), value: stats.total.toString()),
                        _StatChip(label: l10n.translate('inventory_stat_for_sale'), value: stats.forSale.toString()),
                        _StatChip(label: l10n.translate('inventory_stat_kept'), value: stats.kept.toString()),
                        _StatChip(
                          label: l10n.translate('inventory_stat_compare_ready'),
                          value: widget.controller.compareList.length.toString(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CatalogPage(controller: widget.controller, embedded: true, showFab: false),
          MyItemsPage(controller: widget.controller, embedded: true, showFab: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _composeItem(context),
        icon: const Icon(IconlyLight.plus),
        label: Text(l10n.translate('inventory_add_item')),
      ),
    );
  }

  Future<void> _composeItem(BuildContext context) async {
    final item = await showItemComposerSheet(context);
    if (item != null) {
      await widget.controller.addItem(item);
    }
  }

  void _openInsights(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: widget.controller,
          builder: (context, _) {
            final stats = _InventoryStats.fromItems(widget.controller.items);
            final conditions = _conditionBreakdown(widget.controller.items);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.translate('inventory_sheet_title'), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _InsightRow(label: l10n.translate('inventory_stat_total'), value: stats.total.toString()),
                  _InsightRow(label: l10n.translate('inventory_stat_for_sale'), value: stats.forSale.toString()),
                  _InsightRow(label: l10n.translate('inventory_stat_kept'), value: stats.kept.toString()),
                  const SizedBox(height: 12),
                  Text(l10n.translate('inventory_sheet_conditions'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...conditions.entries.map(
                    (entry) => ListTile(
                      dense: true,
                      leading: CircleAvatar(child: Text(entry.key.name.substring(0, 1).toUpperCase())),
                      title: Text(entry.key.name.replaceAll('_', ' ').toUpperCase()),
                      trailing: Text(entry.value.toString()),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Map<ItemCondition, int> _conditionBreakdown(List<Item> items) {
    final breakdown = <ItemCondition, int>{};
    for (final item in items) {
      breakdown.update(item.condition, (value) => value + 1, ifAbsent: () => 1);
    }
    return breakdown;
  }
}

class _InventoryStats {
  const _InventoryStats({required this.total, required this.forSale, required this.kept});

  final int total;
  final int forSale;
  final int kept;

  static _InventoryStats fromItems(List<Item> items) {
    final total = items.length;
    final forSale = items.where((item) => item.forSale).length;
    final kept = total - forSale;
    return _InventoryStats(total: total, forSale: forSale, kept: kept);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
