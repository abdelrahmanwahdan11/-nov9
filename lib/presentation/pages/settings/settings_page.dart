import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../controllers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.controller,
    this.onOpenNotifications,
    this.onOpenTopics,
    this.onOpenSources,
    this.onOpenHistory,
    this.onOpenBookmarks,
    this.onOpenTrends,
    this.onOpenHelp,
    this.onOpenSharePoster,
  });

  final SettingsController controller;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenTopics;
  final VoidCallback? onOpenSources;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenBookmarks;
  final VoidCallback? onOpenTrends;
  final VoidCallback? onOpenHelp;
  final VoidCallback? onOpenSharePoster;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _handleBackup(AppLocalizations l10n) async {
    final backup = await widget.controller.backupToJson();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('settings_backup')),
        content: SelectableText(backup),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.translate('close')),
          ),
        ],
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('settings_backup_ready'))),
    );
  }

  Future<void> _handleRestore(AppLocalizations l10n) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.translate('settings_restore')),
            content: TextField(
              controller: controller,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: l10n.translate('settings_restore_hint'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.translate('cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.translate('confirm')),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || controller.text.trim().isEmpty) {
      return;
    }
    await widget.controller.restoreFromJson(controller.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('settings_restore_success'))),
    );
  }

  Future<void> _handleReset(AppLocalizations l10n) async {
    await widget.controller.resetToDefaults();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('settings_reset_success'))),
    );
  }

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
              ListTile(
                leading: const Icon(IconlyLight.calendar),
                title: Text(l10n.translate('history')),
                onTap: widget.onOpenHistory,
              ),
              ListTile(
                leading: const Icon(IconlyLight.bookmark),
                title: Text(l10n.translate('bookmarks')),
                onTap: widget.onOpenBookmarks,
              ),
              ListTile(
                leading: const Icon(IconlyLight.category),
                title: Text(l10n.translate('topics')),
                subtitle: Text(l10n.translate('topics_description')),
                onTap: widget.onOpenTopics,
              ),
              ListTile(
                leading: const Icon(IconlyLight.paper),
                title: Text(l10n.translate('sources')),
                subtitle: Text(l10n.translate('sources_description')),
                onTap: widget.onOpenSources,
              ),
              ListTile(
                leading: const Icon(IconlyLight.activity),
                title: Text(l10n.translate('trends')),
                onTap: widget.onOpenTrends,
              ),
              ListTile(
                leading: const Icon(IconlyLight.send),
                title: Text(l10n.translate('share_poster')),
                onTap: widget.onOpenSharePoster,
              ),
              ListTile(
                leading: const Icon(IconlyLight.info_circle),
                title: Text(l10n.translate('help_about')),
                onTap: widget.onOpenHelp,
              ),
              const SizedBox(height: 24),
              Text(l10n.translate('settings_data_tools'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.tonal(
                    onPressed: () => _handleBackup(l10n),
                    child: Text(l10n.translate('settings_backup')),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _handleRestore(l10n),
                    child: Text(l10n.translate('settings_restore')),
                  ),
                  OutlinedButton(
                    onPressed: () => _handleReset(l10n),
                    child: Text(l10n.translate('settings_reset')),
                  ),
                ],
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
