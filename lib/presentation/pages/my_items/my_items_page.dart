import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/item.dart';
import '../../../data/models/offer.dart';
import '../../controllers/items_controller.dart';
import '../../widgets/item_tile.dart';
import '../../widgets/item_composer_sheet.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({super.key, required this.controller});

  final ItemsController controller;

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final items = widget.controller.items;
          final kept = items.where((item) => !item.forSale).toList();
          final listed = items.where((item) => item.forSale).toList();
          final latestOffer = widget.controller.latestOffer;
          final recent = items.reversed.take(6).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.translate('my_items')),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.translate('my_items_tab_kept')),
                  Tab(text: l10n.translate('my_items_tab_listed')),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final item = await showItemComposerSheet(context);
                if (item != null) {
                  await widget.controller.addItem(item);
                }
              },
              icon: const Icon(IconlyLight.plus),
              label: Text(l10n.translate('add_item')),
            ),
            body: TabBarView(
              children: [
                _ItemsTab(
                  controller: widget.controller,
                  items: kept,
                  l10n: l10n,
                  header: _TabHeaderData(
                    title: l10n.translate('my_items_kept_title'),
                    subtitle: l10n.translateWithArgs('my_items_kept_count', {'count': kept.length.toString()}),
                    icon: IconlyLight.heart,
                  ),
                  recent: recent,
                  latestOffer: latestOffer,
                  showOfferBanner: false,
                ),
                _ItemsTab(
                  controller: widget.controller,
                  items: listed,
                  l10n: l10n,
                  header: _TabHeaderData(
                    title: l10n.translate('my_items_listed_title'),
                    subtitle: l10n.translateWithArgs('my_items_listed_count', {'count': listed.length.toString()}),
                    icon: IconlyLight.ticket_star,
                  ),
                  recent: recent,
                  latestOffer: latestOffer,
                  showOfferBanner: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab({
    required this.controller,
    required this.items,
    required this.l10n,
    required this.header,
    required this.recent,
    required this.latestOffer,
    required this.showOfferBanner,
  });

  final ItemsController controller;
  final List<Item> items;
  final AppLocalizations l10n;
  final _TabHeaderData header;
  final List<Item> recent;
  final Offer? latestOffer;
  final bool showOfferBanner;

  @override
  Widget build(BuildContext context) {
    final relevantRecent = recent.where((element) => items.contains(element)).toList();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _OverviewCard(header: header, items: items, controller: controller, l10n: l10n),
          ),
        ),
        if (showOfferBanner && latestOffer != null && items.any((item) => item.id == latestOffer!.itemId))
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _OfferBanner(offer: latestOffer!, controller: controller, l10n: l10n),
            ),
          ),
        if (relevantRecent.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.translate('my_items_recent'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = relevantRecent[index];
                        return SizedBox(
                          width: 220,
                          child: ItemTile(
                            item: item,
                            onTap: () => _showQuickLook(context, item),
                            onLongPress: () => controller.toggleCompare(item),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.16),
                            selected: controller.compareList.contains(item),
                            enableHero: false,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: relevantRecent.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(IconlyLight.bag_2, size: 52, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    l10n.translate('items_empty_state'),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _ItemManagementCard(
                      controller: controller,
                      item: item,
                      localization: l10n,
                      onShowItem: () => _showQuickLook(context, item),
                      onShowOffers: (offer) => _showOfferPreview(context, item, offer, l10n),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
      ],
    );
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
            enableHero: false,
            selected: false,
          ),
        );
      },
    );
  }

  Future<void> _showOfferPreview(BuildContext context, Item item, Offer offer, AppLocalizations l10n) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(
                l10n.translateWithArgs('items_offer_amount', {'amount': offer.amount.toStringAsFixed(0)}),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (offer.message != null && offer.message!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(offer.message!, style: Theme.of(context).textTheme.bodyMedium),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.translate('close')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.header,
    required this.items,
    required this.controller,
    required this.l10n,
  });

  final _TabHeaderData header;
  final List<Item> items;
  final ItemsController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avgCondition = items.isEmpty
        ? 0
        : items.map((item) => controller.conditionScoreFor(item)).reduce((a, b) => a + b) / items.length;
    final tips = items.map(controller.tipFor).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.12),
            theme.colorScheme.primary.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.18),
                child: Icon(header.icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(header.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    Text(header.subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: l10n.translate('my_items_metric_total'),
                  value: items.length.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  label: l10n.translate('my_items_metric_condition'),
                  value: '${avgCondition.round()}%',
                ),
              ),
            ],
          ),
          if (tips.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.translate('my_items_tips_title'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tips
                  .take(3)
                  .map(
                    (tip) => Chip(
                      avatar: const Icon(IconlyLight.info_circle, size: 16),
                      label: Text(l10n.translateWithArgs(tip.key, tip.args)),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.offer, required this.controller, required this.l10n});

  final Offer offer;
  final ItemsController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Item? item;
    for (final candidate in controller.items) {
      if (candidate.id == offer.itemId) {
        item = candidate;
        break;
      }
    }
    item ??= controller.items.isNotEmpty
        ? controller.items.first
        : Item(
            id: offer.itemId,
            name: l10n.translate('my_items_unknown_item'),
            specs: const {},
            imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
            condition: ItemCondition.like_new,
            notes: null,
            forSale: true,
            askingPrice: offer.amount,
            targetPrice: offer.amount,
            offers: const [],
          );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.85),
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.translateWithArgs('items_offer_banner', {'from': offer.from}),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: controller.dismissLatestOffer,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translateWithArgs('items_offer_amount', {'amount': offer.amount.toStringAsFixed(0)}),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(item.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87)),
          if (offer.message != null && offer.message!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('“${offer.message}”', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87)),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item!.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            Text(
                              l10n.translateWithArgs('items_offer_amount', {'amount': offer.amount.toStringAsFixed(0)}),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (offer.message != null && offer.message!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(offer.message!, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(l10n.translate('close')),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(l10n.translate('items_offer_view')),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: controller.dismissLatestOffer,
                child: Text(l10n.translate('items_offer_dismiss'), style: const TextStyle(color: Colors.black87)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemManagementCard extends StatelessWidget {
  const _ItemManagementCard({
    required this.controller,
    required this.item,
    required this.localization,
    required this.onShowItem,
    required this.onShowOffers,
  });

  final ItemsController controller;
  final Item item;
  final AppLocalizations localization;
  final VoidCallback onShowItem;
  final void Function(Offer offer) onShowOffers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conditionScore = controller.conditionScoreFor(item);
    final tip = controller.tipFor(item);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemTile(
            item: item,
            onTap: onShowItem,
            onLongPress: () => controller.toggleCompare(item),
            selected: controller.compareList.contains(item),
            color: theme.colorScheme.primary.withOpacity(0.16),
            enableHero: false,
          ),
          const SizedBox(height: 16),
          if (item.targetPrice != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Chip(
                avatar: const Icon(IconlyLight.tick_square, size: 18),
                label: Text(
                  localization.translateWithArgs('items_target_price', {'price': item.targetPrice!.toStringAsFixed(0)}),
                ),
              ),
            ),
          SwitchListTile.adaptive(
            value: item.forSale,
            contentPadding: EdgeInsets.zero,
            secondary: Icon(item.forSale ? IconlyLight.ticket_star : IconlyLight.heart),
            title: Text(
              item.forSale
                  ? localization.translate('items_sale_status_listed')
                  : localization.translate('items_sale_status_private'),
            ),
            subtitle: Text(localization.translate('items_set_price')),
            onChanged: (value) => _toggleSale(context, value),
          ),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _setTargetPrice(context),
                icon: const Icon(IconlyLight.discovery),
                label: Text(localization.translate('items_set_target')),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: item.targetPrice == null ? null : () => controller.setTargetPrice(item, null),
                child: Text(localization.translate('items_clear_target')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(localization.translate('items_condition_score'), style: theme.textTheme.titleMedium),
          Slider(
            value: conditionScore,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${conditionScore.round()}%',
            onChanged: (value) => controller.updateConditionScore(item, value),
          ),
          LinearProgressIndicator(
            value: conditionScore / 100,
            minHeight: 6,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(IconlyLight.info_circle),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localization.translateWithArgs(tip.key, tip.args),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (item.offers.isNotEmpty) ...[
            const SizedBox(height: 16),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.activity),
              title: Text(localization.translate('offers'), style: theme.textTheme.titleMedium),
              children: item.offers
                  .map(
                    (offer) => ListTile(
                      leading: const Icon(IconlyLight.user_1),
                      title: Text(offer.from),
                      subtitle: Text(offer.message ?? ''),
                      trailing: Text('USD ${offer.amount.toStringAsFixed(0)}'),
                      onTap: () => onShowOffers(offer),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggleSale(BuildContext context, bool value) async {
    final l10n = localization;
    if (value) {
      final price = await _promptPrice(context, l10n, initial: item.askingPrice ?? item.targetPrice ?? 120);
      if (price == null) {
        return;
      }
      await controller.setForSale(item, true, price: price);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('items_mark_for_sale'))),
      );
    } else {
      await controller.setForSale(item, false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('items_mark_keep'))),
      );
    }
  }

  Future<void> _setTargetPrice(BuildContext context) async {
    final price = await _promptPrice(
      context,
      localization,
      initial: item.targetPrice ?? item.askingPrice ?? 150,
      label: localization.translate('items_target_prompt'),
    );
    if (price == null) {
      return;
    }
    await controller.setTargetPrice(item, price);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localization.translate('items_target_saved'))),
    );
  }

  Future<double?> _promptPrice(
    BuildContext context,
    AppLocalizations l10n, {
    double? initial,
    String? label,
  }) async {
    final controller = TextEditingController(text: initial?.toStringAsFixed(0));
    final result = await showDialog<double?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label ?? l10n.translate('items_price_hint')),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: l10n.translate('items_price_hint')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.translate('cancel')),
            ),
            FilledButton(
              onPressed: () {
                final value = double.tryParse(controller.text.trim());
                Navigator.of(context).pop(value);
              },
              child: Text(l10n.translate('items_save')),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _TabHeaderData {
  const _TabHeaderData({required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;
}
