import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/services/stats_service.dart';
import '../../controllers/trends_controller.dart';

class TrendsPage extends StatelessWidget {
  const TrendsPage({super.key, required this.controller});

  final TrendsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final snapshot = controller.snapshot;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('trends'))),
          body: snapshot == null
              ? Center(
                  child: Text(
                    l10n.translate('trends_empty'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(l10n.translate('trends_categories'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: CustomPaint(
                        painter: _CategoryChartPainter(snapshot.categoryStats, Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.translate('trends_tags'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: snapshot.topTags
                          .map(
                            (tag) => Chip(
                              label: Text('#${tag.tag}'),
                              avatar: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                                child: Text('${tag.count}'),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.translate('trends_daily'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: CustomPaint(
                        painter: _DailyTrendPainter(snapshot.dailyTotals, Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _CategoryChartPainter extends CustomPainter {
  _CategoryChartPainter(this.stats, this.color);

  final List<CategoryStat> stats;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final maxCount = stats.map((e) => e.count).fold<int>(1, (prev, count) => count > prev ? count : prev);
    final barHeight = size.height / (stats.length * 1.5);
    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];
      final top = i * barHeight * 1.5;
      final width = maxCount == 0 ? 0 : (stat.count / maxCount) * size.width;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, top, width, barHeight),
        const Radius.circular(18),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryChartPainter oldDelegate) {
    return oldDelegate.stats != stats || oldDelegate.color != color;
  }
}

class _DailyTrendPainter extends CustomPainter {
  _DailyTrendPainter(this.totals, this.color);

  final Map<DateTime, int> totals;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (totals.isEmpty) return;
    final sortedEntries = totals.entries.toList();
    final maxCount = sortedEntries.map((e) => e.value).fold<int>(1, (prev, count) => count > prev ? count : prev);
    final path = Path();
    final stepX = sortedEntries.length == 1
        ? 0.0
        : size.width / (sortedEntries.length - 1);
    for (var i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final dx = stepX * i;
      final dy = size.height - (maxCount == 0 ? 0 : (entry.value / maxCount) * size.height);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _DailyTrendPainter oldDelegate) {
    return oldDelegate.totals != totals || oldDelegate.color != color;
  }
}
