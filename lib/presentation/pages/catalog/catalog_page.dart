import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../controllers/items_controller.dart';
import '../../widgets/comparison_view.dart';
import '../../widgets/item_tile.dart';
import '../../../data/models/item.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.controller});

  final ItemsController controller;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _grid = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = [
      DesignTokens.colors['sky']!,
      DesignTokens.colors['pink']!,
      DesignTokens.colors['mint']!,
      DesignTokens.colors['blue']!,
    ];
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.translate('catalog')),
            actions: [
              IconButton(
                icon: Icon(_grid ? IconlyLight.category : IconlyLight.paper),
                onPressed: () => setState(() => _grid = !_grid),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.controller.compareList.length == 2)
                ComparisonView(items: widget.controller.compareList, palette: palette),
              const SizedBox(height: 16),
              _grid ? _gridView(palette) : _listView(palette),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddItem(context),
            icon: const Icon(IconlyLight.plus),
            label: Text(l10n.translate('add_item')),
          ),
        );
      },
    );
  }

  Widget _gridView(List<Color> palette) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemCount: widget.controller.items.length,
      itemBuilder: (context, index) {
        final item = widget.controller.items[index];
        return ItemTile(
          item: item,
          onTap: () {},
          onLongPress: () => widget.controller.toggleCompare(item),
          selected: widget.controller.compareList.contains(item),
          color: palette[index % palette.length],
        );
      },
    );
  }

  Widget _listView(List<Color> palette) {
    return Column(
      children: widget.controller.items
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ItemTile(
                item: entry.value,
                onTap: () {},
                onLongPress: () => widget.controller.toggleCompare(entry.value),
                selected: widget.controller.compareList.contains(entry.value),
                color: palette[entry.key % palette.length],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _showAddItem(BuildContext context) async {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final yearController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Item', style: Theme.of(context).textTheme.titleLarge),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          widget.controller.addItem(
                            Item(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text,
                              specs: {
                                'Brand': brandController.text,
                                'Year': yearController.text,
                              },
                              imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
                              condition: ItemCondition.like_new,
                              notes: 'Newly added collectible.',
                              forSale: false,
                              askingPrice: null,
                              offers: const [],
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
