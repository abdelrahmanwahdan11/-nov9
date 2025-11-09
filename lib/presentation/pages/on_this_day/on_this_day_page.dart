import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../controllers/on_this_day_controller.dart';
import '../../widgets/on_this_day_card.dart';

class OnThisDayPage extends StatefulWidget {
  const OnThisDayPage({super.key, required this.controller});

  final OnThisDayController controller;

  @override
  State<OnThisDayPage> createState() => _OnThisDayPageState();
}

class _OnThisDayPageState extends State<OnThisDayPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.initialized) {
      widget.controller.load(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = [
      DesignTokens.colors['mint']!,
      DesignTokens.colors['sky']!,
      DesignTokens.colors['pink']!,
      DesignTokens.colors['blue']!,
      DesignTokens.colors['lime']!,
    ];
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final events = widget.controller.events;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('on_this_day')),
            actions: [
              IconButton(
                tooltip: l10n.translate('on_this_day_today'),
                icon: const Icon(IconlyLight.sun),
                onPressed: () => widget.controller.selectToday(),
              ),
              IconButton(
                tooltip: l10n.translate('on_this_day_select_date'),
                icon: const Icon(IconlyLight.calendar),
                onPressed: () => _pickDate(context),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => widget.controller.load(force: true),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: _Filters(
                      controller: widget.controller,
                      l10n: l10n,
                    ),
                  ),
                ),
                if (widget.controller.isLoading && events.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (events.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(l10n: l10n),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    sliver: SliverList.separated(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return OnThisDayCard(
                          event: event,
                          color: palette[index % palette.length],
                          l10n: l10n,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final selected = await showDatePicker(
      context: context,
      initialDate: widget.controller.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: locale,
      helpText: l10n.translate('on_this_day_select_date'),
    );
    if (selected != null) {
      await widget.controller.setDate(selected);
    }
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller, required this.l10n});

  final OnThisDayController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final countries = controller.countries;
    final selectedCountry = controller.selectedCountry;
    final types = controller.types;
    final selectedTypes = controller.selectedTypes;
    final date = controller.selectedDate;
    final formattedDate = MaterialLocalizations.of(context).formatFullDate(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('on_this_day_headline'),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.translateWithArgs('on_this_day_date_label', {'date': formattedDate}),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(l10n.translateWithArgs('on_this_day_events_count', {'count': controller.events.length.toString()})),
              avatar: const Icon(IconlyLight.time_circle, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.translate('on_this_day_filter_country'),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(l10n.translate('on_this_day_country_all')),
                  selected: selectedCountry == null,
                  onSelected: (_) => controller.setCountry(null),
                ),
              ),
              ...countries.map(
                (country) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      country.toLowerCase() == 'global'
                          ? l10n.translate('on_this_day_country_global')
                          : country,
                    ),
                    selected: selectedCountry == country,
                    onSelected: (_) => controller.setCountry(country),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              l10n.translate('on_this_day_filter_type'),
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: selectedTypes.isEmpty ? null : () => controller.clearTypes(),
              child: Text(l10n.translate('on_this_day_clear_types')),
            ),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final type in types)
              FilterChip(
                label: Text(l10n.translate(type.localizationKey())),
                selected: selectedTypes.contains(type),
                onSelected: (_) => controller.toggleType(type),
              ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconlyLight.info_circle, size: 48),
          const SizedBox(height: 16),
          Text(
            l10n.translate('on_this_day_empty_title'),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('on_this_day_empty_subtitle'),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
