/// Bundled default team templates (logo assets + kit colors).
class TeamTemplate {
  const TeamTemplate({
    required this.name,
    required this.assetPath,
    required this.colorArgb,
    this.powerRating = 50,
  });

  final String name;
  final String assetPath;
  final int colorArgb;
  final int powerRating;
}

const teamTemplates = <TeamTemplate>[
  TeamTemplate(
    name: 'Moscow Taiga',
    assetPath: 'assets/team_logos/moscow_taiga.png',
    colorArgb: 0xFFE11D48,
    powerRating: 42,
  ),
  TeamTemplate(
    name: 'Melbourne Surf',
    assetPath: 'assets/team_logos/melbourne_surf.png',
    colorArgb: 0xFF2EE6D6,
    powerRating: 44,
  ),
  TeamTemplate(
    name: 'London City',
    assetPath: 'assets/team_logos/london_city.png',
    colorArgb: 0xFFFF2D2D,
    powerRating: 60,
  ),
  TeamTemplate(
    name: 'Lagos Lions',
    assetPath: 'assets/team_logos/lagos_lions.png',
    colorArgb: 0xFF22C55E,
    powerRating: 52,
  ),
  TeamTemplate(
    name: 'City of Gold',
    assetPath: 'assets/team_logos/city_of_gold.png',
    colorArgb: 0xFFD4A017,
    powerRating: 46,
  ),
  TeamTemplate(
    name: 'Buenos Aires Tango',
    assetPath: 'assets/team_logos/buenos_aires_tango.png',
    colorArgb: 0xFF111111,
    powerRating: 54,
  ),
  TeamTemplate(
    name: 'Beijing Light',
    assetPath: 'assets/team_logos/beijing_light.png',
    colorArgb: 0xFFFF6A00,
    powerRating: 40,
  ),
  TeamTemplate(
    name: 'Cairo Falcons',
    assetPath: 'assets/team_logos/cairo_falcons.png',
    colorArgb: 0xFFFFD60A,
    powerRating: 48,
  ),
  TeamTemplate(
    name: 'Delhi Flaming Tigers',
    assetPath: 'assets/team_logos/delhi_flaming_tigers.png',
    colorArgb: 0xFFFF7A00,
    powerRating: 50,
  ),
  TeamTemplate(
    name: 'Singapore Orchids',
    assetPath: 'assets/team_logos/singapore_orchids.png',
    colorArgb: 0xFFFF4DB8,
    powerRating: 40,
  ),
  TeamTemplate(
    name: 'Tokyo Talons',
    assetPath: 'assets/team_logos/tokyo_talons.png',
    colorArgb: 0xFF9B5DE5,
    powerRating: 56,
  ),
  TeamTemplate(
    name: 'New York Empire',
    assetPath: 'assets/team_logos/new_york_empire.png',
    colorArgb: 0xFFC9A227,
    powerRating: 62,
  ),
  TeamTemplate(
    name: 'Mexico City Groupies',
    assetPath: 'assets/team_logos/mexico_city_groupies.png',
    colorArgb: 0xFF0F766E,
    powerRating: 58,
  ),
];
