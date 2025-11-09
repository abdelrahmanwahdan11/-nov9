import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../controllers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.controller, this.onOpenNotifications});

  final SettingsController controller;
  final VoidCallback? onOpenNotifications;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.translate('settings'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.translate('theme'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ],
                selected: {widget.controller.themeMode},
                onSelectionChanged: (value) => widget.controller.changeTheme(value.first),
              ),
              const SizedBox(height: 24),
              Text(l10n.translate('language'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<Locale>(
                segments: const [
                  ButtonSegment(value: Locale('en'), label: Text('English')),
                  ButtonSegment(value: Locale('ar'), label: Text('العربية')),
                ],
                selected: {widget.controller.locale},
                onSelectionChanged: (value) => widget.controller.changeLanguage(value.first),
              ),
              const SizedBox(height: 24),
              Text(l10n.translate('primary_color'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  for (final color in DesignTokens.colors.values)
                    GestureDetector(
                      onTap: () => widget.controller.changePrimary(color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: widget.controller.primaryColor == color
                            ? const Icon(Icons.check, color: Colors.black)
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(IconlyLight.notification),
                title: Text(l10n.translate('notifications')),
                onTap: widget.onOpenNotifications,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: widget.controller.clearData,
                child: Text(l10n.translate('clear_data')),
              ),
            ],
          ),
        );
      },
    );
  }
}
