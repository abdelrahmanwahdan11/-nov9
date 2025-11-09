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
import '../../controllers/risk_controller.dart';
import '../briefing/briefing_page.dart';
import '../forecast/forecast_lab_page.dart';
import '../inventory/inventory_page.dart';
import '../scenario/scenario_planner_page.dart';
import '../search/search_page.dart';
import '../settings/settings_page.dart';
import '../on_this_day/on_this_day_page.dart';
import '../on_this_day/global_spotlight_page.dart';
import '../risk/risk_dashboard_page.dart';
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
    required this.riskController,
    this.startIndex = 0,
    this.initialMenuKey,
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
  final RiskController riskController;
  final int startIndex;
  final String? initialMenuKey;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  static const _menuIndex = 4;
  late int _index;
  late String _currentMenuKey;
  late String _pinnedMenuKey;

  @override
  void initState() {
    super.initState();
    _index = widget.startIndex;
    _currentMenuKey = widget.initialMenuKey ?? 'briefing';
    _pinnedMenuKey = _currentMenuKey;
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
        widget.riskController,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final menuEntries = _buildMenuEntries(l10n);
        if (menuEntries.isNotEmpty) {
          if (!menuEntries.any((entry) => entry.key == _currentMenuKey)) {
            _currentMenuKey = menuEntries.first.key;
          }
          if (!menuEntries.any((entry) => entry.key == _pinnedMenuKey)) {
            _pinnedMenuKey = _currentMenuKey;
          }
        }

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
          OnThisDayPage(controller: widget.onThisDayController),
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
          _MenuSwitcher(
            entries: menuEntries,
            currentKey: _currentMenuKey,
            onSelect: (key) => setState(() => _currentMenuKey = key),
          ),
        ];

        return Scaffold(
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              if (value == _menuIndex) {
                if (menuEntries.isNotEmpty) {
                  setState(() {
                    _index = _menuIndex;
                    _currentMenuKey = menuEntries
                        .firstWhere(
                          (entry) => entry.key == _pinnedMenuKey,
                          orElse: () => menuEntries.first,
                        )
                        .key;
                  });
                } else {
                  setState(() => _index = _menuIndex);
                }
              } else {
                setState(() => _index = value);
              }
            },
            destinations: [
              NavigationDestination(icon: const Icon(IconlyLight.home), label: l10n.translate('home')),
              NavigationDestination(icon: const Icon(IconlyLight.search), label: l10n.translate('search')),
              NavigationDestination(icon: const Icon(IconlyLight.calendar), label: l10n.translate('on_this_day_nav')),
              NavigationDestination(icon: const Icon(IconlyLight.setting), label: l10n.translate('settings')),
              NavigationDestination(
                icon: _MenuDestinationIcon(
                  icon: IconlyLight.category,
                  isSelected: _index == _menuIndex,
                  onLongPress: () => _showMenuPicker(menuEntries),
                ),
                label: l10n.translate('menu_nav'),
              ),
            ],
          ),
        );
      },
    );
  }
 
  List<_MenuEntry> _buildMenuEntries(AppLocalizations l10n) {
    return [
      _MenuEntry(
        key: 'briefing',
        icon: IconlyLight.activity,
        label: l10n.translate('briefing_nav'),
        builder: (context) => BriefingPage(
          routerState: widget.routerState,
          eventsController: widget.eventsController,
          itemsController: widget.itemsController,
          trendsController: widget.trendsController,
          bookmarksController: widget.bookmarksController,
          onThisDayController: widget.onThisDayController,
          filtersController: widget.filtersController,
          searchController: widget.searchController,
          notebookController: widget.notebookController,
          onSelectTab: _handleBriefingShortcut,
          onOpenForecast: () => _selectMenuEntry('forecast'),
          onOpenScenario: () => _selectMenuEntry('scenario'),
          onOpenNotebook: () => widget.routerState.push(AppPage.notebook),
          onOpenRisk: () => _selectMenuEntry('risk'),
          riskController: widget.riskController,
        ),
      ),
      _MenuEntry(
        key: 'forecast',
        icon: IconlyLight.chart,
        label: l10n.translate('forecast_nav'),
        builder: (context) => ForecastLabPage(controller: widget.forecastController),
      ),
      _MenuEntry(
        key: 'scenario',
        icon: IconlyLight.document,
        label: l10n.translate('scenario_nav'),
        builder: (context) => ScenarioPlannerPage(controller: widget.scenarioController),
      ),
      _MenuEntry(
        key: 'risk',
        icon: IconlyLight.shield_done,
        label: l10n.translate('risk_nav'),
        builder: (context) => RiskDashboardPage(controller: widget.riskController),
      ),
      _MenuEntry(
        key: 'spotlight',
        icon: IconlyLight.discovery,
        label: l10n.translate('global_spotlight_nav'),
        builder: (context) => GlobalSpotlightPage(controller: widget.onThisDayController),
      ),
      _MenuEntry(
        key: 'inventory',
        icon: IconlyLight.category,
        label: l10n.translate('inventory_nav'),
        builder: (context) => InventoryPage(controller: widget.itemsController),
      ),
    ];
  }

  void _handleBriefingShortcut(int value) {
    switch (value) {
      case 5:
        setState(() => _index = 1);
        break;
      case 6:
        setState(() => _index = 2);
        break;
      case 8:
        _selectMenuEntry('inventory');
        break;
      default:
        break;
    }
  }

  void _selectMenuEntry(String key) {
    setState(() {
      _index = _menuIndex;
      _currentMenuKey = key;
    });
  }

  void _showMenuPicker(List<_MenuEntry> entries) {
    if (entries.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('menu_customize_title'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('menu_customize_message'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ...entries.map(
                (entry) => RadioListTile<String>(
                  value: entry.key,
                  groupValue: _pinnedMenuKey,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _pinnedMenuKey = value;
                      _currentMenuKey = value;
                      _index = _menuIndex;
                    });
                    Navigator.of(context).pop();
                  },
                  title: Text(entry.label),
                  secondary: Icon(entry.icon),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuEntry {
  const _MenuEntry({
    required this.key,
    required this.icon,
    required this.label,
    required this.builder,
  });

  final String key;
  final IconData icon;
  final String label;
  final WidgetBuilder builder;
}

class _MenuSwitcher extends StatelessWidget {
  const _MenuSwitcher({
    required this.entries,
    required this.currentKey,
    required this.onSelect,
  });

  final List<_MenuEntry> entries;
  final String currentKey;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox();
    }

    final activeEntry = entries.firstWhere(
      (entry) => entry.key == currentKey,
      orElse: () => entries.first,
    );

    return Column(
      children: [
        SizedBox(
          height: 72,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isActive = entry.key == activeEntry.key;
              return ChoiceChip(
                selected: isActive,
                avatar: Icon(entry.icon, size: 18),
                label: Text(entry.label),
                onSelected: (_) => onSelect(entry.key),
              );
            },
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemCount: entries.length,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: KeyedSubtree(
              key: ValueKey(activeEntry.key),
              child: Builder(builder: activeEntry.builder),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuDestinationIcon extends StatelessWidget {
  const _MenuDestinationIcon({
    required this.icon,
    required this.isSelected,
    required this.onLongPress,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: Icon(icon, color: color),
    );
  }
}
