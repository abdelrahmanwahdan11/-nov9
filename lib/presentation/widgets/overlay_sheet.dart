import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/event.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/events_controller.dart';
import '../controllers/overlay_controller.dart';
import 'flip_card.dart';
import 'parallax_3d_image.dart';

class OverlaySheet extends StatelessWidget {
  const OverlaySheet({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.bookmarksController,
    required this.onTagSelected,
    this.onDismiss,
  });

  final OverlayController controller;
  final EventsController eventsController;
  final BookmarksController bookmarksController;
  final ValueChanged<String> onTagSelected;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final event = controller.activeEvent;
    if (event == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final related = eventsController
        .relatedFor(event)
        .where((candidate) => candidate.id != event.id)
        .take(6)
        .toList();
    final isBookmarked = bookmarksController.isBookmarked(event.id);
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      minChildSize: 0.42,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withOpacity(0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isBookmarked ? IconlyBold.bookmark : IconlyLight.bookmark),
                      onPressed: () {
                        bookmarksController.toggle(event.id);
                        final added = bookmarksController.isBookmarked(event.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.translate(added ? 'bookmark_added' : 'bookmark_removed'),
                            ),
                            duration: const Duration(milliseconds: 1400),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.hide();
                        onDismiss?.call();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Hero(
                  tag: 'event_card_${event.id}',
                  child: SizedBox(
                    height: 240,
                    child: FlipCard(
                      showFront: !controller.flipped,
                      front: GestureDetector(
                        onTap: controller.toggleFlip,
                        child: Parallax3DImage(
                          imageUrl: event.imageUrl,
                          heroTag: 'event_card_${event.id}',
                          onTap: controller.toggleFlip,
                        ),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.28),
                              theme.colorScheme.primary.withOpacity(0.08),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.details, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: event.tags
                                  .map(
                                    (tag) => InputChip(
                                      label: Text('#$tag'),
                                      onPressed: () {
                                        onTagSelected(tag);
                                        controller.hide();
                                        onDismiss?.call();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(l10n.translate('quick_facts'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FactChip(icon: IconlyLight.category, label: l10n.translate(event.category.name)),
                    _FactChip(icon: IconlyLight.calendar, label: MaterialLocalizations.of(context).formatShortDate(event.date)),
                    if (event.location != null && event.location!.isNotEmpty)
                      _FactChip(icon: IconlyLight.location, label: event.location!),
                    _FactChip(icon: IconlyLight.paper, label: event.source),
                  ],
                ),
                const SizedBox(height: 20),
                Text(event.summary, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                if (event.tags.isNotEmpty) ...[
                  Text(l10n.translate('search_filters_tags'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: event.tags
                        .map(
                          (tag) => ActionChip(
                            label: Text('#$tag'),
                            onPressed: () {
                              onTagSelected(tag);
                              controller.hide();
                              onDismiss?.call();
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (related.isNotEmpty) ...[
                  Text(l10n.translate('related_events'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = related[index];
                        return _RelatedEventCard(
                          event: item,
                          onTap: () {
                            controller.show(item);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: related.length,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                FilledButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.translate('ai_insight'),
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              const Text('AI insights are coming soon. Stay tuned!'),
                              const SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(IconlyLight.discovery),
                  label: Text(l10n.translate('ai_insight')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _RelatedEventCard extends StatelessWidget {
  const _RelatedEventCard({required this.event, required this.onTap});

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.18),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              MaterialLocalizations.of(context).formatShortDate(event.date),
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
