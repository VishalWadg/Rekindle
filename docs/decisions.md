# Rekindle — Architectural Decision Records (ADRs)

This document records the critical architectural and engineering decisions made during the development of Rekindle, along with the context, options considered, and reasoning behind each choice.

---

## Index of Decisions

- [ADR-001: Pivot to 100% Offline On-Device Mobile App](#adr-001-pivot-to-100-offline-on-device-mobile-app)
- [ADR-002: Modularization with a Pure-Dart Core Package (`rekindle_core`)](#adr-002-modularization-with-a-pure-dart-core-package-rekindle_core)
- [ADR-003: Drift SQLite as Local Source of Truth](#adr-003-drift-sqlite-as-local-source-of-truth)
- [ADR-004: Version-Agnostic Notification Scheduling & Graceful Alarm Fallback](#adr-004-version-agnostic-notification-scheduling--graceful-alarm-fallback)
- [ADR-005: ProGuard & R8 Configuration for Gson Reflection](#adr-005-proguard--r8-configuration-for-gson-reflection)
- [ADR-006: Telegram Bot Webhook for Sideloaded APK CI/CD Distribution](#adr-006-telegram-bot-webhook-for-sideloaded-apk-cicd-distribution)
- [ADR-007: Compulsory Multi-Interest & Thought Seeding in Onboarding](#adr-007-compulsory-multi-interest--thought-seeding-in-onboarding)
- [ADR-008: Fully Offline Reminder Domain Engine & Recurrence Semantics](#adr-008-fully-offline-reminder-domain-engine--recurrence-semantics)
- [ADR-009: Drift Schema v2 Migration & Relational Persistence](#adr-009-drift-schema-v2-migration--relational-persistence)
- [ADR-010: Hexagonal Notification Adapter & Dedicated Reminder Channel](#adr-010-hexagonal-notification-adapter--dedicated-reminder-channel)
- [ADR-011: Idempotent Reminder Reconciliation & Lifecycle Sync](#adr-011-idempotent-reminder-reconciliation--lifecycle-sync)
- [ADR-012: Calm Reminder Presentation & Polymorphic Recurrence UX](#adr-012-calm-reminder-presentation--polymorphic-recurrence-ux)
- [ADR-013: Offline Data Portability & Versioned JSON Backup](#adr-013-offline-data-portability--versioned-json-backup)

---

### ADR-001: Pivot to 100% Offline On-Device Mobile App

- **Date**: 2026-11-02
- **Status**: Accepted
- **Context**: Rekindle was originally conceived as a client-server architecture (FastAPI/Spring Boot + Postgres + Redis). However, a calm, personal rediscovery tool demands absolute privacy, instant responsiveness, and zero dependency on external servers or subscriptions.
- **Decision**: Redesign Rekindle as a 100% offline, on-device mobile application. Remove all network permissions (`android.permission.INTERNET`), HTTP dependencies, and cloud database requirements.
- **Consequences**:
  - *Pros*: Complete privacy for personal thoughts; zero server maintenance costs; immune to outages or network latency.
  - *Cons*: Sideloaded APK distribution model required for personal testing prior to app store submissions.

---

### ADR-002: Modularization with a Pure-Dart Core Package (`rekindle_core`)

- **Date**: 2026-11-02
- **Status**: Accepted
- **Context**: Coupling bandit logic, SQLite queries, and scheduling calculations with Flutter UI widgets makes unit testing slow and platform-dependent.
- **Decision**: Isolate all domain models, algorithms, services, and Drift tables into `packages/rekindle_core` with zero Flutter UI dependencies.
- **Consequences**:
  - *Pros*: 100% of core business logic can be tested in sub-second headless Dart tests (`dart test`); clean separation of concerns; potential reuse across CLI or desktop clients.
  - *Cons*: Requires maintaining a monorepo structure with path dependencies in `pubspec.yaml`.

---

### ADR-003: Drift SQLite as Local Source of Truth

- **Date**: 2026-11-02
- **Status**: Accepted
- **Context**: Need a fast, relational, ACID-compliant local storage engine in Dart supporting complex queries (joins, recency checks, atomic exposure updates). Key-value stores like Hive/SharedPreferences are insufficient for relational bandit querying.
- **Decision**: Use **Drift (formerly Moor)** on top of SQLite (`sqlite3_flutter_libs`).
- **Consequences**:
  - *Pros*: Compile-time type safety; native SQLite indexing; automated schema migrations; reactive streams (`watchSingleOrNull`).
  - *Cons*: Code generation step required (`build_runner`) when modifying schema.

---

### ADR-004: Version-Agnostic Notification Scheduling & Graceful Alarm Fallback

- **Date**: 2026-11-03
- **Status**: Accepted
- **Context**: On Android 12+ (API 31+), and strictly in Android 13/14+, `AlarmManager.setExactAndAllowWhileIdle()` throws a fatal `SecurityException` (`ExactAlarmPermissionException`) unless the user explicitly grants a special hidden OS toggle (*Alarms & reminders*). Calling exact alarms unprompted crashed the app with *"Rekindle keeps stopping"*.
- **Decision**:
  1. Wrap scheduling in defensive degradation: check `canScheduleExactNotifications()`.
  2. Attempt `AndroidScheduleMode.exactAllowWhileIdle`.
  3. If rejected or permission is absent, catch the exception and fall back to `AndroidScheduleMode.inexactAllowWhileIdle`.
  4. Register `ActionBroadcastReceiver` in `AndroidManifest.xml` to handle notification action buttons.
- **Consequences**:
  - *Pros*: App never crashes on launch or schedule; works consistently across Android 8 through 15+.
  - *Cons*: Inexact alarms may have minor delivery jitter (few minutes) when exact permission is not granted.

---

### ADR-005: ProGuard & R8 Configuration for Gson Reflection

- **Date**: 2026-11-03
- **Status**: Accepted
- **Context**: In release builds (`flutter build apk --release`), Android R8 compiler minifies code and strips generic type signatures (`Signature`). `flutter_local_notifications` uses Google's `Gson` library via `TypeToken<ArrayList<NotificationDetails>>` to serialize scheduled alarms. Without keep rules, Gson threw `java.lang.RuntimeException: Missing type parameter` in release mode.
- **Decision**:
  1. Add `proguard-rules.pro` with `-keepattributes Signature, InnerClasses, *Annotation*` and keep rules for `com.google.gson.**` and `com.dexterous.flutterlocalnotifications.**`.
  2. Set `isMinifyEnabled = false` and `isShrinkResources = false` in `build.gradle.kts` release build type.
  3. Add `keep.xml` to prevent discarding notification drawables and launcher icons.
- **Consequences**:
  - *Pros*: Scheduled notifications deserialize flawlessly in release APKs.
  - *Cons*: APK size is slightly larger (~few hundred KB) without class name obfuscation, which is negligible for our use case.

---

### ADR-006: Telegram Bot Webhook for Sideloaded APK CI/CD Distribution

- **Date**: 2026-11-03
- **Status**: Accepted
- **Context**: Because Rekindle is an offline sideloaded app, testers need a frictionless way to install new releases without manually visiting GitHub Releases in a browser.
- **Decision**: Integrate a Telegram Bot webhook into `.github/workflows/build-apk.yml`. Upon every successful push to `main`, GitHub Actions uses `sendDocument` to upload `app-release.apk` directly into the tester Telegram group with a formatted caption and release notes.
- **Consequences**:
  - *Pros*: Testers can tap and install updates directly from Telegram; automated continuous delivery loop.
  - *Cons*: Requires maintaining `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` as repository secrets.

---

### ADR-007: Compulsory Multi-Interest & Thought Seeding in Onboarding

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: The Thompson Sampling bandit algorithm and Surface engine require at least one snippet to surface an interest. Allowing users to complete onboarding with 0 thoughts or only 1 topic left the home screen in an empty or degenerated state.
- **Decision**:
  1. Enforce a minimum of 3 interests selected in Onboarding Step 3 (`_selectedInterests.length >= 3`).
  2. Remove the "Skip for now" button in Step 4; require at least one thought/memory for each of the base 3 interests before allowing the user to proceed.
  3. Replace the cramped `SegmentedButton` in Step 6 with calm, accessible frequency cards with descriptive cadences.
- **Consequences**:
  - *Pros*: Every user leaves onboarding with a rich, functional library ready for immediate multi-armed bandit exploration and surfacing.
  - *Cons*: Adds ~1 minute of intentional effort during initial onboarding.

---

### ADR-008: Fully Offline Reminder Domain Engine & Recurrence Semantics

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: Rekindle requires a reliable, 100% offline reminder scheduling system. Reminders need to support one-time, fixed-interval, and weekly schedules, handling IANA timezones and Daylight Saving Time (DST) edge cases cleanly, with zero network or backend dependency. Furthermore, domain logic must remain independent of Flutter UI and the Thompson Sampling recommendation engine.
- **Decision**:
  1. **Pure-Dart Domain Foundation**: Isolate domain models (`Reminder`, `ReminderOccurrence`, `RecurrenceRule`, `ReminderStatus`, `ScheduleType`, `OccurrenceStatus`) within `packages/rekindle_core/lib/src/reminders/`.
  2. **Headless `ReminderTime`**: Use a dedicated `ReminderTime(int hour, int minute)` value object with validation instead of Flutter's `TimeOfDay`, ensuring domain logic can be tested in sub-second headless Dart tests (`dart test`).
  3. **Strict Elapsed vs. Calendar Recurrence Semantics**:
     - *Interval Rules* (e.g., every 2 hours, every 3 days): Evaluated strictly as elapsed duration from anchor `startUtc` ($T_{next} = T_{start} + k \times \Delta t > T_{after}$), preventing cumulative timing drift.
     - *Weekly Rules* (e.g., Mon/Wed/Fri at 07:00 IST): Evaluated against local calendar days and wall-clock time in the configured IANA timezone using the `timezone` package.
  4. **Single Next Occurrence Policy**: Generate and schedule only the immediate next occurrence per reminder into Drift and the OS alarm manager, avoiding bloated calendars and phantom notifications.
  5. **Engine Decoupling**: Keep the reminder engine strictly decoupled from the recommendation engine. Recommendation suggestions may prompt the user to set a reminder, but reminders are created only via explicit user action.
- **Consequences**:
  - *Pros*: 100% offline, highly deterministic, sub-second headless unit test suite, robust DST transition handling.
  - *Cons*: Demands app-level reconciliation when device timezone shifts or when device reboots.

---

### ADR-009: Drift Schema v2 Migration & Relational Persistence

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: The offline reminder system needs persistent, relational local storage in SQLite. Reminders, versioned recurrence rules, occurrences, and settings must maintain strict relational integrity. Users upgrading from v0.2.0 (Schema v1) must not lose existing interests or snippets.
- **Decision**:
  1. **Schema v2 Tables**: Define `RemindersTable`, `RecurrenceRulesTable`, `ReminderOccurrencesTable`, and `ReminderSettingsTable` in `AppDatabase`.
  2. **Relational Constraints & Cascade Deletion**: Enforce SQLite foreign keys (`PRAGMA foreign_keys = ON;`) with `ON DELETE CASCADE` on `recurrence_rules.reminder_id` and `reminder_occurrences.reminder_id`. Deleting a reminder automatically purges its rule and pending occurrences.
  3. **Unique Occurrence Constraint**: Enforce a compound unique constraint on `(reminder_id, schedule_version, scheduled_at_utc)` preventing duplicate scheduled alarms.
  4. **Non-Destructive Migration**: In `MigrationStrategy.onUpgrade`, conditionally create the new v2 tables when `from < 2`. Existing user data in `interests_table` and `snippets_table` remains completely untouched.
  5. **Atomic Repository Transactions**: Encapsulate multi-table writes (`saveReminder`, `updateRecurrenceRule`) in `db.transaction(() async { ... })` so that a failure never leaves partial records.
- **Consequences**:
  - *Pros*: Zero data loss on upgrades (verified with migration unit test); automatic cleanup of child records; transactionally safe.
  - *Cons*: Requires `build_runner` code generation when modifying schema tables.

---

### ADR-010: Hexagonal Notification Adapter & Dedicated Reminder Channel

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: Rekindle needs an isolated, testable platform adapter for scheduling offline Android notifications without polluting the domain or application layers with Flutter plugins. Reminders demand higher urgency and user intent than gentle serendipitous nudges, requiring a distinct Android notification channel with sound and vibration enabled.
- **Decision**:
  1. **Ports and Adapters**: Declare `LocalNotificationScheduler` interface in `app/lib/features/reminders/reminder_scheduler.dart`. The concrete `FlutterLocalNotificationScheduler` implements this interface using `flutter_local_notifications`.
  2. **Dedicated Channel**: Create Android channel `rekindle_reminders` (`Reminders`, `Importance.high`, sound/vibration enabled), registered alongside `nudges` on app boot.
  3. **Exact-to-Inexact Alarm Degradation**: Defensive scheduling attempts `AndroidScheduleMode.exactAllowWhileIdle` and catches any Android 12/13/14+ `SecurityException` / `ExactAlarmPermissionException` to seamlessly fall back to `AndroidScheduleMode.inexactAllowWhileIdle`.
  4. **Payload & Actions**: Serialize JSON metadata (`type: REMINDER`, `reminderId`, `occurrenceId`) and register notification action buttons (`Complete`, `Skip`).
- **Consequences**:
  - *Pros*: App is completely immune to exact alarm crashes on all Android versions; notification scheduling is fully mockable in unit and widget tests.
  - *Cons*: Action button clicks require routing in notification broadcast callbacks.

---

### ADR-011: Idempotent Reminder Reconciliation & Lifecycle Sync

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: In an offline-first mobile architecture, platform alarm registrations are volatile: devices reboot, aggressive OEM battery management clears pending alarms, and users change timezones. Without a remote push server, the app must autonomously ensure that scheduled reminders are never permanently lost.
- **Decision**:
  1. **SQLite as Single Truth**: Treat SQLite as the authoritative state and the OS `AlarmManager` table as an ephemeral projection.
  2. **Lifecycle Triggers**: Hook reconciliation into `main.dart` on application startup and on `AppLifecycleState.resumed` via `WidgetsBindingObserver`.
  3. **Missed Occurrence Catch-Up**: Compare pending occurrences against `DateTime.now().toUtc()`. Any occurrence past its scheduled instant while the device was sleeping/off is marked `missed`, and recurring rules are immediately stepped forward to their next future occurrence.
  4. **Dropped Alarm Recovery**: Cross-reference active database occurrences against `scheduler.getPendingNotificationIds()`. Any database occurrence missing from the platform scheduler is restored idempotently.
  5. **Timezone Shift Detection**: Compare the current device timezone (`FlutterTimezone`) against the stored `last_reconciled_timezone` setting. When a shift is detected, recalculate occurrences under the new timezone location and reschedule alarms without duplicate firings.
- **Consequences**:
  - *Pros*: Self-healing offline reminder delivery across reboots and timezone shifts; completely verifiable via automated unit tests.
  - *Cons*: Executes a sub-10ms query reconciliation on app foregrounding.

---

### ADR-012: Calm Reminder Presentation & Polymorphic Recurrence UX

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: Rekindle needs a user-facing interface to view, create, edit, pause, and delete offline reminders without violating its calm, pressure-free ethos or introducing complex, cluttered modals.
- **Decision**:
  1. **Reactive List View**: Bind `RemindersListScreen` directly to Drift's reactive `watchAllReminders()` stream via Riverpod (`remindersStreamProvider`).
  2. **Polymorphic Recurrence Form**: Build `ReminderFormScreen` with dynamic input controls tailored to the selected `ScheduleType`:
     - *Interval*: duration numeric input + unit dropdown (hours, days, weeks).
     - *Weekly*: day-of-week selection chips ($1 \dots 7$) + time picker.
     - *Once*: calendar date picker + clock time picker.
  3. **Visual & Voice Alignment**: Apply Warm Paper cards, Lora headline typography, subtle status badges (Active, Paused, Completed), and eliminate all guilt/streak gamification indicators.
  4. **Direct Navigation**: Expose `/reminders`, `/reminders/new`, and `/reminders/edit/:id` routes in `GoRouter`, linked from `SettingsScreen`.
- **Consequences**:
  - *Pros*: Seamless user experience consistent with Rekindle's calm philosophy; immediate UI reactivity on state changes.
  - *Cons*: Requires viewport scrolling management for long forms in widget tests.

---

### ADR-013: Offline Data Portability & Versioned JSON Backup

- **Date**: 2026-11-04
- **Status**: Accepted
- **Context**: Rekindle is an offline-only application with zero cloud databases, accounts, or telemetry. Users who curate reminders and recurrence rules must have full data ownership and the ability to export and import schedules across devices without binary SQLite lock-in.
- **Decision**:
  1. **Versioned JSON Portability**: Implement `ReminderPortabilityService` in `app/lib/features/reminders/reminder_portability_service.dart`.
  2. **Deterministic Payload Structure**: Export includes `schema_version: 1`, `exported_at`, and an array of reminders paired with their serialized versioned recurrence rules (`rule.toSerializedJson()`).
  3. **Idempotent Import & Rescheduling**: When importing, deserialize models, validate schema version compatibility, persist records in Drift transactions, and recalculate next occurrences strictly after current UTC time to enqueue alarms in the target device's `LocalNotificationScheduler`.
- **Consequences**:
  - *Pros*: Complete privacy and portability; seamless transfer between devices; robust schema validation prevents corruption.
  - *Cons*: Future recurrence rule extensions will require migration mappers in the import pipeline.
