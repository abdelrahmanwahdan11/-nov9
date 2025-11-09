import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/historical_event.dart';
import '../controllers/on_this_day_controller.dart';
import 'bento_bubble_card.dart';
import 'parallax_3d_image.dart';

class OnThisDayCard extends StatelessWidget {
  const OnThisDayCard({
    super.key,
    required this.event,
    required this.color,
    required this.l10n,
  });

  final HistoricalEvent event;
  final Color color;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final countryLabel = event.country.toLowerCase() == 'global'
        ? l10n.translate('on_this_day_country_global')
        : event.country;
    final yearLabel = l10n.translateWithArgs('on_this_day_year_label', {
      'year': event.date.year.toString(),
    });
    return BentoBubbleCard(
      backgroundColor: color.withOpacity(0.35),
      onTap: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Parallax3DImage(
            imageUrl: event.imageUrl,
            heroTag: 'historical_${event.id}',
            enableHero: false,
            height: 200,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Chip(
                avatar: const Icon(IconlyLight.discovery, size: 18),
                label: Text(countryLabel),
              ),
              Chip(
                avatar: const Icon(IconlyLight.category, size: 18),
                label: Text(l10n.translate(event.type.localizationKey())),
              ),
              Chip(
                avatar: const Icon(IconlyLight.time_circle, size: 18),
                label: Text(yearLabel),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: theme.textTheme.bodyMedium,
          ),
          if (event.highlights.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.translate('on_this_day_highlights'),
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: event.highlights
                  .map(
                    (highlight) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              highlight,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (event.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: event.tags
                  .map(
                    (tag) => InputChip(
                      label: Text('#$tag'),
                      onPressed: () {},
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(IconlyLight.paper),
              label: Text(
                l10n.translateWithArgs('on_this_day_source', {'source': event.source}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
