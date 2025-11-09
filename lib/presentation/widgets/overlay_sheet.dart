import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/event.dart';
import '../controllers/overlay_controller.dart';
import 'flip_card.dart';
import 'parallax_3d_image.dart';

class OverlaySheet extends StatelessWidget {
  const OverlaySheet({super.key, required this.controller});

  final OverlayController controller;

  @override
  Widget build(BuildContext context) {
    final event = controller.activeEvent;
    if (event == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: controller.toggleFlip,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.94),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: controller.hide,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Hero(
                      tag: 'event_card_${event.id}',
                      child: SizedBox(
                        height: 220,
                        child: FlipCard(
                          showFront: !controller.flipped,
                          front: Parallax3DImage(
                            imageUrl: event.imageUrl,
                            heroTag: 'event_card_${event.id}',
                            onTap: controller.toggleFlip,
                          ),
                          back: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.details, style: Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(IconlyLight.location, size: 20),
                                    const SizedBox(width: 6),
                                    Text(event.location ?? '—'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: event.tags.map((tag) => Chip(label: Text('#$tag'))).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(IconlyLight.document, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(event.summary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
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
            ),
          );
        },
      ),
    );
  }
}
