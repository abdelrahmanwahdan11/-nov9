import 'package:collection/collection.dart';

import '../models/event.dart';

class CategoryStat {
  const CategoryStat(this.category, this.count);

  final EventCategory category;
  final int count;
}

class TagStat {
  const TagStat(this.tag, this.count);

  final String tag;
  final int count;
}

class StatsSnapshot {
  const StatsSnapshot({
    required this.categoryStats,
    required this.topTags,
    required this.dailyTotals,
  });

  final List<CategoryStat> categoryStats;
  final List<TagStat> topTags;
  final Map<DateTime, int> dailyTotals;
}

class StatsService {
  const StatsService();

  StatsSnapshot buildSnapshot(List<Event> events) {
    final categoryStats = _categoryCounts(events);
    final topTags = _tagCounts(events).take(10).toList();
    final dailyTotals = _dailyTotals(events);
    return StatsSnapshot(
      categoryStats: categoryStats,
      topTags: topTags,
      dailyTotals: dailyTotals,
    );
  }

  List<CategoryStat> _categoryCounts(List<Event> events) {
    final grouped = groupBy(events, (event) => event.category);
    return EventCategory.values
        .map(
          (category) => CategoryStat(
            category,
            grouped[category]?.length ?? 0,
          ),
        )
        .toList();
  }

  Iterable<TagStat> _tagCounts(List<Event> events) {
    final counts = <String, int>{};
    for (final event in events) {
      for (final tag in event.tags) {
        counts.update(tag, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    final stats = counts.entries
        .map((entry) => TagStat(entry.key, entry.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return stats;
  }

  Map<DateTime, int> _dailyTotals(List<Event> events) {
    final totals = <DateTime, int>{};
    for (final event in events) {
      final key = DateTime(event.date.year, event.date.month, event.date.day);
      totals.update(key, (value) => value + 1, ifAbsent: () => 1);
    }
    final sortedKeys = totals.keys.toList()..sort();
    return {for (final key in sortedKeys) key: totals[key]!};
  }
}
