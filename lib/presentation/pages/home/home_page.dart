import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/event.dart';
import '../../../data/services/local_article_parser.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/overlay_sheet.dart';
import '../../widgets/segmented_filter.dart';
import '../../widgets/skeleton.dart';
import '../../widgets/top_story_reel.dart';
import '../ingest/ingest_article_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.eventsController,
    required this.overlayController,
    required this.routerState,
    required this.parser,
  });

  final EventsController eventsController;
  final OverlayController overlayController;
  final AppRouterState routerState;
  final LocalArticleParser parser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 120) {
      widget.eventsController.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      animation: Listenable.merge([widget.eventsController, widget.overlayController]),
      builder: (context, _) {
        final events = widget.eventsController.events;
        final politicsCount = events.where((event) => event.category == EventCategory.politics).length;
        final topStories = events.take(5).toList();
        final highlightedIds = topStories.map((event) => event.id).toSet();
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              const _HomeBackground(),
              RefreshIndicator(
                onRefresh: () => widget.eventsController.refresh(),
                color: Theme.of(context).colorScheme.primary,
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                  children: [
                    SafeArea(
                      bottom: false,
                      child: _HomeHeader(
                        title: l10n.translateWithArgs('welcome_title', {'name': 'Mike'}),
                        subtitle: l10n.translate('welcome_tagline'),
                        onSearch: () => widget.routerState.push(AppPage.search),
                        politicsCount: politicsCount,
                        totalStories: events.length,
                        searchLabel: l10n.translate('search'),
                        storiesLabel: l10n.translate('stories'),
                        politicsLabel: l10n.translate('politics'),
                      ),
                    ),
                    if (topStories.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: l10n.translate('top_stories'),
                        trailing: Text(
                          l10n.translateWithArgs('stories_today', {'count': events.length.toString()}),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TopStoryReel(
                        events: topStories,
                        palette: palette,
                        onTap: widget.overlayController.show,
                      ),
                    ],
                    const SizedBox(height: 32),
                    _SectionTitle(
                      title: l10n.translate('digest_sections'),
                      trailing: Text(
                        l10n.translate('politics_priority'),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SegmentedFilter(
                      selected: widget.eventsController.filter,
                      onSelected: widget.eventsController.setFilter,
                    ),
                    const SizedBox(height: 28),
                    if (widget.eventsController.isLoading)
                      const _LoadingMasonrySkeleton()
                    else ...[
                      ..._sectionedEvents(events, palette, highlightedIds),
                      if (widget.eventsController.isFetchingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Skeleton(height: 140),
                        ),
                    ],
                  ],
                ),
              ),
              if (widget.overlayController.activeEvent != null)
                Positioned.fill(
                  child: Material(
                    color: Colors.black54,
                    child: OverlaySheet(controller: widget.overlayController),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: OpenContainer(
            closedElevation: 10,
            transitionType: ContainerTransitionType.fadeThrough,
            closedShape: const StadiumBorder(),
            closedColor: Theme.of(context).colorScheme.primary,
            openBuilder: (context, _) => IngestArticlePage(parser: parser, eventsController: widget.eventsController),
            closedBuilder: (context, openContainer) => FloatingActionButton.extended(
              onPressed: openContainer,
              icon: const Icon(IconlyLight.paper_download),
              label: Text(l10n.translate('ingest_article')),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _sectionedEvents(
    List<Event> events,
    List<Color> palette,
    Set<String> highlightedIds,
  ) {
    final l10n = AppLocalizations.of(context);
    final sections = {
      EventCategory.politics: <Event>[],
      EventCategory.arts: <Event>[],
      EventCategory.world: <Event>[],
    };
    for (final event in events) {
      sections[event.category]!.add(event);
    }
    final widgets = <Widget>[];
    for (final category in [EventCategory.politics, EventCategory.arts, EventCategory.world]) {
      final items = sections[category]!
          .where((event) => !highlightedIds.contains(event.id))
          .toList();
      if (items.isEmpty) continue;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            l10n.translate(category.name),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      );
      widgets.add(
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final columns = maxWidth >= 900
                ? 3
                : maxWidth >= 560
                    ? 2
                    : 1;
            final spacing = 20.0;
            final tileWidth = columns == 1
                ? maxWidth
                : (maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(items.length, (index) {
                final variant = columns == 1
                    ? EventTileVariant.tall
                    : index % columns == 0
                        ? EventTileVariant.tall
                        : EventTileVariant.standard;
                return SizedBox(
                  width: tileWidth,
                  child: EventTile(
                    event: items[index],
                    palette: palette,
                    variant: variant,
                    onTap: () => widget.overlayController.show(items[index]),
                  ),
                );
              }),
            );
          },
        ),
      );
      widgets.add(const SizedBox(height: 32));
    }
    return widgets;
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark
                ? theme.colorScheme.primary.withOpacity(0.18)
                : Color.alphaBlend(theme.colorScheme.primary.withOpacity(0.28), Colors.white),
            theme.scaffoldBackgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.title,
    required this.subtitle,
    required this.onSearch,
    required this.totalStories,
    required this.politicsCount,
    required this.searchLabel,
    required this.storiesLabel,
    required this.politicsLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onSearch;
  final int totalStories;
  final int politicsCount;
  final String searchLabel;
  final String storiesLabel;
  final String politicsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : Colors.black87;
    final searchBackground = isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.85);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            Color.lerp(theme.colorScheme.primary, Colors.white, 0.4)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(color: foreground.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              Material(
                color: searchBackground,
                shape: const StadiumBorder(),
                child: InkWell(
                  onTap: onSearch,
                  customBorder: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconlyLight.search, size: 22, color: foreground),
                        const SizedBox(width: 8),
                        Text(
                          searchLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  label: storiesLabel,
                  value: totalStories.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeaderMetric(
                  label: politicsLabel,
                  value: politicsCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _LoadingMasonrySkeleton extends StatelessWidget {
  const _LoadingMasonrySkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 900
            ? 3
            : maxWidth >= 560
                ? 2
                : 1;
        final spacing = 20.0;
        final tileWidth = columns == 1
            ? maxWidth
            : (maxWidth - spacing * (columns - 1)) / columns;
        final itemCount = (columns * 2).clamp(2, 6);
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(itemCount, (index) {
            return SizedBox(
              width: tileWidth,
              child: const Skeleton(height: 220),
            );
          }),
        );
      },
    );
  }
}
