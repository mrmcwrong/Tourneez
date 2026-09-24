# Tourneez schema plan

Backups use format `tourneez-backup` and embed `schemaVersion`. Restore rejects backups newer than the running app.

## Current tables (v11)

| Table | Purpose |
|-------|---------|
| `teams` | Library teams (logo as data URL, power, career stats, optional `homeVenueId`) |
| `team_lists` / `team_list_members` | Reusable roster packs |
| `leagues` / `divisions` / `division_teams` | Multi-tier seasons + promo/releg |
| `tournaments` / `tournament_teams` | Standalone or league-linked events |
| `matches` | Fixtures + scores + optional schedule + `venueId` |
| `venues` | Sites / complexes / named fields (+ optional layout PNG) |

Known soft FKs (ints, not enforced): `tournaments.leagueId`, `tournaments.divisionId`, `divisions.currentTournamentId`, `matches.venueId`, `venues.parentVenueId`, `teams.homeVenueId`.

## Shipped migrations

### v9 — Calendar (Phase 1) ✅

- `matches.scheduledAt` — `DateTime?` kickoff
- `matches.durationMinutes` — `int?` optional (default 90 in UI)

### v10 — Venues (Phase 2) ✅

- New `venues` table: `id`, `name`, `address?`, `mapUrl?`, `notes?`, `layoutImagePath?`, `parentVenueId?`, `createdAt`
- Top-level rows = standalone grounds or multi-field complexes
- Child rows (`parentVenueId`) = named fields (Field 1, Pitch A, …)
- `layoutImagePath` stores a PNG/JPEG site map as a portable data URL
- `matches.venueId` — soft FK → venues
- `matches.location` kept as denormalized display / free-text override

### v11 — Team home venue ✅

- `teams.homeVenueId` — optional soft FK → venues (teams do not require a home)
- `teams.homeLocation` kept as denormalized label synced from the chosen venue

## Planned migrations (do not skip numbers)

### v12 — Players (Phase 4)

- New `players` table: `id`, `displayName`, `jerseyNumber?`, `notes?`, `createdAt`
- New `team_players` table: `id`, `teamId`, `playerId`, `seasonLabel?`, unique `(teamId, playerId, seasonLabel)`

### Later (not numbered yet)

- Online publish snapshot (server-side; local schema may gain `publishToken` / `lastPublishedAt` on leagues)
- Local notification prefs (SharedPreferences, not Drift)

## Rules for future PRs

1. Bump `schemaVersion` and add an `if (from < N)` branch in `onUpgrade`.
2. Prefer **nullable** new columns so old rows stay valid.
3. Update backup dump/restore table lists in the same PR as the migration.
4. Do not add unused stub columns “just in case” — land them with the feature that uses them.
5. Keep logos (and venue layout maps) as portable `data:` URLs until a dedicated asset store exists.
