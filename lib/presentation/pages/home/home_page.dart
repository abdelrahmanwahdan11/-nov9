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
import '../../widgets/adaptive_app_bar.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/overlay_sheet.dart';
import '../../widgets/segmented_filter.dart';
import '../../widgets/skeleton.dart';
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
        return Scaffold(
          appBar: AdaptiveAppBar(
            title: l10n.translate('today_digest'),
            onSearch: () => widget.routerState.push(AppPage.search),
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => widget.eventsController.refresh(),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: [
                    SegmentedFilter(
                      selected: widget.eventsController.filter,
                      onSelected: widget.eventsController.setFilter,
                    ),
                    const SizedBox(height: 24),
                    if (widget.eventsController.isLoading)
                      const Skeleton(height: 220)
                    else
                      ..._sectionedEvents(widget.eventsController.events, palette),
                    if (widget.eventsController.isFetchingMore) const Padding(padding: EdgeInsets.all(16), child: Skeleton(height: 120)),
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
          floatingActionButton: OpenContainer(
            closedElevation: 6,
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

  List<Widget> _sectionedEvents(List<Event> events, List<Color> palette) {
    final sections = {
      EventCategory.politics: <Event>[],
      EventCategory.arts: <Event>[],
      EventCategory.world: <Event>[],
    };
    for (final event in events) {
      sections[event.category]!.add(event);
    }
    final titles = {
      EventCategory.politics: 'Politics',
      EventCategory.arts: 'Arts & Culture',
      EventCategory.world: 'World',
    };
    final widgets = <Widget>[];
    sections.forEach((category, items) {
      if (items.isEmpty) return;
      widgets.add(Text(
        titles[category]!,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ));
      widgets.add(const SizedBox(height: 16));
      for (final event in items) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EventTile(
              event: event,
              palette: palette,
              onTap: () => widget.overlayController.show(event),
            ),
          ),
        );
      }
      widgets.add(const SizedBox(height: 24));
    });
    return widgets;
  }
}
