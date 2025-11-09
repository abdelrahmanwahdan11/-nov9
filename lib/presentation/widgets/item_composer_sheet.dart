import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../core/i18n/app_localizations.dart';
import '../../data/models/item.dart';

Future<Item?> showItemComposerSheet(BuildContext context, {Item? initial}) {
  return showModalBottomSheet<Item>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) => ItemComposerSheet(initial: initial),
  );
}

class ItemComposerSheet extends StatefulWidget {
  const ItemComposerSheet({super.key, this.initial});

  final Item? initial;

  @override
  State<ItemComposerSheet> createState() => _ItemComposerSheetState();
}

class _ItemComposerSheetState extends State<ItemComposerSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _yearController;
  late final TextEditingController _notesController;
  late final TextEditingController _imageController;
  late final TextEditingController _askingController;
  late final TextEditingController _targetController;

  final List<_SpecField> _extraSpecs = [];
  ItemCondition _condition = ItemCondition.like_new;
  bool _forSale = false;
  String? _selectedImage;

  static const _imageOptions = [
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
    'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
    'https://images.unsplash.com/photo-1489515217757-5fd1be406fef',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    _nameController = TextEditingController(text: item?.name ?? '');
    _brandController = TextEditingController(text: item?.specs['Brand'] ?? '');
    _yearController = TextEditingController(text: item?.specs['Year'] ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');
    _imageController = TextEditingController(text: item?.imageUrl ?? _imageOptions.first);
    _askingController = TextEditingController(text: item?.askingPrice?.toStringAsFixed(0) ?? '');
    _targetController = TextEditingController(text: item?.targetPrice?.toStringAsFixed(0) ?? '');
    _condition = item?.condition ?? ItemCondition.like_new;
    _forSale = item?.forSale ?? false;
    _selectedImage = item?.imageUrl;

    if (item != null) {
      for (final entry in item.specs.entries) {
        if (entry.key == 'Brand' || entry.key == 'Year') continue;
        _extraSpecs.add(_SpecField(key: entry.key, value: entry.value));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    _imageController.dispose();
    _askingController.dispose();
    _targetController.dispose();
    for (final spec in _extraSpecs) {
      spec.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.translate('add_item'),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(l10n.translate('items_composer_image'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final url = _imageOptions[index];
                    final selected = (_selectedImage ?? _imageController.text) == url;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = url;
                          _imageController.text = url;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: selected ? theme.colorScheme.primary : Colors.transparent,
                            width: 2,
                          ),
                          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: _imageOptions.length,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: l10n.translate('items_composer_image_url'),
                  prefixIcon: const Icon(IconlyLight.image),
                ),
                keyboardType: TextInputType.url,
                validator: (value) => value == null || value.isEmpty ? l10n.translate('required') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.translate('items_composer_name'),
                  prefixIcon: const Icon(IconlyLight.box),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.translate('required') : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('items_composer_brand'),
                        prefixIcon: const Icon(IconlyLight.work),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('items_composer_year'),
                        prefixIcon: const Icon(IconlyLight.calendar),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ItemCondition>(
                value: _condition,
                decoration: InputDecoration(
                  labelText: l10n.translate('items_composer_condition'),
                  prefixIcon: const Icon(IconlyLight.document),
                ),
                items: ItemCondition.values
                    .map(
                      (condition) => DropdownMenuItem(
                        value: condition,
                        child: Text(l10n.translate('item_condition_${condition.name}')),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _condition = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.translate('items_composer_notes'),
                  prefixIcon: const Icon(IconlyLight.paper),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.translate('items_composer_specs'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              ..._extraSpecs.map(
                (spec) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: spec.keyController,
                          decoration: InputDecoration(labelText: l10n.translate('items_composer_spec_key')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: spec.valueController,
                          decoration: InputDecoration(labelText: l10n.translate('items_composer_spec_value')),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _extraSpecs.remove(spec);
                            spec.dispose();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => _extraSpecs.add(_SpecField()));
                  },
                  icon: const Icon(IconlyLight.plus),
                  label: Text(l10n.translate('items_composer_add_spec')),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                value: _forSale,
                title: Text(l10n.translate('items_composer_for_sale')),
                subtitle: Text(l10n.translate('items_composer_for_sale_hint')),
                onChanged: (value) => setState(() => _forSale = value),
              ),
              if (_forSale) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _askingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.translate('items_composer_price'),
                    prefixIcon: const Icon(IconlyLight.wallet),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.translate('items_composer_target'),
                  prefixIcon: const Icon(IconlyLight.graph),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.translate('items_save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final specs = <String, String>{
      if (_brandController.text.trim().isNotEmpty) 'Brand': _brandController.text.trim(),
      if (_yearController.text.trim().isNotEmpty) 'Year': _yearController.text.trim(),
    };
    for (final spec in _extraSpecs) {
      final key = spec.keyController.text.trim();
      final value = spec.valueController.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        specs[key] = value;
      }
    }

    final asking = double.tryParse(_askingController.text.trim());
    final target = double.tryParse(_targetController.text.trim());

    final item = Item(
      id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      specs: specs,
      imageUrl: _imageController.text.trim(),
      condition: _condition,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      forSale: _forSale,
      askingPrice: _forSale ? asking : null,
      targetPrice: target,
      offers: widget.initial?.offers ?? const [],
    );

    Navigator.of(context).pop(item);
  }
}

class _SpecField {
  _SpecField({String? key, String? value})
      : keyController = TextEditingController(text: key ?? ''),
        valueController = TextEditingController(text: value ?? '');

  final TextEditingController keyController;
  final TextEditingController valueController;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}
