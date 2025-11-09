import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/event.dart';
import 'bento_bubble_card.dart';
import 'parallax_3d_image.dart';

class TopStoryReel extends StatefulWidget {
  const TopStoryReel({
    super.key,
    required this.events,
    required this.palette,
    required this.onTap,
  });

  final List<Event> events;
  final List<Color> palette;
  final ValueChanged<Event> onTap;

  @override
  State<TopStoryReel> createState() => _TopStoryReelState();
}

class _TopStoryReelState extends State<TopStoryReel> {
  late final PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.78);
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant TopStoryReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events.length != widget.events.length) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (widget.events.length <= 1) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      final nextPage = ((_controller.page?.round() ?? 0) + 1) % widget.events.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          final event = widget.events[index];
          final color = widget.palette[index % widget.palette.length];
          final timeLabel = TimeOfDay.fromDateTime(event.date).format(context);
          final materialLocalization = MaterialLocalizations.of(context);
          final dateLabel = materialLocalization.formatShortDate(event.date);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BentoBubbleCard(
              backgroundColor: color,
              onTap: () => widget.onTap(event),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _Badge(
                        title: dateLabel,
                        subtitle: timeLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Parallax3DImage(
                      imageUrl: event.imageUrl,
                      heroTag: 'event_card_${event.id}',
                      height: 140,
                      onTap: () => widget.onTap(event),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            subtitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.white.withOpacity(0.8) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
