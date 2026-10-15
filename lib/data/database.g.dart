// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TeamsTableTable extends TeamsTable
    with TableInfo<$TeamsTableTable, TeamsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0B6E4F),
  );
  static const VerificationMeta _powerRatingMeta = const VerificationMeta(
    'powerRating',
  );
  @override
  late final GeneratedColumn<int> powerRating = GeneratedColumn<int>(
    'power_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _homeLocationMeta = const VerificationMeta(
    'homeLocation',
  );
  @override
  late final GeneratedColumn<String> homeLocation = GeneratedColumn<String>(
    'home_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeVenueIdMeta = const VerificationMeta(
    'homeVenueId',
  );
  @override
  late final GeneratedColumn<int> homeVenueId = GeneratedColumn<int>(
    'home_venue_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _showLogoCircleMeta = const VerificationMeta(
    'showLogoCircle',
  );
  @override
  late final GeneratedColumn<bool> showLogoCircle = GeneratedColumn<bool>(
    'show_logo_circle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_logo_circle" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _titlesWonMeta = const VerificationMeta(
    'titlesWon',
  );
  @override
  late final GeneratedColumn<int> titlesWon = GeneratedColumn<int>(
    'titles_won',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _titlesJsonMeta = const VerificationMeta(
    'titlesJson',
  );
  @override
  late final GeneratedColumn<String> titlesJson = GeneratedColumn<String>(
    'titles_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _promotionsWonMeta = const VerificationMeta(
    'promotionsWon',
  );
  @override
  late final GeneratedColumn<int> promotionsWon = GeneratedColumn<int>(
    'promotions_won',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _relegationsMeta = const VerificationMeta(
    'relegations',
  );
  @override
  late final GeneratedColumn<int> relegations = GeneratedColumn<int>(
    'relegations',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerPlayedMeta = const VerificationMeta(
    'careerPlayed',
  );
  @override
  late final GeneratedColumn<int> careerPlayed = GeneratedColumn<int>(
    'career_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerWonMeta = const VerificationMeta(
    'careerWon',
  );
  @override
  late final GeneratedColumn<int> careerWon = GeneratedColumn<int>(
    'career_won',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerDrawnMeta = const VerificationMeta(
    'careerDrawn',
  );
  @override
  late final GeneratedColumn<int> careerDrawn = GeneratedColumn<int>(
    'career_drawn',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerLostMeta = const VerificationMeta(
    'careerLost',
  );
  @override
  late final GeneratedColumn<int> careerLost = GeneratedColumn<int>(
    'career_lost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerGoalsForMeta = const VerificationMeta(
    'careerGoalsFor',
  );
  @override
  late final GeneratedColumn<int> careerGoalsFor = GeneratedColumn<int>(
    'career_goals_for',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careerGoalsAgainstMeta =
      const VerificationMeta('careerGoalsAgainst');
  @override
  late final GeneratedColumn<int> careerGoalsAgainst = GeneratedColumn<int>(
    'career_goals_against',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    logoPath,
    colorArgb,
    powerRating,
    homeLocation,
    homeVenueId,
    showLogoCircle,
    titlesWon,
    titlesJson,
    promotionsWon,
    relegations,
    careerPlayed,
    careerWon,
    careerDrawn,
    careerLost,
    careerGoalsFor,
    careerGoalsAgainst,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    }
    if (data.containsKey('power_rating')) {
      context.handle(
        _powerRatingMeta,
        powerRating.isAcceptableOrUnknown(
          data['power_rating']!,
          _powerRatingMeta,
        ),
      );
    }
    if (data.containsKey('home_location')) {
      context.handle(
        _homeLocationMeta,
        homeLocation.isAcceptableOrUnknown(
          data['home_location']!,
          _homeLocationMeta,
        ),
      );
    }
    if (data.containsKey('home_venue_id')) {
      context.handle(
        _homeVenueIdMeta,
        homeVenueId.isAcceptableOrUnknown(
          data['home_venue_id']!,
          _homeVenueIdMeta,
        ),
      );
    }
    if (data.containsKey('show_logo_circle')) {
      context.handle(
        _showLogoCircleMeta,
        showLogoCircle.isAcceptableOrUnknown(
          data['show_logo_circle']!,
          _showLogoCircleMeta,
        ),
      );
    }
    if (data.containsKey('titles_won')) {
      context.handle(
        _titlesWonMeta,
        titlesWon.isAcceptableOrUnknown(data['titles_won']!, _titlesWonMeta),
      );
    }
    if (data.containsKey('titles_json')) {
      context.handle(
        _titlesJsonMeta,
        titlesJson.isAcceptableOrUnknown(data['titles_json']!, _titlesJsonMeta),
      );
    }
    if (data.containsKey('promotions_won')) {
      context.handle(
        _promotionsWonMeta,
        promotionsWon.isAcceptableOrUnknown(
          data['promotions_won']!,
          _promotionsWonMeta,
        ),
      );
    }
    if (data.containsKey('relegations')) {
      context.handle(
        _relegationsMeta,
        relegations.isAcceptableOrUnknown(
          data['relegations']!,
          _relegationsMeta,
        ),
      );
    }
    if (data.containsKey('career_played')) {
      context.handle(
        _careerPlayedMeta,
        careerPlayed.isAcceptableOrUnknown(
          data['career_played']!,
          _careerPlayedMeta,
        ),
      );
    }
    if (data.containsKey('career_won')) {
      context.handle(
        _careerWonMeta,
        careerWon.isAcceptableOrUnknown(data['career_won']!, _careerWonMeta),
      );
    }
    if (data.containsKey('career_drawn')) {
      context.handle(
        _careerDrawnMeta,
        careerDrawn.isAcceptableOrUnknown(
          data['career_drawn']!,
          _careerDrawnMeta,
        ),
      );
    }
    if (data.containsKey('career_lost')) {
      context.handle(
        _careerLostMeta,
        careerLost.isAcceptableOrUnknown(data['career_lost']!, _careerLostMeta),
      );
    }
    if (data.containsKey('career_goals_for')) {
      context.handle(
        _careerGoalsForMeta,
        careerGoalsFor.isAcceptableOrUnknown(
          data['career_goals_for']!,
          _careerGoalsForMeta,
        ),
      );
    }
    if (data.containsKey('career_goals_against')) {
      context.handle(
        _careerGoalsAgainstMeta,
        careerGoalsAgainst.isAcceptableOrUnknown(
          data['career_goals_against']!,
          _careerGoalsAgainstMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      powerRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power_rating'],
      )!,
      homeLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_location'],
      ),
      homeVenueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_venue_id'],
      ),
      showLogoCircle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_logo_circle'],
      )!,
      titlesWon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}titles_won'],
      )!,
      titlesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titles_json'],
      )!,
      promotionsWon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}promotions_won'],
      )!,
      relegations: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relegations'],
      )!,
      careerPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_played'],
      )!,
      careerWon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_won'],
      )!,
      careerDrawn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_drawn'],
      )!,
      careerLost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_lost'],
      )!,
      careerGoalsFor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_goals_for'],
      )!,
      careerGoalsAgainst: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_goals_against'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TeamsTableTable createAlias(String alias) {
    return $TeamsTableTable(attachedDatabase, alias);
  }
}

class TeamsTableData extends DataClass implements Insertable<TeamsTableData> {
  final int id;
  final String name;
  final String? logoPath;
  final int colorArgb;
  final int powerRating;

  /// Denormalized display label synced from [homeVenueId] when set.
  final String? homeLocation;

  /// Soft FK to [VenuesTable] — optional home ground / field.
  final int? homeVenueId;

  /// White disc behind the logo on the parent page. Off when it clashes.
  final bool showLogoCircle;
  final int titlesWon;

  /// JSON array of title names, e.g. `["Premier League S1","Cup Final"]`.
  final String titlesJson;
  final int promotionsWon;
  final int relegations;
  final int careerPlayed;
  final int careerWon;
  final int careerDrawn;
  final int careerLost;
  final int careerGoalsFor;
  final int careerGoalsAgainst;
  final DateTime createdAt;
  const TeamsTableData({
    required this.id,
    required this.name,
    this.logoPath,
    required this.colorArgb,
    required this.powerRating,
    this.homeLocation,
    this.homeVenueId,
    required this.showLogoCircle,
    required this.titlesWon,
    required this.titlesJson,
    required this.promotionsWon,
    required this.relegations,
    required this.careerPlayed,
    required this.careerWon,
    required this.careerDrawn,
    required this.careerLost,
    required this.careerGoalsFor,
    required this.careerGoalsAgainst,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['color_argb'] = Variable<int>(colorArgb);
    map['power_rating'] = Variable<int>(powerRating);
    if (!nullToAbsent || homeLocation != null) {
      map['home_location'] = Variable<String>(homeLocation);
    }
    if (!nullToAbsent || homeVenueId != null) {
      map['home_venue_id'] = Variable<int>(homeVenueId);
    }
    map['show_logo_circle'] = Variable<bool>(showLogoCircle);
    map['titles_won'] = Variable<int>(titlesWon);
    map['titles_json'] = Variable<String>(titlesJson);
    map['promotions_won'] = Variable<int>(promotionsWon);
    map['relegations'] = Variable<int>(relegations);
    map['career_played'] = Variable<int>(careerPlayed);
    map['career_won'] = Variable<int>(careerWon);
    map['career_drawn'] = Variable<int>(careerDrawn);
    map['career_lost'] = Variable<int>(careerLost);
    map['career_goals_for'] = Variable<int>(careerGoalsFor);
    map['career_goals_against'] = Variable<int>(careerGoalsAgainst);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TeamsTableCompanion toCompanion(bool nullToAbsent) {
    return TeamsTableCompanion(
      id: Value(id),
      name: Value(name),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      colorArgb: Value(colorArgb),
      powerRating: Value(powerRating),
      homeLocation: homeLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(homeLocation),
      homeVenueId: homeVenueId == null && nullToAbsent
          ? const Value.absent()
          : Value(homeVenueId),
      showLogoCircle: Value(showLogoCircle),
      titlesWon: Value(titlesWon),
      titlesJson: Value(titlesJson),
      promotionsWon: Value(promotionsWon),
      relegations: Value(relegations),
      careerPlayed: Value(careerPlayed),
      careerWon: Value(careerWon),
      careerDrawn: Value(careerDrawn),
      careerLost: Value(careerLost),
      careerGoalsFor: Value(careerGoalsFor),
      careerGoalsAgainst: Value(careerGoalsAgainst),
      createdAt: Value(createdAt),
    );
  }

  factory TeamsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      powerRating: serializer.fromJson<int>(json['powerRating']),
      homeLocation: serializer.fromJson<String?>(json['homeLocation']),
      homeVenueId: serializer.fromJson<int?>(json['homeVenueId']),
      showLogoCircle: serializer.fromJson<bool>(json['showLogoCircle']),
      titlesWon: serializer.fromJson<int>(json['titlesWon']),
      titlesJson: serializer.fromJson<String>(json['titlesJson']),
      promotionsWon: serializer.fromJson<int>(json['promotionsWon']),
      relegations: serializer.fromJson<int>(json['relegations']),
      careerPlayed: serializer.fromJson<int>(json['careerPlayed']),
      careerWon: serializer.fromJson<int>(json['careerWon']),
      careerDrawn: serializer.fromJson<int>(json['careerDrawn']),
      careerLost: serializer.fromJson<int>(json['careerLost']),
      careerGoalsFor: serializer.fromJson<int>(json['careerGoalsFor']),
      careerGoalsAgainst: serializer.fromJson<int>(json['careerGoalsAgainst']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'logoPath': serializer.toJson<String?>(logoPath),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'powerRating': serializer.toJson<int>(powerRating),
      'homeLocation': serializer.toJson<String?>(homeLocation),
      'homeVenueId': serializer.toJson<int?>(homeVenueId),
      'showLogoCircle': serializer.toJson<bool>(showLogoCircle),
      'titlesWon': serializer.toJson<int>(titlesWon),
      'titlesJson': serializer.toJson<String>(titlesJson),
      'promotionsWon': serializer.toJson<int>(promotionsWon),
      'relegations': serializer.toJson<int>(relegations),
      'careerPlayed': serializer.toJson<int>(careerPlayed),
      'careerWon': serializer.toJson<int>(careerWon),
      'careerDrawn': serializer.toJson<int>(careerDrawn),
      'careerLost': serializer.toJson<int>(careerLost),
      'careerGoalsFor': serializer.toJson<int>(careerGoalsFor),
      'careerGoalsAgainst': serializer.toJson<int>(careerGoalsAgainst),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TeamsTableData copyWith({
    int? id,
    String? name,
    Value<String?> logoPath = const Value.absent(),
    int? colorArgb,
    int? powerRating,
    Value<String?> homeLocation = const Value.absent(),
    Value<int?> homeVenueId = const Value.absent(),
    bool? showLogoCircle,
    int? titlesWon,
    String? titlesJson,
    int? promotionsWon,
    int? relegations,
    int? careerPlayed,
    int? careerWon,
    int? careerDrawn,
    int? careerLost,
    int? careerGoalsFor,
    int? careerGoalsAgainst,
    DateTime? createdAt,
  }) => TeamsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    colorArgb: colorArgb ?? this.colorArgb,
    powerRating: powerRating ?? this.powerRating,
    homeLocation: homeLocation.present ? homeLocation.value : this.homeLocation,
    homeVenueId: homeVenueId.present ? homeVenueId.value : this.homeVenueId,
    showLogoCircle: showLogoCircle ?? this.showLogoCircle,
    titlesWon: titlesWon ?? this.titlesWon,
    titlesJson: titlesJson ?? this.titlesJson,
    promotionsWon: promotionsWon ?? this.promotionsWon,
    relegations: relegations ?? this.relegations,
    careerPlayed: careerPlayed ?? this.careerPlayed,
    careerWon: careerWon ?? this.careerWon,
    careerDrawn: careerDrawn ?? this.careerDrawn,
    careerLost: careerLost ?? this.careerLost,
    careerGoalsFor: careerGoalsFor ?? this.careerGoalsFor,
    careerGoalsAgainst: careerGoalsAgainst ?? this.careerGoalsAgainst,
    createdAt: createdAt ?? this.createdAt,
  );
  TeamsTableData copyWithCompanion(TeamsTableCompanion data) {
    return TeamsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      powerRating: data.powerRating.present
          ? data.powerRating.value
          : this.powerRating,
      homeLocation: data.homeLocation.present
          ? data.homeLocation.value
          : this.homeLocation,
      homeVenueId: data.homeVenueId.present
          ? data.homeVenueId.value
          : this.homeVenueId,
      showLogoCircle: data.showLogoCircle.present
          ? data.showLogoCircle.value
          : this.showLogoCircle,
      titlesWon: data.titlesWon.present ? data.titlesWon.value : this.titlesWon,
      titlesJson: data.titlesJson.present
          ? data.titlesJson.value
          : this.titlesJson,
      promotionsWon: data.promotionsWon.present
          ? data.promotionsWon.value
          : this.promotionsWon,
      relegations: data.relegations.present
          ? data.relegations.value
          : this.relegations,
      careerPlayed: data.careerPlayed.present
          ? data.careerPlayed.value
          : this.careerPlayed,
      careerWon: data.careerWon.present ? data.careerWon.value : this.careerWon,
      careerDrawn: data.careerDrawn.present
          ? data.careerDrawn.value
          : this.careerDrawn,
      careerLost: data.careerLost.present
          ? data.careerLost.value
          : this.careerLost,
      careerGoalsFor: data.careerGoalsFor.present
          ? data.careerGoalsFor.value
          : this.careerGoalsFor,
      careerGoalsAgainst: data.careerGoalsAgainst.present
          ? data.careerGoalsAgainst.value
          : this.careerGoalsAgainst,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logoPath: $logoPath, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('powerRating: $powerRating, ')
          ..write('homeLocation: $homeLocation, ')
          ..write('homeVenueId: $homeVenueId, ')
          ..write('showLogoCircle: $showLogoCircle, ')
          ..write('titlesWon: $titlesWon, ')
          ..write('titlesJson: $titlesJson, ')
          ..write('promotionsWon: $promotionsWon, ')
          ..write('relegations: $relegations, ')
          ..write('careerPlayed: $careerPlayed, ')
          ..write('careerWon: $careerWon, ')
          ..write('careerDrawn: $careerDrawn, ')
          ..write('careerLost: $careerLost, ')
          ..write('careerGoalsFor: $careerGoalsFor, ')
          ..write('careerGoalsAgainst: $careerGoalsAgainst, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    logoPath,
    colorArgb,
    powerRating,
    homeLocation,
    homeVenueId,
    showLogoCircle,
    titlesWon,
    titlesJson,
    promotionsWon,
    relegations,
    careerPlayed,
    careerWon,
    careerDrawn,
    careerLost,
    careerGoalsFor,
    careerGoalsAgainst,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.logoPath == this.logoPath &&
          other.colorArgb == this.colorArgb &&
          other.powerRating == this.powerRating &&
          other.homeLocation == this.homeLocation &&
          other.homeVenueId == this.homeVenueId &&
          other.showLogoCircle == this.showLogoCircle &&
          other.titlesWon == this.titlesWon &&
          other.titlesJson == this.titlesJson &&
          other.promotionsWon == this.promotionsWon &&
          other.relegations == this.relegations &&
          other.careerPlayed == this.careerPlayed &&
          other.careerWon == this.careerWon &&
          other.careerDrawn == this.careerDrawn &&
          other.careerLost == this.careerLost &&
          other.careerGoalsFor == this.careerGoalsFor &&
          other.careerGoalsAgainst == this.careerGoalsAgainst &&
          other.createdAt == this.createdAt);
}

class TeamsTableCompanion extends UpdateCompanion<TeamsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> logoPath;
  final Value<int> colorArgb;
  final Value<int> powerRating;
  final Value<String?> homeLocation;
  final Value<int?> homeVenueId;
  final Value<bool> showLogoCircle;
  final Value<int> titlesWon;
  final Value<String> titlesJson;
  final Value<int> promotionsWon;
  final Value<int> relegations;
  final Value<int> careerPlayed;
  final Value<int> careerWon;
  final Value<int> careerDrawn;
  final Value<int> careerLost;
  final Value<int> careerGoalsFor;
  final Value<int> careerGoalsAgainst;
  final Value<DateTime> createdAt;
  const TeamsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.powerRating = const Value.absent(),
    this.homeLocation = const Value.absent(),
    this.homeVenueId = const Value.absent(),
    this.showLogoCircle = const Value.absent(),
    this.titlesWon = const Value.absent(),
    this.titlesJson = const Value.absent(),
    this.promotionsWon = const Value.absent(),
    this.relegations = const Value.absent(),
    this.careerPlayed = const Value.absent(),
    this.careerWon = const Value.absent(),
    this.careerDrawn = const Value.absent(),
    this.careerLost = const Value.absent(),
    this.careerGoalsFor = const Value.absent(),
    this.careerGoalsAgainst = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TeamsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.logoPath = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.powerRating = const Value.absent(),
    this.homeLocation = const Value.absent(),
    this.homeVenueId = const Value.absent(),
    this.showLogoCircle = const Value.absent(),
    this.titlesWon = const Value.absent(),
    this.titlesJson = const Value.absent(),
    this.promotionsWon = const Value.absent(),
    this.relegations = const Value.absent(),
    this.careerPlayed = const Value.absent(),
    this.careerWon = const Value.absent(),
    this.careerDrawn = const Value.absent(),
    this.careerLost = const Value.absent(),
    this.careerGoalsFor = const Value.absent(),
    this.careerGoalsAgainst = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TeamsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? logoPath,
    Expression<int>? colorArgb,
    Expression<int>? powerRating,
    Expression<String>? homeLocation,
    Expression<int>? homeVenueId,
    Expression<bool>? showLogoCircle,
    Expression<int>? titlesWon,
    Expression<String>? titlesJson,
    Expression<int>? promotionsWon,
    Expression<int>? relegations,
    Expression<int>? careerPlayed,
    Expression<int>? careerWon,
    Expression<int>? careerDrawn,
    Expression<int>? careerLost,
    Expression<int>? careerGoalsFor,
    Expression<int>? careerGoalsAgainst,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (logoPath != null) 'logo_path': logoPath,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (powerRating != null) 'power_rating': powerRating,
      if (homeLocation != null) 'home_location': homeLocation,
      if (homeVenueId != null) 'home_venue_id': homeVenueId,
      if (showLogoCircle != null) 'show_logo_circle': showLogoCircle,
      if (titlesWon != null) 'titles_won': titlesWon,
      if (titlesJson != null) 'titles_json': titlesJson,
      if (promotionsWon != null) 'promotions_won': promotionsWon,
      if (relegations != null) 'relegations': relegations,
      if (careerPlayed != null) 'career_played': careerPlayed,
      if (careerWon != null) 'career_won': careerWon,
      if (careerDrawn != null) 'career_drawn': careerDrawn,
      if (careerLost != null) 'career_lost': careerLost,
      if (careerGoalsFor != null) 'career_goals_for': careerGoalsFor,
      if (careerGoalsAgainst != null)
        'career_goals_against': careerGoalsAgainst,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TeamsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? logoPath,
    Value<int>? colorArgb,
    Value<int>? powerRating,
    Value<String?>? homeLocation,
    Value<int?>? homeVenueId,
    Value<bool>? showLogoCircle,
    Value<int>? titlesWon,
    Value<String>? titlesJson,
    Value<int>? promotionsWon,
    Value<int>? relegations,
    Value<int>? careerPlayed,
    Value<int>? careerWon,
    Value<int>? careerDrawn,
    Value<int>? careerLost,
    Value<int>? careerGoalsFor,
    Value<int>? careerGoalsAgainst,
    Value<DateTime>? createdAt,
  }) {
    return TeamsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      colorArgb: colorArgb ?? this.colorArgb,
      powerRating: powerRating ?? this.powerRating,
      homeLocation: homeLocation ?? this.homeLocation,
      homeVenueId: homeVenueId ?? this.homeVenueId,
      showLogoCircle: showLogoCircle ?? this.showLogoCircle,
      titlesWon: titlesWon ?? this.titlesWon,
      titlesJson: titlesJson ?? this.titlesJson,
      promotionsWon: promotionsWon ?? this.promotionsWon,
      relegations: relegations ?? this.relegations,
      careerPlayed: careerPlayed ?? this.careerPlayed,
      careerWon: careerWon ?? this.careerWon,
      careerDrawn: careerDrawn ?? this.careerDrawn,
      careerLost: careerLost ?? this.careerLost,
      careerGoalsFor: careerGoalsFor ?? this.careerGoalsFor,
      careerGoalsAgainst: careerGoalsAgainst ?? this.careerGoalsAgainst,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (powerRating.present) {
      map['power_rating'] = Variable<int>(powerRating.value);
    }
    if (homeLocation.present) {
      map['home_location'] = Variable<String>(homeLocation.value);
    }
    if (homeVenueId.present) {
      map['home_venue_id'] = Variable<int>(homeVenueId.value);
    }
    if (showLogoCircle.present) {
      map['show_logo_circle'] = Variable<bool>(showLogoCircle.value);
    }
    if (titlesWon.present) {
      map['titles_won'] = Variable<int>(titlesWon.value);
    }
    if (titlesJson.present) {
      map['titles_json'] = Variable<String>(titlesJson.value);
    }
    if (promotionsWon.present) {
      map['promotions_won'] = Variable<int>(promotionsWon.value);
    }
    if (relegations.present) {
      map['relegations'] = Variable<int>(relegations.value);
    }
    if (careerPlayed.present) {
      map['career_played'] = Variable<int>(careerPlayed.value);
    }
    if (careerWon.present) {
      map['career_won'] = Variable<int>(careerWon.value);
    }
    if (careerDrawn.present) {
      map['career_drawn'] = Variable<int>(careerDrawn.value);
    }
    if (careerLost.present) {
      map['career_lost'] = Variable<int>(careerLost.value);
    }
    if (careerGoalsFor.present) {
      map['career_goals_for'] = Variable<int>(careerGoalsFor.value);
    }
    if (careerGoalsAgainst.present) {
      map['career_goals_against'] = Variable<int>(careerGoalsAgainst.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logoPath: $logoPath, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('powerRating: $powerRating, ')
          ..write('homeLocation: $homeLocation, ')
          ..write('homeVenueId: $homeVenueId, ')
          ..write('showLogoCircle: $showLogoCircle, ')
          ..write('titlesWon: $titlesWon, ')
          ..write('titlesJson: $titlesJson, ')
          ..write('promotionsWon: $promotionsWon, ')
          ..write('relegations: $relegations, ')
          ..write('careerPlayed: $careerPlayed, ')
          ..write('careerWon: $careerWon, ')
          ..write('careerDrawn: $careerDrawn, ')
          ..write('careerLost: $careerLost, ')
          ..write('careerGoalsFor: $careerGoalsFor, ')
          ..write('careerGoalsAgainst: $careerGoalsAgainst, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TeamListsTableTable extends TeamListsTable
    with TableInfo<$TeamListsTableTable, TeamListsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamListsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_lists_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamListsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamListsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamListsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TeamListsTableTable createAlias(String alias) {
    return $TeamListsTableTable(attachedDatabase, alias);
  }
}

class TeamListsTableData extends DataClass
    implements Insertable<TeamListsTableData> {
  final int id;
  final String name;
  final DateTime createdAt;
  const TeamListsTableData({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TeamListsTableCompanion toCompanion(bool nullToAbsent) {
    return TeamListsTableCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory TeamListsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamListsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TeamListsTableData copyWith({int? id, String? name, DateTime? createdAt}) =>
      TeamListsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  TeamListsTableData copyWithCompanion(TeamListsTableCompanion data) {
    return TeamListsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamListsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamListsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TeamListsTableCompanion extends UpdateCompanion<TeamListsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const TeamListsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TeamListsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TeamListsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TeamListsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return TeamListsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamListsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TeamListMembersTableTable extends TeamListMembersTable
    with TableInfo<$TeamListMembersTableTable, TeamListMembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamListMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES team_lists_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams_table (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, listId, teamId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_list_members_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamListMembersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {listId, teamId},
  ];
  @override
  TeamListMembersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamListMembersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
    );
  }

  @override
  $TeamListMembersTableTable createAlias(String alias) {
    return $TeamListMembersTableTable(attachedDatabase, alias);
  }
}

class TeamListMembersTableData extends DataClass
    implements Insertable<TeamListMembersTableData> {
  final int id;
  final int listId;
  final int teamId;
  const TeamListMembersTableData({
    required this.id,
    required this.listId,
    required this.teamId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    map['team_id'] = Variable<int>(teamId);
    return map;
  }

  TeamListMembersTableCompanion toCompanion(bool nullToAbsent) {
    return TeamListMembersTableCompanion(
      id: Value(id),
      listId: Value(listId),
      teamId: Value(teamId),
    );
  }

  factory TeamListMembersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamListMembersTableData(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      teamId: serializer.fromJson<int>(json['teamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'teamId': serializer.toJson<int>(teamId),
    };
  }

  TeamListMembersTableData copyWith({int? id, int? listId, int? teamId}) =>
      TeamListMembersTableData(
        id: id ?? this.id,
        listId: listId ?? this.listId,
        teamId: teamId ?? this.teamId,
      );
  TeamListMembersTableData copyWithCompanion(
    TeamListMembersTableCompanion data,
  ) {
    return TeamListMembersTableData(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamListMembersTableData(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listId, teamId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamListMembersTableData &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.teamId == this.teamId);
}

class TeamListMembersTableCompanion
    extends UpdateCompanion<TeamListMembersTableData> {
  final Value<int> id;
  final Value<int> listId;
  final Value<int> teamId;
  const TeamListMembersTableCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.teamId = const Value.absent(),
  });
  TeamListMembersTableCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    required int teamId,
  }) : listId = Value(listId),
       teamId = Value(teamId);
  static Insertable<TeamListMembersTableData> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<int>? teamId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (teamId != null) 'team_id': teamId,
    });
  }

  TeamListMembersTableCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<int>? teamId,
  }) {
    return TeamListMembersTableCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamListMembersTableCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }
}

class $LeaguesTableTable extends LeaguesTable
    with TableInfo<$LeaguesTableTable, LeaguesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaguesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('roundRobin'),
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _promoteCountMeta = const VerificationMeta(
    'promoteCount',
  );
  @override
  late final GeneratedColumn<int> promoteCount = GeneratedColumn<int>(
    'promote_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _relegateCountMeta = const VerificationMeta(
    'relegateCount',
  );
  @override
  late final GeneratedColumn<int> relegateCount = GeneratedColumn<int>(
    'relegate_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _promoRelegEnabledMeta = const VerificationMeta(
    'promoRelegEnabled',
  );
  @override
  late final GeneratedColumn<bool> promoRelegEnabled = GeneratedColumn<bool>(
    'promo_releg_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("promo_releg_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pointsForWinMeta = const VerificationMeta(
    'pointsForWin',
  );
  @override
  late final GeneratedColumn<int> pointsForWin = GeneratedColumn<int>(
    'points_for_win',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _pointsForDrawMeta = const VerificationMeta(
    'pointsForDraw',
  );
  @override
  late final GeneratedColumn<int> pointsForDraw = GeneratedColumn<int>(
    'points_for_draw',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _meetingsPerPairMeta = const VerificationMeta(
    'meetingsPerPair',
  );
  @override
  late final GeneratedColumn<int> meetingsPerPair = GeneratedColumn<int>(
    'meetings_per_pair',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _seasonNumberMeta = const VerificationMeta(
    'seasonNumber',
  );
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
    'season_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    format,
    configJson,
    promoteCount,
    relegateCount,
    promoRelegEnabled,
    pointsForWin,
    pointsForDraw,
    meetingsPerPair,
    seasonNumber,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leagues_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaguesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    }
    if (data.containsKey('promote_count')) {
      context.handle(
        _promoteCountMeta,
        promoteCount.isAcceptableOrUnknown(
          data['promote_count']!,
          _promoteCountMeta,
        ),
      );
    }
    if (data.containsKey('relegate_count')) {
      context.handle(
        _relegateCountMeta,
        relegateCount.isAcceptableOrUnknown(
          data['relegate_count']!,
          _relegateCountMeta,
        ),
      );
    }
    if (data.containsKey('promo_releg_enabled')) {
      context.handle(
        _promoRelegEnabledMeta,
        promoRelegEnabled.isAcceptableOrUnknown(
          data['promo_releg_enabled']!,
          _promoRelegEnabledMeta,
        ),
      );
    }
    if (data.containsKey('points_for_win')) {
      context.handle(
        _pointsForWinMeta,
        pointsForWin.isAcceptableOrUnknown(
          data['points_for_win']!,
          _pointsForWinMeta,
        ),
      );
    }
    if (data.containsKey('points_for_draw')) {
      context.handle(
        _pointsForDrawMeta,
        pointsForDraw.isAcceptableOrUnknown(
          data['points_for_draw']!,
          _pointsForDrawMeta,
        ),
      );
    }
    if (data.containsKey('meetings_per_pair')) {
      context.handle(
        _meetingsPerPairMeta,
        meetingsPerPair.isAcceptableOrUnknown(
          data['meetings_per_pair']!,
          _meetingsPerPairMeta,
        ),
      );
    }
    if (data.containsKey('season_number')) {
      context.handle(
        _seasonNumberMeta,
        seasonNumber.isAcceptableOrUnknown(
          data['season_number']!,
          _seasonNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaguesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaguesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      promoteCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}promote_count'],
      )!,
      relegateCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relegate_count'],
      )!,
      promoRelegEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}promo_releg_enabled'],
      )!,
      pointsForWin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_for_win'],
      )!,
      pointsForDraw: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_for_draw'],
      )!,
      meetingsPerPair: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meetings_per_pair'],
      )!,
      seasonNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $LeaguesTableTable createAlias(String alias) {
    return $LeaguesTableTable(attachedDatabase, alias);
  }
}

class LeaguesTableData extends DataClass
    implements Insertable<LeaguesTableData> {
  final int id;
  final String name;
  final String status;
  final String format;
  final String configJson;
  final int promoteCount;
  final int relegateCount;
  final bool promoRelegEnabled;
  final int pointsForWin;
  final int pointsForDraw;
  final int meetingsPerPair;
  final int seasonNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const LeaguesTableData({
    required this.id,
    required this.name,
    required this.status,
    required this.format,
    required this.configJson,
    required this.promoteCount,
    required this.relegateCount,
    required this.promoRelegEnabled,
    required this.pointsForWin,
    required this.pointsForDraw,
    required this.meetingsPerPair,
    required this.seasonNumber,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['format'] = Variable<String>(format);
    map['config_json'] = Variable<String>(configJson);
    map['promote_count'] = Variable<int>(promoteCount);
    map['relegate_count'] = Variable<int>(relegateCount);
    map['promo_releg_enabled'] = Variable<bool>(promoRelegEnabled);
    map['points_for_win'] = Variable<int>(pointsForWin);
    map['points_for_draw'] = Variable<int>(pointsForDraw);
    map['meetings_per_pair'] = Variable<int>(meetingsPerPair);
    map['season_number'] = Variable<int>(seasonNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LeaguesTableCompanion toCompanion(bool nullToAbsent) {
    return LeaguesTableCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      format: Value(format),
      configJson: Value(configJson),
      promoteCount: Value(promoteCount),
      relegateCount: Value(relegateCount),
      promoRelegEnabled: Value(promoRelegEnabled),
      pointsForWin: Value(pointsForWin),
      pointsForDraw: Value(pointsForDraw),
      meetingsPerPair: Value(meetingsPerPair),
      seasonNumber: Value(seasonNumber),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LeaguesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaguesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      format: serializer.fromJson<String>(json['format']),
      configJson: serializer.fromJson<String>(json['configJson']),
      promoteCount: serializer.fromJson<int>(json['promoteCount']),
      relegateCount: serializer.fromJson<int>(json['relegateCount']),
      promoRelegEnabled: serializer.fromJson<bool>(json['promoRelegEnabled']),
      pointsForWin: serializer.fromJson<int>(json['pointsForWin']),
      pointsForDraw: serializer.fromJson<int>(json['pointsForDraw']),
      meetingsPerPair: serializer.fromJson<int>(json['meetingsPerPair']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'format': serializer.toJson<String>(format),
      'configJson': serializer.toJson<String>(configJson),
      'promoteCount': serializer.toJson<int>(promoteCount),
      'relegateCount': serializer.toJson<int>(relegateCount),
      'promoRelegEnabled': serializer.toJson<bool>(promoRelegEnabled),
      'pointsForWin': serializer.toJson<int>(pointsForWin),
      'pointsForDraw': serializer.toJson<int>(pointsForDraw),
      'meetingsPerPair': serializer.toJson<int>(meetingsPerPair),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LeaguesTableData copyWith({
    int? id,
    String? name,
    String? status,
    String? format,
    String? configJson,
    int? promoteCount,
    int? relegateCount,
    bool? promoRelegEnabled,
    int? pointsForWin,
    int? pointsForDraw,
    int? meetingsPerPair,
    int? seasonNumber,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => LeaguesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    format: format ?? this.format,
    configJson: configJson ?? this.configJson,
    promoteCount: promoteCount ?? this.promoteCount,
    relegateCount: relegateCount ?? this.relegateCount,
    promoRelegEnabled: promoRelegEnabled ?? this.promoRelegEnabled,
    pointsForWin: pointsForWin ?? this.pointsForWin,
    pointsForDraw: pointsForDraw ?? this.pointsForDraw,
    meetingsPerPair: meetingsPerPair ?? this.meetingsPerPair,
    seasonNumber: seasonNumber ?? this.seasonNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  LeaguesTableData copyWithCompanion(LeaguesTableCompanion data) {
    return LeaguesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      format: data.format.present ? data.format.value : this.format,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      promoteCount: data.promoteCount.present
          ? data.promoteCount.value
          : this.promoteCount,
      relegateCount: data.relegateCount.present
          ? data.relegateCount.value
          : this.relegateCount,
      promoRelegEnabled: data.promoRelegEnabled.present
          ? data.promoRelegEnabled.value
          : this.promoRelegEnabled,
      pointsForWin: data.pointsForWin.present
          ? data.pointsForWin.value
          : this.pointsForWin,
      pointsForDraw: data.pointsForDraw.present
          ? data.pointsForDraw.value
          : this.pointsForDraw,
      meetingsPerPair: data.meetingsPerPair.present
          ? data.meetingsPerPair.value
          : this.meetingsPerPair,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaguesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('format: $format, ')
          ..write('configJson: $configJson, ')
          ..write('promoteCount: $promoteCount, ')
          ..write('relegateCount: $relegateCount, ')
          ..write('promoRelegEnabled: $promoRelegEnabled, ')
          ..write('pointsForWin: $pointsForWin, ')
          ..write('pointsForDraw: $pointsForDraw, ')
          ..write('meetingsPerPair: $meetingsPerPair, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    status,
    format,
    configJson,
    promoteCount,
    relegateCount,
    promoRelegEnabled,
    pointsForWin,
    pointsForDraw,
    meetingsPerPair,
    seasonNumber,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaguesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.format == this.format &&
          other.configJson == this.configJson &&
          other.promoteCount == this.promoteCount &&
          other.relegateCount == this.relegateCount &&
          other.promoRelegEnabled == this.promoRelegEnabled &&
          other.pointsForWin == this.pointsForWin &&
          other.pointsForDraw == this.pointsForDraw &&
          other.meetingsPerPair == this.meetingsPerPair &&
          other.seasonNumber == this.seasonNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LeaguesTableCompanion extends UpdateCompanion<LeaguesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> format;
  final Value<String> configJson;
  final Value<int> promoteCount;
  final Value<int> relegateCount;
  final Value<bool> promoRelegEnabled;
  final Value<int> pointsForWin;
  final Value<int> pointsForDraw;
  final Value<int> meetingsPerPair;
  final Value<int> seasonNumber;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const LeaguesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.format = const Value.absent(),
    this.configJson = const Value.absent(),
    this.promoteCount = const Value.absent(),
    this.relegateCount = const Value.absent(),
    this.promoRelegEnabled = const Value.absent(),
    this.pointsForWin = const Value.absent(),
    this.pointsForDraw = const Value.absent(),
    this.meetingsPerPair = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LeaguesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    this.format = const Value.absent(),
    this.configJson = const Value.absent(),
    this.promoteCount = const Value.absent(),
    this.relegateCount = const Value.absent(),
    this.promoRelegEnabled = const Value.absent(),
    this.pointsForWin = const Value.absent(),
    this.pointsForDraw = const Value.absent(),
    this.meetingsPerPair = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status);
  static Insertable<LeaguesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? format,
    Expression<String>? configJson,
    Expression<int>? promoteCount,
    Expression<int>? relegateCount,
    Expression<bool>? promoRelegEnabled,
    Expression<int>? pointsForWin,
    Expression<int>? pointsForDraw,
    Expression<int>? meetingsPerPair,
    Expression<int>? seasonNumber,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (format != null) 'format': format,
      if (configJson != null) 'config_json': configJson,
      if (promoteCount != null) 'promote_count': promoteCount,
      if (relegateCount != null) 'relegate_count': relegateCount,
      if (promoRelegEnabled != null) 'promo_releg_enabled': promoRelegEnabled,
      if (pointsForWin != null) 'points_for_win': pointsForWin,
      if (pointsForDraw != null) 'points_for_draw': pointsForDraw,
      if (meetingsPerPair != null) 'meetings_per_pair': meetingsPerPair,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LeaguesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? format,
    Value<String>? configJson,
    Value<int>? promoteCount,
    Value<int>? relegateCount,
    Value<bool>? promoRelegEnabled,
    Value<int>? pointsForWin,
    Value<int>? pointsForDraw,
    Value<int>? meetingsPerPair,
    Value<int>? seasonNumber,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return LeaguesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      format: format ?? this.format,
      configJson: configJson ?? this.configJson,
      promoteCount: promoteCount ?? this.promoteCount,
      relegateCount: relegateCount ?? this.relegateCount,
      promoRelegEnabled: promoRelegEnabled ?? this.promoRelegEnabled,
      pointsForWin: pointsForWin ?? this.pointsForWin,
      pointsForDraw: pointsForDraw ?? this.pointsForDraw,
      meetingsPerPair: meetingsPerPair ?? this.meetingsPerPair,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (promoteCount.present) {
      map['promote_count'] = Variable<int>(promoteCount.value);
    }
    if (relegateCount.present) {
      map['relegate_count'] = Variable<int>(relegateCount.value);
    }
    if (promoRelegEnabled.present) {
      map['promo_releg_enabled'] = Variable<bool>(promoRelegEnabled.value);
    }
    if (pointsForWin.present) {
      map['points_for_win'] = Variable<int>(pointsForWin.value);
    }
    if (pointsForDraw.present) {
      map['points_for_draw'] = Variable<int>(pointsForDraw.value);
    }
    if (meetingsPerPair.present) {
      map['meetings_per_pair'] = Variable<int>(meetingsPerPair.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaguesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('format: $format, ')
          ..write('configJson: $configJson, ')
          ..write('promoteCount: $promoteCount, ')
          ..write('relegateCount: $relegateCount, ')
          ..write('promoRelegEnabled: $promoRelegEnabled, ')
          ..write('pointsForWin: $pointsForWin, ')
          ..write('pointsForDraw: $pointsForDraw, ')
          ..write('meetingsPerPair: $meetingsPerPair, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DivisionsTableTable extends DivisionsTable
    with TableInfo<$DivisionsTableTable, DivisionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DivisionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _leagueIdMeta = const VerificationMeta(
    'leagueId',
  );
  @override
  late final GeneratedColumn<int> leagueId = GeneratedColumn<int>(
    'league_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES leagues_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierIndexMeta = const VerificationMeta(
    'tierIndex',
  );
  @override
  late final GeneratedColumn<int> tierIndex = GeneratedColumn<int>(
    'tier_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentTournamentIdMeta =
      const VerificationMeta('currentTournamentId');
  @override
  late final GeneratedColumn<int> currentTournamentId = GeneratedColumn<int>(
    'current_tournament_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leagueId,
    name,
    tierIndex,
    currentTournamentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'divisions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DivisionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('league_id')) {
      context.handle(
        _leagueIdMeta,
        leagueId.isAcceptableOrUnknown(data['league_id']!, _leagueIdMeta),
      );
    } else if (isInserting) {
      context.missing(_leagueIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tier_index')) {
      context.handle(
        _tierIndexMeta,
        tierIndex.isAcceptableOrUnknown(data['tier_index']!, _tierIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_tierIndexMeta);
    }
    if (data.containsKey('current_tournament_id')) {
      context.handle(
        _currentTournamentIdMeta,
        currentTournamentId.isAcceptableOrUnknown(
          data['current_tournament_id']!,
          _currentTournamentIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DivisionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DivisionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leagueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}league_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tierIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tier_index'],
      )!,
      currentTournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_tournament_id'],
      ),
    );
  }

  @override
  $DivisionsTableTable createAlias(String alias) {
    return $DivisionsTableTable(attachedDatabase, alias);
  }
}

class DivisionsTableData extends DataClass
    implements Insertable<DivisionsTableData> {
  final int id;
  final int leagueId;
  final String name;
  final int tierIndex;
  final int? currentTournamentId;
  const DivisionsTableData({
    required this.id,
    required this.leagueId,
    required this.name,
    required this.tierIndex,
    this.currentTournamentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['league_id'] = Variable<int>(leagueId);
    map['name'] = Variable<String>(name);
    map['tier_index'] = Variable<int>(tierIndex);
    if (!nullToAbsent || currentTournamentId != null) {
      map['current_tournament_id'] = Variable<int>(currentTournamentId);
    }
    return map;
  }

  DivisionsTableCompanion toCompanion(bool nullToAbsent) {
    return DivisionsTableCompanion(
      id: Value(id),
      leagueId: Value(leagueId),
      name: Value(name),
      tierIndex: Value(tierIndex),
      currentTournamentId: currentTournamentId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentTournamentId),
    );
  }

  factory DivisionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DivisionsTableData(
      id: serializer.fromJson<int>(json['id']),
      leagueId: serializer.fromJson<int>(json['leagueId']),
      name: serializer.fromJson<String>(json['name']),
      tierIndex: serializer.fromJson<int>(json['tierIndex']),
      currentTournamentId: serializer.fromJson<int?>(
        json['currentTournamentId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leagueId': serializer.toJson<int>(leagueId),
      'name': serializer.toJson<String>(name),
      'tierIndex': serializer.toJson<int>(tierIndex),
      'currentTournamentId': serializer.toJson<int?>(currentTournamentId),
    };
  }

  DivisionsTableData copyWith({
    int? id,
    int? leagueId,
    String? name,
    int? tierIndex,
    Value<int?> currentTournamentId = const Value.absent(),
  }) => DivisionsTableData(
    id: id ?? this.id,
    leagueId: leagueId ?? this.leagueId,
    name: name ?? this.name,
    tierIndex: tierIndex ?? this.tierIndex,
    currentTournamentId: currentTournamentId.present
        ? currentTournamentId.value
        : this.currentTournamentId,
  );
  DivisionsTableData copyWithCompanion(DivisionsTableCompanion data) {
    return DivisionsTableData(
      id: data.id.present ? data.id.value : this.id,
      leagueId: data.leagueId.present ? data.leagueId.value : this.leagueId,
      name: data.name.present ? data.name.value : this.name,
      tierIndex: data.tierIndex.present ? data.tierIndex.value : this.tierIndex,
      currentTournamentId: data.currentTournamentId.present
          ? data.currentTournamentId.value
          : this.currentTournamentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DivisionsTableData(')
          ..write('id: $id, ')
          ..write('leagueId: $leagueId, ')
          ..write('name: $name, ')
          ..write('tierIndex: $tierIndex, ')
          ..write('currentTournamentId: $currentTournamentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, leagueId, name, tierIndex, currentTournamentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DivisionsTableData &&
          other.id == this.id &&
          other.leagueId == this.leagueId &&
          other.name == this.name &&
          other.tierIndex == this.tierIndex &&
          other.currentTournamentId == this.currentTournamentId);
}

class DivisionsTableCompanion extends UpdateCompanion<DivisionsTableData> {
  final Value<int> id;
  final Value<int> leagueId;
  final Value<String> name;
  final Value<int> tierIndex;
  final Value<int?> currentTournamentId;
  const DivisionsTableCompanion({
    this.id = const Value.absent(),
    this.leagueId = const Value.absent(),
    this.name = const Value.absent(),
    this.tierIndex = const Value.absent(),
    this.currentTournamentId = const Value.absent(),
  });
  DivisionsTableCompanion.insert({
    this.id = const Value.absent(),
    required int leagueId,
    required String name,
    required int tierIndex,
    this.currentTournamentId = const Value.absent(),
  }) : leagueId = Value(leagueId),
       name = Value(name),
       tierIndex = Value(tierIndex);
  static Insertable<DivisionsTableData> custom({
    Expression<int>? id,
    Expression<int>? leagueId,
    Expression<String>? name,
    Expression<int>? tierIndex,
    Expression<int>? currentTournamentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leagueId != null) 'league_id': leagueId,
      if (name != null) 'name': name,
      if (tierIndex != null) 'tier_index': tierIndex,
      if (currentTournamentId != null)
        'current_tournament_id': currentTournamentId,
    });
  }

  DivisionsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? leagueId,
    Value<String>? name,
    Value<int>? tierIndex,
    Value<int?>? currentTournamentId,
  }) {
    return DivisionsTableCompanion(
      id: id ?? this.id,
      leagueId: leagueId ?? this.leagueId,
      name: name ?? this.name,
      tierIndex: tierIndex ?? this.tierIndex,
      currentTournamentId: currentTournamentId ?? this.currentTournamentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leagueId.present) {
      map['league_id'] = Variable<int>(leagueId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tierIndex.present) {
      map['tier_index'] = Variable<int>(tierIndex.value);
    }
    if (currentTournamentId.present) {
      map['current_tournament_id'] = Variable<int>(currentTournamentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DivisionsTableCompanion(')
          ..write('id: $id, ')
          ..write('leagueId: $leagueId, ')
          ..write('name: $name, ')
          ..write('tierIndex: $tierIndex, ')
          ..write('currentTournamentId: $currentTournamentId')
          ..write(')'))
        .toString();
  }
}

class $DivisionTeamsTableTable extends DivisionTeamsTable
    with TableInfo<$DivisionTeamsTableTable, DivisionTeamsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DivisionTeamsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _divisionIdMeta = const VerificationMeta(
    'divisionId',
  );
  @override
  late final GeneratedColumn<int> divisionId = GeneratedColumn<int>(
    'division_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES divisions_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams_table (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, divisionId, teamId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'division_teams_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DivisionTeamsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('division_id')) {
      context.handle(
        _divisionIdMeta,
        divisionId.isAcceptableOrUnknown(data['division_id']!, _divisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_divisionIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {divisionId, teamId},
  ];
  @override
  DivisionTeamsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DivisionTeamsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      divisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}division_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
    );
  }

  @override
  $DivisionTeamsTableTable createAlias(String alias) {
    return $DivisionTeamsTableTable(attachedDatabase, alias);
  }
}

class DivisionTeamsTableData extends DataClass
    implements Insertable<DivisionTeamsTableData> {
  final int id;
  final int divisionId;
  final int teamId;
  const DivisionTeamsTableData({
    required this.id,
    required this.divisionId,
    required this.teamId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['division_id'] = Variable<int>(divisionId);
    map['team_id'] = Variable<int>(teamId);
    return map;
  }

  DivisionTeamsTableCompanion toCompanion(bool nullToAbsent) {
    return DivisionTeamsTableCompanion(
      id: Value(id),
      divisionId: Value(divisionId),
      teamId: Value(teamId),
    );
  }

  factory DivisionTeamsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DivisionTeamsTableData(
      id: serializer.fromJson<int>(json['id']),
      divisionId: serializer.fromJson<int>(json['divisionId']),
      teamId: serializer.fromJson<int>(json['teamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'divisionId': serializer.toJson<int>(divisionId),
      'teamId': serializer.toJson<int>(teamId),
    };
  }

  DivisionTeamsTableData copyWith({int? id, int? divisionId, int? teamId}) =>
      DivisionTeamsTableData(
        id: id ?? this.id,
        divisionId: divisionId ?? this.divisionId,
        teamId: teamId ?? this.teamId,
      );
  DivisionTeamsTableData copyWithCompanion(DivisionTeamsTableCompanion data) {
    return DivisionTeamsTableData(
      id: data.id.present ? data.id.value : this.id,
      divisionId: data.divisionId.present
          ? data.divisionId.value
          : this.divisionId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DivisionTeamsTableData(')
          ..write('id: $id, ')
          ..write('divisionId: $divisionId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, divisionId, teamId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DivisionTeamsTableData &&
          other.id == this.id &&
          other.divisionId == this.divisionId &&
          other.teamId == this.teamId);
}

class DivisionTeamsTableCompanion
    extends UpdateCompanion<DivisionTeamsTableData> {
  final Value<int> id;
  final Value<int> divisionId;
  final Value<int> teamId;
  const DivisionTeamsTableCompanion({
    this.id = const Value.absent(),
    this.divisionId = const Value.absent(),
    this.teamId = const Value.absent(),
  });
  DivisionTeamsTableCompanion.insert({
    this.id = const Value.absent(),
    required int divisionId,
    required int teamId,
  }) : divisionId = Value(divisionId),
       teamId = Value(teamId);
  static Insertable<DivisionTeamsTableData> custom({
    Expression<int>? id,
    Expression<int>? divisionId,
    Expression<int>? teamId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (divisionId != null) 'division_id': divisionId,
      if (teamId != null) 'team_id': teamId,
    });
  }

  DivisionTeamsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? divisionId,
    Value<int>? teamId,
  }) {
    return DivisionTeamsTableCompanion(
      id: id ?? this.id,
      divisionId: divisionId ?? this.divisionId,
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (divisionId.present) {
      map['division_id'] = Variable<int>(divisionId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DivisionTeamsTableCompanion(')
          ..write('id: $id, ')
          ..write('divisionId: $divisionId, ')
          ..write('teamId: $teamId')
          ..write(')'))
        .toString();
  }
}

class $TournamentsTableTable extends TournamentsTable
    with TableInfo<$TournamentsTableTable, TournamentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leagueIdMeta = const VerificationMeta(
    'leagueId',
  );
  @override
  late final GeneratedColumn<int> leagueId = GeneratedColumn<int>(
    'league_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _divisionIdMeta = const VerificationMeta(
    'divisionId',
  );
  @override
  late final GeneratedColumn<int> divisionId = GeneratedColumn<int>(
    'division_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    format,
    status,
    configJson,
    leagueId,
    divisionId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournaments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('league_id')) {
      context.handle(
        _leagueIdMeta,
        leagueId.isAcceptableOrUnknown(data['league_id']!, _leagueIdMeta),
      );
    }
    if (data.containsKey('division_id')) {
      context.handle(
        _divisionIdMeta,
        divisionId.isAcceptableOrUnknown(data['division_id']!, _divisionIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TournamentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      leagueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}league_id'],
      ),
      divisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}division_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $TournamentsTableTable createAlias(String alias) {
    return $TournamentsTableTable(attachedDatabase, alias);
  }
}

class TournamentsTableData extends DataClass
    implements Insertable<TournamentsTableData> {
  final int id;
  final String name;
  final String format;
  final String status;
  final String configJson;
  final int? leagueId;
  final int? divisionId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const TournamentsTableData({
    required this.id,
    required this.name,
    required this.format,
    required this.status,
    required this.configJson,
    this.leagueId,
    this.divisionId,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['format'] = Variable<String>(format);
    map['status'] = Variable<String>(status);
    map['config_json'] = Variable<String>(configJson);
    if (!nullToAbsent || leagueId != null) {
      map['league_id'] = Variable<int>(leagueId);
    }
    if (!nullToAbsent || divisionId != null) {
      map['division_id'] = Variable<int>(divisionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TournamentsTableCompanion toCompanion(bool nullToAbsent) {
    return TournamentsTableCompanion(
      id: Value(id),
      name: Value(name),
      format: Value(format),
      status: Value(status),
      configJson: Value(configJson),
      leagueId: leagueId == null && nullToAbsent
          ? const Value.absent()
          : Value(leagueId),
      divisionId: divisionId == null && nullToAbsent
          ? const Value.absent()
          : Value(divisionId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TournamentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      format: serializer.fromJson<String>(json['format']),
      status: serializer.fromJson<String>(json['status']),
      configJson: serializer.fromJson<String>(json['configJson']),
      leagueId: serializer.fromJson<int?>(json['leagueId']),
      divisionId: serializer.fromJson<int?>(json['divisionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'format': serializer.toJson<String>(format),
      'status': serializer.toJson<String>(status),
      'configJson': serializer.toJson<String>(configJson),
      'leagueId': serializer.toJson<int?>(leagueId),
      'divisionId': serializer.toJson<int?>(divisionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TournamentsTableData copyWith({
    int? id,
    String? name,
    String? format,
    String? status,
    String? configJson,
    Value<int?> leagueId = const Value.absent(),
    Value<int?> divisionId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => TournamentsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    format: format ?? this.format,
    status: status ?? this.status,
    configJson: configJson ?? this.configJson,
    leagueId: leagueId.present ? leagueId.value : this.leagueId,
    divisionId: divisionId.present ? divisionId.value : this.divisionId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TournamentsTableData copyWithCompanion(TournamentsTableCompanion data) {
    return TournamentsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      format: data.format.present ? data.format.value : this.format,
      status: data.status.present ? data.status.value : this.status,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      leagueId: data.leagueId.present ? data.leagueId.value : this.leagueId,
      divisionId: data.divisionId.present
          ? data.divisionId.value
          : this.divisionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('configJson: $configJson, ')
          ..write('leagueId: $leagueId, ')
          ..write('divisionId: $divisionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    format,
    status,
    configJson,
    leagueId,
    divisionId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.format == this.format &&
          other.status == this.status &&
          other.configJson == this.configJson &&
          other.leagueId == this.leagueId &&
          other.divisionId == this.divisionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TournamentsTableCompanion extends UpdateCompanion<TournamentsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> format;
  final Value<String> status;
  final Value<String> configJson;
  final Value<int?> leagueId;
  final Value<int?> divisionId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const TournamentsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.format = const Value.absent(),
    this.status = const Value.absent(),
    this.configJson = const Value.absent(),
    this.leagueId = const Value.absent(),
    this.divisionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TournamentsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String format,
    required String status,
    required String configJson,
    this.leagueId = const Value.absent(),
    this.divisionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       format = Value(format),
       status = Value(status),
       configJson = Value(configJson);
  static Insertable<TournamentsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? format,
    Expression<String>? status,
    Expression<String>? configJson,
    Expression<int>? leagueId,
    Expression<int>? divisionId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (format != null) 'format': format,
      if (status != null) 'status': status,
      if (configJson != null) 'config_json': configJson,
      if (leagueId != null) 'league_id': leagueId,
      if (divisionId != null) 'division_id': divisionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TournamentsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? format,
    Value<String>? status,
    Value<String>? configJson,
    Value<int?>? leagueId,
    Value<int?>? divisionId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return TournamentsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      format: format ?? this.format,
      status: status ?? this.status,
      configJson: configJson ?? this.configJson,
      leagueId: leagueId ?? this.leagueId,
      divisionId: divisionId ?? this.divisionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (leagueId.present) {
      map['league_id'] = Variable<int>(leagueId.value);
    }
    if (divisionId.present) {
      map['division_id'] = Variable<int>(divisionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('configJson: $configJson, ')
          ..write('leagueId: $leagueId, ')
          ..write('divisionId: $divisionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TournamentTeamsTableTable extends TournamentTeamsTable
    with TableInfo<$TournamentTeamsTableTable, TournamentTeamsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentTeamsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<int> tournamentId = GeneratedColumn<int>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupLabelMeta = const VerificationMeta(
    'groupLabel',
  );
  @override
  late final GeneratedColumn<String> groupLabel = GeneratedColumn<String>(
    'group_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tournamentId,
    teamId,
    seed,
    groupLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_teams_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentTeamsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    }
    if (data.containsKey('group_label')) {
      context.handle(
        _groupLabelMeta,
        groupLabel.isAcceptableOrUnknown(data['group_label']!, _groupLabelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tournamentId, teamId},
  ];
  @override
  TournamentTeamsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentTeamsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tournament_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      ),
      groupLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_label'],
      ),
    );
  }

  @override
  $TournamentTeamsTableTable createAlias(String alias) {
    return $TournamentTeamsTableTable(attachedDatabase, alias);
  }
}

class TournamentTeamsTableData extends DataClass
    implements Insertable<TournamentTeamsTableData> {
  final int id;
  final int tournamentId;
  final int teamId;
  final int? seed;
  final String? groupLabel;
  const TournamentTeamsTableData({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    this.seed,
    this.groupLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tournament_id'] = Variable<int>(tournamentId);
    map['team_id'] = Variable<int>(teamId);
    if (!nullToAbsent || seed != null) {
      map['seed'] = Variable<int>(seed);
    }
    if (!nullToAbsent || groupLabel != null) {
      map['group_label'] = Variable<String>(groupLabel);
    }
    return map;
  }

  TournamentTeamsTableCompanion toCompanion(bool nullToAbsent) {
    return TournamentTeamsTableCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      teamId: Value(teamId),
      seed: seed == null && nullToAbsent ? const Value.absent() : Value(seed),
      groupLabel: groupLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(groupLabel),
    );
  }

  factory TournamentTeamsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentTeamsTableData(
      id: serializer.fromJson<int>(json['id']),
      tournamentId: serializer.fromJson<int>(json['tournamentId']),
      teamId: serializer.fromJson<int>(json['teamId']),
      seed: serializer.fromJson<int?>(json['seed']),
      groupLabel: serializer.fromJson<String?>(json['groupLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tournamentId': serializer.toJson<int>(tournamentId),
      'teamId': serializer.toJson<int>(teamId),
      'seed': serializer.toJson<int?>(seed),
      'groupLabel': serializer.toJson<String?>(groupLabel),
    };
  }

  TournamentTeamsTableData copyWith({
    int? id,
    int? tournamentId,
    int? teamId,
    Value<int?> seed = const Value.absent(),
    Value<String?> groupLabel = const Value.absent(),
  }) => TournamentTeamsTableData(
    id: id ?? this.id,
    tournamentId: tournamentId ?? this.tournamentId,
    teamId: teamId ?? this.teamId,
    seed: seed.present ? seed.value : this.seed,
    groupLabel: groupLabel.present ? groupLabel.value : this.groupLabel,
  );
  TournamentTeamsTableData copyWithCompanion(
    TournamentTeamsTableCompanion data,
  ) {
    return TournamentTeamsTableData(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      seed: data.seed.present ? data.seed.value : this.seed,
      groupLabel: data.groupLabel.present
          ? data.groupLabel.value
          : this.groupLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentTeamsTableData(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('teamId: $teamId, ')
          ..write('seed: $seed, ')
          ..write('groupLabel: $groupLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tournamentId, teamId, seed, groupLabel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentTeamsTableData &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.teamId == this.teamId &&
          other.seed == this.seed &&
          other.groupLabel == this.groupLabel);
}

class TournamentTeamsTableCompanion
    extends UpdateCompanion<TournamentTeamsTableData> {
  final Value<int> id;
  final Value<int> tournamentId;
  final Value<int> teamId;
  final Value<int?> seed;
  final Value<String?> groupLabel;
  const TournamentTeamsTableCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.seed = const Value.absent(),
    this.groupLabel = const Value.absent(),
  });
  TournamentTeamsTableCompanion.insert({
    this.id = const Value.absent(),
    required int tournamentId,
    required int teamId,
    this.seed = const Value.absent(),
    this.groupLabel = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       teamId = Value(teamId);
  static Insertable<TournamentTeamsTableData> custom({
    Expression<int>? id,
    Expression<int>? tournamentId,
    Expression<int>? teamId,
    Expression<int>? seed,
    Expression<String>? groupLabel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (teamId != null) 'team_id': teamId,
      if (seed != null) 'seed': seed,
      if (groupLabel != null) 'group_label': groupLabel,
    });
  }

  TournamentTeamsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? tournamentId,
    Value<int>? teamId,
    Value<int?>? seed,
    Value<String?>? groupLabel,
  }) {
    return TournamentTeamsTableCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamId: teamId ?? this.teamId,
      seed: seed ?? this.seed,
      groupLabel: groupLabel ?? this.groupLabel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<int>(tournamentId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (groupLabel.present) {
      map['group_label'] = Variable<String>(groupLabel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentTeamsTableCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('teamId: $teamId, ')
          ..write('seed: $seed, ')
          ..write('groupLabel: $groupLabel')
          ..write(')'))
        .toString();
  }
}

class $MatchesTableTable extends MatchesTable
    with TableInfo<$MatchesTableTable, MatchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<int> tournamentId = GeneratedColumn<int>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupLabelMeta = const VerificationMeta(
    'groupLabel',
  );
  @override
  late final GeneratedColumn<String> groupLabel = GeneratedColumn<String>(
    'group_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bracketSlotMeta = const VerificationMeta(
    'bracketSlot',
  );
  @override
  late final GeneratedColumn<int> bracketSlot = GeneratedColumn<int>(
    'bracket_slot',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeTeamIdMeta = const VerificationMeta(
    'homeTeamId',
  );
  @override
  late final GeneratedColumn<int> homeTeamId = GeneratedColumn<int>(
    'home_team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayTeamIdMeta = const VerificationMeta(
    'awayTeamId',
  );
  @override
  late final GeneratedColumn<int> awayTeamId = GeneratedColumn<int>(
    'away_team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerAdvancesToMeta = const VerificationMeta(
    'winnerAdvancesTo',
  );
  @override
  late final GeneratedColumn<int> winnerAdvancesTo = GeneratedColumn<int>(
    'winner_advances_to',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loserAdvancesToMeta = const VerificationMeta(
    'loserAdvancesTo',
  );
  @override
  late final GeneratedColumn<int> loserAdvancesTo = GeneratedColumn<int>(
    'loser_advances_to',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venueIdMeta = const VerificationMeta(
    'venueId',
  );
  @override
  late final GeneratedColumn<int> venueId = GeneratedColumn<int>(
    'venue_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesJsonMeta = const VerificationMeta(
    'seriesJson',
  );
  @override
  late final GeneratedColumn<String> seriesJson = GeneratedColumn<String>(
    'series_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tournamentId,
    round,
    stage,
    groupLabel,
    bracketSlot,
    homeTeamId,
    awayTeamId,
    homeScore,
    awayScore,
    status,
    winnerAdvancesTo,
    loserAdvancesTo,
    location,
    scheduledAt,
    durationMinutes,
    venueId,
    seriesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('group_label')) {
      context.handle(
        _groupLabelMeta,
        groupLabel.isAcceptableOrUnknown(data['group_label']!, _groupLabelMeta),
      );
    }
    if (data.containsKey('bracket_slot')) {
      context.handle(
        _bracketSlotMeta,
        bracketSlot.isAcceptableOrUnknown(
          data['bracket_slot']!,
          _bracketSlotMeta,
        ),
      );
    }
    if (data.containsKey('home_team_id')) {
      context.handle(
        _homeTeamIdMeta,
        homeTeamId.isAcceptableOrUnknown(
          data['home_team_id']!,
          _homeTeamIdMeta,
        ),
      );
    }
    if (data.containsKey('away_team_id')) {
      context.handle(
        _awayTeamIdMeta,
        awayTeamId.isAcceptableOrUnknown(
          data['away_team_id']!,
          _awayTeamIdMeta,
        ),
      );
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('winner_advances_to')) {
      context.handle(
        _winnerAdvancesToMeta,
        winnerAdvancesTo.isAcceptableOrUnknown(
          data['winner_advances_to']!,
          _winnerAdvancesToMeta,
        ),
      );
    }
    if (data.containsKey('loser_advances_to')) {
      context.handle(
        _loserAdvancesToMeta,
        loserAdvancesTo.isAcceptableOrUnknown(
          data['loser_advances_to']!,
          _loserAdvancesToMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('venue_id')) {
      context.handle(
        _venueIdMeta,
        venueId.isAcceptableOrUnknown(data['venue_id']!, _venueIdMeta),
      );
    }
    if (data.containsKey('series_json')) {
      context.handle(
        _seriesJsonMeta,
        seriesJson.isAcceptableOrUnknown(data['series_json']!, _seriesJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tournament_id'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      groupLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_label'],
      ),
      bracketSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bracket_slot'],
      ),
      homeTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_team_id'],
      ),
      awayTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_team_id'],
      ),
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      ),
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      winnerAdvancesTo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}winner_advances_to'],
      ),
      loserAdvancesTo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loser_advances_to'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      venueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venue_id'],
      ),
      seriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_json'],
      ),
    );
  }

  @override
  $MatchesTableTable createAlias(String alias) {
    return $MatchesTableTable(attachedDatabase, alias);
  }
}

class MatchesTableData extends DataClass
    implements Insertable<MatchesTableData> {
  final int id;
  final int tournamentId;
  final int round;
  final String stage;
  final String? groupLabel;
  final int? bracketSlot;
  final int? homeTeamId;
  final int? awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final int? winnerAdvancesTo;
  final int? loserAdvancesTo;
  final String? location;

  /// Kickoff datetime (local wall clock stored as UTC millis via Drift).
  final DateTime? scheduledAt;

  /// Planned match length; UI defaults to 90 when null.
  final int? durationMinutes;

  /// Soft FK to [VenuesTable] — preferred over free-text [location].
  final int? venueId;
  final String? seriesJson;
  const MatchesTableData({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.stage,
    this.groupLabel,
    this.bracketSlot,
    this.homeTeamId,
    this.awayTeamId,
    this.homeScore,
    this.awayScore,
    required this.status,
    this.winnerAdvancesTo,
    this.loserAdvancesTo,
    this.location,
    this.scheduledAt,
    this.durationMinutes,
    this.venueId,
    this.seriesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tournament_id'] = Variable<int>(tournamentId);
    map['round'] = Variable<int>(round);
    map['stage'] = Variable<String>(stage);
    if (!nullToAbsent || groupLabel != null) {
      map['group_label'] = Variable<String>(groupLabel);
    }
    if (!nullToAbsent || bracketSlot != null) {
      map['bracket_slot'] = Variable<int>(bracketSlot);
    }
    if (!nullToAbsent || homeTeamId != null) {
      map['home_team_id'] = Variable<int>(homeTeamId);
    }
    if (!nullToAbsent || awayTeamId != null) {
      map['away_team_id'] = Variable<int>(awayTeamId);
    }
    if (!nullToAbsent || homeScore != null) {
      map['home_score'] = Variable<int>(homeScore);
    }
    if (!nullToAbsent || awayScore != null) {
      map['away_score'] = Variable<int>(awayScore);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || winnerAdvancesTo != null) {
      map['winner_advances_to'] = Variable<int>(winnerAdvancesTo);
    }
    if (!nullToAbsent || loserAdvancesTo != null) {
      map['loser_advances_to'] = Variable<int>(loserAdvancesTo);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || venueId != null) {
      map['venue_id'] = Variable<int>(venueId);
    }
    if (!nullToAbsent || seriesJson != null) {
      map['series_json'] = Variable<String>(seriesJson);
    }
    return map;
  }

  MatchesTableCompanion toCompanion(bool nullToAbsent) {
    return MatchesTableCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      round: Value(round),
      stage: Value(stage),
      groupLabel: groupLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(groupLabel),
      bracketSlot: bracketSlot == null && nullToAbsent
          ? const Value.absent()
          : Value(bracketSlot),
      homeTeamId: homeTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(homeTeamId),
      awayTeamId: awayTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(awayTeamId),
      homeScore: homeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(homeScore),
      awayScore: awayScore == null && nullToAbsent
          ? const Value.absent()
          : Value(awayScore),
      status: Value(status),
      winnerAdvancesTo: winnerAdvancesTo == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerAdvancesTo),
      loserAdvancesTo: loserAdvancesTo == null && nullToAbsent
          ? const Value.absent()
          : Value(loserAdvancesTo),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      venueId: venueId == null && nullToAbsent
          ? const Value.absent()
          : Value(venueId),
      seriesJson: seriesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesJson),
    );
  }

  factory MatchesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchesTableData(
      id: serializer.fromJson<int>(json['id']),
      tournamentId: serializer.fromJson<int>(json['tournamentId']),
      round: serializer.fromJson<int>(json['round']),
      stage: serializer.fromJson<String>(json['stage']),
      groupLabel: serializer.fromJson<String?>(json['groupLabel']),
      bracketSlot: serializer.fromJson<int?>(json['bracketSlot']),
      homeTeamId: serializer.fromJson<int?>(json['homeTeamId']),
      awayTeamId: serializer.fromJson<int?>(json['awayTeamId']),
      homeScore: serializer.fromJson<int?>(json['homeScore']),
      awayScore: serializer.fromJson<int?>(json['awayScore']),
      status: serializer.fromJson<String>(json['status']),
      winnerAdvancesTo: serializer.fromJson<int?>(json['winnerAdvancesTo']),
      loserAdvancesTo: serializer.fromJson<int?>(json['loserAdvancesTo']),
      location: serializer.fromJson<String?>(json['location']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      venueId: serializer.fromJson<int?>(json['venueId']),
      seriesJson: serializer.fromJson<String?>(json['seriesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tournamentId': serializer.toJson<int>(tournamentId),
      'round': serializer.toJson<int>(round),
      'stage': serializer.toJson<String>(stage),
      'groupLabel': serializer.toJson<String?>(groupLabel),
      'bracketSlot': serializer.toJson<int?>(bracketSlot),
      'homeTeamId': serializer.toJson<int?>(homeTeamId),
      'awayTeamId': serializer.toJson<int?>(awayTeamId),
      'homeScore': serializer.toJson<int?>(homeScore),
      'awayScore': serializer.toJson<int?>(awayScore),
      'status': serializer.toJson<String>(status),
      'winnerAdvancesTo': serializer.toJson<int?>(winnerAdvancesTo),
      'loserAdvancesTo': serializer.toJson<int?>(loserAdvancesTo),
      'location': serializer.toJson<String?>(location),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'venueId': serializer.toJson<int?>(venueId),
      'seriesJson': serializer.toJson<String?>(seriesJson),
    };
  }

  MatchesTableData copyWith({
    int? id,
    int? tournamentId,
    int? round,
    String? stage,
    Value<String?> groupLabel = const Value.absent(),
    Value<int?> bracketSlot = const Value.absent(),
    Value<int?> homeTeamId = const Value.absent(),
    Value<int?> awayTeamId = const Value.absent(),
    Value<int?> homeScore = const Value.absent(),
    Value<int?> awayScore = const Value.absent(),
    String? status,
    Value<int?> winnerAdvancesTo = const Value.absent(),
    Value<int?> loserAdvancesTo = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<DateTime?> scheduledAt = const Value.absent(),
    Value<int?> durationMinutes = const Value.absent(),
    Value<int?> venueId = const Value.absent(),
    Value<String?> seriesJson = const Value.absent(),
  }) => MatchesTableData(
    id: id ?? this.id,
    tournamentId: tournamentId ?? this.tournamentId,
    round: round ?? this.round,
    stage: stage ?? this.stage,
    groupLabel: groupLabel.present ? groupLabel.value : this.groupLabel,
    bracketSlot: bracketSlot.present ? bracketSlot.value : this.bracketSlot,
    homeTeamId: homeTeamId.present ? homeTeamId.value : this.homeTeamId,
    awayTeamId: awayTeamId.present ? awayTeamId.value : this.awayTeamId,
    homeScore: homeScore.present ? homeScore.value : this.homeScore,
    awayScore: awayScore.present ? awayScore.value : this.awayScore,
    status: status ?? this.status,
    winnerAdvancesTo: winnerAdvancesTo.present
        ? winnerAdvancesTo.value
        : this.winnerAdvancesTo,
    loserAdvancesTo: loserAdvancesTo.present
        ? loserAdvancesTo.value
        : this.loserAdvancesTo,
    location: location.present ? location.value : this.location,
    scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    venueId: venueId.present ? venueId.value : this.venueId,
    seriesJson: seriesJson.present ? seriesJson.value : this.seriesJson,
  );
  MatchesTableData copyWithCompanion(MatchesTableCompanion data) {
    return MatchesTableData(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      round: data.round.present ? data.round.value : this.round,
      stage: data.stage.present ? data.stage.value : this.stage,
      groupLabel: data.groupLabel.present
          ? data.groupLabel.value
          : this.groupLabel,
      bracketSlot: data.bracketSlot.present
          ? data.bracketSlot.value
          : this.bracketSlot,
      homeTeamId: data.homeTeamId.present
          ? data.homeTeamId.value
          : this.homeTeamId,
      awayTeamId: data.awayTeamId.present
          ? data.awayTeamId.value
          : this.awayTeamId,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      status: data.status.present ? data.status.value : this.status,
      winnerAdvancesTo: data.winnerAdvancesTo.present
          ? data.winnerAdvancesTo.value
          : this.winnerAdvancesTo,
      loserAdvancesTo: data.loserAdvancesTo.present
          ? data.loserAdvancesTo.value
          : this.loserAdvancesTo,
      location: data.location.present ? data.location.value : this.location,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      venueId: data.venueId.present ? data.venueId.value : this.venueId,
      seriesJson: data.seriesJson.present
          ? data.seriesJson.value
          : this.seriesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchesTableData(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('round: $round, ')
          ..write('stage: $stage, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('bracketSlot: $bracketSlot, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('status: $status, ')
          ..write('winnerAdvancesTo: $winnerAdvancesTo, ')
          ..write('loserAdvancesTo: $loserAdvancesTo, ')
          ..write('location: $location, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('venueId: $venueId, ')
          ..write('seriesJson: $seriesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tournamentId,
    round,
    stage,
    groupLabel,
    bracketSlot,
    homeTeamId,
    awayTeamId,
    homeScore,
    awayScore,
    status,
    winnerAdvancesTo,
    loserAdvancesTo,
    location,
    scheduledAt,
    durationMinutes,
    venueId,
    seriesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchesTableData &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.round == this.round &&
          other.stage == this.stage &&
          other.groupLabel == this.groupLabel &&
          other.bracketSlot == this.bracketSlot &&
          other.homeTeamId == this.homeTeamId &&
          other.awayTeamId == this.awayTeamId &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.status == this.status &&
          other.winnerAdvancesTo == this.winnerAdvancesTo &&
          other.loserAdvancesTo == this.loserAdvancesTo &&
          other.location == this.location &&
          other.scheduledAt == this.scheduledAt &&
          other.durationMinutes == this.durationMinutes &&
          other.venueId == this.venueId &&
          other.seriesJson == this.seriesJson);
}

class MatchesTableCompanion extends UpdateCompanion<MatchesTableData> {
  final Value<int> id;
  final Value<int> tournamentId;
  final Value<int> round;
  final Value<String> stage;
  final Value<String?> groupLabel;
  final Value<int?> bracketSlot;
  final Value<int?> homeTeamId;
  final Value<int?> awayTeamId;
  final Value<int?> homeScore;
  final Value<int?> awayScore;
  final Value<String> status;
  final Value<int?> winnerAdvancesTo;
  final Value<int?> loserAdvancesTo;
  final Value<String?> location;
  final Value<DateTime?> scheduledAt;
  final Value<int?> durationMinutes;
  final Value<int?> venueId;
  final Value<String?> seriesJson;
  const MatchesTableCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.round = const Value.absent(),
    this.stage = const Value.absent(),
    this.groupLabel = const Value.absent(),
    this.bracketSlot = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.awayTeamId = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.status = const Value.absent(),
    this.winnerAdvancesTo = const Value.absent(),
    this.loserAdvancesTo = const Value.absent(),
    this.location = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.venueId = const Value.absent(),
    this.seriesJson = const Value.absent(),
  });
  MatchesTableCompanion.insert({
    this.id = const Value.absent(),
    required int tournamentId,
    required int round,
    required String stage,
    this.groupLabel = const Value.absent(),
    this.bracketSlot = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.awayTeamId = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    required String status,
    this.winnerAdvancesTo = const Value.absent(),
    this.loserAdvancesTo = const Value.absent(),
    this.location = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.venueId = const Value.absent(),
    this.seriesJson = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       round = Value(round),
       stage = Value(stage),
       status = Value(status);
  static Insertable<MatchesTableData> custom({
    Expression<int>? id,
    Expression<int>? tournamentId,
    Expression<int>? round,
    Expression<String>? stage,
    Expression<String>? groupLabel,
    Expression<int>? bracketSlot,
    Expression<int>? homeTeamId,
    Expression<int>? awayTeamId,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<String>? status,
    Expression<int>? winnerAdvancesTo,
    Expression<int>? loserAdvancesTo,
    Expression<String>? location,
    Expression<DateTime>? scheduledAt,
    Expression<int>? durationMinutes,
    Expression<int>? venueId,
    Expression<String>? seriesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (round != null) 'round': round,
      if (stage != null) 'stage': stage,
      if (groupLabel != null) 'group_label': groupLabel,
      if (bracketSlot != null) 'bracket_slot': bracketSlot,
      if (homeTeamId != null) 'home_team_id': homeTeamId,
      if (awayTeamId != null) 'away_team_id': awayTeamId,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (status != null) 'status': status,
      if (winnerAdvancesTo != null) 'winner_advances_to': winnerAdvancesTo,
      if (loserAdvancesTo != null) 'loser_advances_to': loserAdvancesTo,
      if (location != null) 'location': location,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (venueId != null) 'venue_id': venueId,
      if (seriesJson != null) 'series_json': seriesJson,
    });
  }

  MatchesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? tournamentId,
    Value<int>? round,
    Value<String>? stage,
    Value<String?>? groupLabel,
    Value<int?>? bracketSlot,
    Value<int?>? homeTeamId,
    Value<int?>? awayTeamId,
    Value<int?>? homeScore,
    Value<int?>? awayScore,
    Value<String>? status,
    Value<int?>? winnerAdvancesTo,
    Value<int?>? loserAdvancesTo,
    Value<String?>? location,
    Value<DateTime?>? scheduledAt,
    Value<int?>? durationMinutes,
    Value<int?>? venueId,
    Value<String?>? seriesJson,
  }) {
    return MatchesTableCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      round: round ?? this.round,
      stage: stage ?? this.stage,
      groupLabel: groupLabel ?? this.groupLabel,
      bracketSlot: bracketSlot ?? this.bracketSlot,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      winnerAdvancesTo: winnerAdvancesTo ?? this.winnerAdvancesTo,
      loserAdvancesTo: loserAdvancesTo ?? this.loserAdvancesTo,
      location: location ?? this.location,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      venueId: venueId ?? this.venueId,
      seriesJson: seriesJson ?? this.seriesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<int>(tournamentId.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (groupLabel.present) {
      map['group_label'] = Variable<String>(groupLabel.value);
    }
    if (bracketSlot.present) {
      map['bracket_slot'] = Variable<int>(bracketSlot.value);
    }
    if (homeTeamId.present) {
      map['home_team_id'] = Variable<int>(homeTeamId.value);
    }
    if (awayTeamId.present) {
      map['away_team_id'] = Variable<int>(awayTeamId.value);
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (winnerAdvancesTo.present) {
      map['winner_advances_to'] = Variable<int>(winnerAdvancesTo.value);
    }
    if (loserAdvancesTo.present) {
      map['loser_advances_to'] = Variable<int>(loserAdvancesTo.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (venueId.present) {
      map['venue_id'] = Variable<int>(venueId.value);
    }
    if (seriesJson.present) {
      map['series_json'] = Variable<String>(seriesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesTableCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('round: $round, ')
          ..write('stage: $stage, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('bracketSlot: $bracketSlot, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('status: $status, ')
          ..write('winnerAdvancesTo: $winnerAdvancesTo, ')
          ..write('loserAdvancesTo: $loserAdvancesTo, ')
          ..write('location: $location, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('venueId: $venueId, ')
          ..write('seriesJson: $seriesJson')
          ..write(')'))
        .toString();
  }
}

class $VenuesTableTable extends VenuesTable
    with TableInfo<$VenuesTableTable, VenuesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VenuesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mapUrlMeta = const VerificationMeta('mapUrl');
  @override
  late final GeneratedColumn<String> mapUrl = GeneratedColumn<String>(
    'map_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _layoutImagePathMeta = const VerificationMeta(
    'layoutImagePath',
  );
  @override
  late final GeneratedColumn<String> layoutImagePath = GeneratedColumn<String>(
    'layout_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentVenueIdMeta = const VerificationMeta(
    'parentVenueId',
  );
  @override
  late final GeneratedColumn<int> parentVenueId = GeneratedColumn<int>(
    'parent_venue_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    mapUrl,
    notes,
    layoutImagePath,
    parentVenueId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'venues_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VenuesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('map_url')) {
      context.handle(
        _mapUrlMeta,
        mapUrl.isAcceptableOrUnknown(data['map_url']!, _mapUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('layout_image_path')) {
      context.handle(
        _layoutImagePathMeta,
        layoutImagePath.isAcceptableOrUnknown(
          data['layout_image_path']!,
          _layoutImagePathMeta,
        ),
      );
    }
    if (data.containsKey('parent_venue_id')) {
      context.handle(
        _parentVenueIdMeta,
        parentVenueId.isAcceptableOrUnknown(
          data['parent_venue_id']!,
          _parentVenueIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VenuesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VenuesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      mapUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      layoutImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_image_path'],
      ),
      parentVenueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_venue_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VenuesTableTable createAlias(String alias) {
    return $VenuesTableTable(attachedDatabase, alias);
  }
}

class VenuesTableData extends DataClass implements Insertable<VenuesTableData> {
  final int id;
  final String name;
  final String? address;
  final String? mapUrl;
  final String? notes;

  /// Optional PNG/JPEG site map (data URL) — useful for multi-field complexes.
  final String? layoutImagePath;
  final int? parentVenueId;
  final DateTime createdAt;
  const VenuesTableData({
    required this.id,
    required this.name,
    this.address,
    this.mapUrl,
    this.notes,
    this.layoutImagePath,
    this.parentVenueId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || mapUrl != null) {
      map['map_url'] = Variable<String>(mapUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || layoutImagePath != null) {
      map['layout_image_path'] = Variable<String>(layoutImagePath);
    }
    if (!nullToAbsent || parentVenueId != null) {
      map['parent_venue_id'] = Variable<int>(parentVenueId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VenuesTableCompanion toCompanion(bool nullToAbsent) {
    return VenuesTableCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      mapUrl: mapUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mapUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      layoutImagePath: layoutImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(layoutImagePath),
      parentVenueId: parentVenueId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentVenueId),
      createdAt: Value(createdAt),
    );
  }

  factory VenuesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VenuesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      mapUrl: serializer.fromJson<String?>(json['mapUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      layoutImagePath: serializer.fromJson<String?>(json['layoutImagePath']),
      parentVenueId: serializer.fromJson<int?>(json['parentVenueId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'mapUrl': serializer.toJson<String?>(mapUrl),
      'notes': serializer.toJson<String?>(notes),
      'layoutImagePath': serializer.toJson<String?>(layoutImagePath),
      'parentVenueId': serializer.toJson<int?>(parentVenueId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VenuesTableData copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> mapUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> layoutImagePath = const Value.absent(),
    Value<int?> parentVenueId = const Value.absent(),
    DateTime? createdAt,
  }) => VenuesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    mapUrl: mapUrl.present ? mapUrl.value : this.mapUrl,
    notes: notes.present ? notes.value : this.notes,
    layoutImagePath: layoutImagePath.present
        ? layoutImagePath.value
        : this.layoutImagePath,
    parentVenueId: parentVenueId.present
        ? parentVenueId.value
        : this.parentVenueId,
    createdAt: createdAt ?? this.createdAt,
  );
  VenuesTableData copyWithCompanion(VenuesTableCompanion data) {
    return VenuesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      mapUrl: data.mapUrl.present ? data.mapUrl.value : this.mapUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      layoutImagePath: data.layoutImagePath.present
          ? data.layoutImagePath.value
          : this.layoutImagePath,
      parentVenueId: data.parentVenueId.present
          ? data.parentVenueId.value
          : this.parentVenueId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VenuesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('notes: $notes, ')
          ..write('layoutImagePath: $layoutImagePath, ')
          ..write('parentVenueId: $parentVenueId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    mapUrl,
    notes,
    layoutImagePath,
    parentVenueId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VenuesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.mapUrl == this.mapUrl &&
          other.notes == this.notes &&
          other.layoutImagePath == this.layoutImagePath &&
          other.parentVenueId == this.parentVenueId &&
          other.createdAt == this.createdAt);
}

class VenuesTableCompanion extends UpdateCompanion<VenuesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> mapUrl;
  final Value<String?> notes;
  final Value<String?> layoutImagePath;
  final Value<int?> parentVenueId;
  final Value<DateTime> createdAt;
  const VenuesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.layoutImagePath = const Value.absent(),
    this.parentVenueId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VenuesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.mapUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.layoutImagePath = const Value.absent(),
    this.parentVenueId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<VenuesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? mapUrl,
    Expression<String>? notes,
    Expression<String>? layoutImagePath,
    Expression<int>? parentVenueId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (mapUrl != null) 'map_url': mapUrl,
      if (notes != null) 'notes': notes,
      if (layoutImagePath != null) 'layout_image_path': layoutImagePath,
      if (parentVenueId != null) 'parent_venue_id': parentVenueId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VenuesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? mapUrl,
    Value<String?>? notes,
    Value<String?>? layoutImagePath,
    Value<int?>? parentVenueId,
    Value<DateTime>? createdAt,
  }) {
    return VenuesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      mapUrl: mapUrl ?? this.mapUrl,
      notes: notes ?? this.notes,
      layoutImagePath: layoutImagePath ?? this.layoutImagePath,
      parentVenueId: parentVenueId ?? this.parentVenueId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (mapUrl.present) {
      map['map_url'] = Variable<String>(mapUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (layoutImagePath.present) {
      map['layout_image_path'] = Variable<String>(layoutImagePath.value);
    }
    if (parentVenueId.present) {
      map['parent_venue_id'] = Variable<int>(parentVenueId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VenuesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('mapUrl: $mapUrl, ')
          ..write('notes: $notes, ')
          ..write('layoutImagePath: $layoutImagePath, ')
          ..write('parentVenueId: $parentVenueId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TeamsTableTable teamsTable = $TeamsTableTable(this);
  late final $TeamListsTableTable teamListsTable = $TeamListsTableTable(this);
  late final $TeamListMembersTableTable teamListMembersTable =
      $TeamListMembersTableTable(this);
  late final $LeaguesTableTable leaguesTable = $LeaguesTableTable(this);
  late final $DivisionsTableTable divisionsTable = $DivisionsTableTable(this);
  late final $DivisionTeamsTableTable divisionTeamsTable =
      $DivisionTeamsTableTable(this);
  late final $TournamentsTableTable tournamentsTable = $TournamentsTableTable(
    this,
  );
  late final $TournamentTeamsTableTable tournamentTeamsTable =
      $TournamentTeamsTableTable(this);
  late final $MatchesTableTable matchesTable = $MatchesTableTable(this);
  late final $VenuesTableTable venuesTable = $VenuesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    teamsTable,
    teamListsTable,
    teamListMembersTable,
    leaguesTable,
    divisionsTable,
    divisionTeamsTable,
    tournamentsTable,
    tournamentTeamsTable,
    matchesTable,
    venuesTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'team_lists_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('team_list_members_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('team_list_members_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'leagues_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('divisions_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'divisions_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('division_teams_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('division_teams_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tournament_teams_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tournament_teams_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('matches_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TeamsTableTableCreateCompanionBuilder =
    TeamsTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> logoPath,
      Value<int> colorArgb,
      Value<int> powerRating,
      Value<String?> homeLocation,
      Value<int?> homeVenueId,
      Value<bool> showLogoCircle,
      Value<int> titlesWon,
      Value<String> titlesJson,
      Value<int> promotionsWon,
      Value<int> relegations,
      Value<int> careerPlayed,
      Value<int> careerWon,
      Value<int> careerDrawn,
      Value<int> careerLost,
      Value<int> careerGoalsFor,
      Value<int> careerGoalsAgainst,
      Value<DateTime> createdAt,
    });
typedef $$TeamsTableTableUpdateCompanionBuilder =
    TeamsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> logoPath,
      Value<int> colorArgb,
      Value<int> powerRating,
      Value<String?> homeLocation,
      Value<int?> homeVenueId,
      Value<bool> showLogoCircle,
      Value<int> titlesWon,
      Value<String> titlesJson,
      Value<int> promotionsWon,
      Value<int> relegations,
      Value<int> careerPlayed,
      Value<int> careerWon,
      Value<int> careerDrawn,
      Value<int> careerLost,
      Value<int> careerGoalsFor,
      Value<int> careerGoalsAgainst,
      Value<DateTime> createdAt,
    });

final class $$TeamsTableTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTableTable, TeamsTableData> {
  $$TeamsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TeamListMembersTableTable,
    List<TeamListMembersTableData>
  >
  _teamListMembersTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.teamListMembersTable,
        aliasName: 'teams_table__id__team_list_members_table__team_id',
      );

  $$TeamListMembersTableTableProcessedTableManager
  get teamListMembersTableRefs {
    final manager = $$TeamListMembersTableTableTableManager(
      $_db,
      $_db.teamListMembersTable,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teamListMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DivisionTeamsTableTable,
    List<DivisionTeamsTableData>
  >
  _divisionTeamsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.divisionTeamsTable,
        aliasName: 'teams_table__id__division_teams_table__team_id',
      );

  $$DivisionTeamsTableTableProcessedTableManager get divisionTeamsTableRefs {
    final manager = $$DivisionTeamsTableTableTableManager(
      $_db,
      $_db.divisionTeamsTable,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _divisionTeamsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TournamentTeamsTableTable,
    List<TournamentTeamsTableData>
  >
  _tournamentTeamsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentTeamsTable,
        aliasName: 'teams_table__id__tournament_teams_table__team_id',
      );

  $$TournamentTeamsTableTableProcessedTableManager
  get tournamentTeamsTableRefs {
    final manager = $$TournamentTeamsTableTableTableManager(
      $_db,
      $_db.tournamentTeamsTable,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentTeamsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get powerRating => $composableBuilder(
    column: $table.powerRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeLocation => $composableBuilder(
    column: $table.homeLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeVenueId => $composableBuilder(
    column: $table.homeVenueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showLogoCircle => $composableBuilder(
    column: $table.showLogoCircle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get titlesWon => $composableBuilder(
    column: $table.titlesWon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titlesJson => $composableBuilder(
    column: $table.titlesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promotionsWon => $composableBuilder(
    column: $table.promotionsWon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relegations => $composableBuilder(
    column: $table.relegations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerPlayed => $composableBuilder(
    column: $table.careerPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerWon => $composableBuilder(
    column: $table.careerWon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerDrawn => $composableBuilder(
    column: $table.careerDrawn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerLost => $composableBuilder(
    column: $table.careerLost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerGoalsFor => $composableBuilder(
    column: $table.careerGoalsFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careerGoalsAgainst => $composableBuilder(
    column: $table.careerGoalsAgainst,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamListMembersTableRefs(
    Expression<bool> Function($$TeamListMembersTableTableFilterComposer f) f,
  ) {
    final $$TeamListMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamListMembersTable,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamListMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.teamListMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> divisionTeamsTableRefs(
    Expression<bool> Function($$DivisionTeamsTableTableFilterComposer f) f,
  ) {
    final $$DivisionTeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.divisionTeamsTable,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionTeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.divisionTeamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tournamentTeamsTableRefs(
    Expression<bool> Function($$TournamentTeamsTableTableFilterComposer f) f,
  ) {
    final $$TournamentTeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentTeamsTable,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentTeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.tournamentTeamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get powerRating => $composableBuilder(
    column: $table.powerRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeLocation => $composableBuilder(
    column: $table.homeLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeVenueId => $composableBuilder(
    column: $table.homeVenueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showLogoCircle => $composableBuilder(
    column: $table.showLogoCircle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get titlesWon => $composableBuilder(
    column: $table.titlesWon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titlesJson => $composableBuilder(
    column: $table.titlesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promotionsWon => $composableBuilder(
    column: $table.promotionsWon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relegations => $composableBuilder(
    column: $table.relegations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerPlayed => $composableBuilder(
    column: $table.careerPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerWon => $composableBuilder(
    column: $table.careerWon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerDrawn => $composableBuilder(
    column: $table.careerDrawn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerLost => $composableBuilder(
    column: $table.careerLost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerGoalsFor => $composableBuilder(
    column: $table.careerGoalsFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careerGoalsAgainst => $composableBuilder(
    column: $table.careerGoalsAgainst,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTableTable> {
  $$TeamsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<int> get powerRating => $composableBuilder(
    column: $table.powerRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeLocation => $composableBuilder(
    column: $table.homeLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeVenueId => $composableBuilder(
    column: $table.homeVenueId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showLogoCircle => $composableBuilder(
    column: $table.showLogoCircle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get titlesWon =>
      $composableBuilder(column: $table.titlesWon, builder: (column) => column);

  GeneratedColumn<String> get titlesJson => $composableBuilder(
    column: $table.titlesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get promotionsWon => $composableBuilder(
    column: $table.promotionsWon,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relegations => $composableBuilder(
    column: $table.relegations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careerPlayed => $composableBuilder(
    column: $table.careerPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careerWon =>
      $composableBuilder(column: $table.careerWon, builder: (column) => column);

  GeneratedColumn<int> get careerDrawn => $composableBuilder(
    column: $table.careerDrawn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careerLost => $composableBuilder(
    column: $table.careerLost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careerGoalsFor => $composableBuilder(
    column: $table.careerGoalsFor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careerGoalsAgainst => $composableBuilder(
    column: $table.careerGoalsAgainst,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> teamListMembersTableRefs<T extends Object>(
    Expression<T> Function($$TeamListMembersTableTableAnnotationComposer a) f,
  ) {
    final $$TeamListMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.teamListMembersTable,
          getReferencedColumn: (t) => t.teamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TeamListMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.teamListMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> divisionTeamsTableRefs<T extends Object>(
    Expression<T> Function($$DivisionTeamsTableTableAnnotationComposer a) f,
  ) {
    final $$DivisionTeamsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.divisionTeamsTable,
          getReferencedColumn: (t) => t.teamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DivisionTeamsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.divisionTeamsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> tournamentTeamsTableRefs<T extends Object>(
    Expression<T> Function($$TournamentTeamsTableTableAnnotationComposer a) f,
  ) {
    final $$TournamentTeamsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentTeamsTable,
          getReferencedColumn: (t) => t.teamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentTeamsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentTeamsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TeamsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTableTable,
          TeamsTableData,
          $$TeamsTableTableFilterComposer,
          $$TeamsTableTableOrderingComposer,
          $$TeamsTableTableAnnotationComposer,
          $$TeamsTableTableCreateCompanionBuilder,
          $$TeamsTableTableUpdateCompanionBuilder,
          (TeamsTableData, $$TeamsTableTableReferences),
          TeamsTableData,
          PrefetchHooks Function({
            bool teamListMembersTableRefs,
            bool divisionTeamsTableRefs,
            bool tournamentTeamsTableRefs,
          })
        > {
  $$TeamsTableTableTableManager(_$AppDatabase db, $TeamsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<int> powerRating = const Value.absent(),
                Value<String?> homeLocation = const Value.absent(),
                Value<int?> homeVenueId = const Value.absent(),
                Value<bool> showLogoCircle = const Value.absent(),
                Value<int> titlesWon = const Value.absent(),
                Value<String> titlesJson = const Value.absent(),
                Value<int> promotionsWon = const Value.absent(),
                Value<int> relegations = const Value.absent(),
                Value<int> careerPlayed = const Value.absent(),
                Value<int> careerWon = const Value.absent(),
                Value<int> careerDrawn = const Value.absent(),
                Value<int> careerLost = const Value.absent(),
                Value<int> careerGoalsFor = const Value.absent(),
                Value<int> careerGoalsAgainst = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamsTableCompanion(
                id: id,
                name: name,
                logoPath: logoPath,
                colorArgb: colorArgb,
                powerRating: powerRating,
                homeLocation: homeLocation,
                homeVenueId: homeVenueId,
                showLogoCircle: showLogoCircle,
                titlesWon: titlesWon,
                titlesJson: titlesJson,
                promotionsWon: promotionsWon,
                relegations: relegations,
                careerPlayed: careerPlayed,
                careerWon: careerWon,
                careerDrawn: careerDrawn,
                careerLost: careerLost,
                careerGoalsFor: careerGoalsFor,
                careerGoalsAgainst: careerGoalsAgainst,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> logoPath = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<int> powerRating = const Value.absent(),
                Value<String?> homeLocation = const Value.absent(),
                Value<int?> homeVenueId = const Value.absent(),
                Value<bool> showLogoCircle = const Value.absent(),
                Value<int> titlesWon = const Value.absent(),
                Value<String> titlesJson = const Value.absent(),
                Value<int> promotionsWon = const Value.absent(),
                Value<int> relegations = const Value.absent(),
                Value<int> careerPlayed = const Value.absent(),
                Value<int> careerWon = const Value.absent(),
                Value<int> careerDrawn = const Value.absent(),
                Value<int> careerLost = const Value.absent(),
                Value<int> careerGoalsFor = const Value.absent(),
                Value<int> careerGoalsAgainst = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamsTableCompanion.insert(
                id: id,
                name: name,
                logoPath: logoPath,
                colorArgb: colorArgb,
                powerRating: powerRating,
                homeLocation: homeLocation,
                homeVenueId: homeVenueId,
                showLogoCircle: showLogoCircle,
                titlesWon: titlesWon,
                titlesJson: titlesJson,
                promotionsWon: promotionsWon,
                relegations: relegations,
                careerPlayed: careerPlayed,
                careerWon: careerWon,
                careerDrawn: careerDrawn,
                careerLost: careerLost,
                careerGoalsFor: careerGoalsFor,
                careerGoalsAgainst: careerGoalsAgainst,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                teamListMembersTableRefs = false,
                divisionTeamsTableRefs = false,
                tournamentTeamsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (teamListMembersTableRefs) db.teamListMembersTable,
                    if (divisionTeamsTableRefs) db.divisionTeamsTable,
                    if (tournamentTeamsTableRefs) db.tournamentTeamsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (teamListMembersTableRefs)
                        await $_getPrefetchedData<
                          TeamsTableData,
                          $TeamsTableTable,
                          TeamListMembersTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableTableReferences
                              ._teamListMembersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).teamListMembersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (divisionTeamsTableRefs)
                        await $_getPrefetchedData<
                          TeamsTableData,
                          $TeamsTableTable,
                          DivisionTeamsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableTableReferences
                              ._divisionTeamsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).divisionTeamsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tournamentTeamsTableRefs)
                        await $_getPrefetchedData<
                          TeamsTableData,
                          $TeamsTableTable,
                          TournamentTeamsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableTableReferences
                              ._tournamentTeamsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentTeamsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TeamsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTableTable,
      TeamsTableData,
      $$TeamsTableTableFilterComposer,
      $$TeamsTableTableOrderingComposer,
      $$TeamsTableTableAnnotationComposer,
      $$TeamsTableTableCreateCompanionBuilder,
      $$TeamsTableTableUpdateCompanionBuilder,
      (TeamsTableData, $$TeamsTableTableReferences),
      TeamsTableData,
      PrefetchHooks Function({
        bool teamListMembersTableRefs,
        bool divisionTeamsTableRefs,
        bool tournamentTeamsTableRefs,
      })
    >;
typedef $$TeamListsTableTableCreateCompanionBuilder =
    TeamListsTableCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$TeamListsTableTableUpdateCompanionBuilder =
    TeamListsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$TeamListsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TeamListsTableTable,
          TeamListsTableData
        > {
  $$TeamListsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TeamListMembersTableTable,
    List<TeamListMembersTableData>
  >
  _teamListMembersTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.teamListMembersTable,
        aliasName: 'team_lists_table__id__team_list_members_table__list_id',
      );

  $$TeamListMembersTableTableProcessedTableManager
  get teamListMembersTableRefs {
    final manager = $$TeamListMembersTableTableTableManager(
      $_db,
      $_db.teamListMembersTable,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teamListMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamListsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeamListsTableTable> {
  $$TeamListsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamListMembersTableRefs(
    Expression<bool> Function($$TeamListMembersTableTableFilterComposer f) f,
  ) {
    final $$TeamListMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamListMembersTable,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamListMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.teamListMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamListsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamListsTableTable> {
  $$TeamListsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamListsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamListsTableTable> {
  $$TeamListsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> teamListMembersTableRefs<T extends Object>(
    Expression<T> Function($$TeamListMembersTableTableAnnotationComposer a) f,
  ) {
    final $$TeamListMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.teamListMembersTable,
          getReferencedColumn: (t) => t.listId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TeamListMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.teamListMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TeamListsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamListsTableTable,
          TeamListsTableData,
          $$TeamListsTableTableFilterComposer,
          $$TeamListsTableTableOrderingComposer,
          $$TeamListsTableTableAnnotationComposer,
          $$TeamListsTableTableCreateCompanionBuilder,
          $$TeamListsTableTableUpdateCompanionBuilder,
          (TeamListsTableData, $$TeamListsTableTableReferences),
          TeamListsTableData,
          PrefetchHooks Function({bool teamListMembersTableRefs})
        > {
  $$TeamListsTableTableTableManager(
    _$AppDatabase db,
    $TeamListsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamListsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamListsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamListsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamListsTableCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TeamListsTableCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamListsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamListMembersTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (teamListMembersTableRefs) db.teamListMembersTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamListMembersTableRefs)
                    await $_getPrefetchedData<
                      TeamListsTableData,
                      $TeamListsTableTable,
                      TeamListMembersTableData
                    >(
                      currentTable: table,
                      referencedTable: $$TeamListsTableTableReferences
                          ._teamListMembersTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TeamListsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).teamListMembersTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TeamListsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamListsTableTable,
      TeamListsTableData,
      $$TeamListsTableTableFilterComposer,
      $$TeamListsTableTableOrderingComposer,
      $$TeamListsTableTableAnnotationComposer,
      $$TeamListsTableTableCreateCompanionBuilder,
      $$TeamListsTableTableUpdateCompanionBuilder,
      (TeamListsTableData, $$TeamListsTableTableReferences),
      TeamListsTableData,
      PrefetchHooks Function({bool teamListMembersTableRefs})
    >;
typedef $$TeamListMembersTableTableCreateCompanionBuilder =
    TeamListMembersTableCompanion Function({
      Value<int> id,
      required int listId,
      required int teamId,
    });
typedef $$TeamListMembersTableTableUpdateCompanionBuilder =
    TeamListMembersTableCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<int> teamId,
    });

final class $$TeamListMembersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TeamListMembersTableTable,
          TeamListMembersTableData
        > {
  $$TeamListMembersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TeamListsTableTable _listIdTable(_$AppDatabase db) => db
      .teamListsTable
      .createAlias('team_list_members_table__list_id__team_lists_table__id');

  $$TeamListsTableTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$TeamListsTableTableTableManager(
      $_db,
      $_db.teamListsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTableTable _teamIdTable(_$AppDatabase db) => db.teamsTable
      .createAlias('team_list_members_table__team_id__teams_table__id');

  $$TeamsTableTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableTableManager(
      $_db,
      $_db.teamsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamListMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeamListMembersTableTable> {
  $$TeamListMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamListsTableTableFilterComposer get listId {
    final $$TeamListsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.teamListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamListsTableTableFilterComposer(
            $db: $db,
            $table: $db.teamListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableFilterComposer get teamId {
    final $$TeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamListMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamListMembersTableTable> {
  $$TeamListMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamListsTableTableOrderingComposer get listId {
    final $$TeamListsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.teamListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamListsTableTableOrderingComposer(
            $db: $db,
            $table: $db.teamListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableOrderingComposer get teamId {
    final $$TeamsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableOrderingComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamListMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamListMembersTableTable> {
  $$TeamListMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$TeamListsTableTableAnnotationComposer get listId {
    final $$TeamListsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.teamListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamListsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.teamListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableAnnotationComposer get teamId {
    final $$TeamsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamListMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamListMembersTableTable,
          TeamListMembersTableData,
          $$TeamListMembersTableTableFilterComposer,
          $$TeamListMembersTableTableOrderingComposer,
          $$TeamListMembersTableTableAnnotationComposer,
          $$TeamListMembersTableTableCreateCompanionBuilder,
          $$TeamListMembersTableTableUpdateCompanionBuilder,
          (TeamListMembersTableData, $$TeamListMembersTableTableReferences),
          TeamListMembersTableData,
          PrefetchHooks Function({bool listId, bool teamId})
        > {
  $$TeamListMembersTableTableTableManager(
    _$AppDatabase db,
    $TeamListMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamListMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamListMembersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TeamListMembersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
              }) => TeamListMembersTableCompanion(
                id: id,
                listId: listId,
                teamId: teamId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                required int teamId,
              }) => TeamListMembersTableCompanion.insert(
                id: id,
                listId: listId,
                teamId: teamId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamListMembersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, teamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable:
                                    $$TeamListMembersTableTableReferences
                                        ._listIdTable(db),
                                referencedColumn:
                                    $$TeamListMembersTableTableReferences
                                        ._listIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable:
                                    $$TeamListMembersTableTableReferences
                                        ._teamIdTable(db),
                                referencedColumn:
                                    $$TeamListMembersTableTableReferences
                                        ._teamIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeamListMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamListMembersTableTable,
      TeamListMembersTableData,
      $$TeamListMembersTableTableFilterComposer,
      $$TeamListMembersTableTableOrderingComposer,
      $$TeamListMembersTableTableAnnotationComposer,
      $$TeamListMembersTableTableCreateCompanionBuilder,
      $$TeamListMembersTableTableUpdateCompanionBuilder,
      (TeamListMembersTableData, $$TeamListMembersTableTableReferences),
      TeamListMembersTableData,
      PrefetchHooks Function({bool listId, bool teamId})
    >;
typedef $$LeaguesTableTableCreateCompanionBuilder =
    LeaguesTableCompanion Function({
      Value<int> id,
      required String name,
      required String status,
      Value<String> format,
      Value<String> configJson,
      Value<int> promoteCount,
      Value<int> relegateCount,
      Value<bool> promoRelegEnabled,
      Value<int> pointsForWin,
      Value<int> pointsForDraw,
      Value<int> meetingsPerPair,
      Value<int> seasonNumber,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$LeaguesTableTableUpdateCompanionBuilder =
    LeaguesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> status,
      Value<String> format,
      Value<String> configJson,
      Value<int> promoteCount,
      Value<int> relegateCount,
      Value<bool> promoRelegEnabled,
      Value<int> pointsForWin,
      Value<int> pointsForDraw,
      Value<int> meetingsPerPair,
      Value<int> seasonNumber,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$LeaguesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $LeaguesTableTable, LeaguesTableData> {
  $$LeaguesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DivisionsTableTable, List<DivisionsTableData>>
  _divisionsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.divisionsTable,
    aliasName: 'leagues_table__id__divisions_table__league_id',
  );

  $$DivisionsTableTableProcessedTableManager get divisionsTableRefs {
    final manager = $$DivisionsTableTableTableManager(
      $_db,
      $_db.divisionsTable,
    ).filter((f) => f.leagueId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_divisionsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeaguesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaguesTableTable> {
  $$LeaguesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promoteCount => $composableBuilder(
    column: $table.promoteCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relegateCount => $composableBuilder(
    column: $table.relegateCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get promoRelegEnabled => $composableBuilder(
    column: $table.promoRelegEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsForWin => $composableBuilder(
    column: $table.pointsForWin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsForDraw => $composableBuilder(
    column: $table.pointsForDraw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meetingsPerPair => $composableBuilder(
    column: $table.meetingsPerPair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> divisionsTableRefs(
    Expression<bool> Function($$DivisionsTableTableFilterComposer f) f,
  ) {
    final $$DivisionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.divisionsTable,
      getReferencedColumn: (t) => t.leagueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableTableFilterComposer(
            $db: $db,
            $table: $db.divisionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaguesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaguesTableTable> {
  $$LeaguesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promoteCount => $composableBuilder(
    column: $table.promoteCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relegateCount => $composableBuilder(
    column: $table.relegateCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get promoRelegEnabled => $composableBuilder(
    column: $table.promoRelegEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsForWin => $composableBuilder(
    column: $table.pointsForWin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsForDraw => $composableBuilder(
    column: $table.pointsForDraw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meetingsPerPair => $composableBuilder(
    column: $table.meetingsPerPair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaguesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaguesTableTable> {
  $$LeaguesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get promoteCount => $composableBuilder(
    column: $table.promoteCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relegateCount => $composableBuilder(
    column: $table.relegateCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get promoRelegEnabled => $composableBuilder(
    column: $table.promoRelegEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsForWin => $composableBuilder(
    column: $table.pointsForWin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsForDraw => $composableBuilder(
    column: $table.pointsForDraw,
    builder: (column) => column,
  );

  GeneratedColumn<int> get meetingsPerPair => $composableBuilder(
    column: $table.meetingsPerPair,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> divisionsTableRefs<T extends Object>(
    Expression<T> Function($$DivisionsTableTableAnnotationComposer a) f,
  ) {
    final $$DivisionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.divisionsTable,
      getReferencedColumn: (t) => t.leagueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.divisionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaguesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaguesTableTable,
          LeaguesTableData,
          $$LeaguesTableTableFilterComposer,
          $$LeaguesTableTableOrderingComposer,
          $$LeaguesTableTableAnnotationComposer,
          $$LeaguesTableTableCreateCompanionBuilder,
          $$LeaguesTableTableUpdateCompanionBuilder,
          (LeaguesTableData, $$LeaguesTableTableReferences),
          LeaguesTableData,
          PrefetchHooks Function({bool divisionsTableRefs})
        > {
  $$LeaguesTableTableTableManager(_$AppDatabase db, $LeaguesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaguesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaguesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaguesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> promoteCount = const Value.absent(),
                Value<int> relegateCount = const Value.absent(),
                Value<bool> promoRelegEnabled = const Value.absent(),
                Value<int> pointsForWin = const Value.absent(),
                Value<int> pointsForDraw = const Value.absent(),
                Value<int> meetingsPerPair = const Value.absent(),
                Value<int> seasonNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => LeaguesTableCompanion(
                id: id,
                name: name,
                status: status,
                format: format,
                configJson: configJson,
                promoteCount: promoteCount,
                relegateCount: relegateCount,
                promoRelegEnabled: promoRelegEnabled,
                pointsForWin: pointsForWin,
                pointsForDraw: pointsForDraw,
                meetingsPerPair: meetingsPerPair,
                seasonNumber: seasonNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String status,
                Value<String> format = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> promoteCount = const Value.absent(),
                Value<int> relegateCount = const Value.absent(),
                Value<bool> promoRelegEnabled = const Value.absent(),
                Value<int> pointsForWin = const Value.absent(),
                Value<int> pointsForDraw = const Value.absent(),
                Value<int> meetingsPerPair = const Value.absent(),
                Value<int> seasonNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => LeaguesTableCompanion.insert(
                id: id,
                name: name,
                status: status,
                format: format,
                configJson: configJson,
                promoteCount: promoteCount,
                relegateCount: relegateCount,
                promoRelegEnabled: promoRelegEnabled,
                pointsForWin: pointsForWin,
                pointsForDraw: pointsForDraw,
                meetingsPerPair: meetingsPerPair,
                seasonNumber: seasonNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LeaguesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({divisionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (divisionsTableRefs) db.divisionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (divisionsTableRefs)
                    await $_getPrefetchedData<
                      LeaguesTableData,
                      $LeaguesTableTable,
                      DivisionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$LeaguesTableTableReferences
                          ._divisionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LeaguesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).divisionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.leagueId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LeaguesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaguesTableTable,
      LeaguesTableData,
      $$LeaguesTableTableFilterComposer,
      $$LeaguesTableTableOrderingComposer,
      $$LeaguesTableTableAnnotationComposer,
      $$LeaguesTableTableCreateCompanionBuilder,
      $$LeaguesTableTableUpdateCompanionBuilder,
      (LeaguesTableData, $$LeaguesTableTableReferences),
      LeaguesTableData,
      PrefetchHooks Function({bool divisionsTableRefs})
    >;
typedef $$DivisionsTableTableCreateCompanionBuilder =
    DivisionsTableCompanion Function({
      Value<int> id,
      required int leagueId,
      required String name,
      required int tierIndex,
      Value<int?> currentTournamentId,
    });
typedef $$DivisionsTableTableUpdateCompanionBuilder =
    DivisionsTableCompanion Function({
      Value<int> id,
      Value<int> leagueId,
      Value<String> name,
      Value<int> tierIndex,
      Value<int?> currentTournamentId,
    });

final class $$DivisionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DivisionsTableTable,
          DivisionsTableData
        > {
  $$DivisionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LeaguesTableTable _leagueIdTable(_$AppDatabase db) => db.leaguesTable
      .createAlias('divisions_table__league_id__leagues_table__id');

  $$LeaguesTableTableProcessedTableManager get leagueId {
    final $_column = $_itemColumn<int>('league_id')!;

    final manager = $$LeaguesTableTableTableManager(
      $_db,
      $_db.leaguesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leagueIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DivisionTeamsTableTable,
    List<DivisionTeamsTableData>
  >
  _divisionTeamsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.divisionTeamsTable,
        aliasName: 'divisions_table__id__division_teams_table__division_id',
      );

  $$DivisionTeamsTableTableProcessedTableManager get divisionTeamsTableRefs {
    final manager = $$DivisionTeamsTableTableTableManager(
      $_db,
      $_db.divisionTeamsTable,
    ).filter((f) => f.divisionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _divisionTeamsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DivisionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DivisionsTableTable> {
  $$DivisionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tierIndex => $composableBuilder(
    column: $table.tierIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentTournamentId => $composableBuilder(
    column: $table.currentTournamentId,
    builder: (column) => ColumnFilters(column),
  );

  $$LeaguesTableTableFilterComposer get leagueId {
    final $$LeaguesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leagueId,
      referencedTable: $db.leaguesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaguesTableTableFilterComposer(
            $db: $db,
            $table: $db.leaguesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> divisionTeamsTableRefs(
    Expression<bool> Function($$DivisionTeamsTableTableFilterComposer f) f,
  ) {
    final $$DivisionTeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.divisionTeamsTable,
      getReferencedColumn: (t) => t.divisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionTeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.divisionTeamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DivisionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DivisionsTableTable> {
  $$DivisionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tierIndex => $composableBuilder(
    column: $table.tierIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentTournamentId => $composableBuilder(
    column: $table.currentTournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeaguesTableTableOrderingComposer get leagueId {
    final $$LeaguesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leagueId,
      referencedTable: $db.leaguesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaguesTableTableOrderingComposer(
            $db: $db,
            $table: $db.leaguesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DivisionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DivisionsTableTable> {
  $$DivisionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get tierIndex =>
      $composableBuilder(column: $table.tierIndex, builder: (column) => column);

  GeneratedColumn<int> get currentTournamentId => $composableBuilder(
    column: $table.currentTournamentId,
    builder: (column) => column,
  );

  $$LeaguesTableTableAnnotationComposer get leagueId {
    final $$LeaguesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leagueId,
      referencedTable: $db.leaguesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaguesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.leaguesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> divisionTeamsTableRefs<T extends Object>(
    Expression<T> Function($$DivisionTeamsTableTableAnnotationComposer a) f,
  ) {
    final $$DivisionTeamsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.divisionTeamsTable,
          getReferencedColumn: (t) => t.divisionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DivisionTeamsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.divisionTeamsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DivisionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DivisionsTableTable,
          DivisionsTableData,
          $$DivisionsTableTableFilterComposer,
          $$DivisionsTableTableOrderingComposer,
          $$DivisionsTableTableAnnotationComposer,
          $$DivisionsTableTableCreateCompanionBuilder,
          $$DivisionsTableTableUpdateCompanionBuilder,
          (DivisionsTableData, $$DivisionsTableTableReferences),
          DivisionsTableData,
          PrefetchHooks Function({bool leagueId, bool divisionTeamsTableRefs})
        > {
  $$DivisionsTableTableTableManager(
    _$AppDatabase db,
    $DivisionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DivisionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DivisionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DivisionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> leagueId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> tierIndex = const Value.absent(),
                Value<int?> currentTournamentId = const Value.absent(),
              }) => DivisionsTableCompanion(
                id: id,
                leagueId: leagueId,
                name: name,
                tierIndex: tierIndex,
                currentTournamentId: currentTournamentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int leagueId,
                required String name,
                required int tierIndex,
                Value<int?> currentTournamentId = const Value.absent(),
              }) => DivisionsTableCompanion.insert(
                id: id,
                leagueId: leagueId,
                name: name,
                tierIndex: tierIndex,
                currentTournamentId: currentTournamentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DivisionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({leagueId = false, divisionTeamsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (divisionTeamsTableRefs) db.divisionTeamsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (leagueId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.leagueId,
                                    referencedTable:
                                        $$DivisionsTableTableReferences
                                            ._leagueIdTable(db),
                                    referencedColumn:
                                        $$DivisionsTableTableReferences
                                            ._leagueIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (divisionTeamsTableRefs)
                        await $_getPrefetchedData<
                          DivisionsTableData,
                          $DivisionsTableTable,
                          DivisionTeamsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$DivisionsTableTableReferences
                              ._divisionTeamsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DivisionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).divisionTeamsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.divisionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DivisionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DivisionsTableTable,
      DivisionsTableData,
      $$DivisionsTableTableFilterComposer,
      $$DivisionsTableTableOrderingComposer,
      $$DivisionsTableTableAnnotationComposer,
      $$DivisionsTableTableCreateCompanionBuilder,
      $$DivisionsTableTableUpdateCompanionBuilder,
      (DivisionsTableData, $$DivisionsTableTableReferences),
      DivisionsTableData,
      PrefetchHooks Function({bool leagueId, bool divisionTeamsTableRefs})
    >;
typedef $$DivisionTeamsTableTableCreateCompanionBuilder =
    DivisionTeamsTableCompanion Function({
      Value<int> id,
      required int divisionId,
      required int teamId,
    });
typedef $$DivisionTeamsTableTableUpdateCompanionBuilder =
    DivisionTeamsTableCompanion Function({
      Value<int> id,
      Value<int> divisionId,
      Value<int> teamId,
    });

final class $$DivisionTeamsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DivisionTeamsTableTable,
          DivisionTeamsTableData
        > {
  $$DivisionTeamsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DivisionsTableTable _divisionIdTable(_$AppDatabase db) => db
      .divisionsTable
      .createAlias('division_teams_table__division_id__divisions_table__id');

  $$DivisionsTableTableProcessedTableManager get divisionId {
    final $_column = $_itemColumn<int>('division_id')!;

    final manager = $$DivisionsTableTableTableManager(
      $_db,
      $_db.divisionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_divisionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTableTable _teamIdTable(_$AppDatabase db) => db.teamsTable
      .createAlias('division_teams_table__team_id__teams_table__id');

  $$TeamsTableTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableTableManager(
      $_db,
      $_db.teamsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DivisionTeamsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DivisionTeamsTableTable> {
  $$DivisionTeamsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$DivisionsTableTableFilterComposer get divisionId {
    final $$DivisionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableTableFilterComposer(
            $db: $db,
            $table: $db.divisionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableFilterComposer get teamId {
    final $$TeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DivisionTeamsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DivisionTeamsTableTable> {
  $$DivisionTeamsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$DivisionsTableTableOrderingComposer get divisionId {
    final $$DivisionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.divisionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableOrderingComposer get teamId {
    final $$TeamsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableOrderingComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DivisionTeamsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DivisionTeamsTableTable> {
  $$DivisionTeamsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$DivisionsTableTableAnnotationComposer get divisionId {
    final $$DivisionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.divisionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableAnnotationComposer get teamId {
    final $$TeamsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DivisionTeamsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DivisionTeamsTableTable,
          DivisionTeamsTableData,
          $$DivisionTeamsTableTableFilterComposer,
          $$DivisionTeamsTableTableOrderingComposer,
          $$DivisionTeamsTableTableAnnotationComposer,
          $$DivisionTeamsTableTableCreateCompanionBuilder,
          $$DivisionTeamsTableTableUpdateCompanionBuilder,
          (DivisionTeamsTableData, $$DivisionTeamsTableTableReferences),
          DivisionTeamsTableData,
          PrefetchHooks Function({bool divisionId, bool teamId})
        > {
  $$DivisionTeamsTableTableTableManager(
    _$AppDatabase db,
    $DivisionTeamsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DivisionTeamsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DivisionTeamsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DivisionTeamsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> divisionId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
              }) => DivisionTeamsTableCompanion(
                id: id,
                divisionId: divisionId,
                teamId: teamId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int divisionId,
                required int teamId,
              }) => DivisionTeamsTableCompanion.insert(
                id: id,
                divisionId: divisionId,
                teamId: teamId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DivisionTeamsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({divisionId = false, teamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (divisionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.divisionId,
                                referencedTable:
                                    $$DivisionTeamsTableTableReferences
                                        ._divisionIdTable(db),
                                referencedColumn:
                                    $$DivisionTeamsTableTableReferences
                                        ._divisionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable:
                                    $$DivisionTeamsTableTableReferences
                                        ._teamIdTable(db),
                                referencedColumn:
                                    $$DivisionTeamsTableTableReferences
                                        ._teamIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DivisionTeamsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DivisionTeamsTableTable,
      DivisionTeamsTableData,
      $$DivisionTeamsTableTableFilterComposer,
      $$DivisionTeamsTableTableOrderingComposer,
      $$DivisionTeamsTableTableAnnotationComposer,
      $$DivisionTeamsTableTableCreateCompanionBuilder,
      $$DivisionTeamsTableTableUpdateCompanionBuilder,
      (DivisionTeamsTableData, $$DivisionTeamsTableTableReferences),
      DivisionTeamsTableData,
      PrefetchHooks Function({bool divisionId, bool teamId})
    >;
typedef $$TournamentsTableTableCreateCompanionBuilder =
    TournamentsTableCompanion Function({
      Value<int> id,
      required String name,
      required String format,
      required String status,
      required String configJson,
      Value<int?> leagueId,
      Value<int?> divisionId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$TournamentsTableTableUpdateCompanionBuilder =
    TournamentsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> format,
      Value<String> status,
      Value<String> configJson,
      Value<int?> leagueId,
      Value<int?> divisionId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$TournamentsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentsTableTable,
          TournamentsTableData
        > {
  $$TournamentsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TournamentTeamsTableTable,
    List<TournamentTeamsTableData>
  >
  _tournamentTeamsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentTeamsTable,
        aliasName:
            'tournaments_table__id__tournament_teams_table__tournament_id',
      );

  $$TournamentTeamsTableTableProcessedTableManager
  get tournamentTeamsTableRefs {
    final manager = $$TournamentTeamsTableTableTableManager(
      $_db,
      $_db.tournamentTeamsTable,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentTeamsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchesTableTable, List<MatchesTableData>>
  _matchesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchesTable,
    aliasName: 'tournaments_table__id__matches_table__tournament_id',
  );

  $$MatchesTableTableProcessedTableManager get matchesTableRefs {
    final manager = $$MatchesTableTableTableManager(
      $_db,
      $_db.matchesTable,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TournamentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentsTableTable> {
  $$TournamentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leagueId => $composableBuilder(
    column: $table.leagueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get divisionId => $composableBuilder(
    column: $table.divisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tournamentTeamsTableRefs(
    Expression<bool> Function($$TournamentTeamsTableTableFilterComposer f) f,
  ) {
    final $$TournamentTeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentTeamsTable,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentTeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.tournamentTeamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchesTableRefs(
    Expression<bool> Function($$MatchesTableTableFilterComposer f) f,
  ) {
    final $$MatchesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchesTable,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableTableFilterComposer(
            $db: $db,
            $table: $db.matchesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TournamentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentsTableTable> {
  $$TournamentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leagueId => $composableBuilder(
    column: $table.leagueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get divisionId => $composableBuilder(
    column: $table.divisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TournamentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentsTableTable> {
  $$TournamentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leagueId =>
      $composableBuilder(column: $table.leagueId, builder: (column) => column);

  GeneratedColumn<int> get divisionId => $composableBuilder(
    column: $table.divisionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> tournamentTeamsTableRefs<T extends Object>(
    Expression<T> Function($$TournamentTeamsTableTableAnnotationComposer a) f,
  ) {
    final $$TournamentTeamsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentTeamsTable,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentTeamsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentTeamsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> matchesTableRefs<T extends Object>(
    Expression<T> Function($$MatchesTableTableAnnotationComposer a) f,
  ) {
    final $$MatchesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchesTable,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.matchesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TournamentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentsTableTable,
          TournamentsTableData,
          $$TournamentsTableTableFilterComposer,
          $$TournamentsTableTableOrderingComposer,
          $$TournamentsTableTableAnnotationComposer,
          $$TournamentsTableTableCreateCompanionBuilder,
          $$TournamentsTableTableUpdateCompanionBuilder,
          (TournamentsTableData, $$TournamentsTableTableReferences),
          TournamentsTableData,
          PrefetchHooks Function({
            bool tournamentTeamsTableRefs,
            bool matchesTableRefs,
          })
        > {
  $$TournamentsTableTableTableManager(
    _$AppDatabase db,
    $TournamentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int?> leagueId = const Value.absent(),
                Value<int?> divisionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TournamentsTableCompanion(
                id: id,
                name: name,
                format: format,
                status: status,
                configJson: configJson,
                leagueId: leagueId,
                divisionId: divisionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String format,
                required String status,
                required String configJson,
                Value<int?> leagueId = const Value.absent(),
                Value<int?> divisionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TournamentsTableCompanion.insert(
                id: id,
                name: name,
                format: format,
                status: status,
                configJson: configJson,
                leagueId: leagueId,
                divisionId: divisionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tournamentTeamsTableRefs = false, matchesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tournamentTeamsTableRefs) db.tournamentTeamsTable,
                    if (matchesTableRefs) db.matchesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tournamentTeamsTableRefs)
                        await $_getPrefetchedData<
                          TournamentsTableData,
                          $TournamentsTableTable,
                          TournamentTeamsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableTableReferences
                              ._tournamentTeamsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentTeamsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchesTableRefs)
                        await $_getPrefetchedData<
                          TournamentsTableData,
                          $TournamentsTableTable,
                          MatchesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableTableReferences
                              ._matchesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).matchesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TournamentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentsTableTable,
      TournamentsTableData,
      $$TournamentsTableTableFilterComposer,
      $$TournamentsTableTableOrderingComposer,
      $$TournamentsTableTableAnnotationComposer,
      $$TournamentsTableTableCreateCompanionBuilder,
      $$TournamentsTableTableUpdateCompanionBuilder,
      (TournamentsTableData, $$TournamentsTableTableReferences),
      TournamentsTableData,
      PrefetchHooks Function({
        bool tournamentTeamsTableRefs,
        bool matchesTableRefs,
      })
    >;
typedef $$TournamentTeamsTableTableCreateCompanionBuilder =
    TournamentTeamsTableCompanion Function({
      Value<int> id,
      required int tournamentId,
      required int teamId,
      Value<int?> seed,
      Value<String?> groupLabel,
    });
typedef $$TournamentTeamsTableTableUpdateCompanionBuilder =
    TournamentTeamsTableCompanion Function({
      Value<int> id,
      Value<int> tournamentId,
      Value<int> teamId,
      Value<int?> seed,
      Value<String?> groupLabel,
    });

final class $$TournamentTeamsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentTeamsTableTable,
          TournamentTeamsTableData
        > {
  $$TournamentTeamsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentsTableTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournamentsTable.createAlias(
        'tournament_teams_table__tournament_id__tournaments_table__id',
      );

  $$TournamentsTableTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<int>('tournament_id')!;

    final manager = $$TournamentsTableTableTableManager(
      $_db,
      $_db.tournamentsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTableTable _teamIdTable(_$AppDatabase db) => db.teamsTable
      .createAlias('tournament_teams_table__team_id__teams_table__id');

  $$TeamsTableTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableTableManager(
      $_db,
      $_db.teamsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TournamentTeamsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentTeamsTableTable> {
  $$TournamentTeamsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableTableFilterComposer get tournamentId {
    final $$TournamentsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableFilterComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableFilterComposer get teamId {
    final $$TeamsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableFilterComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentTeamsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentTeamsTableTable> {
  $$TournamentTeamsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableTableOrderingComposer get tournamentId {
    final $$TournamentsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableOrderingComposer get teamId {
    final $$TeamsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableOrderingComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentTeamsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentTeamsTableTable> {
  $$TournamentTeamsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => column,
  );

  $$TournamentsTableTableAnnotationComposer get tournamentId {
    final $$TournamentsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableTableAnnotationComposer get teamId {
    final $$TeamsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teamsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.teamsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentTeamsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentTeamsTableTable,
          TournamentTeamsTableData,
          $$TournamentTeamsTableTableFilterComposer,
          $$TournamentTeamsTableTableOrderingComposer,
          $$TournamentTeamsTableTableAnnotationComposer,
          $$TournamentTeamsTableTableCreateCompanionBuilder,
          $$TournamentTeamsTableTableUpdateCompanionBuilder,
          (TournamentTeamsTableData, $$TournamentTeamsTableTableReferences),
          TournamentTeamsTableData,
          PrefetchHooks Function({bool tournamentId, bool teamId})
        > {
  $$TournamentTeamsTableTableTableManager(
    _$AppDatabase db,
    $TournamentTeamsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentTeamsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentTeamsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TournamentTeamsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tournamentId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<int?> seed = const Value.absent(),
                Value<String?> groupLabel = const Value.absent(),
              }) => TournamentTeamsTableCompanion(
                id: id,
                tournamentId: tournamentId,
                teamId: teamId,
                seed: seed,
                groupLabel: groupLabel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tournamentId,
                required int teamId,
                Value<int?> seed = const Value.absent(),
                Value<String?> groupLabel = const Value.absent(),
              }) => TournamentTeamsTableCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                teamId: teamId,
                seed: seed,
                groupLabel: groupLabel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentTeamsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentId = false, teamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tournamentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tournamentId,
                                referencedTable:
                                    $$TournamentTeamsTableTableReferences
                                        ._tournamentIdTable(db),
                                referencedColumn:
                                    $$TournamentTeamsTableTableReferences
                                        ._tournamentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable:
                                    $$TournamentTeamsTableTableReferences
                                        ._teamIdTable(db),
                                referencedColumn:
                                    $$TournamentTeamsTableTableReferences
                                        ._teamIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TournamentTeamsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentTeamsTableTable,
      TournamentTeamsTableData,
      $$TournamentTeamsTableTableFilterComposer,
      $$TournamentTeamsTableTableOrderingComposer,
      $$TournamentTeamsTableTableAnnotationComposer,
      $$TournamentTeamsTableTableCreateCompanionBuilder,
      $$TournamentTeamsTableTableUpdateCompanionBuilder,
      (TournamentTeamsTableData, $$TournamentTeamsTableTableReferences),
      TournamentTeamsTableData,
      PrefetchHooks Function({bool tournamentId, bool teamId})
    >;
typedef $$MatchesTableTableCreateCompanionBuilder =
    MatchesTableCompanion Function({
      Value<int> id,
      required int tournamentId,
      required int round,
      required String stage,
      Value<String?> groupLabel,
      Value<int?> bracketSlot,
      Value<int?> homeTeamId,
      Value<int?> awayTeamId,
      Value<int?> homeScore,
      Value<int?> awayScore,
      required String status,
      Value<int?> winnerAdvancesTo,
      Value<int?> loserAdvancesTo,
      Value<String?> location,
      Value<DateTime?> scheduledAt,
      Value<int?> durationMinutes,
      Value<int?> venueId,
      Value<String?> seriesJson,
    });
typedef $$MatchesTableTableUpdateCompanionBuilder =
    MatchesTableCompanion Function({
      Value<int> id,
      Value<int> tournamentId,
      Value<int> round,
      Value<String> stage,
      Value<String?> groupLabel,
      Value<int?> bracketSlot,
      Value<int?> homeTeamId,
      Value<int?> awayTeamId,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<String> status,
      Value<int?> winnerAdvancesTo,
      Value<int?> loserAdvancesTo,
      Value<String?> location,
      Value<DateTime?> scheduledAt,
      Value<int?> durationMinutes,
      Value<int?> venueId,
      Value<String?> seriesJson,
    });

final class $$MatchesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MatchesTableTable, MatchesTableData> {
  $$MatchesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentsTableTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentsTable
      .createAlias('matches_table__tournament_id__tournaments_table__id');

  $$TournamentsTableTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<int>('tournament_id')!;

    final manager = $$TournamentsTableTableTableManager(
      $_db,
      $_db.tournamentsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTableTable> {
  $$MatchesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bracketSlot => $composableBuilder(
    column: $table.bracketSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayTeamId => $composableBuilder(
    column: $table.awayTeamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get winnerAdvancesTo => $composableBuilder(
    column: $table.winnerAdvancesTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loserAdvancesTo => $composableBuilder(
    column: $table.loserAdvancesTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get venueId => $composableBuilder(
    column: $table.venueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableTableFilterComposer get tournamentId {
    final $$TournamentsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableFilterComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTableTable> {
  $$MatchesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bracketSlot => $composableBuilder(
    column: $table.bracketSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayTeamId => $composableBuilder(
    column: $table.awayTeamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get winnerAdvancesTo => $composableBuilder(
    column: $table.winnerAdvancesTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loserAdvancesTo => $composableBuilder(
    column: $table.loserAdvancesTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get venueId => $composableBuilder(
    column: $table.venueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableTableOrderingComposer get tournamentId {
    final $$TournamentsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTableTable> {
  $$MatchesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bracketSlot => $composableBuilder(
    column: $table.bracketSlot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeTeamId => $composableBuilder(
    column: $table.homeTeamId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awayTeamId => $composableBuilder(
    column: $table.awayTeamId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get winnerAdvancesTo => $composableBuilder(
    column: $table.winnerAdvancesTo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loserAdvancesTo => $composableBuilder(
    column: $table.loserAdvancesTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get venueId =>
      $composableBuilder(column: $table.venueId, builder: (column) => column);

  GeneratedColumn<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => column,
  );

  $$TournamentsTableTableAnnotationComposer get tournamentId {
    final $$TournamentsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tournamentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTableTable,
          MatchesTableData,
          $$MatchesTableTableFilterComposer,
          $$MatchesTableTableOrderingComposer,
          $$MatchesTableTableAnnotationComposer,
          $$MatchesTableTableCreateCompanionBuilder,
          $$MatchesTableTableUpdateCompanionBuilder,
          (MatchesTableData, $$MatchesTableTableReferences),
          MatchesTableData,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$MatchesTableTableTableManager(_$AppDatabase db, $MatchesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tournamentId = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<String?> groupLabel = const Value.absent(),
                Value<int?> bracketSlot = const Value.absent(),
                Value<int?> homeTeamId = const Value.absent(),
                Value<int?> awayTeamId = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> winnerAdvancesTo = const Value.absent(),
                Value<int?> loserAdvancesTo = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<int?> venueId = const Value.absent(),
                Value<String?> seriesJson = const Value.absent(),
              }) => MatchesTableCompanion(
                id: id,
                tournamentId: tournamentId,
                round: round,
                stage: stage,
                groupLabel: groupLabel,
                bracketSlot: bracketSlot,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                homeScore: homeScore,
                awayScore: awayScore,
                status: status,
                winnerAdvancesTo: winnerAdvancesTo,
                loserAdvancesTo: loserAdvancesTo,
                location: location,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                venueId: venueId,
                seriesJson: seriesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tournamentId,
                required int round,
                required String stage,
                Value<String?> groupLabel = const Value.absent(),
                Value<int?> bracketSlot = const Value.absent(),
                Value<int?> homeTeamId = const Value.absent(),
                Value<int?> awayTeamId = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                required String status,
                Value<int?> winnerAdvancesTo = const Value.absent(),
                Value<int?> loserAdvancesTo = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<int?> venueId = const Value.absent(),
                Value<String?> seriesJson = const Value.absent(),
              }) => MatchesTableCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                round: round,
                stage: stage,
                groupLabel: groupLabel,
                bracketSlot: bracketSlot,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                homeScore: homeScore,
                awayScore: awayScore,
                status: status,
                winnerAdvancesTo: winnerAdvancesTo,
                loserAdvancesTo: loserAdvancesTo,
                location: location,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                venueId: venueId,
                seriesJson: seriesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tournamentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tournamentId,
                                referencedTable: $$MatchesTableTableReferences
                                    ._tournamentIdTable(db),
                                referencedColumn: $$MatchesTableTableReferences
                                    ._tournamentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MatchesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTableTable,
      MatchesTableData,
      $$MatchesTableTableFilterComposer,
      $$MatchesTableTableOrderingComposer,
      $$MatchesTableTableAnnotationComposer,
      $$MatchesTableTableCreateCompanionBuilder,
      $$MatchesTableTableUpdateCompanionBuilder,
      (MatchesTableData, $$MatchesTableTableReferences),
      MatchesTableData,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$VenuesTableTableCreateCompanionBuilder =
    VenuesTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> mapUrl,
      Value<String?> notes,
      Value<String?> layoutImagePath,
      Value<int?> parentVenueId,
      Value<DateTime> createdAt,
    });
typedef $$VenuesTableTableUpdateCompanionBuilder =
    VenuesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> mapUrl,
      Value<String?> notes,
      Value<String?> layoutImagePath,
      Value<int?> parentVenueId,
      Value<DateTime> createdAt,
    });

class $$VenuesTableTableFilterComposer
    extends Composer<_$AppDatabase, $VenuesTableTable> {
  $$VenuesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layoutImagePath => $composableBuilder(
    column: $table.layoutImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentVenueId => $composableBuilder(
    column: $table.parentVenueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VenuesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VenuesTableTable> {
  $$VenuesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapUrl => $composableBuilder(
    column: $table.mapUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layoutImagePath => $composableBuilder(
    column: $table.layoutImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentVenueId => $composableBuilder(
    column: $table.parentVenueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VenuesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VenuesTableTable> {
  $$VenuesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get mapUrl =>
      $composableBuilder(column: $table.mapUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get layoutImagePath => $composableBuilder(
    column: $table.layoutImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentVenueId => $composableBuilder(
    column: $table.parentVenueId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VenuesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VenuesTableTable,
          VenuesTableData,
          $$VenuesTableTableFilterComposer,
          $$VenuesTableTableOrderingComposer,
          $$VenuesTableTableAnnotationComposer,
          $$VenuesTableTableCreateCompanionBuilder,
          $$VenuesTableTableUpdateCompanionBuilder,
          (
            VenuesTableData,
            BaseReferences<_$AppDatabase, $VenuesTableTable, VenuesTableData>,
          ),
          VenuesTableData,
          PrefetchHooks Function()
        > {
  $$VenuesTableTableTableManager(_$AppDatabase db, $VenuesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VenuesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VenuesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VenuesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> layoutImagePath = const Value.absent(),
                Value<int?> parentVenueId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VenuesTableCompanion(
                id: id,
                name: name,
                address: address,
                mapUrl: mapUrl,
                notes: notes,
                layoutImagePath: layoutImagePath,
                parentVenueId: parentVenueId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> mapUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> layoutImagePath = const Value.absent(),
                Value<int?> parentVenueId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VenuesTableCompanion.insert(
                id: id,
                name: name,
                address: address,
                mapUrl: mapUrl,
                notes: notes,
                layoutImagePath: layoutImagePath,
                parentVenueId: parentVenueId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VenuesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VenuesTableTable,
      VenuesTableData,
      $$VenuesTableTableFilterComposer,
      $$VenuesTableTableOrderingComposer,
      $$VenuesTableTableAnnotationComposer,
      $$VenuesTableTableCreateCompanionBuilder,
      $$VenuesTableTableUpdateCompanionBuilder,
      (
        VenuesTableData,
        BaseReferences<_$AppDatabase, $VenuesTableTable, VenuesTableData>,
      ),
      VenuesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TeamsTableTableTableManager get teamsTable =>
      $$TeamsTableTableTableManager(_db, _db.teamsTable);
  $$TeamListsTableTableTableManager get teamListsTable =>
      $$TeamListsTableTableTableManager(_db, _db.teamListsTable);
  $$TeamListMembersTableTableTableManager get teamListMembersTable =>
      $$TeamListMembersTableTableTableManager(_db, _db.teamListMembersTable);
  $$LeaguesTableTableTableManager get leaguesTable =>
      $$LeaguesTableTableTableManager(_db, _db.leaguesTable);
  $$DivisionsTableTableTableManager get divisionsTable =>
      $$DivisionsTableTableTableManager(_db, _db.divisionsTable);
  $$DivisionTeamsTableTableTableManager get divisionTeamsTable =>
      $$DivisionTeamsTableTableTableManager(_db, _db.divisionTeamsTable);
  $$TournamentsTableTableTableManager get tournamentsTable =>
      $$TournamentsTableTableTableManager(_db, _db.tournamentsTable);
  $$TournamentTeamsTableTableTableManager get tournamentTeamsTable =>
      $$TournamentTeamsTableTableTableManager(_db, _db.tournamentTeamsTable);
  $$MatchesTableTableTableManager get matchesTable =>
      $$MatchesTableTableTableManager(_db, _db.matchesTable);
  $$VenuesTableTableTableManager get venuesTable =>
      $$VenuesTableTableTableManager(_db, _db.venuesTable);
}
