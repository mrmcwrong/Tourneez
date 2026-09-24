import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/providers/providers.dart';
import 'package:tourneez/ui/widgets.dart';

/// Opens the venue editor. Returns the created or updated [Venue], or null if
/// the sheet was dismissed without saving.
Future<Venue?> showVenueEditorSheet(
  BuildContext context,
  WidgetRef ref, {
  Venue? venue,
  int? parentVenueId,
}) {
  return showModalBottomSheet<Venue?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (ctx) => keyboardAware(
      context: ctx,
      child: _VenueEditorSheet(
        venue: venue,
        parentVenueId: parentVenueId,
      ),
    ),
  );
}

class _VenueEditorSheet extends ConsumerStatefulWidget {
  const _VenueEditorSheet({this.venue, this.parentVenueId});

  final Venue? venue;
  final int? parentVenueId;

  @override
  ConsumerState<_VenueEditorSheet> createState() => _VenueEditorSheetState();
}

class _VenueEditorSheetState extends ConsumerState<_VenueEditorSheet> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _mapUrl;
  late final TextEditingController _notes;
  String? _layoutPath;
  String? _pickedLayoutSource;
  bool _clearLayout = false;
  bool _saving = false;

  bool get _isField =>
      widget.venue?.isField == true || widget.parentVenueId != null;

  @override
  void initState() {
    super.initState();
    final v = widget.venue;
    _name = TextEditingController(text: v?.name ?? '');
    _address = TextEditingController(text: v?.address ?? '');
    _mapUrl = TextEditingController(text: v?.mapUrl ?? '');
    _notes = TextEditingController(text: v?.notes ?? '');
    _layoutPath = v?.layoutImagePath;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _mapUrl.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickLayout() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _pickedLayoutSource = file.path;
      _clearLayout = false;
      _layoutPath = null;
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    try {
      final int id;
      if (widget.venue == null) {
        id = await repo.createVenue(
          name: name,
          address: _isField ? null : _address.text,
          mapUrl: _isField ? null : _mapUrl.text,
          notes: _notes.text,
          layoutImageSourcePath: _isField ? null : _pickedLayoutSource,
          parentVenueId: widget.parentVenueId,
        );
      } else {
        id = widget.venue!.id;
        await repo.updateVenue(
          id: id,
          name: name,
          address: _isField ? null : _address.text,
          clearAddress: !_isField && _address.text.trim().isEmpty,
          mapUrl: _isField ? null : _mapUrl.text,
          clearMapUrl: !_isField && _mapUrl.text.trim().isEmpty,
          notes: _notes.text,
          clearNotes: _notes.text.trim().isEmpty,
          layoutImageSourcePath: _isField ? null : _pickedLayoutSource,
          clearLayoutImage: _isField ? false : _clearLayout,
        );
      }
      final saved = await repo.getVenue(id);
      if (mounted) Navigator.pop(context, saved);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = widget.venue == null
        ? (_isField ? 'Add field' : 'Add venue')
        : (_isField ? 'Edit field' : 'Edit venue');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              _isField
                  ? 'A named field at a complex (Field 1, Pitch A, …).'
                  : 'A standalone site with an address, or a complex that holds multiple fields.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: _isField ? 'Field name' : 'Venue / complex name',
                hintText: _isField ? 'Field 1' : 'Riverside Sports Complex',
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            if (!_isField) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: '123 Main St, City',
                ),
                textCapitalization: TextCapitalization.words,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _mapUrl,
                decoration: const InputDecoration(
                  labelText: 'Custom map link (optional)',
                  hintText: 'https://maps.google.com/...',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              Text('Site map image', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(
                'Upload a PNG/JPEG of the field layout so parents can see '
                'which field is which.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.62),
                    ),
              ),
              const SizedBox(height: 8),
              if (_layoutPath != null && !_clearLayout && _pickedLayoutSource == null)
                _LayoutPreview(path: _layoutPath!),
              if (_pickedLayoutSource != null)
                Text(
                  'New image selected',
                  style: TextStyle(color: scheme.primary),
                ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickLayout,
                    icon: const Icon(Icons.image_outlined),
                    label: Text(_layoutPath == null && _pickedLayoutSource == null
                        ? 'Upload map'
                        : 'Replace map'),
                  ),
                  if (_layoutPath != null || _pickedLayoutSource != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => setState(() {
                        _clearLayout = true;
                        _pickedLayoutSource = null;
                        _layoutPath = null;
                      }),
                      child: const Text('Remove'),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Parking, gate codes, turf rules…',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Save'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataUrl(path);
    if (bytes == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

Future<Object?> showVenuePickerSheet(
  BuildContext context,
  WidgetRef ref, {
  int? selectedId,
}) async {
  final venues = await ref.read(venuesProvider.future);
  if (!context.mounted) return null;
  return showModalBottomSheet<Object?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (ctx) {
      return _VenuePickerBody(
        initialVenues: venues,
        selectedId: selectedId,
      );
    },
  );
}

class _VenuePickerBody extends ConsumerStatefulWidget {
  const _VenuePickerBody({
    required this.initialVenues,
    required this.selectedId,
  });

  final List<Venue> initialVenues;
  final int? selectedId;

  @override
  ConsumerState<_VenuePickerBody> createState() => _VenuePickerBodyState();
}

class _VenuePickerBodyState extends ConsumerState<_VenuePickerBody> {
  Future<void> _createVenue() async {
    final created = await showVenueEditorSheet(context, ref);
    if (!mounted || created == null) return;
    Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final top = widget.initialVenues.where((v) => v.isTopLevel).toList();
    final byParent = <int, List<Venue>>{};
    for (final v in widget.initialVenues.where((v) => v.isField)) {
      byParent.putIfAbsent(v.parentVenueId!, () => []).add(v);
    }

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Choose venue',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  FilledButton.tonalIcon(
                    onPressed: _createVenue,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create venue'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: top.isEmpty
                  ? EmptyState(
                      icon: Icons.place_outlined,
                      title: 'No venues yet',
                      message:
                          'Create a venue here or from the Venues library.',
                      action: FilledButton.icon(
                        onPressed: _createVenue,
                        icon: const Icon(Icons.add),
                        label: const Text('Create venue'),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final site in top) ...[
                          ListTile(
                            leading: Icon(
                              byParent.containsKey(site.id)
                                  ? Icons.stadium_outlined
                                  : Icons.place_outlined,
                            ),
                            title: Text(site.name),
                            subtitle: site.address == null
                                ? null
                                : Text(site.address!),
                            selected: widget.selectedId == site.id,
                            onTap: () => Navigator.pop(context, site),
                          ),
                          for (final field
                              in byParent[site.id] ?? const <Venue>[])
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 40, right: 16),
                              leading: const Icon(Icons.crop_square_outlined),
                              title: Text(field.name),
                              subtitle: Text(site.name),
                              selected: widget.selectedId == field.id,
                              onTap: () => Navigator.pop(context, field),
                            ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
