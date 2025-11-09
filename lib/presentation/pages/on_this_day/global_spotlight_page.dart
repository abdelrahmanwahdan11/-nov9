import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/historical_event.dart';
import '../../controllers/on_this_day_controller.dart';

class GlobalSpotlightPage extends StatefulWidget {
  const GlobalSpotlightPage({super.key, required this.controller});

  final OnThisDayController controller;

  @override
  State<GlobalSpotlightPage> createState() => _GlobalSpotlightPageState();
}

class _GlobalSpotlightPageState extends State<GlobalSpotlightPage> {
  RangeValues? _yearRange;
  bool _onlyRecent = false;

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
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final events = widget.controller.events;
        final grouped = _groupByCountry(events);
        final minYear = events.isEmpty ? DateTime.now().year : events.map((e) => e.date.year).reduce((a, b) => a < b ? a : b);
        final maxYear = events.isEmpty ? DateTime.now().year : events.map((e) => e.date.year).reduce((a, b) => a > b ? a : b);
        final currentRange = _yearRange ?? RangeValues(minYear.toDouble(), maxYear.toDouble());
        final yearSpan = (maxYear - minYear).abs();
        final sliderDivisions = yearSpan == 0 ? 1 : yearSpan;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('global_spotlight_nav')),
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                _buildHeader(context, l10n, currentRange, minYear, maxYear, sliderDivisions),
                const SizedBox(height: 16),
                if (events.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: Text(l10n.translate('global_spotlight_empty')),
                    ),
                  )
                else ...[
                  ...grouped.entries.map((entry) => _CountryPanel(
                        country: entry.key,
                        events: _filterEvents(entry.value, currentRange, _onlyRecent),
                        l10n: l10n,
                        controller: widget.controller,
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    RangeValues range,
    int minYear,
    int maxYear,
    int sliderDivisions,
  ) {
    final theme = Theme.of(context);
    final countries = [''] + widget.controller.countries;
    final types = widget.controller.types;
    final selectedTypes = widget.controller.selectedTypes;
    final selectedCountry = widget.controller.selectedCountry ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translateWithArgs('global_spotlight_date', {
            'date': MaterialLocalizations.of(context).formatFullDate(widget.controller.selectedDate),
          }),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCountry,
          decoration: InputDecoration(labelText: l10n.translate('on_this_day_filter_country')),
          items: countries
              .map(
                (country) => DropdownMenuItem(
                  value: country,
                  child: Text(
                    country.isEmpty
                        ? l10n.translate('on_this_day_country_all')
                        : (country.toLowerCase() == 'global'
                            ? l10n.translate('on_this_day_country_global')
                            : country),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => widget.controller.setCountry(value == '' ? null : value),
        ),
        const SizedBox(height: 16),
        Text(l10n.translate('global_spotlight_types'), style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types
              .map(
                (type) => FilterChip(
                  label: Text(l10n.translate(type.localizationKey())),
                  selected: selectedTypes.contains(type),
                  onSelected: (_) => widget.controller.toggleType(type),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(l10n.translate('global_spotlight_year_range'), style: theme.textTheme.titleMedium),
        RangeSlider(
          values: range,
          min: minYear.toDouble(),
          max: maxYear.toDouble(),
          divisions: sliderDivisions < 1
              ? 1
              : (sliderDivisions > 120 ? 120 : sliderDivisions),
          labels: RangeLabels(range.start.toInt().toString(), range.end.toInt().toString()),
          onChanged: (values) => setState(() => _yearRange = values),
        ),
        SwitchListTile(
          title: Text(l10n.translate('global_spotlight_recent_only')),
          value: _onlyRecent,
          onChanged: (value) => setState(() => _onlyRecent = value),
        ),
      ],
    );
  }

  List<HistoricalEvent> _filterEvents(
    List<HistoricalEvent> events,
    RangeValues range,
    bool onlyRecent,
  ) {
    final now = DateTime.now().year;
    return events
        .where((entry) {
          final year = entry.event.date.year;
          if (year < range.start || year > range.end) {
            return false;
          }
          if (onlyRecent && (now - year) > 25) {
            return false;
          }
          return true;
        })
        .toList();
  }

  Map<String, List<HistoricalEvent>> _groupByCountry(List<HistoricalEvent> events) {
    final map = <String, List<HistoricalEvent>>{};
    for (final event in events) {
      map.putIfAbsent(event.country, () => []).add(event);
    }
    return map;
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

class _CountryPanel extends StatefulWidget {
  const _CountryPanel({
    required this.country,
    required this.events,
    required this.l10n,
    required this.controller,
  });

  final String country;
  final List<HistoricalEvent> events;
  final AppLocalizations l10n;
  final OnThisDayController controller;

  @override
  State<_CountryPanel> createState() => _CountryPanelState();
}

class _CountryPanelState extends State<_CountryPanel> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (value) => setState(() => _expanded = value),
        title: Text(
          widget.country,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.l10n.translateWithArgs('global_spotlight_country_events', {'count': widget.events.length.toString()})),
        children: widget.events
            .map(
              (wrapper) => ListTile(
                title: Text(wrapper.title),
                subtitle: Text(wrapper.description),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(wrapper.date.year.toString(), style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(widget.l10n.translate(wrapper.type.localizationKey())),
                  ],
                ),
                onTap: () => _openEvent(context, wrapper),
              ),
            )
            .toList(),
      ),
    );
  }

  void _openEvent(BuildContext context, HistoricalEvent wrapper) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
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
              Text(wrapper.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(widget.l10n.translate(wrapper.type.localizationKey())),
              const SizedBox(height: 12),
              Text(wrapper.description),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wrapper.tags
                    .map(
                      (tag) => ActionChip(
                        label: Text(tag),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.controller.setCountry(wrapper.country);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
