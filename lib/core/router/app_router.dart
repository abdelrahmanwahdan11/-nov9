import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

enum AppPage {
  onboarding,
  auth,
  home,
  briefing,
  forecast,
  scenario,
  search,
  onThisDay,
  spotlight,
  inventory,
  ingest,
  notifications,
  settings,
  history,
  topics,
  sources,
  bookmarks,
  trends,
  sharePoster,
  help,
}

class AppRouterState extends ChangeNotifier {
  AppRouterState({AppPage initialPage = AppPage.onboarding}) {
    _pages = [initialPage];
  }

  late List<AppPage> _pages;

  List<AppPage> get pages => List.unmodifiable(_pages);

  void push(AppPage page) {
    if (_pages.isNotEmpty && _pages.last == page) return;
    _pages.add(page);
    notifyListeners();
  }

  void replace(AppPage page) {
    _pages
      ..clear()
      ..add(page);
    notifyListeners();
  }

  void pop() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
    }
  }
}

class AppRouteInformationParser extends RouteInformationParser<List<AppPage>> {
  @override
  Future<List<AppPage>> parseRouteInformation(RouteInformation routeInformation) async {
    return [AppPage.onboarding];
  }

  @override
  RouteInformation? restoreRouteInformation(List<AppPage> configuration) {
    return const RouteInformation(location: '/');
  }
}

class AppRouterDelegate extends RouterDelegate<List<AppPage>> with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<AppPage>> {
  AppRouterDelegate(this._state, this._builder);

  final AppRouterState _state;
  final Map<AppPage, WidgetBuilder> _builder;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _state,
      builder: (context, _) {
        final pages = _state.pages
            .map(
              (page) => _SharedAxisPage(
                key: ValueKey(page),
                builder: _builder[page]!,
              ),
            )
            .toList();

        return Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            _state.pop();
            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(List<AppPage> configuration) async {}

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}

class _SharedAxisPage extends Page<void> {
  const _SharedAxisPage({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Route<void> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
        );
      },
    );
  }
}
