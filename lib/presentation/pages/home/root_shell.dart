import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../data/services/local_article_parser.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/filters_controller.dart';
import '../../controllers/items_controller.dart';
import '../../controllers/on_this_day_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/trends_controller.dart';
import '../../controllers/forecast_controller.dart';
import '../../controllers/scenario_controller.dart';
import '../../controllers/notebook_controller.dart';
import '../briefing/briefing_page.dart';
import '../forecast/forecast_lab_page.dart';
import '../inventory/inventory_page.dart';
import '../scenario/scenario_planner_page.dart';
import '../search/search_page.dart';
import '../settings/settings_page.dart';
import '../on_this_day/on_this_day_page.dart';
import '../on_this_day/global_spotlight_page.dart';
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
    required this.onThisDayController,
    required this.forecastController,
    required this.scenarioController,
    required this.notebookController,
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
  final OnThisDayController onThisDayController;
  final ForecastController forecastController;
  final ScenarioController scenarioController;
  final NotebookController notebookController;
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
        widget.onThisDayController,
        widget.filtersController,
        widget.forecastController,
        widget.scenarioController,
        widget.notebookController,
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
          BriefingPage(
            routerState: widget.routerState,
            eventsController: widget.eventsController,
            itemsController: widget.itemsController,
            trendsController: widget.trendsController,
            bookmarksController: widget.bookmarksController,
            onThisDayController: widget.onThisDayController,
            filtersController: widget.filtersController,
            searchController: widget.searchController,
            notebookController: widget.notebookController,
            onSelectTab: (value) => setState(() => _index = value),
            onOpenForecast: () => setState(() => _index = 2),
            onOpenScenario: () => setState(() => _index = 3),
            onOpenNotebook: () => widget.routerState.push(AppPage.notebook),
          ),
          ForecastLabPage(controller: widget.forecastController),
          ScenarioPlannerPage(controller: widget.scenarioController),
          SearchPage(
            controller: widget.searchController,
            filtersController: widget.filtersController,
            events: widget.eventsController.events,
            items: widget.itemsController.items,
            bookmarksController: widget.bookmarksController,
          ),
          OnThisDayPage(controller: widget.onThisDayController),
          GlobalSpotlightPage(controller: widget.onThisDayController),
          InventoryPage(controller: widget.itemsController),
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
            onOpenNotebook: () => widget.routerState.push(AppPage.notebook),
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
              NavigationDestination(icon: const Icon(IconlyLight.activity), label: l10n.translate('briefing_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.chart), label: l10n.translate('forecast_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.document), label: l10n.translate('scenario_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.search), label: l10n.translate('search')),
              NavigationDestination(icon: const Icon(IconlyLight.calendar), label: l10n.translate('on_this_day_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.discovery), label: l10n.translate('global_spotlight_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.category), label: l10n.translate('inventory_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.setting), label: l10n.translate('settings')),
            ],
          ),
        );
      },
    );
  }
}
