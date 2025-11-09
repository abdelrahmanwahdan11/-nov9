import 'dart:math';

import '../models/event.dart';
import '../models/item.dart';
import '../models/risk_signal.dart';

class RiskService {
  const RiskService();

  RiskOutlook buildOutlook({required List<Event> events, required List<Item> items}) {
    final signals = _synthesiseSignals(events: events, items: items);
    final heat = _buildHeatMap(signals);
    final watchlist = signals
        .where((signal) => signal.severity >= 0.55)
        .toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
    final averageSeverity = signals.isEmpty
        ? 0
        : signals.map((signal) => signal.severity).reduce((a, b) => a + b) / signals.length;
    final momentum = _buildMomentum(signals);

    return RiskOutlook(
      signals: signals,
      heatMap: heat,
      averageSeverity: averageSeverity,
      watchlist: watchlist,
      momentum: momentum,
    );
  }

  List<RiskSignal> _synthesiseSignals({required List<Event> events, required List<Item> items}) {
    final signals = <RiskSignal>[];
    final byCategory = <EventCategory, List<Event>>{};
    for (final category in EventCategory.values) {
      byCategory[category] = events.where((event) => event.category == category).toList();
    }

    double severityFromCount(int count) => ((min(count, 8) / 8).clamp(0.2, 0.95)).toDouble();

    void addEventSignal({required EventCategory category, required RiskCategory riskCategory, required String idSuffix, required String titleKey, required String summaryKey}) {
      final categoryEvents = byCategory[category] ?? [];
      if (categoryEvents.isEmpty) {
        return;
      }
      final tags = categoryEvents.expand((event) => event.tags).toSet().toList();
      signals.add(
        RiskSignal(
          id: 'risk_${riskCategory.name}_$idSuffix',
          category: riskCategory,
          title: titleKey,
          summary: summaryKey,
          severity: severityFromCount(categoryEvents.length),
          recommendation: 'action_focus_primary',
          timeframe: 'risk_timeframe_next72',
          relatedEvents: categoryEvents.map((event) => event.id).take(5).toList(),
          tags: tags.take(6).toList(),
        ),
      );
    }

    addEventSignal(
      category: EventCategory.politics,
      riskCategory: RiskCategory.political,
      idSuffix: 'governance',
      titleKey: 'risk_signal_governance',
      summaryKey: 'risk_summary_governance',
    );
    addEventSignal(
      category: EventCategory.arts,
      riskCategory: RiskCategory.cultural,
      idSuffix: 'culture',
      titleKey: 'risk_signal_culture',
      summaryKey: 'risk_summary_culture',
    );
    addEventSignal(
      category: EventCategory.world,
      riskCategory: RiskCategory.security,
      idSuffix: 'geopolitics',
      titleKey: 'risk_signal_security',
      summaryKey: 'risk_summary_security',
    );

    final economicTags = events.where((event) =>
        event.tags.any((tag) => tag.toLowerCase().contains('economy') || tag.toLowerCase().contains('energy')));
    final economicCount = economicTags.length;
    if (economicCount > 0) {
      signals.add(
        RiskSignal(
          id: 'risk_economic_energy',
          category: RiskCategory.economic,
          title: 'risk_signal_economy',
          summary: 'risk_summary_economy',
          severity: ((min(economicCount, 6) / 6).clamp(0.35, 0.92)).toDouble(),
          recommendation: 'action_review_supply',
          timeframe: 'risk_timeframe_quarter',
          relatedEvents: economicTags.map((event) => event.id).take(5).toList(),
          tags: ['economy', 'energy', 'markets'],
        ),
      );
    }

    final supplySensitiveItems = items.where((item) => item.forSale && (item.specs.keys.any((key) => key.toLowerCase().contains('source')))).toList();
    if (supplySensitiveItems.isNotEmpty) {
      signals.add(
        RiskSignal(
          id: 'risk_supply_chain',
          category: RiskCategory.supply,
          title: 'risk_signal_supply',
          summary: 'risk_summary_supply',
          severity: ((min(supplySensitiveItems.length, 4) / 4).clamp(0.3, 0.8)).toDouble(),
          recommendation: 'action_optimize_inventory',
          timeframe: 'risk_timeframe_inventory',
          relatedItems: supplySensitiveItems.map((item) => item.id).take(5).toList(),
          tags: ['supply', 'inventory'],
        ),
      );
    }

    final culturalEvents = events.where((event) => event.category == EventCategory.arts).toList();
    final socialSignals = culturalEvents.where((event) => event.tags.any((tag) => tag.toLowerCase().contains('community') || tag.toLowerCase().contains('festival')));
    if (socialSignals.isNotEmpty) {
      signals.add(
        RiskSignal(
          id: 'risk_social_sentiment',
          category: RiskCategory.social,
          title: 'risk_signal_social',
          summary: 'risk_summary_social',
          severity: ((min(socialSignals.length, 5) / 5).clamp(0.25, 0.75)).toDouble(),
          recommendation: 'action_engage_community',
          timeframe: 'risk_timeframe_weekend',
          relatedEvents: socialSignals.map((event) => event.id).take(5).toList(),
          tags: ['community', 'culture'],
        ),
      );
    }

    final climateEvents = events.where((event) => event.tags.any((tag) =>
          tag.toLowerCase().contains('climate') || tag.toLowerCase().contains('flood') || tag.toLowerCase().contains('storm')));
    if (climateEvents.isNotEmpty) {
      signals.add(
        RiskSignal(
          id: 'risk_climate',
          category: RiskCategory.climate,
          title: 'risk_signal_climate',
          summary: 'risk_summary_climate',
          severity: ((min(climateEvents.length, 5) / 5).clamp(0.4, 0.9)).toDouble(),
          recommendation: 'action_prepare_response',
          timeframe: 'risk_timeframe_immediate',
          relatedEvents: climateEvents.map((event) => event.id).take(6).toList(),
          tags: ['climate', 'response'],
        ),
      );
    }

    if (signals.isEmpty) {
      signals.add(
        const RiskSignal(
          id: 'risk_baseline',
          category: RiskCategory.political,
          title: 'risk_signal_baseline',
          summary: 'risk_summary_baseline',
          severity: 0.3,
          recommendation: 'action_monitor_general',
          timeframe: 'risk_timeframe_today',
        ),
      );
    }

    return signals;
  }

  Map<RiskCategory, double> _buildHeatMap(List<RiskSignal> signals) {
    final map = <RiskCategory, double>{};
    if (signals.isEmpty) {
      return map;
    }
    final grouped = <RiskCategory, List<RiskSignal>>{};
    for (final signal in signals) {
      grouped.putIfAbsent(signal.category, () => []).add(signal);
    }
    grouped.forEach((category, group) {
      final avg = group.map((signal) => signal.severity).reduce((a, b) => a + b) / group.length;
      map[category] = double.parse(avg.toStringAsFixed(2));
    });
    return map;
  }

  List<RiskMomentumPoint> _buildMomentum(List<RiskSignal> signals) {
    if (signals.isEmpty) {
      return const [];
    }
    final now = DateTime.now();
    final points = <RiskMomentumPoint>[];
    final grouped = <RiskCategory, double>{};
    for (final signal in signals) {
      grouped[signal.category] =
          (grouped[signal.category] ?? 0) + signal.severity;
    }
    grouped.updateAll((key, value) => value / signals.where((element) => element.category == key).length);

    for (final entry in grouped.entries) {
      for (var i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        final base = entry.value;
        final modifier = sin(i / 2.5) * 0.1;
        final severity = (base + modifier).clamp(0.1, 1.0);
        points.add(RiskMomentumPoint(date: day, severity: double.parse(severity.toStringAsFixed(2)), category: entry.key));
      }
    }
    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }
}
