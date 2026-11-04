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
