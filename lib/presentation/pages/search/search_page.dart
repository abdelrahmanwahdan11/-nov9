import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../data/models/event.dart';
import '../../../data/models/item.dart';
import '../../controllers/search_controller.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/item_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.controller,
    required this.events,
    required this.items,
  });

  final SearchPageController controller;
  final List<Event> events;
  final List<Item> items;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: widget.controller.queryController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint'),
                prefixIcon: const Icon(IconlyLight.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                filled: true,
              ),
              onSubmitted: (_) => widget.controller.search(widget.events, widget.items),
            ),
            actions: [
              IconButton(
                icon: const Icon(IconlyLight.filter),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    builder: (_) => const _FiltersSheet(),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.controller.query.isEmpty)
                Text(l10n.translate('search_filters'))
              else ...[
                Text('Events', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...widget.controller.eventResults.map((result) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EventTile(
                        event: result.item,
                        palette: [Colors.white],
                        onTap: () {},
                      ),
                    )),
                const SizedBox(height: 12),
                Text('Items', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...widget.controller.itemResults.map((result) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ItemTile(
                        item: result.item,
                        onTap: () {},
                        onLongPress: () {},
                        color: Colors.white,
                      ),
                    )),
                if (widget.controller.eventResults.isEmpty && widget.controller.itemResults.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text(l10n.translate('no_results'))),
                  ),
              ],
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => widget.controller.search(widget.events, widget.items),
            child: const Icon(IconlyLight.search),
          ),
        );
      },
    );
  }
}

class _FiltersSheet extends StatelessWidget {
  const _FiltersSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Filters coming soon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('Apply category, date range, and price filters in the upcoming update.'),
        ],
      ),
    );
  }
}
