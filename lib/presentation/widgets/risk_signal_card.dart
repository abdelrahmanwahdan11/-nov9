import 'package:flutter/material.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/risk_signal.dart';

class RiskSignalCard extends StatelessWidget {
  const RiskSignalCard({
    super.key,
    required this.signal,
    required this.l10n,
    this.onTap,
  });

  final RiskSignal signal;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  Color _severityColor(BuildContext context, double severity) {
    final theme = Theme.of(context);
    if (severity >= 0.75) {
      return theme.colorScheme.error;
    }
    if (severity >= 0.5) {
      return theme.colorScheme.secondary;
    }
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _severityColor(context, signal.severity);
    final severityPercentage = (signal.severity * 100).toStringAsFixed(0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate(signal.category.key),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.translate(signal.title),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 68,
                  height: 68,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: signal.severity),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 68,
                            height: 68,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              color: severityColor,
                              backgroundColor: severityColor.withOpacity(0.18),
                            ),
                          ),
                          Text(
                            '$severityPercentage%',
                            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translate(signal.summary),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: theme.colorScheme.secondary),
                const SizedBox(width: 6),
                Text(
                  l10n.translate(signal.timeframe),
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(l10n.translate(signal.recommendation)),
                  avatar: const Icon(Icons.auto_fix_high, size: 18),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                ...signal.tags.map(
                  (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            if (signal.relatedEvents.isNotEmpty || signal.relatedItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.translate('risk_related_assets'),
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...signal.relatedEvents.map(
                    (id) => _BubbleBadge(
                      label: '#$id',
                      color: severityColor.withOpacity(0.12),
                      textColor: severityColor,
                    ),
                  ),
                  ...signal.relatedItems.map(
                    (id) => _BubbleBadge(
                      label: '@$id',
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      textColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BubbleBadge extends StatelessWidget {
  const _BubbleBadge({required this.label, required this.color, required this.textColor});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
