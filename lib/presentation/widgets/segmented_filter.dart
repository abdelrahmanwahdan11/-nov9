import 'package:flutter/material.dart';

import '../../data/models/event.dart';

class SegmentedFilter extends StatelessWidget {
  const SegmentedFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = [null, EventCategory.politics, EventCategory.arts, EventCategory.world];
    final labels = ['All', 'Politics', 'Arts', 'World'];
    return Wrap(
      spacing: 12,
      children: List.generate(options.length, (index) {
        final option = options[index];
        final isSelected = option == selected;
        return ChoiceChip(
          label: Text(labels[index]),
          selected: isSelected,
          onSelected: (_) => onSelected(option),
        );
      }),
    );
  }
}
