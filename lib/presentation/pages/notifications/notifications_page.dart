import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../controllers/items_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.itemsController});

  final ItemsController itemsController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: itemsController,
      builder: (context, _) {
        final offers = itemsController.items.expand((item) => item.offers).toList()
          ..sort((a, b) => b.time.compareTo(a.time));
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('notifications'))),
          body: ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.campaign)),
                title: Text('${offer.from} offered ${offer.amount.toStringAsFixed(0)}'),
                subtitle: Text(offer.message ?? ''),
              );
            },
          ),
        );
      },
    );
  }
}
