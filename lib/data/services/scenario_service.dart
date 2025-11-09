import 'dart:math';

import '../models/event.dart';
import '../models/item.dart';
import '../models/scenario_plan.dart';

class ScenarioService {
  const ScenarioService();

  List<ScenarioPlan> generate({
    required List<Event> events,
    required List<Item> items,
    required ScenarioFocus focus,
    required double ambition,
    required double resilience,
  }) {
    final normalizedAmbition = ambition.clamp(0, 1).toDouble();
    final normalizedResilience = resilience.clamp(0, 1).toDouble();
    final focusEvents = _focusEvents(events, focus);
    final fallbackEvents = focusEvents.isEmpty ? events : focusEvents;
    final topTags = _topTags(fallbackEvents).toList();
    final focusConfidence = _confidenceScore(focusEvents.length, normalizedAmbition, normalizedResilience);
    final watchlist = _buildWatchlist(events, items, focus, normalizedResilience);

    final acceleratePlan = ScenarioPlan(
      id: 'accelerate-${focus.name}',
      type: ScenarioType.accelerate,
      focus: focus,
      risk: _riskFrom(normalizedAmbition: normalizedAmbition, normalizedResilience: normalizedResilience),
      confidence: focusConfidence,
      drivers: topTags.take(4).toList(),
      watchlist: watchlist.take(4).toList(),
      actions: _accelerateActions(focus, normalizedAmbition),
    );

    final stabilizePlan = ScenarioPlan(
      id: 'stabilize-${focus.name}',
      type: ScenarioType.stabilize,
      focus: focus,
      risk: ScenarioRisk.medium,
      confidence: max(0.35, normalizedResilience * 0.75 + 0.2),
      drivers: topTags.reversed.take(3).toList(),
      watchlist: watchlist.skip(2).take(4).toList(),
      actions: _stabilizeActions(focus, normalizedResilience),
    );

    final diversifyPlan = ScenarioPlan(
      id: 'diversify-${focus.name}',
      type: ScenarioType.diversify,
      focus: ScenarioFocus.hybrid,
      risk: ScenarioRisk.low,
      confidence: max(0.4, (1 - normalizedResilience) * 0.3 + normalizedAmbition * 0.4),
      drivers: _diversifyDrivers(events, items, topTags),
      watchlist: watchlist.take(6).toList(),
      actions: _diversifyActions(items, normalizedAmbition),
    );

    return [acceleratePlan, stabilizePlan, diversifyPlan];
  }

  List<Event> _focusEvents(List<Event> events, ScenarioFocus focus) {
    switch (focus) {
      case ScenarioFocus.politics:
        return events.where((event) => event.category == EventCategory.politics).toList();
      case ScenarioFocus.arts:
        return events.where((event) => event.category == EventCategory.arts).toList();
      case ScenarioFocus.world:
        return events.where((event) => event.category == EventCategory.world).toList();
      case ScenarioFocus.collection:
        return events.where((event) => event.tags.any((tag) => tag.contains('collection'))).toList();
      case ScenarioFocus.hybrid:
        return events;
    }
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

  double _confidenceScore(int focusCount, double ambition, double resilience) {
    final base = (focusCount / 12).clamp(0.25, 0.85);
    return (base + ambition * 0.1 + resilience * 0.15).clamp(0.2, 1.0);
  }

  ScenarioRisk _riskFrom({required double normalizedAmbition, required double normalizedResilience}) {
    if (normalizedAmbition > 0.66 && normalizedResilience < 0.4) {
      return ScenarioRisk.high;
    }
    if (normalizedAmbition > 0.45) {
      return ScenarioRisk.medium;
    }
    return ScenarioRisk.low;
  }

  List<String> _buildWatchlist(
    List<Event> events,
    List<Item> items,
    ScenarioFocus focus,
    double resilience,
  ) {
    final signals = <String, double>{};
    for (final event in events) {
      final weight = 1 + (event.tags.length * 0.1);
      signals.update(event.tags.isEmpty ? event.category.name : event.tags.first, (value) => value + weight,
          ifAbsent: () => weight);
    }
    for (final item in items) {
      if (!item.forSale) continue;
      final weight = item.askingPrice != null ? min(200, item.askingPrice!).toDouble() / 200 : 0.2;
      signals.update(item.name, (value) => value + weight, ifAbsent: () => weight);
    }
    final entries = signals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final baseLimit = resilience < 0.35
        ? 8
        : resilience > 0.7
            ? 4
            : 6;
    final limit = focus == ScenarioFocus.collection ? max(baseLimit, 8) : baseLimit;
    return entries.map((entry) => entry.key).take(limit).toList();
  }

  List<String> _diversifyDrivers(List<Event> events, List<Item> items, List<String> tagLeaders) {
    final hybridDrivers = <String>[];
    hybridDrivers.addAll(tagLeaders.take(2));
    final artsTag = events
        .where((event) => event.category == EventCategory.arts)
        .expand((event) => event.tags)
        .toSet()
        .take(2);
    hybridDrivers.addAll(artsTag);
    final itemHighlights = items.take(2).map((item) => item.name);
    hybridDrivers.addAll(itemHighlights);
    return hybridDrivers.where((driver) => driver.isNotEmpty).toSet().toList();
  }

  List<ScenarioAction> _accelerateActions(ScenarioFocus focus, double ambition) {
    final actions = <ScenarioAction>[
      ScenarioAction('scenario_action_activate_briefings', {'focus': focus.name}),
      ScenarioAction('scenario_action_surface_signals'),
    ];
    if (ambition > 0.5) {
      actions.add(ScenarioAction('scenario_action_launch_spotlight', {'focus': focus.name}));
    }
    return actions;
  }

  List<ScenarioAction> _stabilizeActions(ScenarioFocus focus, double resilience) {
    final actions = <ScenarioAction>[
      ScenarioAction('scenario_action_strengthen_monitoring'),
      ScenarioAction('scenario_action_pair_advisors', {'focus': focus.name}),
    ];
    if (resilience < 0.4) {
      actions.add(const ScenarioAction('scenario_action_resilience_drills'));
    }
    return actions;
  }

  List<ScenarioAction> _diversifyActions(List<Item> items, double ambition) {
    final actions = <ScenarioAction>[
      const ScenarioAction('scenario_action_crosslink_collection'),
      ScenarioAction('scenario_action_expand_partnerships', {
        'count': min(3, max(1, items.length ~/ 2)).toString(),
      }),
    ];
    if (ambition > 0.6 && items.isNotEmpty) {
      actions.add(ScenarioAction('scenario_action_showcase_items', {'name': items.first.name}));
    }
    return actions;
  }
}
