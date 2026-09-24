import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/providers/theme_provider.dart';
import 'package:tourneez/router.dart';
import 'package:tourneez/ui/theme.dart';

/// Bump when bundled logo assets change so existing teams pick them up once.
const _logoSyncKey = 'template_logo_sync_v4';

class TourneezApp extends ConsumerStatefulWidget {
  const TourneezApp({super.key});

  @override
  ConsumerState<TourneezApp> createState() => _TourneezAppState();
}

class _TourneezAppState extends ConsumerState<TourneezApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncLogosOnce());
  }

  Future<void> _syncLogosOnce() async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getBool(_logoSyncKey) == true) return;
    await ref.read(repositoryProvider).syncTemplateLogos();
    await prefs.setBool(_logoSyncKey, true);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Tourneez',
      debugShowCheckedModeBanner: false,
      theme: TourneezTheme.light(),
      darkTheme: TourneezTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
