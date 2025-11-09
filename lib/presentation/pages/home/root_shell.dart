import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../data/services/local_article_parser.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/items_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/trends_controller.dart';
import '../catalog/catalog_page.dart';
import '../my_items/my_items_page.dart';
import '../search/search_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({
    super.key,
    required this.routerState,
    required this.eventsController,
    required this.overlayController,
    required this.itemsController,
    required this.settingsController,
    required this.searchController,
    required this.filtersController,
    required this.parser,
    required this.bookmarksController,
    required this.trendsController,
    this.startIndex = 0,
  });

  final AppRouterState routerState;
  final EventsController eventsController;
  final OverlayController overlayController;
  final ItemsController itemsController;
  final SettingsController settingsController;
  final SearchPageController searchController;
  final FiltersController filtersController;
  final LocalArticleParser parser;
  final BookmarksController bookmarksController;
  final TrendsController trendsController;
  final int startIndex;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.eventsController,
        widget.itemsController,
        widget.settingsController,
        widget.bookmarksController,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final pages = [
          HomePage(
            eventsController: widget.eventsController,
            overlayController: widget.overlayController,
            routerState: widget.routerState,
            parser: widget.parser,
            bookmarksController: widget.bookmarksController,
            onOpenHistory: () => widget.routerState.push(AppPage.history),
            onOpenBookmarks: () => widget.routerState.push(AppPage.bookmarks),
            onOpenTopics: () => widget.routerState.push(AppPage.topics),
            onOpenSources: () => widget.routerState.push(AppPage.sources),
            trendsController: widget.trendsController,
          ),
          SearchPage(
            controller: widget.searchController,
            filtersController: widget.filtersController,
            events: widget.eventsController.events,
            items: widget.itemsController.items,
            bookmarksController: widget.bookmarksController,
          ),
          CatalogPage(controller: widget.itemsController),
          MyItemsPage(controller: widget.itemsController),
          SettingsPage(
            controller: widget.settingsController,
            onOpenNotifications: () => widget.routerState.push(AppPage.notifications),
            onOpenTopics: () => widget.routerState.push(AppPage.topics),
            onOpenSources: () => widget.routerState.push(AppPage.sources),
            onOpenHistory: () => widget.routerState.push(AppPage.history),
            onOpenBookmarks: () => widget.routerState.push(AppPage.bookmarks),
            onOpenTrends: () => widget.routerState.push(AppPage.trends),
            onOpenHelp: () => widget.routerState.push(AppPage.help),
            onOpenSharePoster: () => widget.routerState.push(AppPage.sharePoster),
          ),
        ];

        return Scaffold(
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              setState(() => _index = value);
            },
            destinations: [
              NavigationDestination(icon: const Icon(IconlyLight.home), label: l10n.translate('home')),
              NavigationDestination(icon: const Icon(IconlyLight.search), label: l10n.translate('search')),
              NavigationDestination(icon: const Icon(IconlyLight.category), label: l10n.translate('catalog')),
              NavigationDestination(icon: const Icon(IconlyLight.bag), label: l10n.translate('my_items')),
              NavigationDestination(icon: const Icon(IconlyLight.setting), label: l10n.translate('settings')),
            ],
          ),
        );
      },
    );
  }
}
