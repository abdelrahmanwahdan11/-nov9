import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../controllers/items_controller.dart';
import '../../widgets/item_tile.dart';
import '../../../data/models/item.dart';

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
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('my_items'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...widget.controller.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemTile(
                        item: item,
                        onTap: () {},
                        onLongPress: () => widget.controller.toggleCompare(item),
                        selected: widget.controller.compareList.contains(item),
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(item.forSale ? IconlyLight.ticket_star : IconlyLight.heart, size: 18),
                          const SizedBox(width: 8),
                          Text(item.forSale ? l10n.translate('for_sale') : l10n.translate('keep')),
                          const Spacer(),
                          TextButton(
                            onPressed: () => widget.controller.setForSale(item, !item.forSale, price: item.askingPrice ?? 120),
                            child: Text(item.forSale ? 'Mark kept' : 'List for sale'),
                          ),
                        ],
                      ),
                      if (item.forSale && item.offers.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(l10n.translate('offers'), style: Theme.of(context).textTheme.titleMedium),
                            ...item.offers.map((offer) => ListTile(
                                  title: Text('${offer.from} offered ${offer.amount.toStringAsFixed(2)}'),
                                  subtitle: Text(offer.message ?? ''),
                                )),
                          ],
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(_tipForCondition(item.condition)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _tipForCondition(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.new_:
        return 'Keep the packaging to maintain mint value.';
      case ItemCondition.like_new:
        return 'Store in a dry location to preserve like-new quality.';
      case ItemCondition.used:
        return 'A gentle polish could restore its original shine.';
      case ItemCondition.needs_fix:
        return 'Consider a specialist repair to unlock its value.';
    }
  }
}
