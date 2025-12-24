# Interval Timer

A local-first Android interval timer app built with Flutter. Configure multiple timers with sound, vibration, colors, and quiet hours. The app stores everything locally and runs offline.

## Features
- Multiple timers with color-coded cards
- Per-timer interval and optional duration
- Start/stop directly from the list
- Quiet hours to pause reminders during a time window
- Global mute toggle
- Dark mode by default, optional light mode
- DE/EN language toggle
- Local notifications with vibration

## Project Structure
- `lib/models/` – data model
- `lib/services/` – storage + notifications
- `lib/state/` – app state store
- `lib/ui/` – screens and widgets
- `lib/l10n/` – lightweight localization

## Run
```bash
flutter pub get
flutter run
```

## Notes
- Android 13+ requires notification permission; the app requests it on launch.
- Custom sound selection is stored in settings, but Android notifications use the system default unless you bundle a sound resource. “Silent” disables sound entirely.
- Per-timer volume is stored for future expansion (Android notification volume is system-managed).

## Build APK
```bash
flutter build apk
```
