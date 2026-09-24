import 'package:flutter/material.dart';
import 'package:tourneez/data/backup.dart';
import 'package:tourneez/data/logo_storage.dart';
import 'package:tourneez/domain/models.dart';
import 'package:tourneez/ui/theme.dart';

class TeamLogo extends StatelessWidget {
  const TeamLogo({
    super.key,
    this.path,
    this.name,
    this.colorArgb,
    this.size = 40,
  });

  final String? path;
  final String? name;
  final int? colorArgb;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Theme.of(context).colorScheme.primary;
    final color = colorArgb != null ? Color(colorArgb!) : fallback;
    final initial = (name?.isNotEmpty == true)
        ? name!.characters.first.toUpperCase()
        : '?';

    // Decode near display resolution, snapped to a few buckets so logos drawn
    // at slightly different sizes reuse one decoded bitmap instead of forcing
    // a fresh decode per size.
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final cacheSize = _logoDecodeBucket(size * dpr);

    final bytes = decodeDataUrl(path);
    final Widget child;
    if (bytes != null) {
      child = Image.memory(
        bytes,
        width: size,
        height: size,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        cacheWidth: cacheSize,
        cacheHeight: cacheSize,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) =>
            _Initial(initial: initial, size: size, color: color),
      );
    } else if (isAssetLogoPath(path)) {
      child = Image.asset(
        path!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        cacheWidth: cacheSize,
        cacheHeight: cacheSize,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) =>
            _Initial(initial: initial, size: size, color: color),
      );
    } else {
      child = _Initial(initial: initial, size: size, color: color);
    }

    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }
}

int _logoDecodeBucket(double target) {
  if (target <= 64) return 64;
  if (target <= 128) return 128;
  if (target <= 192) return 192;
  return 256;
}

/// Soft row tint from a team's kit color.
Color teamRowTint(int colorArgb, {double alpha = 0.16}) =>
    Color(colorArgb).withValues(alpha: alpha);

class _Initial extends StatelessWidget {
  const _Initial({
    required this.initial,
    required this.size,
    this.color,
  });

  final String initial;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: c.withValues(alpha: 0.45), width: 1.4),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
          color: c,
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.onTap});

  final TournamentStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      TournamentStatus.draft => ('Draft', scheme.outline),
      TournamentStatus.active => ('Active', TourneezTheme.seed),
      TournamentStatus.completed => ('Completed', TourneezTheme.secondary),
    };
    return _NamedStatusChip(label: label, color: color, onTap: onTap);
  }
}

class LeagueStatusChip extends StatelessWidget {
  const LeagueStatusChip({super.key, required this.status, this.onTap});

  final LeagueStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      LeagueStatus.draft => ('Draft', scheme.outline),
      LeagueStatus.active => ('In season', TourneezTheme.seed),
      LeagueStatus.completed => ('Completed', TourneezTheme.secondary),
    };
    return _NamedStatusChip(label: label, color: color, onTap: onTap);
  }
}

class _NamedStatusChip extends StatelessWidget {
  const _NamedStatusChip({
    required this.label,
    required this.color,
    this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: chip,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.18),
                  scheme.secondary.withValues(alpha: 0.14),
                ],
              ),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(icon, size: 38, color: scheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TourneezText.heading.copyWith(color: scheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.62),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          if (action != null) ...[
            const SizedBox(height: 22),
            action!,
          ],
        ],
      ),
    );

    return Center(
      child: SingleChildScrollView(child: content),
    );
  }
}

/// Short user-facing error text (avoids dumping huge stack traces into the UI).
String friendlyErrorMessage(Object error) {
  if (error is BackupException) return error.message;
  final raw = error.toString();
  if (raw.startsWith('FormatException:')) {
    return raw.replaceFirst('FormatException: ', '');
  }
  if (raw.contains('Logo file is too large')) {
    return 'That logo file is too large. Pick an image under 8 MB.';
  }
  if (raw.contains('dart:io') || raw.contains('Unsupported operation')) {
    return 'This action is not available in the current browser session. '
        'Try again, or run the Windows/desktop app if it keeps failing.';
  }
  if (raw.contains('web` parameter') || raw.contains('sqlite3.wasm')) {
    return 'Local database is not ready for web yet. Restart after updating.';
  }
  final firstLine = raw.split('\n').first.trim();
  if (firstLine.length > 160) {
    return '${firstLine.substring(0, 157)}...';
  }
  return firstLine.isEmpty ? 'Something went wrong.' : firstLine;
}

class PowerBadge extends StatelessWidget {
  const PowerBadge({super.key, required this.power});

  final int power;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hot = power >= 60;
    final color = hot ? scheme.secondary : scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        'PWR $power',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TourneezText.section)),
          ?trailing,
        ],
      ),
    );
  }
}

/// Pads dialogs/sheets above the on-screen keyboard.
Widget keyboardAware({required BuildContext context, required Widget child}) {
  final bottom = MediaQuery.viewInsetsOf(context).bottom;
  return Padding(
    padding: EdgeInsets.only(bottom: bottom),
    child: child,
  );
}
