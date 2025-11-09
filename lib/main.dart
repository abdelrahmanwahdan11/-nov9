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
import 'domain/usecases/get_events_usecase.dart';
import 'domain/usecases/get_items_usecase.dart';
import 'domain/usecases/item_management_usecase.dart';
import 'domain/usecases/refresh_events_usecase.dart';
import 'domain/usecases/search_usecase.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/events_controller.dart';
import 'presentation/controllers/items_controller.dart';
import 'presentation/controllers/overlay_controller.dart';
import 'presentation/controllers/search_controller.dart';
import 'presentation/controllers/settings_controller.dart';
import 'presentation/pages/auth/auth_page.dart';
import 'presentation/pages/home/root_shell.dart';
import 'presentation/pages/ingest/ingest_article_page.dart';
import 'presentation/pages/notifications/notifications_page.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/search/search_page.dart';
import 'presentation/pages/settings/settings_page.dart';

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
  final authController = AuthController();

  final routerState = AppRouterState();
  final routerDelegate = AppRouterDelegate(routerState, {
    AppPage.onboarding: (context) => OnboardingPage(routerState: routerState),
    AppPage.auth: (context) => AuthPage(routerState: routerState, controller: authController),
    AppPage.home: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          parser: localParser,
        ),
    AppPage.search: (context) => SearchPage(
          controller: searchController,
          events: eventsController.events,
          items: itemsController.items,
        ),
    AppPage.catalog: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          parser: localParser,
          startIndex: 2,
        ),
    AppPage.myItems: (context) => RootShell(
          routerState: routerState,
          eventsController: eventsController,
          overlayController: overlayController,
          itemsController: itemsController,
          settingsController: settingsController,
          searchController: searchController,
          parser: localParser,
          startIndex: 3,
        ),
    AppPage.ingest: (context) => IngestArticlePage(parser: localParser, eventsController: eventsController),
    AppPage.notifications: (context) => NotificationsPage(itemsController: itemsController),
    AppPage.settings: (context) => SettingsPage(controller: settingsController),
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
        final theme = AppTheme(dynamicPrimary: settingsController.primaryColor);
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
