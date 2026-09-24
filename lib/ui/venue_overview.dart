import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/widgets.dart';

/// Lists venues used by the given tournaments and opens Maps / field layouts.
Future<void> showVenueOverviewSheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required List<int> tournamentIds,
}) async {
  final repo = ref.read(repositoryProvider);
  final used = await repo.getVenuesUsedByTournaments(tournamentIds);
  final all = await repo.getVenues();
  if (!context.mounted) return;

  final byId = {for (final v in all) v.id: v};
  final parents = <Venue>[];
  final fieldsByParent = <int, List<Venue>>{};
  final standalone = <Venue>[];

  for (final v in used) {
    if (v.isField) {
      final parent = byId[v.parentVenueId];
      if (parent != null && !parents.any((p) => p.id == parent.id)) {
        parents.add(parent);
      }
      fieldsByParent.putIfAbsent(v.parentVenueId!, () => []).add(v);
    } else {
      standalone.add(v);
      if (!parents.any((p) => p.id == v.id)) {
        final kids = all.where((c) => c.parentVenueId == v.id).toList();
        if (kids.isNotEmpty || v.layoutImagePath != null) {
          parents.add(v);
          fieldsByParent.putIfAbsent(v.id, () => kids);
        }
      }
    }
  }

  final complexIds = parents.map((p) => p.id).toSet();
  final loneSites =
      standalone.where((s) => !complexIds.contains(s.id)).toList();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(ctx).height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(title, style: Theme.of(ctx).textTheme.titleLarge),
              ),
              Expanded(
                child: used.isEmpty
                    ? const EmptyState(
                        icon: Icons.place_outlined,
                        title: 'No venues assigned',
                        message:
                            'Assign venues on match edit sheets; they will '
                            'show up here for maps and field layouts.',
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        children: [
                          for (final site in parents) ...[
                            _OverviewSiteTile(
                              site: site,
                              fields: fieldsByParent[site.id] ?? const [],
                            ),
                          ],
                          for (final site in loneSites)
                            _OverviewSiteTile(site: site, fields: const []),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OverviewSiteTile extends StatelessWidget {
  const _OverviewSiteTile({required this.site, required this.fields});

  final Venue site;
  final List<Venue> fields;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(
              fields.isNotEmpty || site.layoutImagePath != null
                  ? Icons.stadium_outlined
                  : Icons.place_outlined,
              color: scheme.primary,
            ),
            title: Text(
              site.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: site.address == null ? null : Text(site.address!),
            trailing: IconButton(
              tooltip: 'Open in Maps',
              onPressed: () async {
                final ok = await openVenueInMaps(site);
                if (!context.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add an address or map link first'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.map_outlined),
            ),
          ),
          if (site.layoutImagePath != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Field map',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: _LayoutBytes(path: site.layoutImagePath!),
                    ),
                  ),
                ],
              ),
            ),
          for (final field in fields)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 28, right: 16),
              leading: const Icon(Icons.crop_square_outlined, size: 20),
              title: Text(field.name),
              subtitle: field.notes == null ? null : Text(field.notes!),
            ),
        ],
      ),
    );
  }
}

class _LayoutBytes extends StatelessWidget {
  const _LayoutBytes({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataUrl(path);
    if (bytes == null) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const SizedBox(
          height: 120,
          child: Center(child: Icon(Icons.broken_image_outlined)),
        ),
      );
    }
    return Image.memory(
      bytes,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
