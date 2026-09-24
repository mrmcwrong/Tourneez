import 'dart:convert';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

/// Small LRU for decoded logo bytes so lists don't re-decode base64 every build.
const _maxCachedLogos = 96;
final Map<String, Uint8List> _decodedLogoCache = {};

/// Logos are stored inline (data URL) so they work on every platform. Keeping
/// them small matters a lot: oversized PNGs bloat every DB read and stream
/// emission, which shows up as UI lag.
const logoMaxSide = 256;

/// Field-complex layout maps need more detail than team logos.
const layoutMapMaxSide = 1280;

/// Persists a picked logo and returns a storage key usable on all platforms.
///
/// Stores a `data:` URL so logos work on mobile, desktop, and web.
Future<String> persistLogoFile(String sourcePath) async {
  final file = XFile(sourcePath);
  final raw = await file.readAsBytes();
  if (raw.lengthInBytes > maxLogoSourceBytes) {
    throw StateError('Logo file is too large (max 8 MB).');
  }
  final bytes = await shrinkLogoBytes(raw);
  final mime = identical(bytes, raw)
      ? _guessMime(sourcePath, file.mimeType)
      : 'image/png';
  final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
  _cacheLogoBytes(dataUrl, bytes);
  return dataUrl;
}

/// Persists a site/field layout image (PNG/JPEG) as a portable data URL.
Future<String> persistLayoutImageFile(String sourcePath) async {
  final file = XFile(sourcePath);
  final raw = await file.readAsBytes();
  if (raw.lengthInBytes > maxLogoSourceBytes) {
    throw StateError('Layout image is too large (max 8 MB).');
  }
  final bytes = await shrinkLogoBytes(raw, maxSide: layoutMapMaxSide);
  final mime = identical(bytes, raw)
      ? _guessMime(sourcePath, file.mimeType)
      : 'image/png';
  final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
  _cacheLogoBytes(dataUrl, bytes);
  return dataUrl;
}

/// Loads a bundled asset logo into a `data:` URL for DB storage.
Future<String> persistLogoAsset(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final raw = data.buffer.asUint8List();
  final bytes = await shrinkLogoBytes(raw);
  final mime = identical(bytes, raw) ? _guessMime(assetPath, null) : 'image/png';
  final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
  _cacheLogoBytes(dataUrl, bytes);
  return dataUrl;
}

/// Re-encodes [input] as a PNG no larger than [maxSide] on its long edge.
/// Returns [input] unchanged when it is already small or cannot be decoded.
Future<Uint8List> shrinkLogoBytes(
  Uint8List input, {
  int maxSide = logoMaxSide,
}) async {
  try {
    final probe = await ui.instantiateImageCodec(input);
    final frame = await probe.getNextFrame();
    final width = frame.image.width;
    final height = frame.image.height;
    frame.image.dispose();
    probe.dispose();

    if (width <= maxSide && height <= maxSide) return input;

    final codec = await ui.instantiateImageCodec(
      input,
      targetWidth: width >= height ? maxSide : null,
      targetHeight: height > width ? maxSide : null,
    );
    final resized = await codec.getNextFrame();
    final png = await resized.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    resized.image.dispose();
    codec.dispose();
    if (png == null) return input;
    return png.buffer.asUint8List();
  } catch (_) {
    return input;
  }
}

/// Shrinks an existing stored `data:` URL. Returns null when nothing changed.
Future<String?> shrinkLogoDataUrl(String? value) async {
  if (value == null || !value.startsWith('data:')) return null;
  final bytes = decodeDataUrl(value);
  if (bytes == null) return null;
  final smaller = await shrinkLogoBytes(bytes);
  if (identical(smaller, bytes)) return null;
  final dataUrl = 'data:image/png;base64,${base64Encode(smaller)}';
  _cacheLogoBytes(dataUrl, smaller);
  return dataUrl;
}

Uint8List? decodeDataUrl(String? value) {
  if (value == null || !value.startsWith('data:')) return null;
  final cached = _decodedLogoCache[value];
  if (cached != null) return cached;
  final comma = value.indexOf(',');
  if (comma < 0) return null;
  try {
    final bytes = base64Decode(value.substring(comma + 1));
    _cacheLogoBytes(value, bytes);
    return bytes;
  } catch (_) {
    return null;
  }
}

void _cacheLogoBytes(String key, Uint8List bytes) {
  if (_decodedLogoCache.length >= _maxCachedLogos) {
    _decodedLogoCache.remove(_decodedLogoCache.keys.first);
  }
  _decodedLogoCache[key] = bytes;
}

/// Clears decoded logo bitmaps (call after reset / restore).
void clearLogoCache() => _decodedLogoCache.clear();

/// Rejects oversized picked files before decode/shrink.
const maxLogoSourceBytes = 8 * 1024 * 1024;

bool isAssetLogoPath(String? value) =>
    value != null && value.startsWith('assets/');

String _guessMime(String path, String? mimeType) {
  if (mimeType != null && mimeType.isNotEmpty) return mimeType;
  return switch (p.extension(path).toLowerCase()) {
    '.jpg' || '.jpeg' => 'image/jpeg',
    '.gif' => 'image/gif',
    '.webp' => 'image/webp',
    _ => 'image/png',
  };
}
