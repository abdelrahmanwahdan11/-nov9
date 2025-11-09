import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../../data/services/forecast_service.dart';
import '../../controllers/forecast_controller.dart';

class ForecastLabPage extends StatelessWidget {
  const ForecastLabPage({super.key, required this.controller});

  final ForecastController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final summary = controller.summary;
        final momentumPercent = (summary?.momentum ?? 0) * 100;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('forecast_lab_title')),
            actions: [
              IconButton(
                tooltip: l10n.translate('forecast_reset'),
                icon: const Icon(IconlyLight.refresh),
                onPressed: controller.reset,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            physics: const BouncingScrollPhysics(),
            children: [
              _MomentumHeader(
                momentumPercent: momentumPercent,
                horizonDays: summary?.horizonDays ?? controller.horizonDays,
                l10n: l10n,
              ),
              const SizedBox(height: 24),
              _ControlsCard(controller: controller, l10n: l10n),
              const SizedBox(height: 24),
              if (summary == null || !summary.hasData)
                _EmptyState(l10n: l10n)
              else ...[
                _ProjectionList(summary: summary, l10n: l10n),
                const SizedBox(height: 24),
                _RecommendedTags(summary: summary, l10n: l10n),
                const SizedBox(height: 24),
                _FocusEvents(summary: summary, l10n: l10n),
                const SizedBox(height: 24),
                _Suggestions(summary: summary, l10n: l10n),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MomentumHeader extends StatelessWidget {
  const _MomentumHeader({
    required this.momentumPercent,
    required this.horizonDays,
    required this.l10n,
  });

  final double momentumPercent;
  final int horizonDays;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = momentumPercent >= 0;
    final color = isPositive
        ? theme.colorScheme.primary
        : theme.colorScheme.error.withOpacity(0.85);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('forecast_overview_title'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: color),
                const SizedBox(width: 12),
                Text(
                  l10n.translateWithArgs('forecast_overview_momentum', {
                    'value': momentumPercent.toStringAsFixed(1),
                  }),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translateWithArgs('forecast_overview_horizon', {
                'days': horizonDays.toString(),
              }),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsCard extends StatelessWidget {
  const _ControlsCard({required this.controller, required this.l10n});

  final ForecastController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('forecast_controls_title'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Text(l10n.translate('forecast_optimism_label'), style: theme.textTheme.bodyMedium),
            Slider(
              value: controller.optimism,
              min: 0,
              max: 1,
              onChanged: controller.setOptimism,
              divisions: 10,
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('forecast_volatility_label'), style: theme.textTheme.bodyMedium),
            Slider(
              value: controller.volatility,
              min: 0,
              max: 1,
              onChanged: controller.setVolatility,
              divisions: 10,
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('forecast_horizon_label'), style: theme.textTheme.bodyMedium),
            Slider(
              value: controller.horizonDays.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              label: controller.horizonDays.toString(),
              onChanged: controller.setHorizon,
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('forecast_focus_label'), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: EventCategory.values
                  .map(
                    (category) => ChoiceChip(
                      selected: controller.focus == category,
                      label: Text(l10n.translate(category.name)),
                      onSelected: (_) => controller.setFocus(category),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectionList extends StatelessWidget {
  const _ProjectionList({required this.summary, required this.l10n});

  final ForecastSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('forecast_projections_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...summary.projections.map(
          (projection) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProjectionTile(projection: projection, l10n: l10n),
          ),
        ),
      ],
    );
  }
}

class _ProjectionTile extends StatelessWidget {
  const _ProjectionTile({required this.projection, required this.l10n});

  final ForecastProjection projection;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = projection.changePercent >= 0;
    final changeValue = (projection.changePercent * 100).abs().toStringAsFixed(1);
    final changeLabel = projection.changePercent.abs() < 0.05
        ? l10n.translate('forecast_projection_change_neutral')
        : isPositive
            ? l10n.translateWithArgs('forecast_projection_change_positive', {'value': changeValue})
            : l10n.translateWithArgs('forecast_projection_change_negative', {'value': changeValue});
    final color = isPositive
        ? theme.colorScheme.primary
        : theme.colorScheme.error.withOpacity(0.9);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate(projection.category.name),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: color),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translateWithArgs('forecast_projection_expected', {
                'value': projection.expectedCount.toString(),
              }),
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              changeLabel,
              style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            if (projection.drivingTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: projection.drivingTags
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecommendedTags extends StatelessWidget {
  const _RecommendedTags({required this.summary, required this.l10n});

  final ForecastSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (summary.recommendedTags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('forecast_recommended_tags'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: summary.recommendedTags
              .map((tag) => Chip(
                    label: Text('#$tag'),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _FocusEvents extends StatelessWidget {
  const _FocusEvents({required this.summary, required this.l10n});

  final ForecastSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (summary.focusEvents.isEmpty) {
      return Text(l10n.translate('forecast_focus_empty'), style: theme.textTheme.bodyMedium);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('forecast_focus_events'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...summary.focusEvents.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FocusEventTile(event: event, l10n: l10n),
          ),
        ),
      ],
    );
  }
}

class _FocusEventTile extends StatelessWidget {
  const _FocusEventTile({required this.event, required this.l10n});

  final Event event;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      tileColor: theme.colorScheme.surfaceVariant.withOpacity(0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(event.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(
        event.summary,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.translate(event.category.name), style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            '${event.date.day}/${event.date.month}',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: theme.colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(event.details, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.translate('close')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.summary, required this.l10n});

  final ForecastSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (summary.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('forecast_suggestions_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...summary.suggestions.map((suggestion) {
          final localizedArgs = suggestion.args.map(
            (key, value) => MapEntry(key, l10n.translate(value)),
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(IconlyLight.info_circle, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.translateWithArgs(suggestion.key, localizedArgs),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.auto_graph, size: 72, color: theme.colorScheme.primary.withOpacity(0.6)),
        const SizedBox(height: 12),
        Text(
          l10n.translate('forecast_empty_state'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
