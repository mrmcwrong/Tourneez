import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/domain/venue_maps.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/venue_editor.dart';
import 'package:tourneez/ui/widgets.dart';

class VenuesScreen extends ConsumerWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(venuesProvider);

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
        title: const Text('Venues'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add venue',
        onPressed: () => showVenueEditorSheet(context, ref),
        child: const Icon(Icons.add_location_alt_outlined),
      ),
      body: venuesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load venues',
          message: friendlyErrorMessage(e),
        ),
        data: (venues) {
          final top = venues.where((v) => v.isTopLevel).toList();
          final byParent = <int, List<Venue>>{};
          for (final v in venues.where((v) => v.isField)) {
            byParent.putIfAbsent(v.parentVenueId!, () => []).add(v);
          }

          if (top.isEmpty) {
            return EmptyState(
              icon: Icons.place_outlined,
              title: 'No venues yet',
              message:
                  'Add standalone grounds with addresses, or a complex with '
                  'Field 1 / Field 2 and an optional layout map.',
              action: FilledButton.icon(
                onPressed: () => showVenueEditorSheet(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add venue'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: top.length,
            itemBuilder: (context, index) {
              final site = top[index];
              final fields = byParent[site.id] ?? const <Venue>[];
              return _VenueCard(
                site: site,
                fields: fields,
              );
            },
          );
        },
      ),
    );
  }
}

class _VenueCard extends ConsumerWidget {
  const _VenueCard({required this.site, required this.fields});

  final Venue site;
  final List<Venue> fields;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isComplex = fields.isNotEmpty || site.layoutImagePath != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(
              isComplex ? Icons.stadium_outlined : Icons.place_outlined,
              color: scheme.primary,
            ),
            title: Text(
              site.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              [
                if (site.address != null && site.address!.trim().isNotEmpty)
                  site.address!,
                if (fields.isNotEmpty) '${fields.length} fields',
              ].join(' · '),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    await showVenueEditorSheet(context, ref, venue: site);
                  case 'add_field':
                    await showVenueEditorSheet(
                      context,
                      ref,
                      parentVenueId: site.id,
                    );
                  case 'maps':
                    final ok = await openVenueInMaps(site);
                    if (!context.mounted) return;
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add an address or map link first'),
                        ),
                      );
                    }
                  case 'delete':
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete venue?'),
                        content: Text(
                          fields.isEmpty
                              ? 'Remove "${site.name}"?'
                              : 'Remove "${site.name}" and its ${fields.length} fields?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref.read(repositoryProvider).deleteVenue(site.id);
                    }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'add_field',
                  child: Text('Add field'),
                ),
                const PopupMenuItem(
                  value: 'maps',
                  child: Text('Open in Maps'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: () => _showDetail(context, ref, site, fields),
          ),
          if (site.layoutImagePath != null)
            GestureDetector(
              onTap: () => _showDetail(context, ref, site, fields),
              child: _LayoutBanner(path: site.layoutImagePath!),
            ),
          for (final field in fields)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 28, right: 8),
              leading: const Icon(Icons.crop_square_outlined, size: 20),
              title: Text(field.name),
              subtitle: field.notes == null ? null : Text(field.notes!),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () =>
                    showVenueEditorSheet(context, ref, venue: field),
              ),
              onLongPress: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete field?'),
                    content: Text('Remove "${field.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref.read(repositoryProvider).deleteVenue(field.id);
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> _showDetail(
    BuildContext context,
    WidgetRef ref,
    Venue site,
    List<Venue> fields,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (ctx, scroll) {
          return ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Text(site.name, style: Theme.of(ctx).textTheme.headlineSmall),
              if (site.address != null) ...[
                const SizedBox(height: 8),
                Text(site.address!),
              ],
              if (site.notes != null && site.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(site.notes!),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final ok = await openVenueInMaps(site);
                      if (!ctx.mounted) return;
                      if (!ok) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Add an address or map link first'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Open in Maps'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showVenueEditorSheet(context, ref, venue: site);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ],
              ),
              if (site.layoutImagePath != null) ...[
                const SizedBox(height: 16),
                Text('Field map', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: _LayoutImage(path: site.layoutImagePath!),
                  ),
                ),
              ],
              if (fields.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Fields', style: Theme.of(ctx).textTheme.titleMedium),
                for (final f in fields)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.crop_square_outlined),
                    title: Text(f.name),
                    subtitle: f.notes == null ? null : Text(f.notes!),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LayoutBanner extends StatelessWidget {
  const _LayoutBanner({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: _LayoutImage(path: path, fit: BoxFit.cover),
    );
  }
}

class _LayoutImage extends StatelessWidget {
  const _LayoutImage({required this.path, this.fit = BoxFit.contain});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataUrl(path);
    if (bytes == null) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      );
    }
    return Image.memory(
      bytes,
      fit: fit,
      filterQuality: FilterQuality.medium,
    );
  }
}
