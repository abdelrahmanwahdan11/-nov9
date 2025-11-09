import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/risk_signal.dart';
import '../../controllers/risk_controller.dart';
import '../../widgets/risk_signal_card.dart';

class RiskDashboardPage extends StatelessWidget {
  const RiskDashboardPage({super.key, required this.controller});

  final RiskController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final l10n = AppLocalizations.of(context);
            final signals = controller.signals;
            final heatMap = controller.heatMap;
            final watchlist = controller.watchlist;
            final actions = controller.recommendedActions;
            final focus = controller.focus;

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, padding.top + 12, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.translate('risk_dashboard_title'),
                                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.translate('risk_dashboard_tagline'),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(IconlyLight.info_circle),
                                tooltip: l10n.translate('risk_info_tooltip'),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.translate('risk_info_title'),
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              l10n.translate('risk_info_body'),
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 16),
                                            FilledButton.tonal(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(l10n.translate('close')),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _OverviewHeader(
                            l10n: l10n,
                            controller: controller,
                          ),
                          const SizedBox(height: 16),
                          _CategoryFilters(
                            l10n: l10n,
                            selected: focus,
                            onSelected: controller.setFocus,
                          ),
                          const SizedBox(height: 16),
                          _HeatMap(l10n: l10n, data: heatMap),
                          const SizedBox(height: 16),
                          if (actions.isNotEmpty)
                            _ActionRail(actions: actions, l10n: l10n),
                          if (watchlist.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _Watchlist(l10n: l10n, signals: watchlist),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  if (controller.isLoading && signals.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(color: theme.colorScheme.primary),
                      ),
                    )
                  else if (signals.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          l10n.translate('risk_empty_state'),
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final signal = signals[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: RiskSignalCard(
                              signal: signal,
                              l10n: l10n,
                            ),
                          );
                        },
                        childCount: signals.length,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
                      child: _MomentumPanel(l10n: l10n, controller: controller),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader({required this.l10n, required this.controller});

  final AppLocalizations l10n;
  final RiskController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final average = (controller.averageSeverity * 100).toStringAsFixed(0);
    final watchlistCount = controller.watchlist.length;
    final totalSignals = controller.signals.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.08),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('risk_average_title'),
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.translateWithArgs('risk_average_value', {
                    'value': average,
                  }),
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translateWithArgs('risk_overview_counts', {
                    'signals': totalSignals.toString(),
                    'watch': watchlistCount.toString(),
                  }),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 88,
            width: 88,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: controller.averageSeverity),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 88,
                      width: 88,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                      ),
                    ),
                    Text(
                      '${(value * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({required this.l10n, required this.selected, required this.onSelected});

  final AppLocalizations l10n;
  final RiskCategory? selected;
  final ValueChanged<RiskCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = [
      FilterChip(
        label: Text(l10n.translate('all')),
        selected: selected == null,
        onSelected: (_) => onSelected(null),
      ),
      ...RiskCategory.values.map(
        (category) => FilterChip(
          label: Text(l10n.translate(category.key)),
          selected: selected == category,
          onSelected: (_) => onSelected(selected == category ? null : category),
        ),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (chip) => Theme(
              data: theme.copyWith(chipTheme: theme.chipTheme.copyWith(padding: const EdgeInsets.symmetric(horizontal: 12))),
              child: chip,
            ),
          )
          .toList(),
    );
  }
}

class _HeatMap extends StatelessWidget {
  const _HeatMap({required this.l10n, required this.data});

  final AppLocalizations l10n;
  final Map<RiskCategory, double> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return Text(l10n.translate('risk_heatmap_empty'), style: theme.textTheme.bodyMedium);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('risk_heatmap_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: data.entries
              .map(
                (entry) => _HeatTile(
                  label: l10n.translate(entry.key.key),
                  value: entry.value,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HeatTile extends StatelessWidget {
  const _HeatTile({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (value * 100).toStringAsFixed(0);
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.12 + value * 0.2),
            theme.colorScheme.primary.withOpacity(0.22 + value * 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text('$percent%', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({required this.actions, required this.l10n});

  final List<String> actions;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('risk_action_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: actions
              .map(
                (action) => Chip(
                  avatar: const Icon(Icons.bolt, size: 18),
                  label: Text(l10n.translate(action)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Watchlist extends StatelessWidget {
  const _Watchlist({required this.l10n, required this.signals});

  final AppLocalizations l10n;
  final List<RiskSignal> signals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('risk_watchlist_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final signal = signals[index];
              return Container(
                width: 240,
                margin: EdgeInsets.only(left: index == 0 ? 4 : 0, right: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate(signal.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.translate(signal.summary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.speed, size: 16),
                        const SizedBox(width: 6),
                        Text('${(signal.severity * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: signals.length,
          ),
        ),
      ],
    );
  }
}

class _MomentumPanel extends StatelessWidget {
  const _MomentumPanel({required this.l10n, required this.controller});

  final AppLocalizations l10n;
  final RiskController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final points = controller.momentum;
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    final grouped = <RiskCategory, List<RiskMomentumPoint>>{};
    for (final point in points) {
      grouped.putIfAbsent(point.category, () => []).add(point);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('risk_momentum_title'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Column(
          children: grouped.entries
              .map(
                (entry) => _MomentumRow(
                  label: l10n.translate(entry.key.key),
                  points: entry.value,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MomentumRow extends StatelessWidget {
  const _MomentumRow({required this.label, required this.points});

  final String label;
  final List<RiskMomentumPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points
                  .map(
                    (point) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          height: (point.severity.clamp(0, 1) * 60) + 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.primary.withOpacity(0.2 + point.severity * 0.5),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
