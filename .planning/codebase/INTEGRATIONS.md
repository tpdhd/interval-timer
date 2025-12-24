# External Integrations

**Analysis Date:** 2025-12-24

## APIs & External Services

**No External Services Detected**
- No HTTP/REST API calls
- No Firebase integration
- No cloud database connectivity
- No analytics services
- No third-party authentication providers
- No payment processing
- No advertisement networks

## Data Storage

**Local Storage (On-Device Only):**
- SharedPreferences - Persistent key-value storage
  - Location: `lib/services/timer_storage.dart`
  - Stores: Timer data (JSON), global mute state, theme mode, locale preference
  - No cloud sync or backup

## Device-Level Integrations

**Local Notifications:**
- Flutter Local Notifications 17.2.3 - `lib/services/notification_service.dart`
  - Scheduled exact alarms for interval-based reminders
  - Android notification channels for different sound types
  - Custom notification sounds (bundled as raw resources)
  - Vibration pattern support with `Int64List`
  - Timezone-aware scheduling via timezone library
  - Exact alarm scheduling with fallback to inexact mode
  - Required permissions: POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM

**Audio Playback:**
- AudioPlayers 6.1.0 - `lib/ui/widgets/timer_editor_sheet.dart`
  - Sound testing during timer configuration
  - Supports: example sounds, custom user files, silent mode
  - Volume control (stored for future expansion)

**File System Access:**
- FilePicker 8.1.2 - `lib/ui/widgets/timer_editor_sheet.dart`
  - Custom audio file selection for notification sounds
  - Required permissions: READ_MEDIA_AUDIO, READ_EXTERNAL_STORAGE

**Timezone Services:**
- FlutterTimezone 5.0.1 - Gets device timezone
- Timezone library 0.9.4 - Manages timezone data for scheduled notifications
  - Location: `lib/services/notification_service.dart`
  - Handles DST and timezone conversions

## System Permissions

**Android Manifest** (`android/app/src/main/AndroidManifest.xml`):
- POST_NOTIFICATIONS - Required for Android 13+
- VIBRATE - Haptic feedback for notifications
- SCHEDULE_EXACT_ALARM - Precise timer scheduling
- READ_MEDIA_AUDIO - Access to custom sound files
- READ_EXTERNAL_STORAGE - Legacy storage access

## Authentication & Identity

**No authentication system**
- No user accounts
- No login/logout flow
- No identity providers
- All data stored locally per device

## Monitoring & Observability

**No external monitoring:**
- No error tracking (Sentry, Crashlytics)
- No analytics (Google Analytics, Mixpanel)
- No performance monitoring
- No remote logging

## CI/CD & Deployment

**No CI/CD configured:**
- No GitHub Actions workflows
- No automated testing pipeline
- No deployment automation
- Manual build and release process

## Environment Configuration

**Development:**
- No environment variables required
- All configuration in `pubspec.yaml`
- No secrets management needed (no external services)

**Production:**
- Same as development (no environment differences)
- No deployment-specific configuration

## Data Flow

**Architecture:** Local-first, offline-capable
- All data remains on-device (no network calls)
- Timer data serialized as JSON in SharedPreferences
- Notifications scheduled locally using Android's AlarmManager
- No internet connectivity required for any functionality

---

*Integration audit: 2025-12-24*
*Update when adding/removing external services*
