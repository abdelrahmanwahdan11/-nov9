
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/item.dart';
import '../../../data/models/offer.dart';
import '../../controllers/items_controller.dart';
import '../../widgets/item_tile.dart';

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
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final items = widget.controller.items;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('my_items'))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              _buildOfferBanner(context, l10n),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _ItemManagementCard(
                      controller: widget.controller,
                      item: item,
                      localization: l10n,
                      onShowItem: () => _showItemPreview(context, item),
                      onShowOffers: (offer) => _showOfferPreview(context, item, offer, l10n),
                    ),
                  )),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Column(
                    children: [
                      Icon(IconlyLight.bag_2, size: 56, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        l10n.translate('items_empty_state'),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfferBanner(BuildContext context, AppLocalizations l10n) {
    final offer = widget.controller.latestOffer;
    if (offer == null) {
      return const SizedBox.shrink();
    }
    final item = _findItem(offer.itemId);
    if (item == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: AnimatedContainer(
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: widget.controller.dismissLatestOffer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translateWithArgs(
                'items_offer_amount',
                {'amount': offer.amount.toStringAsFixed(0)},
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
            ),
            if (offer.message != null && offer.message!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '“${offer.message}”',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => _showOfferPreview(context, item, offer, l10n),
                  child: Text(l10n.translate('items_offer_view')),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: widget.controller.dismissLatestOffer,
                  child: Text(l10n.translate('items_offer_dismiss'), style: const TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Item? _findItem(String id) {
    for (final item in widget.controller.items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<void> _showItemPreview(BuildContext context, Item item) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ItemTile(
              item: item,
              onTap: () => Navigator.of(context).pop(),
              onLongPress: () {},
              color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showOfferPreview(
    BuildContext context,
    Item item,
    Offer offer,
    AppLocalizations l10n,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translateWithArgs('items_offer_amount', {'amount': offer.amount.toStringAsFixed(0)}),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (offer.message != null) ...[
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
          ),
        );
      },
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
          ),
          const SizedBox(height: 16),
          if (item.targetPrice != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Chip(
                avatar: const Icon(IconlyLight.tick_square, size: 18),
                label: Text(
                  localization.translateWithArgs(
                    'items_target_price',
                    {'price': item.targetPrice!.toStringAsFixed(0)},
                  ),
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
          Text(
            localization.translate('items_condition_score'),
            style: theme.textTheme.titleMedium,
          ),
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
