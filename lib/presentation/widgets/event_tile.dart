import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../data/models/event.dart';
import 'bento_bubble_card.dart';
import 'parallax_3d_image.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
    required this.palette,
  });

  final Event event;
  final VoidCallback onTap;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final color = palette[event.category.index % palette.length];
    return BentoBubbleCard(
      backgroundColor: color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Parallax3DImage(
            imageUrl: event.imageUrl,
            heroTag: 'event_card_${event.id}',
            onTap: onTap,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _pill(context, event.category.name.toUpperCase()),
              const SizedBox(width: 8),
              Icon(IconlyLight.calendar, size: 18, color: Colors.black87),
              const SizedBox(width: 4),
              Text(
                '${event.date.day}/${event.date.month}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            event.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: event.tags.map((tag) => _tagChip(context, tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tagChip(BuildContext context, String tag) {
    return Chip(
      label: Text('#$tag'),
      visualDensity: VisualDensity.compact,
    );
  }
}
