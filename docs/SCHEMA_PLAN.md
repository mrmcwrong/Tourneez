# Tourneez schema plan

Backups use format `tourneez-backup` and embed `schemaVersion`. Restore rejects backups newer than the running app.

## Current tables (v12)

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

### v12 — Parent logo circle ✅

- `teams.showLogoCircle` — default true; manager can hide the white disc behind a logo on the parent page

## Planned migrations (do not skip numbers)

### v13 — Players (Phase 4)

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


# THE NEW PLAN

One app, one database, two views. A local "View as" switch on this laptop stands in for separate manager and coach/parent devices until the online phase exists.

What each view shows
Manager keeps the app you have now: create and edit leagues, teams, venues, scores, schedule, simulate, backups, and reset.

Coach / parent is a read-only view of the same data:

They see	They do not see
Schedule, scores, standings, bracket
Create league or tournament
Venue list, Maps, field-layout image
Edit venues, teams, or scores
Their team's games called out
Simulate, reset, backup, power ratings
A team is optional. With no team selected, the family view shows the whole league. With a team selected, that team's matches are pinned at the top.

How you test both on one laptop
The role lives in local settings (SharedPreferences), not in the database, so switching never copies or splits your leagues.

A chip on the home bar reads Viewing as: Manager or Viewing as: Coach / parent. Tap it to switch. The change applies immediately.
In coach/parent mode, a second chip picks which team you are looking as, so you can walk through "parent of Field 1's team" and then "parent of another team" without a second device.
A thin banner stays on screen in coach/parent mode so it is obvious which view is active.
The same switch also lives in App settings, so you can flip it even when the home bar is crowded.
You stay in one flutter run session. No second install, no second database.

How a manager controls what families see
Each league gets a small "What families see" panel, visible only in manager view. Toggles, all on by default except power ratings:

Schedule
Scores and bracket
Standings
Venues and field map
Highlight a single team (the team chip above)
Those flags are stored on the league (in its existing config JSON, so no schema bump). Coach/parent screens read the flags and hide the rest. Manager screens ignore them.

Build order
Role switcher. Add an app role (manager or family) plus an optional team id in settings, the home-bar chip, and the banner. No screen changes yet, so you can confirm the switch sticks across restarts.
Hide manager actions. Gate create, edit, score entry, simulate, reset, backup, team library, and venue editing behind the manager role. Coach/parent home shows leagues and the schedule, standings, and venue map only.
League visibility toggles. Add the "What families see" panel and have the family screens respect it.
Team lens. In family mode, pin the selected team's fixtures and label the rest as "other games."
Accounts, invites, and a published read-only link stay in the later online phase. This switcher is the local stand-in so you can design those screens now.