import 'package:tourneez/domain/models.dart';
import 'package:url_launcher/url_launcher.dart';

/// Label for UI lists: `Field 1 · Riverside Complex` or just the venue name.
String venueDisplayLabel(Venue venue, {Venue? parent}) {
  if (parent != null) return '${venue.name} · ${parent.name}';
  return venue.name;
}

/// Best address for maps: field inherits parent complex address.
String? venueEffectiveAddress(Venue venue, {Venue? parent}) {
  final own = venue.address?.trim();
  if (own != null && own.isNotEmpty) return own;
  final parentAddr = parent?.address?.trim();
  if (parentAddr != null && parentAddr.isNotEmpty) return parentAddr;
  return null;
}

/// Prefer explicit map URL, otherwise Google Maps search for the address.
Uri? venueMapsUri(Venue venue, {Venue? parent}) {
  final custom = venue.mapUrl?.trim();
  if (custom != null && custom.isNotEmpty) {
    return Uri.tryParse(custom);
  }
  if (parent != null) {
    final parentCustom = parent.mapUrl?.trim();
    if (parentCustom != null && parentCustom.isNotEmpty) {
      return Uri.tryParse(parentCustom);
    }
  }
  final address = venueEffectiveAddress(venue, parent: parent);
  if (address == null) return null;
  return Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': address});
}

/// Opens one venue in the device maps app / browser.
Future<bool> openVenueInMaps(Venue venue, {Venue? parent}) async {
  final uri = venueMapsUri(venue, parent: parent);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Venue shown for a game: the match assignment, or the home team's venue.
class ResolvedMatchVenue {
  const ResolvedMatchVenue({
    required this.venue,
    required this.fromHomeTeam,
    this.parent,
  });

  final Venue venue;
  final Venue? parent;
  final bool fromHomeTeam;

  String get label => venueDisplayLabel(venue, parent: parent);
  String? get address => venueEffectiveAddress(venue, parent: parent);
  String? get layoutPath => venue.layoutImagePath ?? parent?.layoutImagePath;
  String get locationText => venueLocationText(venue, parent: parent);
}

ResolvedMatchVenue? resolveMatchVenue({
  required int? venueId,
  int? homeVenueId,
  required List<Venue> venues,
}) {
  final fromMatch = venueId != null;
  final id = venueId ?? homeVenueId;
  if (id == null) return null;
  Venue? find(int target) {
    for (final venue in venues) {
      if (venue.id == target) return venue;
    }
    return null;
  }

  final venue = find(id);
  if (venue == null) return null;
  final parent = venue.parentVenueId == null ? null : find(venue.parentVenueId!);
  return ResolvedMatchVenue(
    venue: venue,
    parent: parent,
    fromHomeTeam: !fromMatch,
  );
}

/// Free-text location synced onto matches when a venue is assigned.
String venueLocationText(Venue venue, {Venue? parent}) {
  if (parent != null) {
    final addr = venueEffectiveAddress(venue, parent: parent);
    if (addr != null) return '${venue.name} · ${parent.name} ($addr)';
    return '${venue.name} · ${parent.name}';
  }
  final addr = venue.address?.trim();
  if (addr != null && addr.isNotEmpty) return '${venue.name} ($addr)';
  return venue.name;
}
