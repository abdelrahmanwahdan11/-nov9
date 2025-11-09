import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/scenario_plan.dart';
import '../../controllers/scenario_controller.dart';

class ScenarioPlannerPage extends StatelessWidget {
  const ScenarioPlannerPage({super.key, required this.controller});

  final ScenarioController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final scenarios = controller.scenarios;
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('scenario_lab_title')),
            actions: [
              IconButton(
                tooltip: l10n.translate('scenario_reset'),
                icon: const Icon(IconlyLight.refresh),
                onPressed: controller.reset,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            physics: const BouncingScrollPhysics(),
            children: [
              _ScenarioHeader(controller: controller, l10n: l10n),
              const SizedBox(height: 24),
              _ScenarioControls(controller: controller, l10n: l10n),
              const SizedBox(height: 24),
              if (scenarios.isEmpty)
                _ScenarioEmpty(l10n: l10n)
              else
                ...scenarios.map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _ScenarioCard(plan: plan, l10n: l10n),
                    )),
              if (scenarios.isNotEmpty)
                Text(
                  l10n.translate('scenario_footer_disclaimer'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ScenarioHeader extends StatelessWidget {
  const _ScenarioHeader({required this.controller, required this.l10n});

  final ScenarioController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('scenario_header_title'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translateWithArgs('scenario_header_focus', {
                'focus': l10n.translate(_focusKey(controller.focus)),
              }),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _Badge(
                  icon: Icons.auto_graph,
                  label: l10n.translateWithArgs('scenario_header_ambition', {
                    'value': (controller.ambition * 100).toStringAsFixed(0),
                  }),
                ),
                _Badge(
                  icon: Icons.shield_moon_outlined,
                  label: l10n.translateWithArgs('scenario_header_resilience', {
                    'value': (controller.resilience * 100).toStringAsFixed(0),
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioControls extends StatelessWidget {
  const _ScenarioControls({required this.controller, required this.l10n});

  final ScenarioController controller;
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
              l10n.translate('scenario_controls_focus'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ScenarioFocus.values
                  .map(
                    (focus) => ChoiceChip(
                      label: Text(l10n.translate(_focusKey(focus))),
                      selected: controller.focus == focus,
                      onSelected: (_) => controller.setFocus(focus),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('scenario_controls_ambition'),
              style: theme.textTheme.titleMedium,
            ),
            Slider(
              value: controller.ambition,
              onChanged: controller.setAmbition,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translate('scenario_controls_resilience'),
              style: theme.textTheme.titleMedium,
            ),
            Slider(
              value: controller.resilience,
              onChanged: controller.setResilience,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.plan, required this.l10n});

  final ScenarioPlan plan;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskLabel = l10n.translate(_riskKey(plan.risk));
    final typeLabel = l10n.translate(_typeKey(plan.type));
    final confidencePercent = (plan.confidence * 100).clamp(0, 100).toStringAsFixed(0);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_typeIcon(plan.type), color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.translateWithArgs('scenario_plan_title', {
                      'type': typeLabel,
                      'focus': l10n.translate(_focusKey(plan.focus)),
                    }),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    riskLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('scenario_confidence'),
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (plan.confidence).clamp(0, 1),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text('$confidencePercent%'),
              ],
            ),
            if (plan.drivers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.translate('scenario_drivers'), style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plan.drivers
                    .map(
                      (driver) => Chip(
                        label: Text(driver),
                        backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (plan.watchlist.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.translate('scenario_watchlist'), style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plan.watchlist
                    .map(
                      (item) => ActionChip(
                        label: Text(item),
                        avatar: const Icon(Icons.visibility_outlined, size: 16),
                        onPressed: () {},
                      ),
                    )
                    .toList(),
              ),
            ],
            if (plan.actions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.translate('scenario_actions'), style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              ...plan.actions.map((action) {
                final args = Map<String, String>.from(action.args);
                if (args.containsKey('focus')) {
                  args['focus'] = l10n.translate(
                    _focusKey(_scenarioFocusFromName(args['focus']!)),
                  );
                }
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(IconlyLight.paper_fail, size: 22),
                  title: Text(l10n.translateWithArgs(action.key, args)),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScenarioEmpty extends StatelessWidget {
  const _ScenarioEmpty({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('scenario_empty_title'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(l10n.translate('scenario_empty_message'), style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _focusKey(ScenarioFocus focus) {
  switch (focus) {
    case ScenarioFocus.politics:
      return 'scenario_focus_politics';
    case ScenarioFocus.arts:
      return 'scenario_focus_arts';
    case ScenarioFocus.world:
      return 'scenario_focus_world';
    case ScenarioFocus.collection:
      return 'scenario_focus_collection';
    case ScenarioFocus.hybrid:
      return 'scenario_focus_hybrid';
  }
}

String _riskKey(ScenarioRisk risk) {
  switch (risk) {
    case ScenarioRisk.low:
      return 'scenario_risk_low';
    case ScenarioRisk.medium:
      return 'scenario_risk_medium';
    case ScenarioRisk.high:
      return 'scenario_risk_high';
  }
}

String _typeKey(ScenarioType type) {
  switch (type) {
    case ScenarioType.accelerate:
      return 'scenario_type_accelerate';
    case ScenarioType.stabilize:
      return 'scenario_type_stabilize';
    case ScenarioType.diversify:
      return 'scenario_type_diversify';
  }
}

IconData _typeIcon(ScenarioType type) {
  switch (type) {
    case ScenarioType.accelerate:
      return Icons.bolt_outlined;
    case ScenarioType.stabilize:
      return Icons.handyman_outlined;
    case ScenarioType.diversify:
      return Icons.scatter_plot_outlined;
  }
}

ScenarioFocus _scenarioFocusFromName(String value) {
  return ScenarioFocus.values.firstWhere(
    (element) => element.name == value,
    orElse: () => ScenarioFocus.politics,
  );
}
