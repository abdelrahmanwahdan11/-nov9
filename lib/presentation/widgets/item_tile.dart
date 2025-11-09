import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../data/models/item.dart';
import 'bento_bubble_card.dart';
import 'parallax_3d_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onLongPress,
    required this.color,
    this.selected = false,
    this.enableHero = true,
  });

  final Item item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color color;
  final bool selected;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    return BentoBubbleCard(
      backgroundColor: color,
      onTap: onTap,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Parallax3DImage(
                  imageUrl: item.imageUrl,
                  heroTag: 'item_card_${item.id}',
                  enableHero: enableHero,
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _conditionBadge(context),
                    const Spacer(),
                    if (item.forSale)
                      Row(
                        children: [
                          const Icon(IconlyLight.wallet, size: 20),
                          const SizedBox(width: 6),
                          Text('${item.askingPrice?.toStringAsFixed(0) ?? '--'} USD'),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.specs.entries
                      .map((entry) => Chip(
                            label: Text('${entry.key}: ${entry.value}'),
                          ))
                      .toList(),
                ),
                if (item.notes != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    item.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
            if (selected)
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 16,
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _conditionBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        item.condition.name.replaceAll('_', ' ').toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
