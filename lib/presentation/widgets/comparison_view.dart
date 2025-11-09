import 'package:flutter/material.dart';

import '../../data/models/item.dart';
import 'item_tile.dart';

class ComparisonView extends StatelessWidget {
  const ComparisonView({super.key, required this.items, required this.palette});

  final List<Item> items;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    if (items.length < 2) {
      return const SizedBox.shrink();
    }
    final specKeys = <String>{};
    for (final item in items) {
      specKeys.addAll(item.specs.keys);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comparison', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemTile(
                item: items[0],
                onTap: () {},
                onLongPress: () {},
                color: palette.first,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ItemTile(
                item: items[1],
                onTap: () {},
                onLongPress: () {},
                color: palette[1 % palette.length],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...specKeys.map((key) {
          final values = items.map((item) => item.specs[key] ?? '—').toList();
          final isDifferent = values.toSet().length > 1;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDifferent ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(key, style: Theme.of(context).textTheme.titleMedium),
                ),
                ...values.map(
                  (value) => Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: isDifferent ? FontWeight.bold : FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
