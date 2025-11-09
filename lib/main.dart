import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/i18n/app_localizations.dart';
import 'core/preferences/prefs_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/local_article_parser.dart';
import 'data/services/mock_event_service.dart';
import 'data/services/mock_items_service.dart';
import 'data/services/search_service.dart';
import 'data/services/stats_service.dart';
import 'data/services/on_this_day_service.dart';
import 'data/services/forecast_service.dart';
import 'data/services/scenario_service.dart';
import 'data/services/notebook_service.dart';
import 'domain/usecases/get_events_usecase.dart';
import 'domain/usecases/get_items_usecase.dart';
import 'domain/usecases/item_management_usecase.dart';
import 'domain/usecases/refresh_events_usecase.dart';
import 'domain/usecases/search_usecase.dart';
import 'domain/usecases/get_on_this_day_usecase.dart';
import 'domain/usecases/get_scenarios_usecase.dart';
import 'domain/usecases/manage_notes_usecase.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/bookmarks_controller.dart';
import 'presentation/controllers/filters_controller.dart';
import 'presentation/controllers/events_controller.dart';
import 'presentation/controllers/history_controller.dart';
import 'presentation/controllers/forecast_controller.dart';
import 'presentation/controllers/items_controller.dart';
import 'presentation/controllers/notebook_controller.dart';
import 'presentation/controllers/overlay_controller.dart';
import 'presentation/controllers/search_controller.dart';
import 'presentation/controllers/settings_controller.dart';
import 'presentation/controllers/sources_controller.dart';
import 'presentation/controllers/topics_controller.dart';
import 'presentation/controllers/trends_controller.dart';
import 'presentation/controllers/on_this_day_controller.dart';
import 'presentation/controllers/scenario_controller.dart';
import 'presentation/pages/auth/auth_page.dart';
import 'presentation/pages/bookmarks/bookmarks_page.dart';
import 'presentation/pages/home/root_shell.dart';
import 'presentation/pages/ingest/ingest_article_page.dart';
import 'presentation/pages/notifications/notifications_page.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/history/history_page.dart';
import 'presentation/pages/help/help_page.dart';
import 'presentation/pages/inventory/inventory_page.dart';
import 'presentation/pages/on_this_day/global_spotlight_page.dart';
import 'presentation/pages/search/search_page.dart';
import 'presentation/pages/share/share_poster_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/sources/sources_page.dart';
import 'presentation/pages/topics/topics_page.dart';
import 'presentation/pages/trends/trends_page.dart';
import 'presentation/pages/scenario/scenario_planner_page.dart';
import 'presentation/pages/notebook/strategy_notebook_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await PrefsService.create();
  final mockEventService = MockEventService();
  final localParser = LocalArticleParser();
  final getEvents = GetEventsUseCase(mockEventService);
  final refreshEvents = RefreshEventsUseCase(mockEventService, localParser);
  final settingsController = SettingsController(prefs);
  await settingsController.load();
  final overlayController = OverlayController();
  final eventsController = EventsController(getEvents, refreshEvents);
  final itemsService = MockItemsService(prefs);
  final itemsController = ItemsController(GetItemsUseCase(itemsService), ItemManagementUseCase(itemsService));
  final searchController = SearchPageController(SearchUseCase(const SearchService()));
  final filtersController = FiltersController(prefs);
  final authController = AuthController();
  final bookmarksController = BookmarksController(prefs);
  final historyController = HistoryController(getEvents);
  final topicsController = TopicsController(prefs, eventsController);
  final sourcesController = SourcesController(prefs, eventsController);
  final trendsController = TrendsController(const StatsService());
  final onThisDayService = MockOnThisDayService();
  final onThisDayController = OnThisDayController(GetOnThisDayUseCase(onThisDayService));
  final forecastController = ForecastController(const ForecastService(), eventsController);
  final scenarioController = ScenarioController(
    const GetScenariosUseCase(ScenarioService()),
    eventsController,
    itemsController,
  );
  final notebookController = NotebookController(
    ManageNotesUseCase(NotebookService(prefs)),
  );
  await onThisDayController.load(force: true);
  await notebookController.initialize();
  eventsController.addListener(() {
    trendsController.update(eventsController.events);
  });
  trendsController.update(eventsController.events);

  final initialPage = prefs.hasCompletedOnboarding ? AppPage.home : AppPage.onboarding;
  final routerState = AppRouterState(initialPage: initialPage);
  final routerDelegate = AppRouterDelegate(routerState, {
    AppPage.onboarding: (context) => OnboardingPage(routerState: routerState, prefs: prefs),
    AppPage.auth: (context) => AuthPage(routerState: routerState, controller: authController),
    AppPage.home: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
        ),
    AppPage.briefing: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
          startIndex: 1,
        ),
    AppPage.forecast: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
          startIndex: 2,
        ),
    AppPage.scenario: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
          startIndex: 3,
        ),
    AppPage.search: (context) => SearchPage(
          controller: searchController,
          filtersController: filtersController,
          events: eventsController.events,
          items: itemsController.items,
          bookmarksController: bookmarksController,
        ),
    AppPage.notebook: (context) => StrategyNotebookPage(controller: notebookController),
    AppPage.spotlight: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          startIndex: 6,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
        ),
    AppPage.inventory: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          startIndex: 7,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
        ),
    AppPage.onThisDay: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          filtersController: filtersController,
          parser: localParser,
          startIndex: 5,
          trendsController: trendsController,
          bookmarksController: bookmarksController,
          onThisDayController: onThisDayController,
          forecastController: forecastController,
          scenarioController: scenarioController,
          notebookController: notebookController,
        ),
    AppPage.ingest: (context) => IngestArticlePage(parser: localParser, eventsController: eventsController),
    AppPage.notifications: (context) => NotificationsPage(itemsController: itemsController),
    AppPage.settings: (context) => SettingsPage(
          controller: settingsController,
          onOpenNotebook: () => routerState.push(AppPage.notebook),
        ),
    AppPage.history: (context) => HistoryPage(
          controller: historyController,
          eventsController: eventsController,
          bookmarksController: bookmarksController,
        ),
    AppPage.topics: (context) => TopicsPage(controller: topicsController),
    AppPage.sources: (context) => SourcesPage(controller: sourcesController, eventsController: eventsController),
    AppPage.bookmarks: (context) => BookmarksPage(
          bookmarksController: bookmarksController,
          eventsController: eventsController,
        ),
    AppPage.trends: (context) => TrendsPage(controller: trendsController),
    AppPage.sharePoster: (context) => SharePosterPage(
          eventsController: eventsController,
          itemsController: itemsController,
        ),
    AppPage.help: (context) => const HelpAboutPage(),
  });
  final routeParser = AppRouteInformationParser();

  runApp(DailyDigestApp(
    routerDelegate: routerDelegate,
    routeParser: routeParser,
    settingsController: settingsController,
  ));
}

class DailyDigestApp extends StatelessWidget {
  const DailyDigestApp({
    super.key,
    required this.routerDelegate,
    required this.routeParser,
    required this.settingsController,
  });

  final AppRouterDelegate routerDelegate;
  final AppRouteInformationParser routeParser;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        final theme = AppTheme(
          dynamicPrimary: settingsController.primaryColor,
          locale: settingsController.locale,
        );
        return MaterialApp.router(
          title: 'Daily Bubble Digest',
          debugShowCheckedModeBanner: false,
          routerDelegate: routerDelegate,
          routeInformationParser: routeParser,
          locale: settingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}
