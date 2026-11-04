// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppStatesTable extends AppStates
    with TableInfo<$AppStatesTable, AppState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL CHECK (id = 1)',
      defaultValue: const Constant(1));
  static const VerificationMeta _installSeedMeta =
      const VerificationMeta('installSeed');
  @override
  late final GeneratedColumn<int> installSeed = GeneratedColumn<int>(
      'install_seed', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timezoneMeta =
      const VerificationMeta('timezone');
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _onboardingCompletedAtMeta =
      const VerificationMeta('onboardingCompletedAt');
  @override
  late final GeneratedColumn<DateTime> onboardingCompletedAt =
      GeneratedColumn<DateTime>('onboarding_completed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSeenAtMeta =
      const VerificationMeta('lastSeenAt');
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
      'last_seen_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notificationPermissionMeta =
      const VerificationMeta('notificationPermission');
  @override
  late final GeneratedColumn<String> notificationPermission =
      GeneratedColumn<String>('notification_permission', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('UNKNOWN'));
  static const VerificationMeta _permissionReaskDueAtMeta =
      const VerificationMeta('permissionReaskDueAt');
  @override
  late final GeneratedColumn<DateTime> permissionReaskDueAt =
      GeneratedColumn<DateTime>('permission_reask_due_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _quietCardPendingMeta =
      const VerificationMeta('quietCardPending');
  @override
  late final GeneratedColumn<bool> quietCardPending = GeneratedColumn<bool>(
      'quiet_card_pending', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("quiet_card_pending" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _insightsEnabledMeta =
      const VerificationMeta('insightsEnabled');
  @override
  late final GeneratedColumn<bool> insightsEnabled = GeneratedColumn<bool>(
      'insights_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("insights_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _plannerLastRunAtMeta =
      const VerificationMeta('plannerLastRunAt');
  @override
  late final GeneratedColumn<DateTime> plannerLastRunAt =
      GeneratedColumn<DateTime>('planner_last_run_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _appVersionMeta =
      const VerificationMeta('appVersion');
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
      'app_version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0.2.0'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        installSeed,
        timezone,
        onboardingCompletedAt,
        lastSeenAt,
        notificationPermission,
        permissionReaskDueAt,
        quietCardPending,
        insightsEnabled,
        plannerLastRunAt,
        appVersion,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_states';
  @override
  VerificationContext validateIntegrity(Insertable<AppState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('install_seed')) {
      context.handle(
          _installSeedMeta,
          installSeed.isAcceptableOrUnknown(
              data['install_seed']!, _installSeedMeta));
    } else if (isInserting) {
      context.missing(_installSeedMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(_timezoneMeta,
          timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta));
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('onboarding_completed_at')) {
      context.handle(
          _onboardingCompletedAtMeta,
          onboardingCompletedAt.isAcceptableOrUnknown(
              data['onboarding_completed_at']!, _onboardingCompletedAtMeta));
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
          _lastSeenAtMeta,
          lastSeenAt.isAcceptableOrUnknown(
              data['last_seen_at']!, _lastSeenAtMeta));
    }
    if (data.containsKey('notification_permission')) {
      context.handle(
          _notificationPermissionMeta,
          notificationPermission.isAcceptableOrUnknown(
              data['notification_permission']!, _notificationPermissionMeta));
    }
    if (data.containsKey('permission_reask_due_at')) {
      context.handle(
          _permissionReaskDueAtMeta,
          permissionReaskDueAt.isAcceptableOrUnknown(
              data['permission_reask_due_at']!, _permissionReaskDueAtMeta));
    }
    if (data.containsKey('quiet_card_pending')) {
      context.handle(
          _quietCardPendingMeta,
          quietCardPending.isAcceptableOrUnknown(
              data['quiet_card_pending']!, _quietCardPendingMeta));
    }
    if (data.containsKey('insights_enabled')) {
      context.handle(
          _insightsEnabledMeta,
          insightsEnabled.isAcceptableOrUnknown(
              data['insights_enabled']!, _insightsEnabledMeta));
    }
    if (data.containsKey('planner_last_run_at')) {
      context.handle(
          _plannerLastRunAtMeta,
          plannerLastRunAt.isAcceptableOrUnknown(
              data['planner_last_run_at']!, _plannerLastRunAtMeta));
    }
    if (data.containsKey('app_version')) {
      context.handle(
          _appVersionMeta,
          appVersion.isAcceptableOrUnknown(
              data['app_version']!, _appVersionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      installSeed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}install_seed'])!,
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone'])!,
      onboardingCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}onboarding_completed_at']),
      lastSeenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen_at']),
      notificationPermission: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}notification_permission'])!,
      permissionReaskDueAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}permission_reask_due_at']),
      quietCardPending: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}quiet_card_pending'])!,
      insightsEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}insights_enabled'])!,
      plannerLastRunAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}planner_last_run_at']),
      appVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AppStatesTable createAlias(String alias) {
    return $AppStatesTable(attachedDatabase, alias);
  }
}

class AppState extends DataClass implements Insertable<AppState> {
  final int id;
  final int installSeed;
  final String timezone;
  final DateTime? onboardingCompletedAt;
  final DateTime? lastSeenAt;
  final String notificationPermission;
  final DateTime? permissionReaskDueAt;
  final bool quietCardPending;
  final bool insightsEnabled;
  final DateTime? plannerLastRunAt;
  final String appVersion;
  final DateTime createdAt;
  const AppState(
      {required this.id,
      required this.installSeed,
      required this.timezone,
      this.onboardingCompletedAt,
      this.lastSeenAt,
      required this.notificationPermission,
      this.permissionReaskDueAt,
      required this.quietCardPending,
      required this.insightsEnabled,
      this.plannerLastRunAt,
      required this.appVersion,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['install_seed'] = Variable<int>(installSeed);
    map['timezone'] = Variable<String>(timezone);
    if (!nullToAbsent || onboardingCompletedAt != null) {
      map['onboarding_completed_at'] =
          Variable<DateTime>(onboardingCompletedAt);
    }
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['notification_permission'] = Variable<String>(notificationPermission);
    if (!nullToAbsent || permissionReaskDueAt != null) {
      map['permission_reask_due_at'] = Variable<DateTime>(permissionReaskDueAt);
    }
    map['quiet_card_pending'] = Variable<bool>(quietCardPending);
    map['insights_enabled'] = Variable<bool>(insightsEnabled);
    if (!nullToAbsent || plannerLastRunAt != null) {
      map['planner_last_run_at'] = Variable<DateTime>(plannerLastRunAt);
    }
    map['app_version'] = Variable<String>(appVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppStatesCompanion toCompanion(bool nullToAbsent) {
    return AppStatesCompanion(
      id: Value(id),
      installSeed: Value(installSeed),
      timezone: Value(timezone),
      onboardingCompletedAt: onboardingCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingCompletedAt),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      notificationPermission: Value(notificationPermission),
      permissionReaskDueAt: permissionReaskDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(permissionReaskDueAt),
      quietCardPending: Value(quietCardPending),
      insightsEnabled: Value(insightsEnabled),
      plannerLastRunAt: plannerLastRunAt == null && nullToAbsent
          ? const Value.absent()
          : Value(plannerLastRunAt),
      appVersion: Value(appVersion),
      createdAt: Value(createdAt),
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppState(
      id: serializer.fromJson<int>(json['id']),
      installSeed: serializer.fromJson<int>(json['installSeed']),
      timezone: serializer.fromJson<String>(json['timezone']),
      onboardingCompletedAt:
          serializer.fromJson<DateTime?>(json['onboardingCompletedAt']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      notificationPermission:
          serializer.fromJson<String>(json['notificationPermission']),
      permissionReaskDueAt:
          serializer.fromJson<DateTime?>(json['permissionReaskDueAt']),
      quietCardPending: serializer.fromJson<bool>(json['quietCardPending']),
      insightsEnabled: serializer.fromJson<bool>(json['insightsEnabled']),
      plannerLastRunAt:
          serializer.fromJson<DateTime?>(json['plannerLastRunAt']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'installSeed': serializer.toJson<int>(installSeed),
      'timezone': serializer.toJson<String>(timezone),
      'onboardingCompletedAt':
          serializer.toJson<DateTime?>(onboardingCompletedAt),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'notificationPermission':
          serializer.toJson<String>(notificationPermission),
      'permissionReaskDueAt':
          serializer.toJson<DateTime?>(permissionReaskDueAt),
      'quietCardPending': serializer.toJson<bool>(quietCardPending),
      'insightsEnabled': serializer.toJson<bool>(insightsEnabled),
      'plannerLastRunAt': serializer.toJson<DateTime?>(plannerLastRunAt),
      'appVersion': serializer.toJson<String>(appVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppState copyWith(
          {int? id,
          int? installSeed,
          String? timezone,
          Value<DateTime?> onboardingCompletedAt = const Value.absent(),
          Value<DateTime?> lastSeenAt = const Value.absent(),
          String? notificationPermission,
          Value<DateTime?> permissionReaskDueAt = const Value.absent(),
          bool? quietCardPending,
          bool? insightsEnabled,
          Value<DateTime?> plannerLastRunAt = const Value.absent(),
          String? appVersion,
          DateTime? createdAt}) =>
      AppState(
        id: id ?? this.id,
        installSeed: installSeed ?? this.installSeed,
        timezone: timezone ?? this.timezone,
        onboardingCompletedAt: onboardingCompletedAt.present
            ? onboardingCompletedAt.value
            : this.onboardingCompletedAt,
        lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
        notificationPermission:
            notificationPermission ?? this.notificationPermission,
        permissionReaskDueAt: permissionReaskDueAt.present
            ? permissionReaskDueAt.value
            : this.permissionReaskDueAt,
        quietCardPending: quietCardPending ?? this.quietCardPending,
        insightsEnabled: insightsEnabled ?? this.insightsEnabled,
        plannerLastRunAt: plannerLastRunAt.present
            ? plannerLastRunAt.value
            : this.plannerLastRunAt,
        appVersion: appVersion ?? this.appVersion,
        createdAt: createdAt ?? this.createdAt,
      );
  AppState copyWithCompanion(AppStatesCompanion data) {
    return AppState(
      id: data.id.present ? data.id.value : this.id,
      installSeed:
          data.installSeed.present ? data.installSeed.value : this.installSeed,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      onboardingCompletedAt: data.onboardingCompletedAt.present
          ? data.onboardingCompletedAt.value
          : this.onboardingCompletedAt,
      lastSeenAt:
          data.lastSeenAt.present ? data.lastSeenAt.value : this.lastSeenAt,
      notificationPermission: data.notificationPermission.present
          ? data.notificationPermission.value
          : this.notificationPermission,
      permissionReaskDueAt: data.permissionReaskDueAt.present
          ? data.permissionReaskDueAt.value
          : this.permissionReaskDueAt,
      quietCardPending: data.quietCardPending.present
          ? data.quietCardPending.value
          : this.quietCardPending,
      insightsEnabled: data.insightsEnabled.present
          ? data.insightsEnabled.value
          : this.insightsEnabled,
      plannerLastRunAt: data.plannerLastRunAt.present
          ? data.plannerLastRunAt.value
          : this.plannerLastRunAt,
      appVersion:
          data.appVersion.present ? data.appVersion.value : this.appVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppState(')
          ..write('id: $id, ')
          ..write('installSeed: $installSeed, ')
          ..write('timezone: $timezone, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('notificationPermission: $notificationPermission, ')
          ..write('permissionReaskDueAt: $permissionReaskDueAt, ')
          ..write('quietCardPending: $quietCardPending, ')
          ..write('insightsEnabled: $insightsEnabled, ')
          ..write('plannerLastRunAt: $plannerLastRunAt, ')
          ..write('appVersion: $appVersion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      installSeed,
      timezone,
      onboardingCompletedAt,
      lastSeenAt,
      notificationPermission,
      permissionReaskDueAt,
      quietCardPending,
      insightsEnabled,
      plannerLastRunAt,
      appVersion,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState &&
          other.id == this.id &&
          other.installSeed == this.installSeed &&
          other.timezone == this.timezone &&
          other.onboardingCompletedAt == this.onboardingCompletedAt &&
          other.lastSeenAt == this.lastSeenAt &&
          other.notificationPermission == this.notificationPermission &&
          other.permissionReaskDueAt == this.permissionReaskDueAt &&
          other.quietCardPending == this.quietCardPending &&
          other.insightsEnabled == this.insightsEnabled &&
          other.plannerLastRunAt == this.plannerLastRunAt &&
          other.appVersion == this.appVersion &&
          other.createdAt == this.createdAt);
}

class AppStatesCompanion extends UpdateCompanion<AppState> {
  final Value<int> id;
  final Value<int> installSeed;
  final Value<String> timezone;
  final Value<DateTime?> onboardingCompletedAt;
  final Value<DateTime?> lastSeenAt;
  final Value<String> notificationPermission;
  final Value<DateTime?> permissionReaskDueAt;
  final Value<bool> quietCardPending;
  final Value<bool> insightsEnabled;
  final Value<DateTime?> plannerLastRunAt;
  final Value<String> appVersion;
  final Value<DateTime> createdAt;
  const AppStatesCompanion({
    this.id = const Value.absent(),
    this.installSeed = const Value.absent(),
    this.timezone = const Value.absent(),
    this.onboardingCompletedAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.notificationPermission = const Value.absent(),
    this.permissionReaskDueAt = const Value.absent(),
    this.quietCardPending = const Value.absent(),
    this.insightsEnabled = const Value.absent(),
    this.plannerLastRunAt = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppStatesCompanion.insert({
    this.id = const Value.absent(),
    required int installSeed,
    required String timezone,
    this.onboardingCompletedAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.notificationPermission = const Value.absent(),
    this.permissionReaskDueAt = const Value.absent(),
    this.quietCardPending = const Value.absent(),
    this.insightsEnabled = const Value.absent(),
    this.plannerLastRunAt = const Value.absent(),
    this.appVersion = const Value.absent(),
    required DateTime createdAt,
  })  : installSeed = Value(installSeed),
        timezone = Value(timezone),
        createdAt = Value(createdAt);
  static Insertable<AppState> custom({
    Expression<int>? id,
    Expression<int>? installSeed,
    Expression<String>? timezone,
    Expression<DateTime>? onboardingCompletedAt,
    Expression<DateTime>? lastSeenAt,
    Expression<String>? notificationPermission,
    Expression<DateTime>? permissionReaskDueAt,
    Expression<bool>? quietCardPending,
    Expression<bool>? insightsEnabled,
    Expression<DateTime>? plannerLastRunAt,
    Expression<String>? appVersion,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (installSeed != null) 'install_seed': installSeed,
      if (timezone != null) 'timezone': timezone,
      if (onboardingCompletedAt != null)
        'onboarding_completed_at': onboardingCompletedAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (notificationPermission != null)
        'notification_permission': notificationPermission,
      if (permissionReaskDueAt != null)
        'permission_reask_due_at': permissionReaskDueAt,
      if (quietCardPending != null) 'quiet_card_pending': quietCardPending,
      if (insightsEnabled != null) 'insights_enabled': insightsEnabled,
      if (plannerLastRunAt != null) 'planner_last_run_at': plannerLastRunAt,
      if (appVersion != null) 'app_version': appVersion,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppStatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? installSeed,
      Value<String>? timezone,
      Value<DateTime?>? onboardingCompletedAt,
      Value<DateTime?>? lastSeenAt,
      Value<String>? notificationPermission,
      Value<DateTime?>? permissionReaskDueAt,
      Value<bool>? quietCardPending,
      Value<bool>? insightsEnabled,
      Value<DateTime?>? plannerLastRunAt,
      Value<String>? appVersion,
      Value<DateTime>? createdAt}) {
    return AppStatesCompanion(
      id: id ?? this.id,
      installSeed: installSeed ?? this.installSeed,
      timezone: timezone ?? this.timezone,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      notificationPermission:
          notificationPermission ?? this.notificationPermission,
      permissionReaskDueAt: permissionReaskDueAt ?? this.permissionReaskDueAt,
      quietCardPending: quietCardPending ?? this.quietCardPending,
      insightsEnabled: insightsEnabled ?? this.insightsEnabled,
      plannerLastRunAt: plannerLastRunAt ?? this.plannerLastRunAt,
      appVersion: appVersion ?? this.appVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (installSeed.present) {
      map['install_seed'] = Variable<int>(installSeed.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (onboardingCompletedAt.present) {
      map['onboarding_completed_at'] =
          Variable<DateTime>(onboardingCompletedAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (notificationPermission.present) {
      map['notification_permission'] =
          Variable<String>(notificationPermission.value);
    }
    if (permissionReaskDueAt.present) {
      map['permission_reask_due_at'] =
          Variable<DateTime>(permissionReaskDueAt.value);
    }
    if (quietCardPending.present) {
      map['quiet_card_pending'] = Variable<bool>(quietCardPending.value);
    }
    if (insightsEnabled.present) {
      map['insights_enabled'] = Variable<bool>(insightsEnabled.value);
    }
    if (plannerLastRunAt.present) {
      map['planner_last_run_at'] = Variable<DateTime>(plannerLastRunAt.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppStatesCompanion(')
          ..write('id: $id, ')
          ..write('installSeed: $installSeed, ')
          ..write('timezone: $timezone, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('notificationPermission: $notificationPermission, ')
          ..write('permissionReaskDueAt: $permissionReaskDueAt, ')
          ..write('quietCardPending: $quietCardPending, ')
          ..write('insightsEnabled: $insightsEnabled, ')
          ..write('plannerLastRunAt: $plannerLastRunAt, ')
          ..write('appVersion: $appVersion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationSettingsTableTable extends NotificationSettingsTable
    with
        TableInfo<$NotificationSettingsTableTable,
            NotificationSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL CHECK (id = 1)',
      defaultValue: const Constant(1));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('GENTLE'));
  static const VerificationMeta _windowsMeta =
      const VerificationMeta('windows');
  @override
  late final GeneratedColumn<int> windows = GeneratedColumn<int>(
      'windows', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _voiceMeta = const VerificationMeta('voice');
  @override
  late final GeneratedColumn<String> voice = GeneratedColumn<String>(
      'voice', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CALM'));
  static const VerificationMeta _showTextOnLockScreenMeta =
      const VerificationMeta('showTextOnLockScreen');
  @override
  late final GeneratedColumn<bool> showTextOnLockScreen = GeneratedColumn<bool>(
      'show_text_on_lock_screen', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_text_on_lock_screen" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pausedUntilMeta =
      const VerificationMeta('pausedUntil');
  @override
  late final GeneratedColumn<DateTime> pausedUntil = GeneratedColumn<DateTime>(
      'paused_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _consecutiveIgnoredMeta =
      const VerificationMeta('consecutiveIgnored');
  @override
  late final GeneratedColumn<int> consecutiveIgnored = GeneratedColumn<int>(
      'consecutive_ignored', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _backoffStepMeta =
      const VerificationMeta('backoffStep');
  @override
  late final GeneratedColumn<int> backoffStep = GeneratedColumn<int>(
      'backoff_step', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastNudgeAtMeta =
      const VerificationMeta('lastNudgeAt');
  @override
  late final GeneratedColumn<DateTime> lastNudgeAt = GeneratedColumn<DateTime>(
      'last_nudge_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        level,
        windows,
        voice,
        showTextOnLockScreen,
        pausedUntil,
        consecutiveIgnored,
        backoffStep,
        lastNudgeAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('windows')) {
      context.handle(_windowsMeta,
          windows.isAcceptableOrUnknown(data['windows']!, _windowsMeta));
    }
    if (data.containsKey('voice')) {
      context.handle(
          _voiceMeta, voice.isAcceptableOrUnknown(data['voice']!, _voiceMeta));
    }
    if (data.containsKey('show_text_on_lock_screen')) {
      context.handle(
          _showTextOnLockScreenMeta,
          showTextOnLockScreen.isAcceptableOrUnknown(
              data['show_text_on_lock_screen']!, _showTextOnLockScreenMeta));
    }
    if (data.containsKey('paused_until')) {
      context.handle(
          _pausedUntilMeta,
          pausedUntil.isAcceptableOrUnknown(
              data['paused_until']!, _pausedUntilMeta));
    }
    if (data.containsKey('consecutive_ignored')) {
      context.handle(
          _consecutiveIgnoredMeta,
          consecutiveIgnored.isAcceptableOrUnknown(
              data['consecutive_ignored']!, _consecutiveIgnoredMeta));
    }
    if (data.containsKey('backoff_step')) {
      context.handle(
          _backoffStepMeta,
          backoffStep.isAcceptableOrUnknown(
              data['backoff_step']!, _backoffStepMeta));
    }
    if (data.containsKey('last_nudge_at')) {
      context.handle(
          _lastNudgeAtMeta,
          lastNudgeAt.isAcceptableOrUnknown(
              data['last_nudge_at']!, _lastNudgeAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      windows: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}windows'])!,
      voice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice'])!,
      showTextOnLockScreen: attachedDatabase.typeMapping.read(DriftSqlType.bool,
          data['${effectivePrefix}show_text_on_lock_screen'])!,
      pausedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paused_until']),
      consecutiveIgnored: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}consecutive_ignored'])!,
      backoffStep: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}backoff_step'])!,
      lastNudgeAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_nudge_at']),
    );
  }

  @override
  $NotificationSettingsTableTable createAlias(String alias) {
    return $NotificationSettingsTableTable(attachedDatabase, alias);
  }
}

class NotificationSettingsTableData extends DataClass
    implements Insertable<NotificationSettingsTableData> {
  final int id;
  final String level;
  final int windows;
  final String voice;
  final bool showTextOnLockScreen;
  final DateTime? pausedUntil;
  final int consecutiveIgnored;
  final int backoffStep;
  final DateTime? lastNudgeAt;
  const NotificationSettingsTableData(
      {required this.id,
      required this.level,
      required this.windows,
      required this.voice,
      required this.showTextOnLockScreen,
      this.pausedUntil,
      required this.consecutiveIgnored,
      required this.backoffStep,
      this.lastNudgeAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['windows'] = Variable<int>(windows);
    map['voice'] = Variable<String>(voice);
    map['show_text_on_lock_screen'] = Variable<bool>(showTextOnLockScreen);
    if (!nullToAbsent || pausedUntil != null) {
      map['paused_until'] = Variable<DateTime>(pausedUntil);
    }
    map['consecutive_ignored'] = Variable<int>(consecutiveIgnored);
    map['backoff_step'] = Variable<int>(backoffStep);
    if (!nullToAbsent || lastNudgeAt != null) {
      map['last_nudge_at'] = Variable<DateTime>(lastNudgeAt);
    }
    return map;
  }

  NotificationSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationSettingsTableCompanion(
      id: Value(id),
      level: Value(level),
      windows: Value(windows),
      voice: Value(voice),
      showTextOnLockScreen: Value(showTextOnLockScreen),
      pausedUntil: pausedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedUntil),
      consecutiveIgnored: Value(consecutiveIgnored),
      backoffStep: Value(backoffStep),
      lastNudgeAt: lastNudgeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNudgeAt),
    );
  }

  factory NotificationSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      windows: serializer.fromJson<int>(json['windows']),
      voice: serializer.fromJson<String>(json['voice']),
      showTextOnLockScreen:
          serializer.fromJson<bool>(json['showTextOnLockScreen']),
      pausedUntil: serializer.fromJson<DateTime?>(json['pausedUntil']),
      consecutiveIgnored: serializer.fromJson<int>(json['consecutiveIgnored']),
      backoffStep: serializer.fromJson<int>(json['backoffStep']),
      lastNudgeAt: serializer.fromJson<DateTime?>(json['lastNudgeAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'windows': serializer.toJson<int>(windows),
      'voice': serializer.toJson<String>(voice),
      'showTextOnLockScreen': serializer.toJson<bool>(showTextOnLockScreen),
      'pausedUntil': serializer.toJson<DateTime?>(pausedUntil),
      'consecutiveIgnored': serializer.toJson<int>(consecutiveIgnored),
      'backoffStep': serializer.toJson<int>(backoffStep),
      'lastNudgeAt': serializer.toJson<DateTime?>(lastNudgeAt),
    };
  }

  NotificationSettingsTableData copyWith(
          {int? id,
          String? level,
          int? windows,
          String? voice,
          bool? showTextOnLockScreen,
          Value<DateTime?> pausedUntil = const Value.absent(),
          int? consecutiveIgnored,
          int? backoffStep,
          Value<DateTime?> lastNudgeAt = const Value.absent()}) =>
      NotificationSettingsTableData(
        id: id ?? this.id,
        level: level ?? this.level,
        windows: windows ?? this.windows,
        voice: voice ?? this.voice,
        showTextOnLockScreen: showTextOnLockScreen ?? this.showTextOnLockScreen,
        pausedUntil: pausedUntil.present ? pausedUntil.value : this.pausedUntil,
        consecutiveIgnored: consecutiveIgnored ?? this.consecutiveIgnored,
        backoffStep: backoffStep ?? this.backoffStep,
        lastNudgeAt: lastNudgeAt.present ? lastNudgeAt.value : this.lastNudgeAt,
      );
  NotificationSettingsTableData copyWithCompanion(
      NotificationSettingsTableCompanion data) {
    return NotificationSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      windows: data.windows.present ? data.windows.value : this.windows,
      voice: data.voice.present ? data.voice.value : this.voice,
      showTextOnLockScreen: data.showTextOnLockScreen.present
          ? data.showTextOnLockScreen.value
          : this.showTextOnLockScreen,
      pausedUntil:
          data.pausedUntil.present ? data.pausedUntil.value : this.pausedUntil,
      consecutiveIgnored: data.consecutiveIgnored.present
          ? data.consecutiveIgnored.value
          : this.consecutiveIgnored,
      backoffStep:
          data.backoffStep.present ? data.backoffStep.value : this.backoffStep,
      lastNudgeAt:
          data.lastNudgeAt.present ? data.lastNudgeAt.value : this.lastNudgeAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsTableData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('windows: $windows, ')
          ..write('voice: $voice, ')
          ..write('showTextOnLockScreen: $showTextOnLockScreen, ')
          ..write('pausedUntil: $pausedUntil, ')
          ..write('consecutiveIgnored: $consecutiveIgnored, ')
          ..write('backoffStep: $backoffStep, ')
          ..write('lastNudgeAt: $lastNudgeAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      level,
      windows,
      voice,
      showTextOnLockScreen,
      pausedUntil,
      consecutiveIgnored,
      backoffStep,
      lastNudgeAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSettingsTableData &&
          other.id == this.id &&
          other.level == this.level &&
          other.windows == this.windows &&
          other.voice == this.voice &&
          other.showTextOnLockScreen == this.showTextOnLockScreen &&
          other.pausedUntil == this.pausedUntil &&
          other.consecutiveIgnored == this.consecutiveIgnored &&
          other.backoffStep == this.backoffStep &&
          other.lastNudgeAt == this.lastNudgeAt);
}

class NotificationSettingsTableCompanion
    extends UpdateCompanion<NotificationSettingsTableData> {
  final Value<int> id;
  final Value<String> level;
  final Value<int> windows;
  final Value<String> voice;
  final Value<bool> showTextOnLockScreen;
  final Value<DateTime?> pausedUntil;
  final Value<int> consecutiveIgnored;
  final Value<int> backoffStep;
  final Value<DateTime?> lastNudgeAt;
  const NotificationSettingsTableCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.windows = const Value.absent(),
    this.voice = const Value.absent(),
    this.showTextOnLockScreen = const Value.absent(),
    this.pausedUntil = const Value.absent(),
    this.consecutiveIgnored = const Value.absent(),
    this.backoffStep = const Value.absent(),
    this.lastNudgeAt = const Value.absent(),
  });
  NotificationSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.windows = const Value.absent(),
    this.voice = const Value.absent(),
    this.showTextOnLockScreen = const Value.absent(),
    this.pausedUntil = const Value.absent(),
    this.consecutiveIgnored = const Value.absent(),
    this.backoffStep = const Value.absent(),
    this.lastNudgeAt = const Value.absent(),
  });
  static Insertable<NotificationSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<int>? windows,
    Expression<String>? voice,
    Expression<bool>? showTextOnLockScreen,
    Expression<DateTime>? pausedUntil,
    Expression<int>? consecutiveIgnored,
    Expression<int>? backoffStep,
    Expression<DateTime>? lastNudgeAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (windows != null) 'windows': windows,
      if (voice != null) 'voice': voice,
      if (showTextOnLockScreen != null)
        'show_text_on_lock_screen': showTextOnLockScreen,
      if (pausedUntil != null) 'paused_until': pausedUntil,
      if (consecutiveIgnored != null) 'consecutive_ignored': consecutiveIgnored,
      if (backoffStep != null) 'backoff_step': backoffStep,
      if (lastNudgeAt != null) 'last_nudge_at': lastNudgeAt,
    });
  }

  NotificationSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? level,
      Value<int>? windows,
      Value<String>? voice,
      Value<bool>? showTextOnLockScreen,
      Value<DateTime?>? pausedUntil,
      Value<int>? consecutiveIgnored,
      Value<int>? backoffStep,
      Value<DateTime?>? lastNudgeAt}) {
    return NotificationSettingsTableCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      windows: windows ?? this.windows,
      voice: voice ?? this.voice,
      showTextOnLockScreen: showTextOnLockScreen ?? this.showTextOnLockScreen,
      pausedUntil: pausedUntil ?? this.pausedUntil,
      consecutiveIgnored: consecutiveIgnored ?? this.consecutiveIgnored,
      backoffStep: backoffStep ?? this.backoffStep,
      lastNudgeAt: lastNudgeAt ?? this.lastNudgeAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (windows.present) {
      map['windows'] = Variable<int>(windows.value);
    }
    if (voice.present) {
      map['voice'] = Variable<String>(voice.value);
    }
    if (showTextOnLockScreen.present) {
      map['show_text_on_lock_screen'] =
          Variable<bool>(showTextOnLockScreen.value);
    }
    if (pausedUntil.present) {
      map['paused_until'] = Variable<DateTime>(pausedUntil.value);
    }
    if (consecutiveIgnored.present) {
      map['consecutive_ignored'] = Variable<int>(consecutiveIgnored.value);
    }
    if (backoffStep.present) {
      map['backoff_step'] = Variable<int>(backoffStep.value);
    }
    if (lastNudgeAt.present) {
      map['last_nudge_at'] = Variable<DateTime>(lastNudgeAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('windows: $windows, ')
          ..write('voice: $voice, ')
          ..write('showTextOnLockScreen: $showTextOnLockScreen, ')
          ..write('pausedUntil: $pausedUntil, ')
          ..write('consecutiveIgnored: $consecutiveIgnored, ')
          ..write('backoffStep: $backoffStep, ')
          ..write('lastNudgeAt: $lastNudgeAt')
          ..write(')'))
        .toString();
  }
}

class $InterestsTableTable extends InterestsTable
    with TableInfo<$InterestsTableTable, InterestsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterestsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameKeyMeta =
      const VerificationMeta('nameKey');
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
      'name_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _alphaMeta = const VerificationMeta('alpha');
  @override
  late final GeneratedColumn<double> alpha = GeneratedColumn<double>(
      'alpha', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _betaMeta = const VerificationMeta('beta');
  @override
  late final GeneratedColumn<double> beta = GeneratedColumn<double>(
      'beta', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _pushCooldownUntilMeta =
      const VerificationMeta('pushCooldownUntil');
  @override
  late final GeneratedColumn<DateTime> pushCooldownUntil =
      GeneratedColumn<DateTime>('push_cooldown_until', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nameKey,
        alpha,
        beta,
        pushCooldownUntil,
        archivedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interests_table';
  @override
  VerificationContext validateIntegrity(Insertable<InterestsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(_nameKeyMeta,
          nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta));
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('alpha')) {
      context.handle(
          _alphaMeta, alpha.isAcceptableOrUnknown(data['alpha']!, _alphaMeta));
    }
    if (data.containsKey('beta')) {
      context.handle(
          _betaMeta, beta.isAcceptableOrUnknown(data['beta']!, _betaMeta));
    }
    if (data.containsKey('push_cooldown_until')) {
      context.handle(
          _pushCooldownUntilMeta,
          pushCooldownUntil.isAcceptableOrUnknown(
              data['push_cooldown_until']!, _pushCooldownUntilMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterestsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterestsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_key'])!,
      alpha: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}alpha'])!,
      beta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}beta'])!,
      pushCooldownUntil: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}push_cooldown_until']),
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InterestsTableTable createAlias(String alias) {
    return $InterestsTableTable(attachedDatabase, alias);
  }
}

class InterestsTableData extends DataClass
    implements Insertable<InterestsTableData> {
  final String id;
  final String name;
  final String nameKey;
  final double alpha;
  final double beta;
  final DateTime? pushCooldownUntil;
  final DateTime? archivedAt;
  final DateTime createdAt;
  const InterestsTableData(
      {required this.id,
      required this.name,
      required this.nameKey,
      required this.alpha,
      required this.beta,
      this.pushCooldownUntil,
      this.archivedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_key'] = Variable<String>(nameKey);
    map['alpha'] = Variable<double>(alpha);
    map['beta'] = Variable<double>(beta);
    if (!nullToAbsent || pushCooldownUntil != null) {
      map['push_cooldown_until'] = Variable<DateTime>(pushCooldownUntil);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InterestsTableCompanion toCompanion(bool nullToAbsent) {
    return InterestsTableCompanion(
      id: Value(id),
      name: Value(name),
      nameKey: Value(nameKey),
      alpha: Value(alpha),
      beta: Value(beta),
      pushCooldownUntil: pushCooldownUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(pushCooldownUntil),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
    );
  }

  factory InterestsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterestsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      alpha: serializer.fromJson<double>(json['alpha']),
      beta: serializer.fromJson<double>(json['beta']),
      pushCooldownUntil:
          serializer.fromJson<DateTime?>(json['pushCooldownUntil']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameKey': serializer.toJson<String>(nameKey),
      'alpha': serializer.toJson<double>(alpha),
      'beta': serializer.toJson<double>(beta),
      'pushCooldownUntil': serializer.toJson<DateTime?>(pushCooldownUntil),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InterestsTableData copyWith(
          {String? id,
          String? name,
          String? nameKey,
          double? alpha,
          double? beta,
          Value<DateTime?> pushCooldownUntil = const Value.absent(),
          Value<DateTime?> archivedAt = const Value.absent(),
          DateTime? createdAt}) =>
      InterestsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        nameKey: nameKey ?? this.nameKey,
        alpha: alpha ?? this.alpha,
        beta: beta ?? this.beta,
        pushCooldownUntil: pushCooldownUntil.present
            ? pushCooldownUntil.value
            : this.pushCooldownUntil,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  InterestsTableData copyWithCompanion(InterestsTableCompanion data) {
    return InterestsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      alpha: data.alpha.present ? data.alpha.value : this.alpha,
      beta: data.beta.present ? data.beta.value : this.beta,
      pushCooldownUntil: data.pushCooldownUntil.present
          ? data.pushCooldownUntil.value
          : this.pushCooldownUntil,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterestsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('alpha: $alpha, ')
          ..write('beta: $beta, ')
          ..write('pushCooldownUntil: $pushCooldownUntil, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, nameKey, alpha, beta, pushCooldownUntil, archivedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterestsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameKey == this.nameKey &&
          other.alpha == this.alpha &&
          other.beta == this.beta &&
          other.pushCooldownUntil == this.pushCooldownUntil &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt);
}

class InterestsTableCompanion extends UpdateCompanion<InterestsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameKey;
  final Value<double> alpha;
  final Value<double> beta;
  final Value<DateTime?> pushCooldownUntil;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InterestsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.alpha = const Value.absent(),
    this.beta = const Value.absent(),
    this.pushCooldownUntil = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InterestsTableCompanion.insert({
    required String id,
    required String name,
    required String nameKey,
    this.alpha = const Value.absent(),
    this.beta = const Value.absent(),
    this.pushCooldownUntil = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        nameKey = Value(nameKey),
        createdAt = Value(createdAt);
  static Insertable<InterestsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameKey,
    Expression<double>? alpha,
    Expression<double>? beta,
    Expression<DateTime>? pushCooldownUntil,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameKey != null) 'name_key': nameKey,
      if (alpha != null) 'alpha': alpha,
      if (beta != null) 'beta': beta,
      if (pushCooldownUntil != null) 'push_cooldown_until': pushCooldownUntil,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InterestsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? nameKey,
      Value<double>? alpha,
      Value<double>? beta,
      Value<DateTime?>? pushCooldownUntil,
      Value<DateTime?>? archivedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InterestsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      alpha: alpha ?? this.alpha,
      beta: beta ?? this.beta,
      pushCooldownUntil: pushCooldownUntil ?? this.pushCooldownUntil,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (alpha.present) {
      map['alpha'] = Variable<double>(alpha.value);
    }
    if (beta.present) {
      map['beta'] = Variable<double>(beta.value);
    }
    if (pushCooldownUntil.present) {
      map['push_cooldown_until'] = Variable<DateTime>(pushCooldownUntil.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterestsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('alpha: $alpha, ')
          ..write('beta: $beta, ')
          ..write('pushCooldownUntil: $pushCooldownUntil, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTableTable extends SnippetsTable
    with TableInfo<$SnippetsTableTable, SnippetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _interestIdMeta =
      const VerificationMeta('interestId');
  @override
  late final GeneratedColumn<String> interestId = GeneratedColumn<String>(
      'interest_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES interests_table(id) ON DELETE CASCADE');
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (length(content) BETWEEN 1 AND 1000)');
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, interestId, content, source, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets_table';
  @override
  VerificationContext validateIntegrity(Insertable<SnippetsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('interest_id')) {
      context.handle(
          _interestIdMeta,
          interestId.isAcceptableOrUnknown(
              data['interest_id']!, _interestIdMeta));
    } else if (isInserting) {
      context.missing(_interestIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnippetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      interestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interest_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SnippetsTableTable createAlias(String alias) {
    return $SnippetsTableTable(attachedDatabase, alias);
  }
}

class SnippetsTableData extends DataClass
    implements Insertable<SnippetsTableData> {
  final String id;
  final String interestId;
  final String content;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SnippetsTableData(
      {required this.id,
      required this.interestId,
      required this.content,
      required this.source,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['interest_id'] = Variable<String>(interestId);
    map['content'] = Variable<String>(content);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SnippetsTableCompanion toCompanion(bool nullToAbsent) {
    return SnippetsTableCompanion(
      id: Value(id),
      interestId: Value(interestId),
      content: Value(content),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SnippetsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetsTableData(
      id: serializer.fromJson<String>(json['id']),
      interestId: serializer.fromJson<String>(json['interestId']),
      content: serializer.fromJson<String>(json['content']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'interestId': serializer.toJson<String>(interestId),
      'content': serializer.toJson<String>(content),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SnippetsTableData copyWith(
          {String? id,
          String? interestId,
          String? content,
          String? source,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SnippetsTableData(
        id: id ?? this.id,
        interestId: interestId ?? this.interestId,
        content: content ?? this.content,
        source: source ?? this.source,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SnippetsTableData copyWithCompanion(SnippetsTableCompanion data) {
    return SnippetsTableData(
      id: data.id.present ? data.id.value : this.id,
      interestId:
          data.interestId.present ? data.interestId.value : this.interestId,
      content: data.content.present ? data.content.value : this.content,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsTableData(')
          ..write('id: $id, ')
          ..write('interestId: $interestId, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, interestId, content, source, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetsTableData &&
          other.id == this.id &&
          other.interestId == this.interestId &&
          other.content == this.content &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SnippetsTableCompanion extends UpdateCompanion<SnippetsTableData> {
  final Value<String> id;
  final Value<String> interestId;
  final Value<String> content;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SnippetsTableCompanion({
    this.id = const Value.absent(),
    this.interestId = const Value.absent(),
    this.content = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetsTableCompanion.insert({
    required String id,
    required String interestId,
    required String content,
    required String source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        interestId = Value(interestId),
        content = Value(content),
        source = Value(source),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SnippetsTableData> custom({
    Expression<String>? id,
    Expression<String>? interestId,
    Expression<String>? content,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (interestId != null) 'interest_id': interestId,
      if (content != null) 'content': content,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? interestId,
      Value<String>? content,
      Value<String>? source,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SnippetsTableCompanion(
      id: id ?? this.id,
      interestId: interestId ?? this.interestId,
      content: content ?? this.content,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (interestId.present) {
      map['interest_id'] = Variable<String>(interestId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsTableCompanion(')
          ..write('id: $id, ')
          ..write('interestId: $interestId, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExposuresTableTable extends ExposuresTable
    with TableInfo<$ExposuresTableTable, ExposuresTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExposuresTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _interestIdMeta =
      const VerificationMeta('interestId');
  @override
  late final GeneratedColumn<String> interestId = GeneratedColumn<String>(
      'interest_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES interests_table(id) ON DELETE CASCADE');
  static const VerificationMeta _snippetIdMeta =
      const VerificationMeta('snippetId');
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
      'snippet_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES snippets_table(id) ON DELETE SET NULL');
  static const VerificationMeta _altInterestIdMeta =
      const VerificationMeta('altInterestId');
  @override
  late final GeneratedColumn<String> altInterestId = GeneratedColumn<String>(
      'alt_interest_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateCodeMeta =
      const VerificationMeta('templateCode');
  @override
  late final GeneratedColumn<String> templateCode = GeneratedColumn<String>(
      'template_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _copyVariantMeta =
      const VerificationMeta('copyVariant');
  @override
  late final GeneratedColumn<String> copyVariant = GeneratedColumn<String>(
      'copy_variant', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voiceMeta = const VerificationMeta('voice');
  @override
  late final GeneratedColumn<String> voice = GeneratedColumn<String>(
      'voice', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelMeta =
      const VerificationMeta('channel');
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
      'channel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _scheduledForMeta =
      const VerificationMeta('scheduledFor');
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
      'scheduled_for', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _surfacedAtMeta =
      const VerificationMeta('surfacedAt');
  @override
  late final GeneratedColumn<DateTime> surfacedAt = GeneratedColumn<DateTime>(
      'surfaced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
      'delivered_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _respondedAtMeta =
      const VerificationMeta('respondedAt');
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
      'responded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reactionMeta =
      const VerificationMeta('reaction');
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
      'reaction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NONE'));
  static const VerificationMeta _respondedViaMeta =
      const VerificationMeta('respondedVia');
  @override
  late final GeneratedColumn<String> respondedVia = GeneratedColumn<String>(
      'responded_via', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _responseTextMeta =
      const VerificationMeta('responseText');
  @override
  late final GeneratedColumn<String> responseText = GeneratedColumn<String>(
      'response_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _planReasonMeta =
      const VerificationMeta('planReason');
  @override
  late final GeneratedColumn<String> planReason = GeneratedColumn<String>(
      'plan_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        interestId,
        snippetId,
        altInterestId,
        kind,
        templateCode,
        copyVariant,
        voice,
        channel,
        notificationId,
        scheduledFor,
        surfacedAt,
        expiresAt,
        deliveredAt,
        respondedAt,
        reaction,
        respondedVia,
        responseText,
        planReason
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exposures_table';
  @override
  VerificationContext validateIntegrity(Insertable<ExposuresTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('interest_id')) {
      context.handle(
          _interestIdMeta,
          interestId.isAcceptableOrUnknown(
              data['interest_id']!, _interestIdMeta));
    } else if (isInserting) {
      context.missing(_interestIdMeta);
    }
    if (data.containsKey('snippet_id')) {
      context.handle(_snippetIdMeta,
          snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta));
    }
    if (data.containsKey('alt_interest_id')) {
      context.handle(
          _altInterestIdMeta,
          altInterestId.isAcceptableOrUnknown(
              data['alt_interest_id']!, _altInterestIdMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('template_code')) {
      context.handle(
          _templateCodeMeta,
          templateCode.isAcceptableOrUnknown(
              data['template_code']!, _templateCodeMeta));
    } else if (isInserting) {
      context.missing(_templateCodeMeta);
    }
    if (data.containsKey('copy_variant')) {
      context.handle(
          _copyVariantMeta,
          copyVariant.isAcceptableOrUnknown(
              data['copy_variant']!, _copyVariantMeta));
    } else if (isInserting) {
      context.missing(_copyVariantMeta);
    }
    if (data.containsKey('voice')) {
      context.handle(
          _voiceMeta, voice.isAcceptableOrUnknown(data['voice']!, _voiceMeta));
    } else if (isInserting) {
      context.missing(_voiceMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(_channelMeta,
          channel.isAcceptableOrUnknown(data['channel']!, _channelMeta));
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
          _scheduledForMeta,
          scheduledFor.isAcceptableOrUnknown(
              data['scheduled_for']!, _scheduledForMeta));
    }
    if (data.containsKey('surfaced_at')) {
      context.handle(
          _surfacedAtMeta,
          surfacedAt.isAcceptableOrUnknown(
              data['surfaced_at']!, _surfacedAtMeta));
    } else if (isInserting) {
      context.missing(_surfacedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    }
    if (data.containsKey('responded_at')) {
      context.handle(
          _respondedAtMeta,
          respondedAt.isAcceptableOrUnknown(
              data['responded_at']!, _respondedAtMeta));
    }
    if (data.containsKey('reaction')) {
      context.handle(_reactionMeta,
          reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta));
    }
    if (data.containsKey('responded_via')) {
      context.handle(
          _respondedViaMeta,
          respondedVia.isAcceptableOrUnknown(
              data['responded_via']!, _respondedViaMeta));
    }
    if (data.containsKey('response_text')) {
      context.handle(
          _responseTextMeta,
          responseText.isAcceptableOrUnknown(
              data['response_text']!, _responseTextMeta));
    }
    if (data.containsKey('plan_reason')) {
      context.handle(
          _planReasonMeta,
          planReason.isAcceptableOrUnknown(
              data['plan_reason']!, _planReasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExposuresTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExposuresTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      interestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interest_id'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id']),
      altInterestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alt_interest_id']),
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      templateCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_code'])!,
      copyVariant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}copy_variant'])!,
      voice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice'])!,
      channel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id']),
      scheduledFor: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_for']),
      surfacedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}surfaced_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivered_at']),
      respondedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}responded_at']),
      reaction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reaction'])!,
      respondedVia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}responded_via']),
      responseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response_text']),
      planReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_reason']),
    );
  }

  @override
  $ExposuresTableTable createAlias(String alias) {
    return $ExposuresTableTable(attachedDatabase, alias);
  }
}

class ExposuresTableData extends DataClass
    implements Insertable<ExposuresTableData> {
  final String id;
  final String interestId;
  final String? snippetId;
  final String? altInterestId;
  final String kind;
  final String templateCode;
  final String copyVariant;
  final String voice;
  final String channel;
  final int? notificationId;
  final DateTime? scheduledFor;
  final DateTime surfacedAt;
  final DateTime? expiresAt;
  final DateTime? deliveredAt;
  final DateTime? respondedAt;
  final String reaction;
  final String? respondedVia;
  final String? responseText;
  final String? planReason;
  const ExposuresTableData(
      {required this.id,
      required this.interestId,
      this.snippetId,
      this.altInterestId,
      required this.kind,
      required this.templateCode,
      required this.copyVariant,
      required this.voice,
      required this.channel,
      this.notificationId,
      this.scheduledFor,
      required this.surfacedAt,
      this.expiresAt,
      this.deliveredAt,
      this.respondedAt,
      required this.reaction,
      this.respondedVia,
      this.responseText,
      this.planReason});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['interest_id'] = Variable<String>(interestId);
    if (!nullToAbsent || snippetId != null) {
      map['snippet_id'] = Variable<String>(snippetId);
    }
    if (!nullToAbsent || altInterestId != null) {
      map['alt_interest_id'] = Variable<String>(altInterestId);
    }
    map['kind'] = Variable<String>(kind);
    map['template_code'] = Variable<String>(templateCode);
    map['copy_variant'] = Variable<String>(copyVariant);
    map['voice'] = Variable<String>(voice);
    map['channel'] = Variable<String>(channel);
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    if (!nullToAbsent || scheduledFor != null) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    }
    map['surfaced_at'] = Variable<DateTime>(surfacedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    map['reaction'] = Variable<String>(reaction);
    if (!nullToAbsent || respondedVia != null) {
      map['responded_via'] = Variable<String>(respondedVia);
    }
    if (!nullToAbsent || responseText != null) {
      map['response_text'] = Variable<String>(responseText);
    }
    if (!nullToAbsent || planReason != null) {
      map['plan_reason'] = Variable<String>(planReason);
    }
    return map;
  }

  ExposuresTableCompanion toCompanion(bool nullToAbsent) {
    return ExposuresTableCompanion(
      id: Value(id),
      interestId: Value(interestId),
      snippetId: snippetId == null && nullToAbsent
          ? const Value.absent()
          : Value(snippetId),
      altInterestId: altInterestId == null && nullToAbsent
          ? const Value.absent()
          : Value(altInterestId),
      kind: Value(kind),
      templateCode: Value(templateCode),
      copyVariant: Value(copyVariant),
      voice: Value(voice),
      channel: Value(channel),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      scheduledFor: scheduledFor == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledFor),
      surfacedAt: Value(surfacedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
      reaction: Value(reaction),
      respondedVia: respondedVia == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedVia),
      responseText: responseText == null && nullToAbsent
          ? const Value.absent()
          : Value(responseText),
      planReason: planReason == null && nullToAbsent
          ? const Value.absent()
          : Value(planReason),
    );
  }

  factory ExposuresTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExposuresTableData(
      id: serializer.fromJson<String>(json['id']),
      interestId: serializer.fromJson<String>(json['interestId']),
      snippetId: serializer.fromJson<String?>(json['snippetId']),
      altInterestId: serializer.fromJson<String?>(json['altInterestId']),
      kind: serializer.fromJson<String>(json['kind']),
      templateCode: serializer.fromJson<String>(json['templateCode']),
      copyVariant: serializer.fromJson<String>(json['copyVariant']),
      voice: serializer.fromJson<String>(json['voice']),
      channel: serializer.fromJson<String>(json['channel']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      scheduledFor: serializer.fromJson<DateTime?>(json['scheduledFor']),
      surfacedAt: serializer.fromJson<DateTime>(json['surfacedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
      reaction: serializer.fromJson<String>(json['reaction']),
      respondedVia: serializer.fromJson<String?>(json['respondedVia']),
      responseText: serializer.fromJson<String?>(json['responseText']),
      planReason: serializer.fromJson<String?>(json['planReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'interestId': serializer.toJson<String>(interestId),
      'snippetId': serializer.toJson<String?>(snippetId),
      'altInterestId': serializer.toJson<String?>(altInterestId),
      'kind': serializer.toJson<String>(kind),
      'templateCode': serializer.toJson<String>(templateCode),
      'copyVariant': serializer.toJson<String>(copyVariant),
      'voice': serializer.toJson<String>(voice),
      'channel': serializer.toJson<String>(channel),
      'notificationId': serializer.toJson<int?>(notificationId),
      'scheduledFor': serializer.toJson<DateTime?>(scheduledFor),
      'surfacedAt': serializer.toJson<DateTime>(surfacedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
      'reaction': serializer.toJson<String>(reaction),
      'respondedVia': serializer.toJson<String?>(respondedVia),
      'responseText': serializer.toJson<String?>(responseText),
      'planReason': serializer.toJson<String?>(planReason),
    };
  }

  ExposuresTableData copyWith(
          {String? id,
          String? interestId,
          Value<String?> snippetId = const Value.absent(),
          Value<String?> altInterestId = const Value.absent(),
          String? kind,
          String? templateCode,
          String? copyVariant,
          String? voice,
          String? channel,
          Value<int?> notificationId = const Value.absent(),
          Value<DateTime?> scheduledFor = const Value.absent(),
          DateTime? surfacedAt,
          Value<DateTime?> expiresAt = const Value.absent(),
          Value<DateTime?> deliveredAt = const Value.absent(),
          Value<DateTime?> respondedAt = const Value.absent(),
          String? reaction,
          Value<String?> respondedVia = const Value.absent(),
          Value<String?> responseText = const Value.absent(),
          Value<String?> planReason = const Value.absent()}) =>
      ExposuresTableData(
        id: id ?? this.id,
        interestId: interestId ?? this.interestId,
        snippetId: snippetId.present ? snippetId.value : this.snippetId,
        altInterestId:
            altInterestId.present ? altInterestId.value : this.altInterestId,
        kind: kind ?? this.kind,
        templateCode: templateCode ?? this.templateCode,
        copyVariant: copyVariant ?? this.copyVariant,
        voice: voice ?? this.voice,
        channel: channel ?? this.channel,
        notificationId:
            notificationId.present ? notificationId.value : this.notificationId,
        scheduledFor:
            scheduledFor.present ? scheduledFor.value : this.scheduledFor,
        surfacedAt: surfacedAt ?? this.surfacedAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
        respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
        reaction: reaction ?? this.reaction,
        respondedVia:
            respondedVia.present ? respondedVia.value : this.respondedVia,
        responseText:
            responseText.present ? responseText.value : this.responseText,
        planReason: planReason.present ? planReason.value : this.planReason,
      );
  ExposuresTableData copyWithCompanion(ExposuresTableCompanion data) {
    return ExposuresTableData(
      id: data.id.present ? data.id.value : this.id,
      interestId:
          data.interestId.present ? data.interestId.value : this.interestId,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      altInterestId: data.altInterestId.present
          ? data.altInterestId.value
          : this.altInterestId,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateCode: data.templateCode.present
          ? data.templateCode.value
          : this.templateCode,
      copyVariant:
          data.copyVariant.present ? data.copyVariant.value : this.copyVariant,
      voice: data.voice.present ? data.voice.value : this.voice,
      channel: data.channel.present ? data.channel.value : this.channel,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      surfacedAt:
          data.surfacedAt.present ? data.surfacedAt.value : this.surfacedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      deliveredAt:
          data.deliveredAt.present ? data.deliveredAt.value : this.deliveredAt,
      respondedAt:
          data.respondedAt.present ? data.respondedAt.value : this.respondedAt,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      respondedVia: data.respondedVia.present
          ? data.respondedVia.value
          : this.respondedVia,
      responseText: data.responseText.present
          ? data.responseText.value
          : this.responseText,
      planReason:
          data.planReason.present ? data.planReason.value : this.planReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExposuresTableData(')
          ..write('id: $id, ')
          ..write('interestId: $interestId, ')
          ..write('snippetId: $snippetId, ')
          ..write('altInterestId: $altInterestId, ')
          ..write('kind: $kind, ')
          ..write('templateCode: $templateCode, ')
          ..write('copyVariant: $copyVariant, ')
          ..write('voice: $voice, ')
          ..write('channel: $channel, ')
          ..write('notificationId: $notificationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('surfacedAt: $surfacedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('reaction: $reaction, ')
          ..write('respondedVia: $respondedVia, ')
          ..write('responseText: $responseText, ')
          ..write('planReason: $planReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      interestId,
      snippetId,
      altInterestId,
      kind,
      templateCode,
      copyVariant,
      voice,
      channel,
      notificationId,
      scheduledFor,
      surfacedAt,
      expiresAt,
      deliveredAt,
      respondedAt,
      reaction,
      respondedVia,
      responseText,
      planReason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExposuresTableData &&
          other.id == this.id &&
          other.interestId == this.interestId &&
          other.snippetId == this.snippetId &&
          other.altInterestId == this.altInterestId &&
          other.kind == this.kind &&
          other.templateCode == this.templateCode &&
          other.copyVariant == this.copyVariant &&
          other.voice == this.voice &&
          other.channel == this.channel &&
          other.notificationId == this.notificationId &&
          other.scheduledFor == this.scheduledFor &&
          other.surfacedAt == this.surfacedAt &&
          other.expiresAt == this.expiresAt &&
          other.deliveredAt == this.deliveredAt &&
          other.respondedAt == this.respondedAt &&
          other.reaction == this.reaction &&
          other.respondedVia == this.respondedVia &&
          other.responseText == this.responseText &&
          other.planReason == this.planReason);
}

class ExposuresTableCompanion extends UpdateCompanion<ExposuresTableData> {
  final Value<String> id;
  final Value<String> interestId;
  final Value<String?> snippetId;
  final Value<String?> altInterestId;
  final Value<String> kind;
  final Value<String> templateCode;
  final Value<String> copyVariant;
  final Value<String> voice;
  final Value<String> channel;
  final Value<int?> notificationId;
  final Value<DateTime?> scheduledFor;
  final Value<DateTime> surfacedAt;
  final Value<DateTime?> expiresAt;
  final Value<DateTime?> deliveredAt;
  final Value<DateTime?> respondedAt;
  final Value<String> reaction;
  final Value<String?> respondedVia;
  final Value<String?> responseText;
  final Value<String?> planReason;
  final Value<int> rowid;
  const ExposuresTableCompanion({
    this.id = const Value.absent(),
    this.interestId = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.altInterestId = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateCode = const Value.absent(),
    this.copyVariant = const Value.absent(),
    this.voice = const Value.absent(),
    this.channel = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.surfacedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.reaction = const Value.absent(),
    this.respondedVia = const Value.absent(),
    this.responseText = const Value.absent(),
    this.planReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExposuresTableCompanion.insert({
    required String id,
    required String interestId,
    this.snippetId = const Value.absent(),
    this.altInterestId = const Value.absent(),
    required String kind,
    required String templateCode,
    required String copyVariant,
    required String voice,
    required String channel,
    this.notificationId = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    required DateTime surfacedAt,
    this.expiresAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.reaction = const Value.absent(),
    this.respondedVia = const Value.absent(),
    this.responseText = const Value.absent(),
    this.planReason = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        interestId = Value(interestId),
        kind = Value(kind),
        templateCode = Value(templateCode),
        copyVariant = Value(copyVariant),
        voice = Value(voice),
        channel = Value(channel),
        surfacedAt = Value(surfacedAt);
  static Insertable<ExposuresTableData> custom({
    Expression<String>? id,
    Expression<String>? interestId,
    Expression<String>? snippetId,
    Expression<String>? altInterestId,
    Expression<String>? kind,
    Expression<String>? templateCode,
    Expression<String>? copyVariant,
    Expression<String>? voice,
    Expression<String>? channel,
    Expression<int>? notificationId,
    Expression<DateTime>? scheduledFor,
    Expression<DateTime>? surfacedAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? deliveredAt,
    Expression<DateTime>? respondedAt,
    Expression<String>? reaction,
    Expression<String>? respondedVia,
    Expression<String>? responseText,
    Expression<String>? planReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (interestId != null) 'interest_id': interestId,
      if (snippetId != null) 'snippet_id': snippetId,
      if (altInterestId != null) 'alt_interest_id': altInterestId,
      if (kind != null) 'kind': kind,
      if (templateCode != null) 'template_code': templateCode,
      if (copyVariant != null) 'copy_variant': copyVariant,
      if (voice != null) 'voice': voice,
      if (channel != null) 'channel': channel,
      if (notificationId != null) 'notification_id': notificationId,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (surfacedAt != null) 'surfaced_at': surfacedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (reaction != null) 'reaction': reaction,
      if (respondedVia != null) 'responded_via': respondedVia,
      if (responseText != null) 'response_text': responseText,
      if (planReason != null) 'plan_reason': planReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExposuresTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? interestId,
      Value<String?>? snippetId,
      Value<String?>? altInterestId,
      Value<String>? kind,
      Value<String>? templateCode,
      Value<String>? copyVariant,
      Value<String>? voice,
      Value<String>? channel,
      Value<int?>? notificationId,
      Value<DateTime?>? scheduledFor,
      Value<DateTime>? surfacedAt,
      Value<DateTime?>? expiresAt,
      Value<DateTime?>? deliveredAt,
      Value<DateTime?>? respondedAt,
      Value<String>? reaction,
      Value<String?>? respondedVia,
      Value<String?>? responseText,
      Value<String?>? planReason,
      Value<int>? rowid}) {
    return ExposuresTableCompanion(
      id: id ?? this.id,
      interestId: interestId ?? this.interestId,
      snippetId: snippetId ?? this.snippetId,
      altInterestId: altInterestId ?? this.altInterestId,
      kind: kind ?? this.kind,
      templateCode: templateCode ?? this.templateCode,
      copyVariant: copyVariant ?? this.copyVariant,
      voice: voice ?? this.voice,
      channel: channel ?? this.channel,
      notificationId: notificationId ?? this.notificationId,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      surfacedAt: surfacedAt ?? this.surfacedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      respondedAt: respondedAt ?? this.respondedAt,
      reaction: reaction ?? this.reaction,
      respondedVia: respondedVia ?? this.respondedVia,
      responseText: responseText ?? this.responseText,
      planReason: planReason ?? this.planReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (interestId.present) {
      map['interest_id'] = Variable<String>(interestId.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (altInterestId.present) {
      map['alt_interest_id'] = Variable<String>(altInterestId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (templateCode.present) {
      map['template_code'] = Variable<String>(templateCode.value);
    }
    if (copyVariant.present) {
      map['copy_variant'] = Variable<String>(copyVariant.value);
    }
    if (voice.present) {
      map['voice'] = Variable<String>(voice.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (surfacedAt.present) {
      map['surfaced_at'] = Variable<DateTime>(surfacedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (respondedVia.present) {
      map['responded_via'] = Variable<String>(respondedVia.value);
    }
    if (responseText.present) {
      map['response_text'] = Variable<String>(responseText.value);
    }
    if (planReason.present) {
      map['plan_reason'] = Variable<String>(planReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExposuresTableCompanion(')
          ..write('id: $id, ')
          ..write('interestId: $interestId, ')
          ..write('snippetId: $snippetId, ')
          ..write('altInterestId: $altInterestId, ')
          ..write('kind: $kind, ')
          ..write('templateCode: $templateCode, ')
          ..write('copyVariant: $copyVariant, ')
          ..write('voice: $voice, ')
          ..write('channel: $channel, ')
          ..write('notificationId: $notificationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('surfacedAt: $surfacedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('reaction: $reaction, ')
          ..write('respondedVia: $respondedVia, ')
          ..write('responseText: $responseText, ')
          ..write('planReason: $planReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalyticsEventsTableTable extends AnalyticsEventsTable
    with TableInfo<$AnalyticsEventsTableTable, AnalyticsEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalyticsEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<DateTime> ts = GeneratedColumn<DateTime>(
      'ts', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _localDateMeta =
      const VerificationMeta('localDate');
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
      'local_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localHourMeta =
      const VerificationMeta('localHour');
  @override
  late final GeneratedColumn<int> localHour = GeneratedColumn<int>(
      'local_hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exposureIdMeta =
      const VerificationMeta('exposureId');
  @override
  late final GeneratedColumn<String> exposureId = GeneratedColumn<String>(
      'exposure_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _interestIdMeta =
      const VerificationMeta('interestId');
  @override
  late final GeneratedColumn<String> interestId = GeneratedColumn<String>(
      'interest_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _propsMeta = const VerificationMeta('props');
  @override
  late final GeneratedColumn<String> props = GeneratedColumn<String>(
      'props', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ts, localDate, localHour, type, exposureId, interestId, props];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analytics_events_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AnalyticsEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(_localDateMeta,
          localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta));
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_hour')) {
      context.handle(_localHourMeta,
          localHour.isAcceptableOrUnknown(data['local_hour']!, _localHourMeta));
    } else if (isInserting) {
      context.missing(_localHourMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('exposure_id')) {
      context.handle(
          _exposureIdMeta,
          exposureId.isAcceptableOrUnknown(
              data['exposure_id']!, _exposureIdMeta));
    }
    if (data.containsKey('interest_id')) {
      context.handle(
          _interestIdMeta,
          interestId.isAcceptableOrUnknown(
              data['interest_id']!, _interestIdMeta));
    }
    if (data.containsKey('props')) {
      context.handle(
          _propsMeta, props.isAcceptableOrUnknown(data['props']!, _propsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalyticsEventsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalyticsEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ts'])!,
      localDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_date'])!,
      localHour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_hour'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      exposureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exposure_id']),
      interestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interest_id']),
      props: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}props']),
    );
  }

  @override
  $AnalyticsEventsTableTable createAlias(String alias) {
    return $AnalyticsEventsTableTable(attachedDatabase, alias);
  }
}

class AnalyticsEventsTableData extends DataClass
    implements Insertable<AnalyticsEventsTableData> {
  final int id;
  final DateTime ts;
  final String localDate;
  final int localHour;
  final String type;
  final String? exposureId;
  final String? interestId;
  final String? props;
  const AnalyticsEventsTableData(
      {required this.id,
      required this.ts,
      required this.localDate,
      required this.localHour,
      required this.type,
      this.exposureId,
      this.interestId,
      this.props});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    map['local_date'] = Variable<String>(localDate);
    map['local_hour'] = Variable<int>(localHour);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || exposureId != null) {
      map['exposure_id'] = Variable<String>(exposureId);
    }
    if (!nullToAbsent || interestId != null) {
      map['interest_id'] = Variable<String>(interestId);
    }
    if (!nullToAbsent || props != null) {
      map['props'] = Variable<String>(props);
    }
    return map;
  }

  AnalyticsEventsTableCompanion toCompanion(bool nullToAbsent) {
    return AnalyticsEventsTableCompanion(
      id: Value(id),
      ts: Value(ts),
      localDate: Value(localDate),
      localHour: Value(localHour),
      type: Value(type),
      exposureId: exposureId == null && nullToAbsent
          ? const Value.absent()
          : Value(exposureId),
      interestId: interestId == null && nullToAbsent
          ? const Value.absent()
          : Value(interestId),
      props:
          props == null && nullToAbsent ? const Value.absent() : Value(props),
    );
  }

  factory AnalyticsEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalyticsEventsTableData(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localHour: serializer.fromJson<int>(json['localHour']),
      type: serializer.fromJson<String>(json['type']),
      exposureId: serializer.fromJson<String?>(json['exposureId']),
      interestId: serializer.fromJson<String?>(json['interestId']),
      props: serializer.fromJson<String?>(json['props']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'localDate': serializer.toJson<String>(localDate),
      'localHour': serializer.toJson<int>(localHour),
      'type': serializer.toJson<String>(type),
      'exposureId': serializer.toJson<String?>(exposureId),
      'interestId': serializer.toJson<String?>(interestId),
      'props': serializer.toJson<String?>(props),
    };
  }

  AnalyticsEventsTableData copyWith(
          {int? id,
          DateTime? ts,
          String? localDate,
          int? localHour,
          String? type,
          Value<String?> exposureId = const Value.absent(),
          Value<String?> interestId = const Value.absent(),
          Value<String?> props = const Value.absent()}) =>
      AnalyticsEventsTableData(
        id: id ?? this.id,
        ts: ts ?? this.ts,
        localDate: localDate ?? this.localDate,
        localHour: localHour ?? this.localHour,
        type: type ?? this.type,
        exposureId: exposureId.present ? exposureId.value : this.exposureId,
        interestId: interestId.present ? interestId.value : this.interestId,
        props: props.present ? props.value : this.props,
      );
  AnalyticsEventsTableData copyWithCompanion(
      AnalyticsEventsTableCompanion data) {
    return AnalyticsEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localHour: data.localHour.present ? data.localHour.value : this.localHour,
      type: data.type.present ? data.type.value : this.type,
      exposureId:
          data.exposureId.present ? data.exposureId.value : this.exposureId,
      interestId:
          data.interestId.present ? data.interestId.value : this.interestId,
      props: data.props.present ? data.props.value : this.props,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsEventsTableData(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('localDate: $localDate, ')
          ..write('localHour: $localHour, ')
          ..write('type: $type, ')
          ..write('exposureId: $exposureId, ')
          ..write('interestId: $interestId, ')
          ..write('props: $props')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, ts, localDate, localHour, type, exposureId, interestId, props);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalyticsEventsTableData &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.localDate == this.localDate &&
          other.localHour == this.localHour &&
          other.type == this.type &&
          other.exposureId == this.exposureId &&
          other.interestId == this.interestId &&
          other.props == this.props);
}

class AnalyticsEventsTableCompanion
    extends UpdateCompanion<AnalyticsEventsTableData> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<String> localDate;
  final Value<int> localHour;
  final Value<String> type;
  final Value<String?> exposureId;
  final Value<String?> interestId;
  final Value<String?> props;
  const AnalyticsEventsTableCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localHour = const Value.absent(),
    this.type = const Value.absent(),
    this.exposureId = const Value.absent(),
    this.interestId = const Value.absent(),
    this.props = const Value.absent(),
  });
  AnalyticsEventsTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required String localDate,
    required int localHour,
    required String type,
    this.exposureId = const Value.absent(),
    this.interestId = const Value.absent(),
    this.props = const Value.absent(),
  })  : ts = Value(ts),
        localDate = Value(localDate),
        localHour = Value(localHour),
        type = Value(type);
  static Insertable<AnalyticsEventsTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<String>? localDate,
    Expression<int>? localHour,
    Expression<String>? type,
    Expression<String>? exposureId,
    Expression<String>? interestId,
    Expression<String>? props,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (localDate != null) 'local_date': localDate,
      if (localHour != null) 'local_hour': localHour,
      if (type != null) 'type': type,
      if (exposureId != null) 'exposure_id': exposureId,
      if (interestId != null) 'interest_id': interestId,
      if (props != null) 'props': props,
    });
  }

  AnalyticsEventsTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? ts,
      Value<String>? localDate,
      Value<int>? localHour,
      Value<String>? type,
      Value<String?>? exposureId,
      Value<String?>? interestId,
      Value<String?>? props}) {
    return AnalyticsEventsTableCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      localDate: localDate ?? this.localDate,
      localHour: localHour ?? this.localHour,
      type: type ?? this.type,
      exposureId: exposureId ?? this.exposureId,
      interestId: interestId ?? this.interestId,
      props: props ?? this.props,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ts.present) {
      map['ts'] = Variable<DateTime>(ts.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localHour.present) {
      map['local_hour'] = Variable<int>(localHour.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (exposureId.present) {
      map['exposure_id'] = Variable<String>(exposureId.value);
    }
    if (interestId.present) {
      map['interest_id'] = Variable<String>(interestId.value);
    }
    if (props.present) {
      map['props'] = Variable<String>(props.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('localDate: $localDate, ')
          ..write('localHour: $localHour, ')
          ..write('type: $type, ')
          ..write('exposureId: $exposureId, ')
          ..write('interestId: $interestId, ')
          ..write('props: $props')
          ..write(')'))
        .toString();
  }
}

class $AnalyticsDailyTableTable extends AnalyticsDailyTable
    with TableInfo<$AnalyticsDailyTableTable, AnalyticsDailyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalyticsDailyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta =
      const VerificationMeta('localDate');
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
      'local_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
      'metric', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dimensionMeta =
      const VerificationMeta('dimension');
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
      'dimension', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [localDate, metric, dimension, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analytics_daily_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AnalyticsDailyTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(_localDateMeta,
          localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta));
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(_metricMeta,
          metric.isAcceptableOrUnknown(data['metric']!, _metricMeta));
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('dimension')) {
      context.handle(_dimensionMeta,
          dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta));
    } else if (isInserting) {
      context.missing(_dimensionMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate, metric, dimension};
  @override
  AnalyticsDailyTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalyticsDailyTableData(
      localDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_date'])!,
      metric: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metric'])!,
      dimension: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dimension'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AnalyticsDailyTableTable createAlias(String alias) {
    return $AnalyticsDailyTableTable(attachedDatabase, alias);
  }
}

class AnalyticsDailyTableData extends DataClass
    implements Insertable<AnalyticsDailyTableData> {
  final String localDate;
  final String metric;
  final String dimension;
  final double value;
  const AnalyticsDailyTableData(
      {required this.localDate,
      required this.metric,
      required this.dimension,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['metric'] = Variable<String>(metric);
    map['dimension'] = Variable<String>(dimension);
    map['value'] = Variable<double>(value);
    return map;
  }

  AnalyticsDailyTableCompanion toCompanion(bool nullToAbsent) {
    return AnalyticsDailyTableCompanion(
      localDate: Value(localDate),
      metric: Value(metric),
      dimension: Value(dimension),
      value: Value(value),
    );
  }

  factory AnalyticsDailyTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalyticsDailyTableData(
      localDate: serializer.fromJson<String>(json['localDate']),
      metric: serializer.fromJson<String>(json['metric']),
      dimension: serializer.fromJson<String>(json['dimension']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDate': serializer.toJson<String>(localDate),
      'metric': serializer.toJson<String>(metric),
      'dimension': serializer.toJson<String>(dimension),
      'value': serializer.toJson<double>(value),
    };
  }

  AnalyticsDailyTableData copyWith(
          {String? localDate,
          String? metric,
          String? dimension,
          double? value}) =>
      AnalyticsDailyTableData(
        localDate: localDate ?? this.localDate,
        metric: metric ?? this.metric,
        dimension: dimension ?? this.dimension,
        value: value ?? this.value,
      );
  AnalyticsDailyTableData copyWithCompanion(AnalyticsDailyTableCompanion data) {
    return AnalyticsDailyTableData(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      metric: data.metric.present ? data.metric.value : this.metric,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsDailyTableData(')
          ..write('localDate: $localDate, ')
          ..write('metric: $metric, ')
          ..write('dimension: $dimension, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localDate, metric, dimension, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalyticsDailyTableData &&
          other.localDate == this.localDate &&
          other.metric == this.metric &&
          other.dimension == this.dimension &&
          other.value == this.value);
}

class AnalyticsDailyTableCompanion
    extends UpdateCompanion<AnalyticsDailyTableData> {
  final Value<String> localDate;
  final Value<String> metric;
  final Value<String> dimension;
  final Value<double> value;
  final Value<int> rowid;
  const AnalyticsDailyTableCompanion({
    this.localDate = const Value.absent(),
    this.metric = const Value.absent(),
    this.dimension = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalyticsDailyTableCompanion.insert({
    required String localDate,
    required String metric,
    required String dimension,
    required double value,
    this.rowid = const Value.absent(),
  })  : localDate = Value(localDate),
        metric = Value(metric),
        dimension = Value(dimension),
        value = Value(value);
  static Insertable<AnalyticsDailyTableData> custom({
    Expression<String>? localDate,
    Expression<String>? metric,
    Expression<String>? dimension,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (metric != null) 'metric': metric,
      if (dimension != null) 'dimension': dimension,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalyticsDailyTableCompanion copyWith(
      {Value<String>? localDate,
      Value<String>? metric,
      Value<String>? dimension,
      Value<double>? value,
      Value<int>? rowid}) {
    return AnalyticsDailyTableCompanion(
      localDate: localDate ?? this.localDate,
      metric: metric ?? this.metric,
      dimension: dimension ?? this.dimension,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsDailyTableCompanion(')
          ..write('localDate: $localDate, ')
          ..write('metric: $metric, ')
          ..write('dimension: $dimension, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ErrorLogsTableTable extends ErrorLogsTable
    with TableInfo<$ErrorLogsTableTable, ErrorLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErrorLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<DateTime> ts = GeneratedColumn<DateTime>(
      'ts', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _stackMeta = const VerificationMeta('stack');
  @override
  late final GeneratedColumn<String> stack = GeneratedColumn<String>(
      'stack', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 4096),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, ts, source, message, stack];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'error_logs_table';
  @override
  VerificationContext validateIntegrity(Insertable<ErrorLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('stack')) {
      context.handle(
          _stackMeta, stack.isAcceptableOrUnknown(data['stack']!, _stackMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ErrorLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErrorLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ts'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      stack: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stack']),
    );
  }

  @override
  $ErrorLogsTableTable createAlias(String alias) {
    return $ErrorLogsTableTable(attachedDatabase, alias);
  }
}

class ErrorLogsTableData extends DataClass
    implements Insertable<ErrorLogsTableData> {
  final int id;
  final DateTime ts;
  final String source;
  final String message;
  final String? stack;
  const ErrorLogsTableData(
      {required this.id,
      required this.ts,
      required this.source,
      required this.message,
      this.stack});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    map['source'] = Variable<String>(source);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || stack != null) {
      map['stack'] = Variable<String>(stack);
    }
    return map;
  }

  ErrorLogsTableCompanion toCompanion(bool nullToAbsent) {
    return ErrorLogsTableCompanion(
      id: Value(id),
      ts: Value(ts),
      source: Value(source),
      message: Value(message),
      stack:
          stack == null && nullToAbsent ? const Value.absent() : Value(stack),
    );
  }

  factory ErrorLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErrorLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      source: serializer.fromJson<String>(json['source']),
      message: serializer.fromJson<String>(json['message']),
      stack: serializer.fromJson<String?>(json['stack']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'source': serializer.toJson<String>(source),
      'message': serializer.toJson<String>(message),
      'stack': serializer.toJson<String?>(stack),
    };
  }

  ErrorLogsTableData copyWith(
          {int? id,
          DateTime? ts,
          String? source,
          String? message,
          Value<String?> stack = const Value.absent()}) =>
      ErrorLogsTableData(
        id: id ?? this.id,
        ts: ts ?? this.ts,
        source: source ?? this.source,
        message: message ?? this.message,
        stack: stack.present ? stack.value : this.stack,
      );
  ErrorLogsTableData copyWithCompanion(ErrorLogsTableCompanion data) {
    return ErrorLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      source: data.source.present ? data.source.value : this.source,
      message: data.message.present ? data.message.value : this.message,
      stack: data.stack.present ? data.stack.value : this.stack,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErrorLogsTableData(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('source: $source, ')
          ..write('message: $message, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ts, source, message, stack);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorLogsTableData &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.source == this.source &&
          other.message == this.message &&
          other.stack == this.stack);
}

class ErrorLogsTableCompanion extends UpdateCompanion<ErrorLogsTableData> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<String> source;
  final Value<String> message;
  final Value<String?> stack;
  const ErrorLogsTableCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.source = const Value.absent(),
    this.message = const Value.absent(),
    this.stack = const Value.absent(),
  });
  ErrorLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required String source,
    required String message,
    this.stack = const Value.absent(),
  })  : ts = Value(ts),
        source = Value(source),
        message = Value(message);
  static Insertable<ErrorLogsTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<String>? source,
    Expression<String>? message,
    Expression<String>? stack,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (source != null) 'source': source,
      if (message != null) 'message': message,
      if (stack != null) 'stack': stack,
    });
  }

  ErrorLogsTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? ts,
      Value<String>? source,
      Value<String>? message,
      Value<String?>? stack}) {
    return ErrorLogsTableCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      source: source ?? this.source,
      message: message ?? this.message,
      stack: stack ?? this.stack,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ts.present) {
      map['ts'] = Variable<DateTime>(ts.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (stack.present) {
      map['stack'] = Variable<String>(stack.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErrorLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('source: $source, ')
          ..write('message: $message, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startLocalMeta =
      const VerificationMeta('startLocal');
  @override
  late final GeneratedColumn<DateTime> startLocal = GeneratedColumn<DateTime>(
      'start_local', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _timezoneIdMeta =
      const VerificationMeta('timezoneId');
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
      'timezone_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nextOccurrenceUtcMeta =
      const VerificationMeta('nextOccurrenceUtc');
  @override
  late final GeneratedColumn<DateTime> nextOccurrenceUtc =
      GeneratedColumn<DateTime>('next_occurrence_utc', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _scheduleVersionMeta =
      const VerificationMeta('scheduleVersion');
  @override
  late final GeneratedColumn<int> scheduleVersion = GeneratedColumn<int>(
      'schedule_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
      'notification_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _linkedActivityIdMeta =
      const VerificationMeta('linkedActivityId');
  @override
  late final GeneratedColumn<String> linkedActivityId = GeneratedColumn<String>(
      'linked_activity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        status,
        scheduleType,
        startLocal,
        timezoneId,
        nextOccurrenceUtc,
        scheduleVersion,
        notificationEnabled,
        linkedActivityId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<RemindersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('start_local')) {
      context.handle(
          _startLocalMeta,
          startLocal.isAcceptableOrUnknown(
              data['start_local']!, _startLocalMeta));
    } else if (isInserting) {
      context.missing(_startLocalMeta);
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
          _timezoneIdMeta,
          timezoneId.isAcceptableOrUnknown(
              data['timezone_id']!, _timezoneIdMeta));
    } else if (isInserting) {
      context.missing(_timezoneIdMeta);
    }
    if (data.containsKey('next_occurrence_utc')) {
      context.handle(
          _nextOccurrenceUtcMeta,
          nextOccurrenceUtc.isAcceptableOrUnknown(
              data['next_occurrence_utc']!, _nextOccurrenceUtcMeta));
    }
    if (data.containsKey('schedule_version')) {
      context.handle(
          _scheduleVersionMeta,
          scheduleVersion.isAcceptableOrUnknown(
              data['schedule_version']!, _scheduleVersionMeta));
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
          _notificationEnabledMeta,
          notificationEnabled.isAcceptableOrUnknown(
              data['notification_enabled']!, _notificationEnabledMeta));
    }
    if (data.containsKey('linked_activity_id')) {
      context.handle(
          _linkedActivityIdMeta,
          linkedActivityId.isAcceptableOrUnknown(
              data['linked_activity_id']!, _linkedActivityIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      startLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_local'])!,
      timezoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone_id'])!,
      nextOccurrenceUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_occurrence_utc']),
      scheduleVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}schedule_version'])!,
      notificationEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notification_enabled'])!,
      linkedActivityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_activity_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String scheduleType;
  final DateTime startLocal;
  final String timezoneId;
  final DateTime? nextOccurrenceUtc;
  final int scheduleVersion;
  final bool notificationEnabled;
  final String? linkedActivityId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RemindersTableData(
      {required this.id,
      required this.title,
      this.description,
      required this.status,
      required this.scheduleType,
      required this.startLocal,
      required this.timezoneId,
      this.nextOccurrenceUtc,
      required this.scheduleVersion,
      required this.notificationEnabled,
      this.linkedActivityId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['start_local'] = Variable<DateTime>(startLocal);
    map['timezone_id'] = Variable<String>(timezoneId);
    if (!nullToAbsent || nextOccurrenceUtc != null) {
      map['next_occurrence_utc'] = Variable<DateTime>(nextOccurrenceUtc);
    }
    map['schedule_version'] = Variable<int>(scheduleVersion);
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    if (!nullToAbsent || linkedActivityId != null) {
      map['linked_activity_id'] = Variable<String>(linkedActivityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      scheduleType: Value(scheduleType),
      startLocal: Value(startLocal),
      timezoneId: Value(timezoneId),
      nextOccurrenceUtc: nextOccurrenceUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(nextOccurrenceUtc),
      scheduleVersion: Value(scheduleVersion),
      notificationEnabled: Value(notificationEnabled),
      linkedActivityId: linkedActivityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedActivityId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RemindersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      startLocal: serializer.fromJson<DateTime>(json['startLocal']),
      timezoneId: serializer.fromJson<String>(json['timezoneId']),
      nextOccurrenceUtc:
          serializer.fromJson<DateTime?>(json['nextOccurrenceUtc']),
      scheduleVersion: serializer.fromJson<int>(json['scheduleVersion']),
      notificationEnabled:
          serializer.fromJson<bool>(json['notificationEnabled']),
      linkedActivityId: serializer.fromJson<String?>(json['linkedActivityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'startLocal': serializer.toJson<DateTime>(startLocal),
      'timezoneId': serializer.toJson<String>(timezoneId),
      'nextOccurrenceUtc': serializer.toJson<DateTime?>(nextOccurrenceUtc),
      'scheduleVersion': serializer.toJson<int>(scheduleVersion),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
      'linkedActivityId': serializer.toJson<String?>(linkedActivityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RemindersTableData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? status,
          String? scheduleType,
          DateTime? startLocal,
          String? timezoneId,
          Value<DateTime?> nextOccurrenceUtc = const Value.absent(),
          int? scheduleVersion,
          bool? notificationEnabled,
          Value<String?> linkedActivityId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RemindersTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        status: status ?? this.status,
        scheduleType: scheduleType ?? this.scheduleType,
        startLocal: startLocal ?? this.startLocal,
        timezoneId: timezoneId ?? this.timezoneId,
        nextOccurrenceUtc: nextOccurrenceUtc.present
            ? nextOccurrenceUtc.value
            : this.nextOccurrenceUtc,
        scheduleVersion: scheduleVersion ?? this.scheduleVersion,
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        linkedActivityId: linkedActivityId.present
            ? linkedActivityId.value
            : this.linkedActivityId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      startLocal:
          data.startLocal.present ? data.startLocal.value : this.startLocal,
      timezoneId:
          data.timezoneId.present ? data.timezoneId.value : this.timezoneId,
      nextOccurrenceUtc: data.nextOccurrenceUtc.present
          ? data.nextOccurrenceUtc.value
          : this.nextOccurrenceUtc,
      scheduleVersion: data.scheduleVersion.present
          ? data.scheduleVersion.value
          : this.scheduleVersion,
      notificationEnabled: data.notificationEnabled.present
          ? data.notificationEnabled.value
          : this.notificationEnabled,
      linkedActivityId: data.linkedActivityId.present
          ? data.linkedActivityId.value
          : this.linkedActivityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('startLocal: $startLocal, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('nextOccurrenceUtc: $nextOccurrenceUtc, ')
          ..write('scheduleVersion: $scheduleVersion, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('linkedActivityId: $linkedActivityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      status,
      scheduleType,
      startLocal,
      timezoneId,
      nextOccurrenceUtc,
      scheduleVersion,
      notificationEnabled,
      linkedActivityId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.scheduleType == this.scheduleType &&
          other.startLocal == this.startLocal &&
          other.timezoneId == this.timezoneId &&
          other.nextOccurrenceUtc == this.nextOccurrenceUtc &&
          other.scheduleVersion == this.scheduleVersion &&
          other.notificationEnabled == this.notificationEnabled &&
          other.linkedActivityId == this.linkedActivityId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> status;
  final Value<String> scheduleType;
  final Value<DateTime> startLocal;
  final Value<String> timezoneId;
  final Value<DateTime?> nextOccurrenceUtc;
  final Value<int> scheduleVersion;
  final Value<bool> notificationEnabled;
  final Value<String?> linkedActivityId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.startLocal = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.nextOccurrenceUtc = const Value.absent(),
    this.scheduleVersion = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.linkedActivityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String status,
    required String scheduleType,
    required DateTime startLocal,
    required String timezoneId,
    this.nextOccurrenceUtc = const Value.absent(),
    this.scheduleVersion = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.linkedActivityId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        status = Value(status),
        scheduleType = Value(scheduleType),
        startLocal = Value(startLocal),
        timezoneId = Value(timezoneId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RemindersTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? scheduleType,
    Expression<DateTime>? startLocal,
    Expression<String>? timezoneId,
    Expression<DateTime>? nextOccurrenceUtc,
    Expression<int>? scheduleVersion,
    Expression<bool>? notificationEnabled,
    Expression<String>? linkedActivityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (startLocal != null) 'start_local': startLocal,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (nextOccurrenceUtc != null) 'next_occurrence_utc': nextOccurrenceUtc,
      if (scheduleVersion != null) 'schedule_version': scheduleVersion,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (linkedActivityId != null) 'linked_activity_id': linkedActivityId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? status,
      Value<String>? scheduleType,
      Value<DateTime>? startLocal,
      Value<String>? timezoneId,
      Value<DateTime?>? nextOccurrenceUtc,
      Value<int>? scheduleVersion,
      Value<bool>? notificationEnabled,
      Value<String?>? linkedActivityId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      scheduleType: scheduleType ?? this.scheduleType,
      startLocal: startLocal ?? this.startLocal,
      timezoneId: timezoneId ?? this.timezoneId,
      nextOccurrenceUtc: nextOccurrenceUtc ?? this.nextOccurrenceUtc,
      scheduleVersion: scheduleVersion ?? this.scheduleVersion,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      linkedActivityId: linkedActivityId ?? this.linkedActivityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (startLocal.present) {
      map['start_local'] = Variable<DateTime>(startLocal.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (nextOccurrenceUtc.present) {
      map['next_occurrence_utc'] = Variable<DateTime>(nextOccurrenceUtc.value);
    }
    if (scheduleVersion.present) {
      map['schedule_version'] = Variable<int>(scheduleVersion.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (linkedActivityId.present) {
      map['linked_activity_id'] = Variable<String>(linkedActivityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('startLocal: $startLocal, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('nextOccurrenceUtc: $nextOccurrenceUtc, ')
          ..write('scheduleVersion: $scheduleVersion, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('linkedActivityId: $linkedActivityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRulesTableTable extends RecurrenceRulesTable
    with TableInfo<$RecurrenceRulesTableTable, RecurrenceRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES reminders(id) ON DELETE CASCADE');
  static const VerificationMeta _ruleTypeMeta =
      const VerificationMeta('ruleType');
  @override
  late final GeneratedColumn<String> ruleType = GeneratedColumn<String>(
      'rule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _configJsonMeta =
      const VerificationMeta('configJson');
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
      'config_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _schemaVersionMeta =
      const VerificationMeta('schemaVersion');
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
      'schema_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, reminderId, ruleType, configJson, schemaVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rules';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurrenceRulesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('rule_type')) {
      context.handle(_ruleTypeMeta,
          ruleType.isAcceptableOrUnknown(data['rule_type']!, _ruleTypeMeta));
    } else if (isInserting) {
      context.missing(_ruleTypeMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
          _configJsonMeta,
          configJson.isAcceptableOrUnknown(
              data['config_json']!, _configJsonMeta));
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
          _schemaVersionMeta,
          schemaVersion.isAcceptableOrUnknown(
              data['schema_version']!, _schemaVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurrenceRulesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRulesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id'])!,
      ruleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_type'])!,
      configJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config_json'])!,
      schemaVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}schema_version'])!,
    );
  }

  @override
  $RecurrenceRulesTableTable createAlias(String alias) {
    return $RecurrenceRulesTableTable(attachedDatabase, alias);
  }
}

class RecurrenceRulesTableData extends DataClass
    implements Insertable<RecurrenceRulesTableData> {
  final String id;
  final String reminderId;
  final String ruleType;
  final String configJson;
  final int schemaVersion;
  const RecurrenceRulesTableData(
      {required this.id,
      required this.reminderId,
      required this.ruleType,
      required this.configJson,
      required this.schemaVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reminder_id'] = Variable<String>(reminderId);
    map['rule_type'] = Variable<String>(ruleType);
    map['config_json'] = Variable<String>(configJson);
    map['schema_version'] = Variable<int>(schemaVersion);
    return map;
  }

  RecurrenceRulesTableCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRulesTableCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      ruleType: Value(ruleType),
      configJson: Value(configJson),
      schemaVersion: Value(schemaVersion),
    );
  }

  factory RecurrenceRulesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      ruleType: serializer.fromJson<String>(json['ruleType']),
      configJson: serializer.fromJson<String>(json['configJson']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reminderId': serializer.toJson<String>(reminderId),
      'ruleType': serializer.toJson<String>(ruleType),
      'configJson': serializer.toJson<String>(configJson),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
    };
  }

  RecurrenceRulesTableData copyWith(
          {String? id,
          String? reminderId,
          String? ruleType,
          String? configJson,
          int? schemaVersion}) =>
      RecurrenceRulesTableData(
        id: id ?? this.id,
        reminderId: reminderId ?? this.reminderId,
        ruleType: ruleType ?? this.ruleType,
        configJson: configJson ?? this.configJson,
        schemaVersion: schemaVersion ?? this.schemaVersion,
      );
  RecurrenceRulesTableData copyWithCompanion(
      RecurrenceRulesTableCompanion data) {
    return RecurrenceRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      ruleType: data.ruleType.present ? data.ruleType.value : this.ruleType,
      configJson:
          data.configJson.present ? data.configJson.value : this.configJson,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRulesTableData(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('ruleType: $ruleType, ')
          ..write('configJson: $configJson, ')
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, reminderId, ruleType, configJson, schemaVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRulesTableData &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.ruleType == this.ruleType &&
          other.configJson == this.configJson &&
          other.schemaVersion == this.schemaVersion);
}

class RecurrenceRulesTableCompanion
    extends UpdateCompanion<RecurrenceRulesTableData> {
  final Value<String> id;
  final Value<String> reminderId;
  final Value<String> ruleType;
  final Value<String> configJson;
  final Value<int> schemaVersion;
  final Value<int> rowid;
  const RecurrenceRulesTableCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.ruleType = const Value.absent(),
    this.configJson = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceRulesTableCompanion.insert({
    required String id,
    required String reminderId,
    required String ruleType,
    required String configJson,
    this.schemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reminderId = Value(reminderId),
        ruleType = Value(ruleType),
        configJson = Value(configJson);
  static Insertable<RecurrenceRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? reminderId,
    Expression<String>? ruleType,
    Expression<String>? configJson,
    Expression<int>? schemaVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (ruleType != null) 'rule_type': ruleType,
      if (configJson != null) 'config_json': configJson,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceRulesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? reminderId,
      Value<String>? ruleType,
      Value<String>? configJson,
      Value<int>? schemaVersion,
      Value<int>? rowid}) {
    return RecurrenceRulesTableCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      ruleType: ruleType ?? this.ruleType,
      configJson: configJson ?? this.configJson,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (ruleType.present) {
      map['rule_type'] = Variable<String>(ruleType.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('ruleType: $ruleType, ')
          ..write('configJson: $configJson, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderOccurrencesTableTable extends ReminderOccurrencesTable
    with
        TableInfo<$ReminderOccurrencesTableTable,
            ReminderOccurrencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderOccurrencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES reminders(id) ON DELETE CASCADE');
  static const VerificationMeta _scheduleVersionMeta =
      const VerificationMeta('scheduleVersion');
  @override
  late final GeneratedColumn<int> scheduleVersion = GeneratedColumn<int>(
      'schedule_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtUtcMeta =
      const VerificationMeta('scheduledAtUtc');
  @override
  late final GeneratedColumn<DateTime> scheduledAtUtc =
      GeneratedColumn<DateTime>('scheduled_at_utc', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _scheduledLocalMeta =
      const VerificationMeta('scheduledLocal');
  @override
  late final GeneratedColumn<DateTime> scheduledLocal =
      GeneratedColumn<DateTime>('scheduled_local', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reminderId,
        scheduleVersion,
        scheduledAtUtc,
        scheduledLocal,
        status,
        notificationId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_occurrences';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReminderOccurrencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('schedule_version')) {
      context.handle(
          _scheduleVersionMeta,
          scheduleVersion.isAcceptableOrUnknown(
              data['schedule_version']!, _scheduleVersionMeta));
    } else if (isInserting) {
      context.missing(_scheduleVersionMeta);
    }
    if (data.containsKey('scheduled_at_utc')) {
      context.handle(
          _scheduledAtUtcMeta,
          scheduledAtUtc.isAcceptableOrUnknown(
              data['scheduled_at_utc']!, _scheduledAtUtcMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtUtcMeta);
    }
    if (data.containsKey('scheduled_local')) {
      context.handle(
          _scheduledLocalMeta,
          scheduledLocal.isAcceptableOrUnknown(
              data['scheduled_local']!, _scheduledLocalMeta));
    } else if (isInserting) {
      context.missing(_scheduledLocalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {reminderId, scheduleVersion, scheduledAtUtc},
      ];
  @override
  ReminderOccurrencesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderOccurrencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id'])!,
      scheduleVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}schedule_version'])!,
      scheduledAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at_utc'])!,
      scheduledLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_local'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReminderOccurrencesTableTable createAlias(String alias) {
    return $ReminderOccurrencesTableTable(attachedDatabase, alias);
  }
}

class ReminderOccurrencesTableData extends DataClass
    implements Insertable<ReminderOccurrencesTableData> {
  final String id;
  final String reminderId;
  final int scheduleVersion;
  final DateTime scheduledAtUtc;
  final DateTime scheduledLocal;
  final String status;
  final int notificationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReminderOccurrencesTableData(
      {required this.id,
      required this.reminderId,
      required this.scheduleVersion,
      required this.scheduledAtUtc,
      required this.scheduledLocal,
      required this.status,
      required this.notificationId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reminder_id'] = Variable<String>(reminderId);
    map['schedule_version'] = Variable<int>(scheduleVersion);
    map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc);
    map['scheduled_local'] = Variable<DateTime>(scheduledLocal);
    map['status'] = Variable<String>(status);
    map['notification_id'] = Variable<int>(notificationId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderOccurrencesTableCompanion toCompanion(bool nullToAbsent) {
    return ReminderOccurrencesTableCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      scheduleVersion: Value(scheduleVersion),
      scheduledAtUtc: Value(scheduledAtUtc),
      scheduledLocal: Value(scheduledLocal),
      status: Value(status),
      notificationId: Value(notificationId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderOccurrencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderOccurrencesTableData(
      id: serializer.fromJson<String>(json['id']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      scheduleVersion: serializer.fromJson<int>(json['scheduleVersion']),
      scheduledAtUtc: serializer.fromJson<DateTime>(json['scheduledAtUtc']),
      scheduledLocal: serializer.fromJson<DateTime>(json['scheduledLocal']),
      status: serializer.fromJson<String>(json['status']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reminderId': serializer.toJson<String>(reminderId),
      'scheduleVersion': serializer.toJson<int>(scheduleVersion),
      'scheduledAtUtc': serializer.toJson<DateTime>(scheduledAtUtc),
      'scheduledLocal': serializer.toJson<DateTime>(scheduledLocal),
      'status': serializer.toJson<String>(status),
      'notificationId': serializer.toJson<int>(notificationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderOccurrencesTableData copyWith(
          {String? id,
          String? reminderId,
          int? scheduleVersion,
          DateTime? scheduledAtUtc,
          DateTime? scheduledLocal,
          String? status,
          int? notificationId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ReminderOccurrencesTableData(
        id: id ?? this.id,
        reminderId: reminderId ?? this.reminderId,
        scheduleVersion: scheduleVersion ?? this.scheduleVersion,
        scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
        scheduledLocal: scheduledLocal ?? this.scheduledLocal,
        status: status ?? this.status,
        notificationId: notificationId ?? this.notificationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReminderOccurrencesTableData copyWithCompanion(
      ReminderOccurrencesTableCompanion data) {
    return ReminderOccurrencesTableData(
      id: data.id.present ? data.id.value : this.id,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      scheduleVersion: data.scheduleVersion.present
          ? data.scheduleVersion.value
          : this.scheduleVersion,
      scheduledAtUtc: data.scheduledAtUtc.present
          ? data.scheduledAtUtc.value
          : this.scheduledAtUtc,
      scheduledLocal: data.scheduledLocal.present
          ? data.scheduledLocal.value
          : this.scheduledLocal,
      status: data.status.present ? data.status.value : this.status,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOccurrencesTableData(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduleVersion: $scheduleVersion, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('scheduledLocal: $scheduledLocal, ')
          ..write('status: $status, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      reminderId,
      scheduleVersion,
      scheduledAtUtc,
      scheduledLocal,
      status,
      notificationId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderOccurrencesTableData &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.scheduleVersion == this.scheduleVersion &&
          other.scheduledAtUtc == this.scheduledAtUtc &&
          other.scheduledLocal == this.scheduledLocal &&
          other.status == this.status &&
          other.notificationId == this.notificationId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReminderOccurrencesTableCompanion
    extends UpdateCompanion<ReminderOccurrencesTableData> {
  final Value<String> id;
  final Value<String> reminderId;
  final Value<int> scheduleVersion;
  final Value<DateTime> scheduledAtUtc;
  final Value<DateTime> scheduledLocal;
  final Value<String> status;
  final Value<int> notificationId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReminderOccurrencesTableCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.scheduleVersion = const Value.absent(),
    this.scheduledAtUtc = const Value.absent(),
    this.scheduledLocal = const Value.absent(),
    this.status = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderOccurrencesTableCompanion.insert({
    required String id,
    required String reminderId,
    required int scheduleVersion,
    required DateTime scheduledAtUtc,
    required DateTime scheduledLocal,
    required String status,
    required int notificationId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reminderId = Value(reminderId),
        scheduleVersion = Value(scheduleVersion),
        scheduledAtUtc = Value(scheduledAtUtc),
        scheduledLocal = Value(scheduledLocal),
        status = Value(status),
        notificationId = Value(notificationId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ReminderOccurrencesTableData> custom({
    Expression<String>? id,
    Expression<String>? reminderId,
    Expression<int>? scheduleVersion,
    Expression<DateTime>? scheduledAtUtc,
    Expression<DateTime>? scheduledLocal,
    Expression<String>? status,
    Expression<int>? notificationId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (scheduleVersion != null) 'schedule_version': scheduleVersion,
      if (scheduledAtUtc != null) 'scheduled_at_utc': scheduledAtUtc,
      if (scheduledLocal != null) 'scheduled_local': scheduledLocal,
      if (status != null) 'status': status,
      if (notificationId != null) 'notification_id': notificationId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderOccurrencesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? reminderId,
      Value<int>? scheduleVersion,
      Value<DateTime>? scheduledAtUtc,
      Value<DateTime>? scheduledLocal,
      Value<String>? status,
      Value<int>? notificationId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ReminderOccurrencesTableCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      scheduleVersion: scheduleVersion ?? this.scheduleVersion,
      scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
      scheduledLocal: scheduledLocal ?? this.scheduledLocal,
      status: status ?? this.status,
      notificationId: notificationId ?? this.notificationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (scheduleVersion.present) {
      map['schedule_version'] = Variable<int>(scheduleVersion.value);
    }
    if (scheduledAtUtc.present) {
      map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc.value);
    }
    if (scheduledLocal.present) {
      map['scheduled_local'] = Variable<DateTime>(scheduledLocal.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOccurrencesTableCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduleVersion: $scheduleVersion, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('scheduledLocal: $scheduledLocal, ')
          ..write('status: $status, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTableTable extends ReminderSettingsTable
    with TableInfo<$ReminderSettingsTableTable, ReminderSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReminderSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ReminderSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSettingsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $ReminderSettingsTableTable createAlias(String alias) {
    return $ReminderSettingsTableTable(attachedDatabase, alias);
  }
}

class ReminderSettingsTableData extends DataClass
    implements Insertable<ReminderSettingsTableData> {
  final String key;
  final String value;
  const ReminderSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  ReminderSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory ReminderSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  ReminderSettingsTableData copyWith({String? key, String? value}) =>
      ReminderSettingsTableData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  ReminderSettingsTableData copyWithCompanion(
      ReminderSettingsTableCompanion data) {
    return ReminderSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class ReminderSettingsTableCompanion
    extends UpdateCompanion<ReminderSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const ReminderSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<ReminderSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderSettingsTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return ReminderSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppStatesTable appStates = $AppStatesTable(this);
  late final $NotificationSettingsTableTable notificationSettingsTable =
      $NotificationSettingsTableTable(this);
  late final $InterestsTableTable interestsTable = $InterestsTableTable(this);
  late final $SnippetsTableTable snippetsTable = $SnippetsTableTable(this);
  late final $ExposuresTableTable exposuresTable = $ExposuresTableTable(this);
  late final $AnalyticsEventsTableTable analyticsEventsTable =
      $AnalyticsEventsTableTable(this);
  late final $AnalyticsDailyTableTable analyticsDailyTable =
      $AnalyticsDailyTableTable(this);
  late final $ErrorLogsTableTable errorLogsTable = $ErrorLogsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $RecurrenceRulesTableTable recurrenceRulesTable =
      $RecurrenceRulesTableTable(this);
  late final $ReminderOccurrencesTableTable reminderOccurrencesTable =
      $ReminderOccurrencesTableTable(this);
  late final $ReminderSettingsTableTable reminderSettingsTable =
      $ReminderSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appStates,
        notificationSettingsTable,
        interestsTable,
        snippetsTable,
        exposuresTable,
        analyticsEventsTable,
        analyticsDailyTable,
        errorLogsTable,
        remindersTable,
        recurrenceRulesTable,
        reminderOccurrencesTable,
        reminderSettingsTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('interests_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('snippets_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('interests_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exposures_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('snippets_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exposures_table', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('reminders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recurrence_rules', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('reminders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminder_occurrences', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$AppStatesTableCreateCompanionBuilder = AppStatesCompanion Function({
  Value<int> id,
  required int installSeed,
  required String timezone,
  Value<DateTime?> onboardingCompletedAt,
  Value<DateTime?> lastSeenAt,
  Value<String> notificationPermission,
  Value<DateTime?> permissionReaskDueAt,
  Value<bool> quietCardPending,
  Value<bool> insightsEnabled,
  Value<DateTime?> plannerLastRunAt,
  Value<String> appVersion,
  required DateTime createdAt,
});
typedef $$AppStatesTableUpdateCompanionBuilder = AppStatesCompanion Function({
  Value<int> id,
  Value<int> installSeed,
  Value<String> timezone,
  Value<DateTime?> onboardingCompletedAt,
  Value<DateTime?> lastSeenAt,
  Value<String> notificationPermission,
  Value<DateTime?> permissionReaskDueAt,
  Value<bool> quietCardPending,
  Value<bool> insightsEnabled,
  Value<DateTime?> plannerLastRunAt,
  Value<String> appVersion,
  Value<DateTime> createdAt,
});

class $$AppStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installSeed => $composableBuilder(
      column: $table.installSeed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationPermission => $composableBuilder(
      column: $table.notificationPermission,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get permissionReaskDueAt => $composableBuilder(
      column: $table.permissionReaskDueAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get quietCardPending => $composableBuilder(
      column: $table.quietCardPending,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get insightsEnabled => $composableBuilder(
      column: $table.insightsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get plannerLastRunAt => $composableBuilder(
      column: $table.plannerLastRunAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AppStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installSeed => $composableBuilder(
      column: $table.installSeed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationPermission => $composableBuilder(
      column: $table.notificationPermission,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get permissionReaskDueAt => $composableBuilder(
      column: $table.permissionReaskDueAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get quietCardPending => $composableBuilder(
      column: $table.quietCardPending,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get insightsEnabled => $composableBuilder(
      column: $table.insightsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get plannerLastRunAt => $composableBuilder(
      column: $table.plannerLastRunAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AppStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get installSeed => $composableBuilder(
      column: $table.installSeed, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => column);

  GeneratedColumn<String> get notificationPermission => $composableBuilder(
      column: $table.notificationPermission, builder: (column) => column);

  GeneratedColumn<DateTime> get permissionReaskDueAt => $composableBuilder(
      column: $table.permissionReaskDueAt, builder: (column) => column);

  GeneratedColumn<bool> get quietCardPending => $composableBuilder(
      column: $table.quietCardPending, builder: (column) => column);

  GeneratedColumn<bool> get insightsEnabled => $composableBuilder(
      column: $table.insightsEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get plannerLastRunAt => $composableBuilder(
      column: $table.plannerLastRunAt, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppStatesTable,
    AppState,
    $$AppStatesTableFilterComposer,
    $$AppStatesTableOrderingComposer,
    $$AppStatesTableAnnotationComposer,
    $$AppStatesTableCreateCompanionBuilder,
    $$AppStatesTableUpdateCompanionBuilder,
    (AppState, BaseReferences<_$AppDatabase, $AppStatesTable, AppState>),
    AppState,
    PrefetchHooks Function()> {
  $$AppStatesTableTableManager(_$AppDatabase db, $AppStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> installSeed = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            Value<DateTime?> onboardingCompletedAt = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            Value<String> notificationPermission = const Value.absent(),
            Value<DateTime?> permissionReaskDueAt = const Value.absent(),
            Value<bool> quietCardPending = const Value.absent(),
            Value<bool> insightsEnabled = const Value.absent(),
            Value<DateTime?> plannerLastRunAt = const Value.absent(),
            Value<String> appVersion = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AppStatesCompanion(
            id: id,
            installSeed: installSeed,
            timezone: timezone,
            onboardingCompletedAt: onboardingCompletedAt,
            lastSeenAt: lastSeenAt,
            notificationPermission: notificationPermission,
            permissionReaskDueAt: permissionReaskDueAt,
            quietCardPending: quietCardPending,
            insightsEnabled: insightsEnabled,
            plannerLastRunAt: plannerLastRunAt,
            appVersion: appVersion,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int installSeed,
            required String timezone,
            Value<DateTime?> onboardingCompletedAt = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            Value<String> notificationPermission = const Value.absent(),
            Value<DateTime?> permissionReaskDueAt = const Value.absent(),
            Value<bool> quietCardPending = const Value.absent(),
            Value<bool> insightsEnabled = const Value.absent(),
            Value<DateTime?> plannerLastRunAt = const Value.absent(),
            Value<String> appVersion = const Value.absent(),
            required DateTime createdAt,
          }) =>
              AppStatesCompanion.insert(
            id: id,
            installSeed: installSeed,
            timezone: timezone,
            onboardingCompletedAt: onboardingCompletedAt,
            lastSeenAt: lastSeenAt,
            notificationPermission: notificationPermission,
            permissionReaskDueAt: permissionReaskDueAt,
            quietCardPending: quietCardPending,
            insightsEnabled: insightsEnabled,
            plannerLastRunAt: plannerLastRunAt,
            appVersion: appVersion,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppStatesTable,
    AppState,
    $$AppStatesTableFilterComposer,
    $$AppStatesTableOrderingComposer,
    $$AppStatesTableAnnotationComposer,
    $$AppStatesTableCreateCompanionBuilder,
    $$AppStatesTableUpdateCompanionBuilder,
    (AppState, BaseReferences<_$AppDatabase, $AppStatesTable, AppState>),
    AppState,
    PrefetchHooks Function()>;
typedef $$NotificationSettingsTableTableCreateCompanionBuilder
    = NotificationSettingsTableCompanion Function({
  Value<int> id,
  Value<String> level,
  Value<int> windows,
  Value<String> voice,
  Value<bool> showTextOnLockScreen,
  Value<DateTime?> pausedUntil,
  Value<int> consecutiveIgnored,
  Value<int> backoffStep,
  Value<DateTime?> lastNudgeAt,
});
typedef $$NotificationSettingsTableTableUpdateCompanionBuilder
    = NotificationSettingsTableCompanion Function({
  Value<int> id,
  Value<String> level,
  Value<int> windows,
  Value<String> voice,
  Value<bool> showTextOnLockScreen,
  Value<DateTime?> pausedUntil,
  Value<int> consecutiveIgnored,
  Value<int> backoffStep,
  Value<DateTime?> lastNudgeAt,
});

class $$NotificationSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get windows => $composableBuilder(
      column: $table.windows, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voice => $composableBuilder(
      column: $table.voice, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showTextOnLockScreen => $composableBuilder(
      column: $table.showTextOnLockScreen,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pausedUntil => $composableBuilder(
      column: $table.pausedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get consecutiveIgnored => $composableBuilder(
      column: $table.consecutiveIgnored,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backoffStep => $composableBuilder(
      column: $table.backoffStep, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastNudgeAt => $composableBuilder(
      column: $table.lastNudgeAt, builder: (column) => ColumnFilters(column));
}

class $$NotificationSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get windows => $composableBuilder(
      column: $table.windows, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voice => $composableBuilder(
      column: $table.voice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showTextOnLockScreen => $composableBuilder(
      column: $table.showTextOnLockScreen,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pausedUntil => $composableBuilder(
      column: $table.pausedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get consecutiveIgnored => $composableBuilder(
      column: $table.consecutiveIgnored,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backoffStep => $composableBuilder(
      column: $table.backoffStep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastNudgeAt => $composableBuilder(
      column: $table.lastNudgeAt, builder: (column) => ColumnOrderings(column));
}

class $$NotificationSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get windows =>
      $composableBuilder(column: $table.windows, builder: (column) => column);

  GeneratedColumn<String> get voice =>
      $composableBuilder(column: $table.voice, builder: (column) => column);

  GeneratedColumn<bool> get showTextOnLockScreen => $composableBuilder(
      column: $table.showTextOnLockScreen, builder: (column) => column);

  GeneratedColumn<DateTime> get pausedUntil => $composableBuilder(
      column: $table.pausedUntil, builder: (column) => column);

  GeneratedColumn<int> get consecutiveIgnored => $composableBuilder(
      column: $table.consecutiveIgnored, builder: (column) => column);

  GeneratedColumn<int> get backoffStep => $composableBuilder(
      column: $table.backoffStep, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNudgeAt => $composableBuilder(
      column: $table.lastNudgeAt, builder: (column) => column);
}

class $$NotificationSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationSettingsTableTable,
    NotificationSettingsTableData,
    $$NotificationSettingsTableTableFilterComposer,
    $$NotificationSettingsTableTableOrderingComposer,
    $$NotificationSettingsTableTableAnnotationComposer,
    $$NotificationSettingsTableTableCreateCompanionBuilder,
    $$NotificationSettingsTableTableUpdateCompanionBuilder,
    (
      NotificationSettingsTableData,
      BaseReferences<_$AppDatabase, $NotificationSettingsTableTable,
          NotificationSettingsTableData>
    ),
    NotificationSettingsTableData,
    PrefetchHooks Function()> {
  $$NotificationSettingsTableTableTableManager(
      _$AppDatabase db, $NotificationSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<int> windows = const Value.absent(),
            Value<String> voice = const Value.absent(),
            Value<bool> showTextOnLockScreen = const Value.absent(),
            Value<DateTime?> pausedUntil = const Value.absent(),
            Value<int> consecutiveIgnored = const Value.absent(),
            Value<int> backoffStep = const Value.absent(),
            Value<DateTime?> lastNudgeAt = const Value.absent(),
          }) =>
              NotificationSettingsTableCompanion(
            id: id,
            level: level,
            windows: windows,
            voice: voice,
            showTextOnLockScreen: showTextOnLockScreen,
            pausedUntil: pausedUntil,
            consecutiveIgnored: consecutiveIgnored,
            backoffStep: backoffStep,
            lastNudgeAt: lastNudgeAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<int> windows = const Value.absent(),
            Value<String> voice = const Value.absent(),
            Value<bool> showTextOnLockScreen = const Value.absent(),
            Value<DateTime?> pausedUntil = const Value.absent(),
            Value<int> consecutiveIgnored = const Value.absent(),
            Value<int> backoffStep = const Value.absent(),
            Value<DateTime?> lastNudgeAt = const Value.absent(),
          }) =>
              NotificationSettingsTableCompanion.insert(
            id: id,
            level: level,
            windows: windows,
            voice: voice,
            showTextOnLockScreen: showTextOnLockScreen,
            pausedUntil: pausedUntil,
            consecutiveIgnored: consecutiveIgnored,
            backoffStep: backoffStep,
            lastNudgeAt: lastNudgeAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $NotificationSettingsTableTable,
        NotificationSettingsTableData,
        $$NotificationSettingsTableTableFilterComposer,
        $$NotificationSettingsTableTableOrderingComposer,
        $$NotificationSettingsTableTableAnnotationComposer,
        $$NotificationSettingsTableTableCreateCompanionBuilder,
        $$NotificationSettingsTableTableUpdateCompanionBuilder,
        (
          NotificationSettingsTableData,
          BaseReferences<_$AppDatabase, $NotificationSettingsTableTable,
              NotificationSettingsTableData>
        ),
        NotificationSettingsTableData,
        PrefetchHooks Function()>;
typedef $$InterestsTableTableCreateCompanionBuilder = InterestsTableCompanion
    Function({
  required String id,
  required String name,
  required String nameKey,
  Value<double> alpha,
  Value<double> beta,
  Value<DateTime?> pushCooldownUntil,
  Value<DateTime?> archivedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$InterestsTableTableUpdateCompanionBuilder = InterestsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> nameKey,
  Value<double> alpha,
  Value<double> beta,
  Value<DateTime?> pushCooldownUntil,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$InterestsTableTableReferences extends BaseReferences<
    _$AppDatabase, $InterestsTableTable, InterestsTableData> {
  $$InterestsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SnippetsTableTable, List<SnippetsTableData>>
      _snippetsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.snippetsTable,
              aliasName: $_aliasNameGenerator(
                  db.interestsTable.id, db.snippetsTable.interestId));

  $$SnippetsTableTableProcessedTableManager get snippetsTableRefs {
    final manager = $$SnippetsTableTableTableManager($_db, $_db.snippetsTable)
        .filter((f) => f.interestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_snippetsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExposuresTableTable, List<ExposuresTableData>>
      _exposuresTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.exposuresTable,
              aliasName: $_aliasNameGenerator(
                  db.interestsTable.id, db.exposuresTable.interestId));

  $$ExposuresTableTableProcessedTableManager get exposuresTableRefs {
    final manager = $$ExposuresTableTableTableManager($_db, $_db.exposuresTable)
        .filter((f) => f.interestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_exposuresTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InterestsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InterestsTableTable> {
  $$InterestsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alpha => $composableBuilder(
      column: $table.alpha, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get beta => $composableBuilder(
      column: $table.beta, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pushCooldownUntil => $composableBuilder(
      column: $table.pushCooldownUntil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> snippetsTableRefs(
      Expression<bool> Function($$SnippetsTableTableFilterComposer f) f) {
    final $$SnippetsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.snippetsTable,
        getReferencedColumn: (t) => t.interestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableTableFilterComposer(
              $db: $db,
              $table: $db.snippetsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> exposuresTableRefs(
      Expression<bool> Function($$ExposuresTableTableFilterComposer f) f) {
    final $$ExposuresTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exposuresTable,
        getReferencedColumn: (t) => t.interestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExposuresTableTableFilterComposer(
              $db: $db,
              $table: $db.exposuresTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InterestsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InterestsTableTable> {
  $$InterestsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKey => $composableBuilder(
      column: $table.nameKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alpha => $composableBuilder(
      column: $table.alpha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get beta => $composableBuilder(
      column: $table.beta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pushCooldownUntil => $composableBuilder(
      column: $table.pushCooldownUntil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$InterestsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterestsTableTable> {
  $$InterestsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<double> get alpha =>
      $composableBuilder(column: $table.alpha, builder: (column) => column);

  GeneratedColumn<double> get beta =>
      $composableBuilder(column: $table.beta, builder: (column) => column);

  GeneratedColumn<DateTime> get pushCooldownUntil => $composableBuilder(
      column: $table.pushCooldownUntil, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> snippetsTableRefs<T extends Object>(
      Expression<T> Function($$SnippetsTableTableAnnotationComposer a) f) {
    final $$SnippetsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.snippetsTable,
        getReferencedColumn: (t) => t.interestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.snippetsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> exposuresTableRefs<T extends Object>(
      Expression<T> Function($$ExposuresTableTableAnnotationComposer a) f) {
    final $$ExposuresTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exposuresTable,
        getReferencedColumn: (t) => t.interestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExposuresTableTableAnnotationComposer(
              $db: $db,
              $table: $db.exposuresTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InterestsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InterestsTableTable,
    InterestsTableData,
    $$InterestsTableTableFilterComposer,
    $$InterestsTableTableOrderingComposer,
    $$InterestsTableTableAnnotationComposer,
    $$InterestsTableTableCreateCompanionBuilder,
    $$InterestsTableTableUpdateCompanionBuilder,
    (InterestsTableData, $$InterestsTableTableReferences),
    InterestsTableData,
    PrefetchHooks Function({bool snippetsTableRefs, bool exposuresTableRefs})> {
  $$InterestsTableTableTableManager(
      _$AppDatabase db, $InterestsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterestsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterestsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterestsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameKey = const Value.absent(),
            Value<double> alpha = const Value.absent(),
            Value<double> beta = const Value.absent(),
            Value<DateTime?> pushCooldownUntil = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InterestsTableCompanion(
            id: id,
            name: name,
            nameKey: nameKey,
            alpha: alpha,
            beta: beta,
            pushCooldownUntil: pushCooldownUntil,
            archivedAt: archivedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String nameKey,
            Value<double> alpha = const Value.absent(),
            Value<double> beta = const Value.absent(),
            Value<DateTime?> pushCooldownUntil = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InterestsTableCompanion.insert(
            id: id,
            name: name,
            nameKey: nameKey,
            alpha: alpha,
            beta: beta,
            pushCooldownUntil: pushCooldownUntil,
            archivedAt: archivedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InterestsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {snippetsTableRefs = false, exposuresTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (snippetsTableRefs) db.snippetsTable,
                if (exposuresTableRefs) db.exposuresTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (snippetsTableRefs)
                    await $_getPrefetchedData<InterestsTableData,
                            $InterestsTableTable, SnippetsTableData>(
                        currentTable: table,
                        referencedTable: $$InterestsTableTableReferences
                            ._snippetsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InterestsTableTableReferences(db, table, p0)
                                .snippetsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.interestId == item.id),
                        typedResults: items),
                  if (exposuresTableRefs)
                    await $_getPrefetchedData<InterestsTableData,
                            $InterestsTableTable, ExposuresTableData>(
                        currentTable: table,
                        referencedTable: $$InterestsTableTableReferences
                            ._exposuresTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InterestsTableTableReferences(db, table, p0)
                                .exposuresTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.interestId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InterestsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InterestsTableTable,
    InterestsTableData,
    $$InterestsTableTableFilterComposer,
    $$InterestsTableTableOrderingComposer,
    $$InterestsTableTableAnnotationComposer,
    $$InterestsTableTableCreateCompanionBuilder,
    $$InterestsTableTableUpdateCompanionBuilder,
    (InterestsTableData, $$InterestsTableTableReferences),
    InterestsTableData,
    PrefetchHooks Function({bool snippetsTableRefs, bool exposuresTableRefs})>;
typedef $$SnippetsTableTableCreateCompanionBuilder = SnippetsTableCompanion
    Function({
  required String id,
  required String interestId,
  required String content,
  required String source,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SnippetsTableTableUpdateCompanionBuilder = SnippetsTableCompanion
    Function({
  Value<String> id,
  Value<String> interestId,
  Value<String> content,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SnippetsTableTableReferences extends BaseReferences<_$AppDatabase,
    $SnippetsTableTable, SnippetsTableData> {
  $$SnippetsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InterestsTableTable _interestIdTable(_$AppDatabase db) =>
      db.interestsTable.createAlias($_aliasNameGenerator(
          db.snippetsTable.interestId, db.interestsTable.id));

  $$InterestsTableTableProcessedTableManager get interestId {
    final $_column = $_itemColumn<String>('interest_id')!;

    final manager = $$InterestsTableTableTableManager($_db, $_db.interestsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_interestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ExposuresTableTable, List<ExposuresTableData>>
      _exposuresTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.exposuresTable,
              aliasName: $_aliasNameGenerator(
                  db.snippetsTable.id, db.exposuresTable.snippetId));

  $$ExposuresTableTableProcessedTableManager get exposuresTableRefs {
    final manager = $$ExposuresTableTableTableManager($_db, $_db.exposuresTable)
        .filter((f) => f.snippetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_exposuresTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SnippetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTableTable> {
  $$SnippetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$InterestsTableTableFilterComposer get interestId {
    final $$InterestsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableFilterComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> exposuresTableRefs(
      Expression<bool> Function($$ExposuresTableTableFilterComposer f) f) {
    final $$ExposuresTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exposuresTable,
        getReferencedColumn: (t) => t.snippetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExposuresTableTableFilterComposer(
              $db: $db,
              $table: $db.exposuresTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SnippetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTableTable> {
  $$SnippetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$InterestsTableTableOrderingComposer get interestId {
    final $$InterestsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableOrderingComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SnippetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTableTable> {
  $$SnippetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$InterestsTableTableAnnotationComposer get interestId {
    final $$InterestsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> exposuresTableRefs<T extends Object>(
      Expression<T> Function($$ExposuresTableTableAnnotationComposer a) f) {
    final $$ExposuresTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exposuresTable,
        getReferencedColumn: (t) => t.snippetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExposuresTableTableAnnotationComposer(
              $db: $db,
              $table: $db.exposuresTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SnippetsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnippetsTableTable,
    SnippetsTableData,
    $$SnippetsTableTableFilterComposer,
    $$SnippetsTableTableOrderingComposer,
    $$SnippetsTableTableAnnotationComposer,
    $$SnippetsTableTableCreateCompanionBuilder,
    $$SnippetsTableTableUpdateCompanionBuilder,
    (SnippetsTableData, $$SnippetsTableTableReferences),
    SnippetsTableData,
    PrefetchHooks Function({bool interestId, bool exposuresTableRefs})> {
  $$SnippetsTableTableTableManager(_$AppDatabase db, $SnippetsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> interestId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SnippetsTableCompanion(
            id: id,
            interestId: interestId,
            content: content,
            source: source,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String interestId,
            required String content,
            required String source,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SnippetsTableCompanion.insert(
            id: id,
            interestId: interestId,
            content: content,
            source: source,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SnippetsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {interestId = false, exposuresTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (exposuresTableRefs) db.exposuresTable
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (interestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.interestId,
                    referencedTable:
                        $$SnippetsTableTableReferences._interestIdTable(db),
                    referencedColumn:
                        $$SnippetsTableTableReferences._interestIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exposuresTableRefs)
                    await $_getPrefetchedData<SnippetsTableData,
                            $SnippetsTableTable, ExposuresTableData>(
                        currentTable: table,
                        referencedTable: $$SnippetsTableTableReferences
                            ._exposuresTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SnippetsTableTableReferences(db, table, p0)
                                .exposuresTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.snippetId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SnippetsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnippetsTableTable,
    SnippetsTableData,
    $$SnippetsTableTableFilterComposer,
    $$SnippetsTableTableOrderingComposer,
    $$SnippetsTableTableAnnotationComposer,
    $$SnippetsTableTableCreateCompanionBuilder,
    $$SnippetsTableTableUpdateCompanionBuilder,
    (SnippetsTableData, $$SnippetsTableTableReferences),
    SnippetsTableData,
    PrefetchHooks Function({bool interestId, bool exposuresTableRefs})>;
typedef $$ExposuresTableTableCreateCompanionBuilder = ExposuresTableCompanion
    Function({
  required String id,
  required String interestId,
  Value<String?> snippetId,
  Value<String?> altInterestId,
  required String kind,
  required String templateCode,
  required String copyVariant,
  required String voice,
  required String channel,
  Value<int?> notificationId,
  Value<DateTime?> scheduledFor,
  required DateTime surfacedAt,
  Value<DateTime?> expiresAt,
  Value<DateTime?> deliveredAt,
  Value<DateTime?> respondedAt,
  Value<String> reaction,
  Value<String?> respondedVia,
  Value<String?> responseText,
  Value<String?> planReason,
  Value<int> rowid,
});
typedef $$ExposuresTableTableUpdateCompanionBuilder = ExposuresTableCompanion
    Function({
  Value<String> id,
  Value<String> interestId,
  Value<String?> snippetId,
  Value<String?> altInterestId,
  Value<String> kind,
  Value<String> templateCode,
  Value<String> copyVariant,
  Value<String> voice,
  Value<String> channel,
  Value<int?> notificationId,
  Value<DateTime?> scheduledFor,
  Value<DateTime> surfacedAt,
  Value<DateTime?> expiresAt,
  Value<DateTime?> deliveredAt,
  Value<DateTime?> respondedAt,
  Value<String> reaction,
  Value<String?> respondedVia,
  Value<String?> responseText,
  Value<String?> planReason,
  Value<int> rowid,
});

final class $$ExposuresTableTableReferences extends BaseReferences<
    _$AppDatabase, $ExposuresTableTable, ExposuresTableData> {
  $$ExposuresTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InterestsTableTable _interestIdTable(_$AppDatabase db) =>
      db.interestsTable.createAlias($_aliasNameGenerator(
          db.exposuresTable.interestId, db.interestsTable.id));

  $$InterestsTableTableProcessedTableManager get interestId {
    final $_column = $_itemColumn<String>('interest_id')!;

    final manager = $$InterestsTableTableTableManager($_db, $_db.interestsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_interestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SnippetsTableTable _snippetIdTable(_$AppDatabase db) =>
      db.snippetsTable.createAlias($_aliasNameGenerator(
          db.exposuresTable.snippetId, db.snippetsTable.id));

  $$SnippetsTableTableProcessedTableManager? get snippetId {
    final $_column = $_itemColumn<String>('snippet_id');
    if ($_column == null) return null;
    final manager = $$SnippetsTableTableTableManager($_db, $_db.snippetsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snippetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExposuresTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExposuresTableTable> {
  $$ExposuresTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get altInterestId => $composableBuilder(
      column: $table.altInterestId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get copyVariant => $composableBuilder(
      column: $table.copyVariant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voice => $composableBuilder(
      column: $table.voice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get surfacedAt => $composableBuilder(
      column: $table.surfacedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reaction => $composableBuilder(
      column: $table.reaction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get respondedVia => $composableBuilder(
      column: $table.respondedVia, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get responseText => $composableBuilder(
      column: $table.responseText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planReason => $composableBuilder(
      column: $table.planReason, builder: (column) => ColumnFilters(column));

  $$InterestsTableTableFilterComposer get interestId {
    final $$InterestsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableFilterComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SnippetsTableTableFilterComposer get snippetId {
    final $$SnippetsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snippetId,
        referencedTable: $db.snippetsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableTableFilterComposer(
              $db: $db,
              $table: $db.snippetsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExposuresTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExposuresTableTable> {
  $$ExposuresTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get altInterestId => $composableBuilder(
      column: $table.altInterestId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateCode => $composableBuilder(
      column: $table.templateCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get copyVariant => $composableBuilder(
      column: $table.copyVariant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voice => $composableBuilder(
      column: $table.voice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get surfacedAt => $composableBuilder(
      column: $table.surfacedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reaction => $composableBuilder(
      column: $table.reaction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get respondedVia => $composableBuilder(
      column: $table.respondedVia,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get responseText => $composableBuilder(
      column: $table.responseText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planReason => $composableBuilder(
      column: $table.planReason, builder: (column) => ColumnOrderings(column));

  $$InterestsTableTableOrderingComposer get interestId {
    final $$InterestsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableOrderingComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SnippetsTableTableOrderingComposer get snippetId {
    final $$SnippetsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snippetId,
        referencedTable: $db.snippetsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableTableOrderingComposer(
              $db: $db,
              $table: $db.snippetsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExposuresTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExposuresTableTable> {
  $$ExposuresTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get altInterestId => $composableBuilder(
      column: $table.altInterestId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => column);

  GeneratedColumn<String> get copyVariant => $composableBuilder(
      column: $table.copyVariant, builder: (column) => column);

  GeneratedColumn<String> get voice =>
      $composableBuilder(column: $table.voice, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => column);

  GeneratedColumn<DateTime> get surfacedAt => $composableBuilder(
      column: $table.surfacedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<String> get respondedVia => $composableBuilder(
      column: $table.respondedVia, builder: (column) => column);

  GeneratedColumn<String> get responseText => $composableBuilder(
      column: $table.responseText, builder: (column) => column);

  GeneratedColumn<String> get planReason => $composableBuilder(
      column: $table.planReason, builder: (column) => column);

  $$InterestsTableTableAnnotationComposer get interestId {
    final $$InterestsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.interestId,
        referencedTable: $db.interestsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InterestsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.interestsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SnippetsTableTableAnnotationComposer get snippetId {
    final $$SnippetsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snippetId,
        referencedTable: $db.snippetsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SnippetsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.snippetsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExposuresTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExposuresTableTable,
    ExposuresTableData,
    $$ExposuresTableTableFilterComposer,
    $$ExposuresTableTableOrderingComposer,
    $$ExposuresTableTableAnnotationComposer,
    $$ExposuresTableTableCreateCompanionBuilder,
    $$ExposuresTableTableUpdateCompanionBuilder,
    (ExposuresTableData, $$ExposuresTableTableReferences),
    ExposuresTableData,
    PrefetchHooks Function({bool interestId, bool snippetId})> {
  $$ExposuresTableTableTableManager(
      _$AppDatabase db, $ExposuresTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExposuresTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExposuresTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExposuresTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> interestId = const Value.absent(),
            Value<String?> snippetId = const Value.absent(),
            Value<String?> altInterestId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> templateCode = const Value.absent(),
            Value<String> copyVariant = const Value.absent(),
            Value<String> voice = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<int?> notificationId = const Value.absent(),
            Value<DateTime?> scheduledFor = const Value.absent(),
            Value<DateTime> surfacedAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<DateTime?> respondedAt = const Value.absent(),
            Value<String> reaction = const Value.absent(),
            Value<String?> respondedVia = const Value.absent(),
            Value<String?> responseText = const Value.absent(),
            Value<String?> planReason = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExposuresTableCompanion(
            id: id,
            interestId: interestId,
            snippetId: snippetId,
            altInterestId: altInterestId,
            kind: kind,
            templateCode: templateCode,
            copyVariant: copyVariant,
            voice: voice,
            channel: channel,
            notificationId: notificationId,
            scheduledFor: scheduledFor,
            surfacedAt: surfacedAt,
            expiresAt: expiresAt,
            deliveredAt: deliveredAt,
            respondedAt: respondedAt,
            reaction: reaction,
            respondedVia: respondedVia,
            responseText: responseText,
            planReason: planReason,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String interestId,
            Value<String?> snippetId = const Value.absent(),
            Value<String?> altInterestId = const Value.absent(),
            required String kind,
            required String templateCode,
            required String copyVariant,
            required String voice,
            required String channel,
            Value<int?> notificationId = const Value.absent(),
            Value<DateTime?> scheduledFor = const Value.absent(),
            required DateTime surfacedAt,
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<DateTime?> respondedAt = const Value.absent(),
            Value<String> reaction = const Value.absent(),
            Value<String?> respondedVia = const Value.absent(),
            Value<String?> responseText = const Value.absent(),
            Value<String?> planReason = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExposuresTableCompanion.insert(
            id: id,
            interestId: interestId,
            snippetId: snippetId,
            altInterestId: altInterestId,
            kind: kind,
            templateCode: templateCode,
            copyVariant: copyVariant,
            voice: voice,
            channel: channel,
            notificationId: notificationId,
            scheduledFor: scheduledFor,
            surfacedAt: surfacedAt,
            expiresAt: expiresAt,
            deliveredAt: deliveredAt,
            respondedAt: respondedAt,
            reaction: reaction,
            respondedVia: respondedVia,
            responseText: responseText,
            planReason: planReason,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExposuresTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({interestId = false, snippetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (interestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.interestId,
                    referencedTable:
                        $$ExposuresTableTableReferences._interestIdTable(db),
                    referencedColumn:
                        $$ExposuresTableTableReferences._interestIdTable(db).id,
                  ) as T;
                }
                if (snippetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.snippetId,
                    referencedTable:
                        $$ExposuresTableTableReferences._snippetIdTable(db),
                    referencedColumn:
                        $$ExposuresTableTableReferences._snippetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExposuresTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExposuresTableTable,
    ExposuresTableData,
    $$ExposuresTableTableFilterComposer,
    $$ExposuresTableTableOrderingComposer,
    $$ExposuresTableTableAnnotationComposer,
    $$ExposuresTableTableCreateCompanionBuilder,
    $$ExposuresTableTableUpdateCompanionBuilder,
    (ExposuresTableData, $$ExposuresTableTableReferences),
    ExposuresTableData,
    PrefetchHooks Function({bool interestId, bool snippetId})>;
typedef $$AnalyticsEventsTableTableCreateCompanionBuilder
    = AnalyticsEventsTableCompanion Function({
  Value<int> id,
  required DateTime ts,
  required String localDate,
  required int localHour,
  required String type,
  Value<String?> exposureId,
  Value<String?> interestId,
  Value<String?> props,
});
typedef $$AnalyticsEventsTableTableUpdateCompanionBuilder
    = AnalyticsEventsTableCompanion Function({
  Value<int> id,
  Value<DateTime> ts,
  Value<String> localDate,
  Value<int> localHour,
  Value<String> type,
  Value<String?> exposureId,
  Value<String?> interestId,
  Value<String?> props,
});

class $$AnalyticsEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnalyticsEventsTableTable> {
  $$AnalyticsEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localHour => $composableBuilder(
      column: $table.localHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exposureId => $composableBuilder(
      column: $table.exposureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get interestId => $composableBuilder(
      column: $table.interestId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get props => $composableBuilder(
      column: $table.props, builder: (column) => ColumnFilters(column));
}

class $$AnalyticsEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalyticsEventsTableTable> {
  $$AnalyticsEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localHour => $composableBuilder(
      column: $table.localHour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exposureId => $composableBuilder(
      column: $table.exposureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get interestId => $composableBuilder(
      column: $table.interestId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get props => $composableBuilder(
      column: $table.props, builder: (column) => ColumnOrderings(column));
}

class $$AnalyticsEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalyticsEventsTableTable> {
  $$AnalyticsEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get localHour =>
      $composableBuilder(column: $table.localHour, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get exposureId => $composableBuilder(
      column: $table.exposureId, builder: (column) => column);

  GeneratedColumn<String> get interestId => $composableBuilder(
      column: $table.interestId, builder: (column) => column);

  GeneratedColumn<String> get props =>
      $composableBuilder(column: $table.props, builder: (column) => column);
}

class $$AnalyticsEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnalyticsEventsTableTable,
    AnalyticsEventsTableData,
    $$AnalyticsEventsTableTableFilterComposer,
    $$AnalyticsEventsTableTableOrderingComposer,
    $$AnalyticsEventsTableTableAnnotationComposer,
    $$AnalyticsEventsTableTableCreateCompanionBuilder,
    $$AnalyticsEventsTableTableUpdateCompanionBuilder,
    (
      AnalyticsEventsTableData,
      BaseReferences<_$AppDatabase, $AnalyticsEventsTableTable,
          AnalyticsEventsTableData>
    ),
    AnalyticsEventsTableData,
    PrefetchHooks Function()> {
  $$AnalyticsEventsTableTableTableManager(
      _$AppDatabase db, $AnalyticsEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalyticsEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalyticsEventsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalyticsEventsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> ts = const Value.absent(),
            Value<String> localDate = const Value.absent(),
            Value<int> localHour = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> exposureId = const Value.absent(),
            Value<String?> interestId = const Value.absent(),
            Value<String?> props = const Value.absent(),
          }) =>
              AnalyticsEventsTableCompanion(
            id: id,
            ts: ts,
            localDate: localDate,
            localHour: localHour,
            type: type,
            exposureId: exposureId,
            interestId: interestId,
            props: props,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime ts,
            required String localDate,
            required int localHour,
            required String type,
            Value<String?> exposureId = const Value.absent(),
            Value<String?> interestId = const Value.absent(),
            Value<String?> props = const Value.absent(),
          }) =>
              AnalyticsEventsTableCompanion.insert(
            id: id,
            ts: ts,
            localDate: localDate,
            localHour: localHour,
            type: type,
            exposureId: exposureId,
            interestId: interestId,
            props: props,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnalyticsEventsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AnalyticsEventsTableTable,
        AnalyticsEventsTableData,
        $$AnalyticsEventsTableTableFilterComposer,
        $$AnalyticsEventsTableTableOrderingComposer,
        $$AnalyticsEventsTableTableAnnotationComposer,
        $$AnalyticsEventsTableTableCreateCompanionBuilder,
        $$AnalyticsEventsTableTableUpdateCompanionBuilder,
        (
          AnalyticsEventsTableData,
          BaseReferences<_$AppDatabase, $AnalyticsEventsTableTable,
              AnalyticsEventsTableData>
        ),
        AnalyticsEventsTableData,
        PrefetchHooks Function()>;
typedef $$AnalyticsDailyTableTableCreateCompanionBuilder
    = AnalyticsDailyTableCompanion Function({
  required String localDate,
  required String metric,
  required String dimension,
  required double value,
  Value<int> rowid,
});
typedef $$AnalyticsDailyTableTableUpdateCompanionBuilder
    = AnalyticsDailyTableCompanion Function({
  Value<String> localDate,
  Value<String> metric,
  Value<String> dimension,
  Value<double> value,
  Value<int> rowid,
});

class $$AnalyticsDailyTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnalyticsDailyTableTable> {
  $$AnalyticsDailyTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metric => $composableBuilder(
      column: $table.metric, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AnalyticsDailyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalyticsDailyTableTable> {
  $$AnalyticsDailyTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metric => $composableBuilder(
      column: $table.metric, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AnalyticsDailyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalyticsDailyTableTable> {
  $$AnalyticsDailyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AnalyticsDailyTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnalyticsDailyTableTable,
    AnalyticsDailyTableData,
    $$AnalyticsDailyTableTableFilterComposer,
    $$AnalyticsDailyTableTableOrderingComposer,
    $$AnalyticsDailyTableTableAnnotationComposer,
    $$AnalyticsDailyTableTableCreateCompanionBuilder,
    $$AnalyticsDailyTableTableUpdateCompanionBuilder,
    (
      AnalyticsDailyTableData,
      BaseReferences<_$AppDatabase, $AnalyticsDailyTableTable,
          AnalyticsDailyTableData>
    ),
    AnalyticsDailyTableData,
    PrefetchHooks Function()> {
  $$AnalyticsDailyTableTableTableManager(
      _$AppDatabase db, $AnalyticsDailyTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalyticsDailyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalyticsDailyTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalyticsDailyTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> localDate = const Value.absent(),
            Value<String> metric = const Value.absent(),
            Value<String> dimension = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnalyticsDailyTableCompanion(
            localDate: localDate,
            metric: metric,
            dimension: dimension,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String localDate,
            required String metric,
            required String dimension,
            required double value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AnalyticsDailyTableCompanion.insert(
            localDate: localDate,
            metric: metric,
            dimension: dimension,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnalyticsDailyTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnalyticsDailyTableTable,
    AnalyticsDailyTableData,
    $$AnalyticsDailyTableTableFilterComposer,
    $$AnalyticsDailyTableTableOrderingComposer,
    $$AnalyticsDailyTableTableAnnotationComposer,
    $$AnalyticsDailyTableTableCreateCompanionBuilder,
    $$AnalyticsDailyTableTableUpdateCompanionBuilder,
    (
      AnalyticsDailyTableData,
      BaseReferences<_$AppDatabase, $AnalyticsDailyTableTable,
          AnalyticsDailyTableData>
    ),
    AnalyticsDailyTableData,
    PrefetchHooks Function()>;
typedef $$ErrorLogsTableTableCreateCompanionBuilder = ErrorLogsTableCompanion
    Function({
  Value<int> id,
  required DateTime ts,
  required String source,
  required String message,
  Value<String?> stack,
});
typedef $$ErrorLogsTableTableUpdateCompanionBuilder = ErrorLogsTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> ts,
  Value<String> source,
  Value<String> message,
  Value<String?> stack,
});

class $$ErrorLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ErrorLogsTableTable> {
  $$ErrorLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stack => $composableBuilder(
      column: $table.stack, builder: (column) => ColumnFilters(column));
}

class $$ErrorLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ErrorLogsTableTable> {
  $$ErrorLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stack => $composableBuilder(
      column: $table.stack, builder: (column) => ColumnOrderings(column));
}

class $$ErrorLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ErrorLogsTableTable> {
  $$ErrorLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get stack =>
      $composableBuilder(column: $table.stack, builder: (column) => column);
}

class $$ErrorLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ErrorLogsTableTable,
    ErrorLogsTableData,
    $$ErrorLogsTableTableFilterComposer,
    $$ErrorLogsTableTableOrderingComposer,
    $$ErrorLogsTableTableAnnotationComposer,
    $$ErrorLogsTableTableCreateCompanionBuilder,
    $$ErrorLogsTableTableUpdateCompanionBuilder,
    (
      ErrorLogsTableData,
      BaseReferences<_$AppDatabase, $ErrorLogsTableTable, ErrorLogsTableData>
    ),
    ErrorLogsTableData,
    PrefetchHooks Function()> {
  $$ErrorLogsTableTableTableManager(
      _$AppDatabase db, $ErrorLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ErrorLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ErrorLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ErrorLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> ts = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String?> stack = const Value.absent(),
          }) =>
              ErrorLogsTableCompanion(
            id: id,
            ts: ts,
            source: source,
            message: message,
            stack: stack,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime ts,
            required String source,
            required String message,
            Value<String?> stack = const Value.absent(),
          }) =>
              ErrorLogsTableCompanion.insert(
            id: id,
            ts: ts,
            source: source,
            message: message,
            stack: stack,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ErrorLogsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ErrorLogsTableTable,
    ErrorLogsTableData,
    $$ErrorLogsTableTableFilterComposer,
    $$ErrorLogsTableTableOrderingComposer,
    $$ErrorLogsTableTableAnnotationComposer,
    $$ErrorLogsTableTableCreateCompanionBuilder,
    $$ErrorLogsTableTableUpdateCompanionBuilder,
    (
      ErrorLogsTableData,
      BaseReferences<_$AppDatabase, $ErrorLogsTableTable, ErrorLogsTableData>
    ),
    ErrorLogsTableData,
    PrefetchHooks Function()>;
typedef $$RemindersTableTableCreateCompanionBuilder = RemindersTableCompanion
    Function({
  required String id,
  required String title,
  Value<String?> description,
  required String status,
  required String scheduleType,
  required DateTime startLocal,
  required String timezoneId,
  Value<DateTime?> nextOccurrenceUtc,
  Value<int> scheduleVersion,
  Value<bool> notificationEnabled,
  Value<String?> linkedActivityId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableTableUpdateCompanionBuilder = RemindersTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> status,
  Value<String> scheduleType,
  Value<DateTime> startLocal,
  Value<String> timezoneId,
  Value<DateTime?> nextOccurrenceUtc,
  Value<int> scheduleVersion,
  Value<bool> notificationEnabled,
  Value<String?> linkedActivityId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RemindersTableTableReferences extends BaseReferences<
    _$AppDatabase, $RemindersTableTable, RemindersTableData> {
  $$RemindersTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurrenceRulesTableTable,
      List<RecurrenceRulesTableData>> _recurrenceRulesTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.recurrenceRulesTable,
          aliasName: $_aliasNameGenerator(
              db.remindersTable.id, db.recurrenceRulesTable.reminderId));

  $$RecurrenceRulesTableTableProcessedTableManager
      get recurrenceRulesTableRefs {
    final manager = $$RecurrenceRulesTableTableTableManager(
            $_db, $_db.recurrenceRulesTable)
        .filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurrenceRulesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReminderOccurrencesTableTable,
      List<ReminderOccurrencesTableData>> _reminderOccurrencesTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.reminderOccurrencesTable,
          aliasName: $_aliasNameGenerator(
              db.remindersTable.id, db.reminderOccurrencesTable.reminderId));

  $$ReminderOccurrencesTableTableProcessedTableManager
      get reminderOccurrencesTableRefs {
    final manager = $$ReminderOccurrencesTableTableTableManager(
            $_db, $_db.reminderOccurrencesTable)
        .filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_reminderOccurrencesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startLocal => $composableBuilder(
      column: $table.startLocal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextOccurrenceUtc => $composableBuilder(
      column: $table.nextOccurrenceUtc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedActivityId => $composableBuilder(
      column: $table.linkedActivityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> recurrenceRulesTableRefs(
      Expression<bool> Function($$RecurrenceRulesTableTableFilterComposer f)
          f) {
    final $$RecurrenceRulesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurrenceRulesTable,
        getReferencedColumn: (t) => t.reminderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableTableFilterComposer(
              $db: $db,
              $table: $db.recurrenceRulesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reminderOccurrencesTableRefs(
      Expression<bool> Function($$ReminderOccurrencesTableTableFilterComposer f)
          f) {
    final $$ReminderOccurrencesTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.reminderOccurrencesTable,
            getReferencedColumn: (t) => t.reminderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ReminderOccurrencesTableTableFilterComposer(
                  $db: $db,
                  $table: $db.reminderOccurrencesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startLocal => $composableBuilder(
      column: $table.startLocal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextOccurrenceUtc => $composableBuilder(
      column: $table.nextOccurrenceUtc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedActivityId => $composableBuilder(
      column: $table.linkedActivityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<DateTime> get startLocal => $composableBuilder(
      column: $table.startLocal, builder: (column) => column);

  GeneratedColumn<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => column);

  GeneratedColumn<DateTime> get nextOccurrenceUtc => $composableBuilder(
      column: $table.nextOccurrenceUtc, builder: (column) => column);

  GeneratedColumn<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion, builder: (column) => column);

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled, builder: (column) => column);

  GeneratedColumn<String> get linkedActivityId => $composableBuilder(
      column: $table.linkedActivityId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recurrenceRulesTableRefs<T extends Object>(
      Expression<T> Function($$RecurrenceRulesTableTableAnnotationComposer a)
          f) {
    final $$RecurrenceRulesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurrenceRulesTable,
            getReferencedColumn: (t) => t.reminderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurrenceRulesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurrenceRulesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> reminderOccurrencesTableRefs<T extends Object>(
      Expression<T> Function(
              $$ReminderOccurrencesTableTableAnnotationComposer a)
          f) {
    final $$ReminderOccurrencesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.reminderOccurrencesTable,
            getReferencedColumn: (t) => t.reminderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ReminderOccurrencesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.reminderOccurrencesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RemindersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (RemindersTableData, $$RemindersTableTableReferences),
    RemindersTableData,
    PrefetchHooks Function(
        {bool recurrenceRulesTableRefs, bool reminderOccurrencesTableRefs})> {
  $$RemindersTableTableTableManager(
      _$AppDatabase db, $RemindersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<DateTime> startLocal = const Value.absent(),
            Value<String> timezoneId = const Value.absent(),
            Value<DateTime?> nextOccurrenceUtc = const Value.absent(),
            Value<int> scheduleVersion = const Value.absent(),
            Value<bool> notificationEnabled = const Value.absent(),
            Value<String?> linkedActivityId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion(
            id: id,
            title: title,
            description: description,
            status: status,
            scheduleType: scheduleType,
            startLocal: startLocal,
            timezoneId: timezoneId,
            nextOccurrenceUtc: nextOccurrenceUtc,
            scheduleVersion: scheduleVersion,
            notificationEnabled: notificationEnabled,
            linkedActivityId: linkedActivityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            required String status,
            required String scheduleType,
            required DateTime startLocal,
            required String timezoneId,
            Value<DateTime?> nextOccurrenceUtc = const Value.absent(),
            Value<int> scheduleVersion = const Value.absent(),
            Value<bool> notificationEnabled = const Value.absent(),
            Value<String?> linkedActivityId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            status: status,
            scheduleType: scheduleType,
            startLocal: startLocal,
            timezoneId: timezoneId,
            nextOccurrenceUtc: nextOccurrenceUtc,
            scheduleVersion: scheduleVersion,
            notificationEnabled: notificationEnabled,
            linkedActivityId: linkedActivityId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RemindersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {recurrenceRulesTableRefs = false,
              reminderOccurrencesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurrenceRulesTableRefs) db.recurrenceRulesTable,
                if (reminderOccurrencesTableRefs) db.reminderOccurrencesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurrenceRulesTableRefs)
                    await $_getPrefetchedData<RemindersTableData,
                            $RemindersTableTable, RecurrenceRulesTableData>(
                        currentTable: table,
                        referencedTable: $$RemindersTableTableReferences
                            ._recurrenceRulesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RemindersTableTableReferences(db, table, p0)
                                .recurrenceRulesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reminderId == item.id),
                        typedResults: items),
                  if (reminderOccurrencesTableRefs)
                    await $_getPrefetchedData<RemindersTableData,
                            $RemindersTableTable, ReminderOccurrencesTableData>(
                        currentTable: table,
                        referencedTable: $$RemindersTableTableReferences
                            ._reminderOccurrencesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RemindersTableTableReferences(db, table, p0)
                                .reminderOccurrencesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reminderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RemindersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (RemindersTableData, $$RemindersTableTableReferences),
    RemindersTableData,
    PrefetchHooks Function(
        {bool recurrenceRulesTableRefs, bool reminderOccurrencesTableRefs})>;
typedef $$RecurrenceRulesTableTableCreateCompanionBuilder
    = RecurrenceRulesTableCompanion Function({
  required String id,
  required String reminderId,
  required String ruleType,
  required String configJson,
  Value<int> schemaVersion,
  Value<int> rowid,
});
typedef $$RecurrenceRulesTableTableUpdateCompanionBuilder
    = RecurrenceRulesTableCompanion Function({
  Value<String> id,
  Value<String> reminderId,
  Value<String> ruleType,
  Value<String> configJson,
  Value<int> schemaVersion,
  Value<int> rowid,
});

final class $$RecurrenceRulesTableTableReferences extends BaseReferences<
    _$AppDatabase, $RecurrenceRulesTableTable, RecurrenceRulesTableData> {
  $$RecurrenceRulesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RemindersTableTable _reminderIdTable(_$AppDatabase db) =>
      db.remindersTable.createAlias($_aliasNameGenerator(
          db.recurrenceRulesTable.reminderId, db.remindersTable.id));

  $$RemindersTableTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$RemindersTableTableTableManager($_db, $_db.remindersTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecurrenceRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTableTable> {
  $$RecurrenceRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get schemaVersion => $composableBuilder(
      column: $table.schemaVersion, builder: (column) => ColumnFilters(column));

  $$RemindersTableTableFilterComposer get reminderId {
    final $$RemindersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableFilterComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrenceRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTableTable> {
  $$RecurrenceRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
      column: $table.schemaVersion,
      builder: (column) => ColumnOrderings(column));

  $$RemindersTableTableOrderingComposer get reminderId {
    final $$RemindersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableOrderingComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrenceRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTableTable> {
  $$RecurrenceRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleType =>
      $composableBuilder(column: $table.ruleType, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
      column: $table.schemaVersion, builder: (column) => column);

  $$RemindersTableTableAnnotationComposer get reminderId {
    final $$RemindersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrenceRulesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurrenceRulesTableTable,
    RecurrenceRulesTableData,
    $$RecurrenceRulesTableTableFilterComposer,
    $$RecurrenceRulesTableTableOrderingComposer,
    $$RecurrenceRulesTableTableAnnotationComposer,
    $$RecurrenceRulesTableTableCreateCompanionBuilder,
    $$RecurrenceRulesTableTableUpdateCompanionBuilder,
    (RecurrenceRulesTableData, $$RecurrenceRulesTableTableReferences),
    RecurrenceRulesTableData,
    PrefetchHooks Function({bool reminderId})> {
  $$RecurrenceRulesTableTableTableManager(
      _$AppDatabase db, $RecurrenceRulesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrenceRulesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrenceRulesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reminderId = const Value.absent(),
            Value<String> ruleType = const Value.absent(),
            Value<String> configJson = const Value.absent(),
            Value<int> schemaVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrenceRulesTableCompanion(
            id: id,
            reminderId: reminderId,
            ruleType: ruleType,
            configJson: configJson,
            schemaVersion: schemaVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reminderId,
            required String ruleType,
            required String configJson,
            Value<int> schemaVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrenceRulesTableCompanion.insert(
            id: id,
            reminderId: reminderId,
            ruleType: ruleType,
            configJson: configJson,
            schemaVersion: schemaVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecurrenceRulesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (reminderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reminderId,
                    referencedTable: $$RecurrenceRulesTableTableReferences
                        ._reminderIdTable(db),
                    referencedColumn: $$RecurrenceRulesTableTableReferences
                        ._reminderIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecurrenceRulesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RecurrenceRulesTableTable,
        RecurrenceRulesTableData,
        $$RecurrenceRulesTableTableFilterComposer,
        $$RecurrenceRulesTableTableOrderingComposer,
        $$RecurrenceRulesTableTableAnnotationComposer,
        $$RecurrenceRulesTableTableCreateCompanionBuilder,
        $$RecurrenceRulesTableTableUpdateCompanionBuilder,
        (RecurrenceRulesTableData, $$RecurrenceRulesTableTableReferences),
        RecurrenceRulesTableData,
        PrefetchHooks Function({bool reminderId})>;
typedef $$ReminderOccurrencesTableTableCreateCompanionBuilder
    = ReminderOccurrencesTableCompanion Function({
  required String id,
  required String reminderId,
  required int scheduleVersion,
  required DateTime scheduledAtUtc,
  required DateTime scheduledLocal,
  required String status,
  required int notificationId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ReminderOccurrencesTableTableUpdateCompanionBuilder
    = ReminderOccurrencesTableCompanion Function({
  Value<String> id,
  Value<String> reminderId,
  Value<int> scheduleVersion,
  Value<DateTime> scheduledAtUtc,
  Value<DateTime> scheduledLocal,
  Value<String> status,
  Value<int> notificationId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ReminderOccurrencesTableTableReferences extends BaseReferences<
    _$AppDatabase,
    $ReminderOccurrencesTableTable,
    ReminderOccurrencesTableData> {
  $$ReminderOccurrencesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RemindersTableTable _reminderIdTable(_$AppDatabase db) =>
      db.remindersTable.createAlias($_aliasNameGenerator(
          db.reminderOccurrencesTable.reminderId, db.remindersTable.id));

  $$RemindersTableTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$RemindersTableTableTableManager($_db, $_db.remindersTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReminderOccurrencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTableTable> {
  $$ReminderOccurrencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAtUtc => $composableBuilder(
      column: $table.scheduledAtUtc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledLocal => $composableBuilder(
      column: $table.scheduledLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$RemindersTableTableFilterComposer get reminderId {
    final $$RemindersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableFilterComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderOccurrencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTableTable> {
  $$ReminderOccurrencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAtUtc => $composableBuilder(
      column: $table.scheduledAtUtc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledLocal => $composableBuilder(
      column: $table.scheduledLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$RemindersTableTableOrderingComposer get reminderId {
    final $$RemindersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableOrderingComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderOccurrencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderOccurrencesTableTable> {
  $$ReminderOccurrencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get scheduleVersion => $composableBuilder(
      column: $table.scheduleVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAtUtc => $composableBuilder(
      column: $table.scheduledAtUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledLocal => $composableBuilder(
      column: $table.scheduledLocal, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RemindersTableTableAnnotationComposer get reminderId {
    final $$RemindersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.remindersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.remindersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderOccurrencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderOccurrencesTableTable,
    ReminderOccurrencesTableData,
    $$ReminderOccurrencesTableTableFilterComposer,
    $$ReminderOccurrencesTableTableOrderingComposer,
    $$ReminderOccurrencesTableTableAnnotationComposer,
    $$ReminderOccurrencesTableTableCreateCompanionBuilder,
    $$ReminderOccurrencesTableTableUpdateCompanionBuilder,
    (ReminderOccurrencesTableData, $$ReminderOccurrencesTableTableReferences),
    ReminderOccurrencesTableData,
    PrefetchHooks Function({bool reminderId})> {
  $$ReminderOccurrencesTableTableTableManager(
      _$AppDatabase db, $ReminderOccurrencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderOccurrencesTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderOccurrencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderOccurrencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reminderId = const Value.absent(),
            Value<int> scheduleVersion = const Value.absent(),
            Value<DateTime> scheduledAtUtc = const Value.absent(),
            Value<DateTime> scheduledLocal = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> notificationId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderOccurrencesTableCompanion(
            id: id,
            reminderId: reminderId,
            scheduleVersion: scheduleVersion,
            scheduledAtUtc: scheduledAtUtc,
            scheduledLocal: scheduledLocal,
            status: status,
            notificationId: notificationId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reminderId,
            required int scheduleVersion,
            required DateTime scheduledAtUtc,
            required DateTime scheduledLocal,
            required String status,
            required int notificationId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderOccurrencesTableCompanion.insert(
            id: id,
            reminderId: reminderId,
            scheduleVersion: scheduleVersion,
            scheduledAtUtc: scheduledAtUtc,
            scheduledLocal: scheduledLocal,
            status: status,
            notificationId: notificationId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReminderOccurrencesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (reminderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reminderId,
                    referencedTable: $$ReminderOccurrencesTableTableReferences
                        ._reminderIdTable(db),
                    referencedColumn: $$ReminderOccurrencesTableTableReferences
                        ._reminderIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReminderOccurrencesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ReminderOccurrencesTableTable,
        ReminderOccurrencesTableData,
        $$ReminderOccurrencesTableTableFilterComposer,
        $$ReminderOccurrencesTableTableOrderingComposer,
        $$ReminderOccurrencesTableTableAnnotationComposer,
        $$ReminderOccurrencesTableTableCreateCompanionBuilder,
        $$ReminderOccurrencesTableTableUpdateCompanionBuilder,
        (
          ReminderOccurrencesTableData,
          $$ReminderOccurrencesTableTableReferences
        ),
        ReminderOccurrencesTableData,
        PrefetchHooks Function({bool reminderId})>;
typedef $$ReminderSettingsTableTableCreateCompanionBuilder
    = ReminderSettingsTableCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$ReminderSettingsTableTableUpdateCompanionBuilder
    = ReminderSettingsTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$ReminderSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$ReminderSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$ReminderSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$ReminderSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderSettingsTableTable,
    ReminderSettingsTableData,
    $$ReminderSettingsTableTableFilterComposer,
    $$ReminderSettingsTableTableOrderingComposer,
    $$ReminderSettingsTableTableAnnotationComposer,
    $$ReminderSettingsTableTableCreateCompanionBuilder,
    $$ReminderSettingsTableTableUpdateCompanionBuilder,
    (
      ReminderSettingsTableData,
      BaseReferences<_$AppDatabase, $ReminderSettingsTableTable,
          ReminderSettingsTableData>
    ),
    ReminderSettingsTableData,
    PrefetchHooks Function()> {
  $$ReminderSettingsTableTableTableManager(
      _$AppDatabase db, $ReminderSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderSettingsTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderSettingsTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReminderSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ReminderSettingsTableTable,
        ReminderSettingsTableData,
        $$ReminderSettingsTableTableFilterComposer,
        $$ReminderSettingsTableTableOrderingComposer,
        $$ReminderSettingsTableTableAnnotationComposer,
        $$ReminderSettingsTableTableCreateCompanionBuilder,
        $$ReminderSettingsTableTableUpdateCompanionBuilder,
        (
          ReminderSettingsTableData,
          BaseReferences<_$AppDatabase, $ReminderSettingsTableTable,
              ReminderSettingsTableData>
        ),
        ReminderSettingsTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppStatesTableTableManager get appStates =>
      $$AppStatesTableTableManager(_db, _db.appStates);
  $$NotificationSettingsTableTableTableManager get notificationSettingsTable =>
      $$NotificationSettingsTableTableTableManager(
          _db, _db.notificationSettingsTable);
  $$InterestsTableTableTableManager get interestsTable =>
      $$InterestsTableTableTableManager(_db, _db.interestsTable);
  $$SnippetsTableTableTableManager get snippetsTable =>
      $$SnippetsTableTableTableManager(_db, _db.snippetsTable);
  $$ExposuresTableTableTableManager get exposuresTable =>
      $$ExposuresTableTableTableManager(_db, _db.exposuresTable);
  $$AnalyticsEventsTableTableTableManager get analyticsEventsTable =>
      $$AnalyticsEventsTableTableTableManager(_db, _db.analyticsEventsTable);
  $$AnalyticsDailyTableTableTableManager get analyticsDailyTable =>
      $$AnalyticsDailyTableTableTableManager(_db, _db.analyticsDailyTable);
  $$ErrorLogsTableTableTableManager get errorLogsTable =>
      $$ErrorLogsTableTableTableManager(_db, _db.errorLogsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
  $$RecurrenceRulesTableTableTableManager get recurrenceRulesTable =>
      $$RecurrenceRulesTableTableTableManager(_db, _db.recurrenceRulesTable);
  $$ReminderOccurrencesTableTableTableManager get reminderOccurrencesTable =>
      $$ReminderOccurrencesTableTableTableManager(
          _db, _db.reminderOccurrencesTable);
  $$ReminderSettingsTableTableTableManager get reminderSettingsTable =>
      $$ReminderSettingsTableTableTableManager(_db, _db.reminderSettingsTable);
}
