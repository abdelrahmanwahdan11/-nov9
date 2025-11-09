import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../controllers/topics_controller.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key, required this.controller});

  final TopicsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('topics'))),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                l10n.translate('topics_description'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ...EventCategory.values.map(
                (category) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: SwitchListTile.adaptive(
                    value: controller.selected.contains(category),
                    onChanged: (value) => controller.toggle(category),
                    title: Text(l10n.translate(category.name)),
                    subtitle: Text(_subtitleFor(category, l10n)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => controller.setAll(EventCategory.values.toSet()),
                icon: const Icon(Icons.select_all),
                label: Text(l10n.translate('topics_enable_all')),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('topics_keep_politics'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  String _subtitleFor(EventCategory category, AppLocalizations l10n) {
    switch (category) {
      case EventCategory.politics:
        return l10n.translate('topics_politics');
      case EventCategory.arts:
        return l10n.translate('topics_arts');
      case EventCategory.world:
        return l10n.translate('topics_world');
    }
  }
}
