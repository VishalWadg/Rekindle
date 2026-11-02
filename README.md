# Rekindle

> A calm, anti-productivity rediscovery mobile app that gently surfaces thoughts, notes, and curiosities you once cared about during spare moments — with zero streaks, zero due dates, and zero pressure.

Rekindle is explicitly **not** a spaced-repetition or productivity tool. It does not test you, track streaks, or tell you what is "overdue". Instead, it asks: *"what would you enjoy rediscovering right now?"*

Version 0.2 is **100% offline, on-device Flutter** (Android-first, iOS-ready). Release builds declare **no network permissions** and include **zero network packages**.

---

## Architecture Overview

Rekindle uses a clean two-tier workspace:

```text
rekindle/
├── app/                      # Flutter mobile application
│   ├── lib/
│   │   ├── app/              # Router (go_router), Theme (Paper/Dark), Providers
│   │   └── features/
│   │       ├── onboarding/   # 8-step guided onboarding flow
│   │       ├── surface/      # Single-thought screen with 250ms cross-fade
│   │       ├── interests/    # Interest catalog and snippet management
│   │       ├── explore/      # Hairline-divided library browse
│   │       ├── insights/     # On-device reflective analytics (no scoreboards)
│   │       ├── settings/     # Nudge preferences, test nudge, data export
│   │       └── nudges/       # Local notification gateway & action handlers
├── packages/
│   └── rekindle_core/        # Pure Dart domain package (zero Flutter imports)
│       ├── lib/src/
│       │   ├── bandit/       # BetaSampler (Marsaglia-Tsang / Box-Muller) & Thompson bandit
│       │   ├── data/         # Drift SQLite schema v1 (WAL mode, cascades, constraints)
│       │   ├── governor/     # Delivery governor rules (windows, gaps, backoff)
│       │   ├── planner/      # Deterministic 72h NudgePlanner
│       │   └── services/     # SurfaceService, ResponseService (exactly-once updates)
│       └── test/             # 20+ unit and property tests
├── assets/
│   ├── catalog/              # 36 starter interests across 6 categories
│   └── copy/                 # Calm and Playful copy library (T1–T5 templates)
├── tool/
│   └── check_offline.dart    # Offline CI guard (validates zero network imports & no banned words)
└── .github/workflows/
    └── build-apk.yml         # Automated GitHub Actions APK build workflow
```

---

## Core Guarantees & Philosophy

1. **Offline by Construction**: All data lives strictly in the phone's local SQLite database. No server, no accounts, and no telemetry.
2. **Thompson Sampling Bandit**: Written in pure Dart using Marsaglia-Tsang gamma-ratio sampling. Adapts to your preferences over time.
3. **Local Scheduled Nudges**: Answerable notifications (T1–T5) scheduled directly with the Android alarm system. Tapping an action button or typing an inline reply updates SQLite without opening the app.
4. **Ignoring is Always Free**: Dismissing a notification never penalizes an interest and never raises frequency.

---

## Development & Testing

### Running the App
```powershell
cd app
flutter run
```

### Running Core Unit Tests
```powershell
cd packages/rekindle_core
dart test
```

### Running the Offline Guard
```powershell
dart run tool/check_offline.dart
```

### Building Release APK
```powershell
cd app
flutter build apk --release
```
