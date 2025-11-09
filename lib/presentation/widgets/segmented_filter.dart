import 'package:flutter/material.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/event.dart';

class SegmentedFilter extends StatelessWidget {
  const SegmentedFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = [null, EventCategory.politics, EventCategory.arts, EventCategory.world];
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.translate('all'),
      l10n.translate('politics'),
      l10n.translate('arts'),
      l10n.translate('world'),
    ];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.7);
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(options.length, (index) {
        final option = options[index];
        final isSelected = option == selected;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: isSelected
                    ? theme.colorScheme.primary
                    : inactiveColor,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Text(
                labels[index],
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? (theme.brightness == Brightness.dark ? Colors.black : Colors.black)
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
