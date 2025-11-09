import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';

class HelpAboutPage extends StatelessWidget {
  const HelpAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('help_about'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.translate('help_about_faq_title'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SelectableText(l10n.translate('help_about_faq_content')),
          const SizedBox(height: 24),
          Text(l10n.translate('help_about_privacy_title'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SelectableText(l10n.translate('help_about_privacy_content')),
          const SizedBox(height: 24),
          Text(l10n.translate('help_about_version'), style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
