import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/sources_controller.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key, required this.controller, required this.eventsController});

  final SourcesController controller;
  final EventsController eventsController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([controller, eventsController]),
      builder: (context, _) {
        final sources = eventsController.availableSources.toList()..sort();
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('sources'))),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                l10n.translate('sources_description'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              if (sources.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    l10n.translate('sources_empty'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                )
              else
                ...sources.map(
                  (source) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: SwitchListTile.adaptive(
                      value: controller.enabled.contains(source),
                      onChanged: (_) => controller.toggle(source),
                      title: Text(source),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => controller.enableAll(sources),
                icon: const Icon(Icons.layers),
                label: Text(l10n.translate('sources_enable_all')),
              ),
            ],
          ),
        );
      },
    );
  }
}
