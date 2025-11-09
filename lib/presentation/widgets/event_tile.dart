import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../data/models/event.dart';
import '../../core/i18n/app_localizations.dart';
import 'bento_bubble_card.dart';
import 'parallax_3d_image.dart';

enum EventTileVariant { standard, tall, wide }

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
    required this.palette,
    this.variant = EventTileVariant.standard,
  });

  final Event event;
  final VoidCallback onTap;
  final List<Color> palette;
  final EventTileVariant variant;

  @override
  Widget build(BuildContext context) {
    final color = palette[event.category.index % palette.length];
    final theme = Theme.of(context);
    final isTall = variant == EventTileVariant.tall;
    final imageHeight = isTall ? 220.0 : 160.0;
    final summaryLines = isTall ? 4 : 2;
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      height: 1.05,
    );
    final l10n = AppLocalizations.of(context);
    final timeOfDay = TimeOfDay.fromDateTime(event.date).format(context);
    final materialLocalization = MaterialLocalizations.of(context);
    final dateLabel = materialLocalization.formatShortDate(event.date);

    return BentoBubbleCard(
      backgroundColor: color,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: titleStyle,
                  maxLines: isTall ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _DateBadge(timeOfDay: timeOfDay, dateLabel: dateLabel),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoPill(
                icon: IconlyLight.category,
                label: l10n.translate(event.category.name),
              ),
              const SizedBox(width: 12),
              _InfoPill(
                icon: IconlyLight.location,
                label: event.location ?? event.source,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Parallax3DImage(
            imageUrl: event.imageUrl,
            heroTag: 'event_card_${event.id}',
            height: imageHeight,
            onTap: onTap,
          ),
          const SizedBox(height: 18),
          Text(
            event.summary,
            maxLines: summaryLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: event.tags.take(4).map((tag) => _tagChip(context, tag)).toList(),
          ),
        ],
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

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.timeOfDay, required this.dateLabel});

  final String timeOfDay;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeOfDay,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            dateLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.white.withOpacity(0.8) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.14) : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.white : Colors.black87),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
