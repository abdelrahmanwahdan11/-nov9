import 'dart:math';

import '../models/event.dart';

class ForecastProjection {
  const ForecastProjection({
    required this.category,
    required this.expectedCount,
    required this.changePercent,
    required this.drivingTags,
  });

  final EventCategory category;
  final int expectedCount;
  final double changePercent;
  final List<String> drivingTags;
}

class ForecastSuggestion {
  const ForecastSuggestion(this.key, this.args);

  final String key;
  final Map<String, String> args;
}

class ForecastSummary {
  const ForecastSummary({
    required this.projections,
    required this.focusEvents,
    required this.recommendedTags,
    required this.horizonDays,
    required this.momentum,
    required this.suggestions,
  });

  final List<ForecastProjection> projections;
  final List<Event> focusEvents;
  final List<String> recommendedTags;
  final int horizonDays;
  final double momentum;
  final List<ForecastSuggestion> suggestions;

  bool get hasData => projections.any((projection) => projection.expectedCount > 0);
}

class ForecastService {
  const ForecastService();

  ForecastSummary build({
    required List<Event> events,
    required double optimism,
    required double volatility,
    required EventCategory focus,
    required int horizonDays,
  }) {
    if (events.isEmpty) {
      return const ForecastSummary(
        projections: <ForecastProjection>[],
        focusEvents: <Event>[],
        recommendedTags: <String>[],
        horizonDays: 0,
        momentum: 0,
        suggestions: <ForecastSuggestion>[],
      );
    }

    final recentWindow = DateTime.now().subtract(const Duration(days: 7));
    final categoryEvents = {
      for (final category in EventCategory.values)
        category: events.where((event) => event.category == category).toList(),
    };

    final projections = <ForecastProjection>[];
    final suggestions = <ForecastSuggestion>[];
    final horizonFactor = max(1, horizonDays);

    for (final category in EventCategory.values) {
      final eventsForCategory = categoryEvents[category]!;
      final recentEvents = eventsForCategory.where((event) => event.date.isAfter(recentWindow)).toList();
      final baseline = max(1, recentEvents.length);
      final trend = _trendScore(eventsForCategory);
      final volatilityBias = (volatility - 0.5) * 0.6;
      final optimismBias = (optimism - 0.5) * 0.8;
      final focusBias = category == focus ? 0.25 : 0.0;
      final momentum = (trend * 0.5) + optimismBias + volatilityBias + focusBias;
      final clampedMomentum = momentum.clamp(-0.6, 0.9);
      final projected = (baseline * (1 + clampedMomentum) * (horizonFactor / 2)).round();
      final tags = _topTags(eventsForCategory).take(4).toList();

      projections.add(
        ForecastProjection(
          category: category,
          expectedCount: max(0, projected),
          changePercent: clampedMomentum,
          drivingTags: tags,
        ),
      );

      if (clampedMomentum > 0.3) {
        suggestions.add(
          ForecastSuggestion('forecast_suggestion_expand', {
            'category': category.name,
          }),
        );
      } else if (clampedMomentum < -0.2) {
        suggestions.add(
          ForecastSuggestion('forecast_suggestion_monitor', {
            'category': category.name,
          }),
        );
      }
    }

    projections.sort((a, b) => b.changePercent.compareTo(a.changePercent));
    final averageMomentum = projections.isEmpty
        ? 0.0
        : projections.map((projection) => projection.changePercent).reduce((value, element) => value + element) /
            projections.length;

    final focusEvents = categoryEvents[focus]!
        .where((event) => event.date.isAfter(recentWindow))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final recommendedTags = projections
        .firstWhere((projection) => projection.category == focus, orElse: () => projections.first)
        .drivingTags;

    if (averageMomentum > 0.15) {
      suggestions.add(const ForecastSuggestion('forecast_suggestion_capitalize', {}));
    } else if (averageMomentum < -0.1) {
      suggestions.add(const ForecastSuggestion('forecast_suggestion_rebalance', {}));
    }

    return ForecastSummary(
      projections: projections,
      focusEvents: focusEvents.take(5).toList(),
      recommendedTags: recommendedTags,
      horizonDays: horizonFactor,
      momentum: averageMomentum,
      suggestions: suggestions,
    );
  }

  double _trendScore(List<Event> events) {
    if (events.length < 2) {
      return 0;
    }
    final grouped = <DateTime, int>{};
    for (final event in events) {
      final key = DateTime(event.date.year, event.date.month, event.date.day);
      grouped.update(key, (value) => value + 1, ifAbsent: () => 1);
    }
    final keys = grouped.keys.toList()..sort();
    if (keys.length < 2) {
      return 0;
    }
    final first = grouped[keys.first]!.toDouble();
    final last = grouped[keys.last]!.toDouble();
    final spanDays = max(1, keys.last.difference(keys.first).inDays);
    final average = grouped.values.fold<double>(0, (value, count) => value + count) / keys.length;
    if (average == 0) {
      return 0;
    }
    final slope = (last - first) / spanDays;
    return (slope / average).clamp(-1.0, 1.0);
  }

  Iterable<String> _topTags(List<Event> events) {
    final counts = <String, int>{};
    for (final event in events) {
      for (final tag in event.tags) {
        counts.update(tag, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((entry) => entry.key);
  }
}
