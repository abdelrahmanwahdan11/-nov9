import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/router/app_router.dart';
import '../../../data/services/local_article_parser.dart';
import '../../controllers/events_controller.dart';
import '../../controllers/items_controller.dart';
import '../../controllers/overlay_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/settings_controller.dart';
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
    required this.parser,
    this.startIndex = 0,
  });

  final AppRouterState routerState;
  final EventsController eventsController;
  final OverlayController overlayController;
  final ItemsController itemsController;
  final SettingsController settingsController;
  final SearchPageController searchController;
  final LocalArticleParser parser;
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
      animation: Listenable.merge([widget.eventsController, widget.itemsController, widget.settingsController]),
      builder: (context, _) {
        final pages = [
          HomePage(
            eventsController: widget.eventsController,
            overlayController: widget.overlayController,
            routerState: widget.routerState,
            parser: widget.parser,
          ),
          SearchPage(
            controller: widget.searchController,
            events: widget.eventsController.events,
            items: widget.itemsController.items,
          ),
          CatalogPage(controller: widget.itemsController),
          MyItemsPage(controller: widget.itemsController),
          SettingsPage(
            controller: widget.settingsController,
            onOpenNotifications: () => widget.routerState.push(AppPage.notifications),
          ),
        ];

        return Scaffold(
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              setState(() => _index = value);
            },
            destinations: const [
              NavigationDestination(icon: Icon(IconlyLight.home), label: 'Home'),
              NavigationDestination(icon: Icon(IconlyLight.search), label: 'Search'),
              NavigationDestination(icon: Icon(IconlyLight.category), label: 'Catalog'),
              NavigationDestination(icon: Icon(IconlyLight.bag), label: 'MyItems'),
              NavigationDestination(icon: Icon(IconlyLight.setting), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
