import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tourneez/data/backup.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/theme_provider.dart';
import 'package:tourneez/ui/widgets.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  bool get _useShareSheet =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    try {
      final mode = ref.read(themeModeProvider);
      final themeValue = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      final json = await ref.read(repositoryProvider).exportBackupJson(
        preferences: {'theme_mode': themeValue},
      );
      final bytes = Uint8List.fromList(utf8.encode(json));

      final stamp = DateTime.now()
          .toUtc()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final fileName = 'tourneez-backup-$stamp.json';

      if (_useShareSheet) {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                bytes,
                mimeType: 'application/json',
                name: fileName,
              ),
            ],
            subject: 'Tourneez backup',
            text: 'Tourneez local data backup. Keep this file private — it '
                'includes team logos and league data.',
          ),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup ready to save or share')),
        );
        return;
      }

      // Web + desktop: native save / download dialog (no dart:io).
      final saved = await FilePicker.saveFile(
        dialogTitle: 'Save Tourneez backup',
        fileName: fileName,
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: const ['json'],
        mimeType: 'application/json',
      );
      if (!context.mounted) return;
      if (saved == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup saved')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    }
  }

  Future<void> _restoreBackup(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (files.isEmpty || !context.mounted) return;

    final file = files.single;
    late final String raw;
    try {
      raw = utf8.decode(await file.xFile.readAsBytes());
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
      return;
    }
    if (raw.trim().isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read backup file')),
      );
      return;
    }

    // Validate before the destructive confirm so bad files never wipe data.
    try {
      parseAndValidateBackup(raw);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => keyboardAware(
        context: ctx,
        child: AlertDialog(
          title: const Text('Restore backup?'),
          content: const SingleChildScrollView(
            child: Text(
              'This replaces every team, tournament, league, and match on '
              'this device with the backup. Current data will be lost. '
              'This cannot be undone.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Restore'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final backup = parseAndValidateBackup(raw);
      await ref.read(repositoryProvider).restoreBackupJson(raw);

      final themeRaw = backup.preferences['theme_mode']?.toString();
      final theme = switch (themeRaw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      await ref.read(themeModeProvider.notifier).setMode(theme);

      if (!context.mounted) return;
      context.go('/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup restored')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    }
  }

  Future<void> _resetApp(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => keyboardAware(
        context: ctx,
        child: AlertDialog(
          title: const Text('Reset app?'),
          content: const SingleChildScrollView(
            child: Text(
              'Deletes every team, tournament, league, and saved preference. '
              'Export a backup first if you might need this data later. '
              'This cannot be undone.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reset app'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(repositoryProvider).resetApp();
    await ref.read(sharedPreferencesProvider).clear();
    if (!context.mounted) return;

    await ref.read(themeModeProvider.notifier).setMode(ThemeMode.system);
    if (!context.mounted) return;

    context.go('/');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App reset')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final narrow = MediaQuery.sizeOf(context).width < 380;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('App settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const SectionHeader(title: 'Appearance'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: narrow ? null : const Text('System'),
                        icon: const Icon(Icons.brightness_auto),
                        tooltip: 'System',
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: narrow ? null : const Text('Light'),
                        icon: const Icon(Icons.light_mode_outlined),
                        tooltip: 'Light',
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: narrow ? null : const Text('Dark'),
                        icon: const Icon(Icons.dark_mode_outlined),
                        tooltip: 'Dark',
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (s) {
                      ref.read(themeModeProvider.notifier).setMode(s.first);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Theme preference is separate from tournament settings.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.62),
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader(title: 'Data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      Icon(Icons.upload_file_outlined, color: scheme.primary),
                  title: const Text('Export backup'),
                  subtitle: const Text(
                    'Save all leagues, teams, and scores as a JSON file.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportBackup(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.download_outlined, color: scheme.primary),
                  title: const Text('Restore backup'),
                  subtitle: const Text(
                    'Replace local data with a previously exported file.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _restoreBackup(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      Icon(Icons.delete_forever_outlined, color: scheme.error),
                  title: const Text('Reset app'),
                  subtitle: const Text(
                    'Erase all teams, tournaments, leagues, and settings.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _resetApp(context, ref),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
            child: Text(
              'Backups stay on your device or wherever you save/share them. '
              'They include team logos. Do not post backup files publicly.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.62),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
