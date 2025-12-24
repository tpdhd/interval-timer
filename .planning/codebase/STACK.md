# Technology Stack

**Analysis Date:** 2025-12-24

## Languages

**Primary:**
- Dart 3.10.4+ - All application code

## Runtime

**Environment:**
- Flutter 3.35.0+ - Mobile UI framework
- Android 13+ for notification permissions
- Gradle for Android builds

**Package Manager:**
- Pub (Dart's package manager)
- Lockfile: `pubspec.lock` present

## Frameworks

**Core:**
- Flutter - Cross-platform mobile UI framework
- Material Design 3 - UI theming (`lib/main.dart`)
- Provider 6.1.2 - State management (ChangeNotifier pattern)

**Testing:**
- flutter_test (Flutter SDK) - Widget testing framework
- flutter_lints 6.0.0 - Dart linting rules

**Build/Dev:**
- Gradle - Android build system
- analysis_options.yaml - Dart analyzer configuration

## Key Dependencies

**Critical:**
- provider 6.1.2 - State management (`lib/main.dart`, `lib/state/timer_store.dart`)
- flutter_local_notifications 17.2.3 - Local notifications/reminders (`lib/services/notification_service.dart`)
- shared_preferences 2.3.2 - Persistent local storage (`lib/services/timer_storage.dart`)
- audioplayers 6.1.0 - Audio playback for sound testing (`lib/ui/widgets/timer_editor_sheet.dart`)
- uuid 4.5.1 - Unique ID generation for timers (`lib/state/timer_store.dart`)

**Infrastructure:**
- flutter_timezone 5.0.1 - Timezone handling for notifications (`lib/services/notification_service.dart`)
- timezone 0.9.4 - Timezone data and scheduling (`lib/services/notification_service.dart`)
- file_picker 8.1.2 - Custom sound file selection (`lib/ui/widgets/timer_editor_sheet.dart`)
- intl 0.20.2 - Internationalization support
- cupertino_icons 1.0.8 - iOS icon assets

## Configuration

**Environment:**
- No .env files or external environment variables
- Configuration stored in `pubspec.yaml`
- Android permissions configured in `android/app/src/main/AndroidManifest.xml`

**Build:**
- `pubspec.yaml` - Flutter project configuration
- `analysis_options.yaml` - Linting configuration
- `android/gradle.properties` - JVM settings (-Xmx8G, MaxMetaspaceSize=4G)

## Platform Requirements

**Development:**
- Flutter SDK 3.35.0+
- Dart SDK 3.10.4+
- Any platform (Windows/macOS/Linux)
- Android SDK for Android builds

**Production:**
- Android 13+ (for notification permissions)
- Supports English (en) and German (de) locales (`lib/l10n/app_localizations.dart`)
- Local-first architecture (no internet required)

---

*Stack analysis: 2025-12-24*
*Update after major dependency changes*
