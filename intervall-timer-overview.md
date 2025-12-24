# Interval Timer App (Mobile, Local-First)

## Project Summary
A local, minimalist interval-timer app for Android that reminds users via sound, vibration, and notifications (e.g., hydration, breaks, focus).
The app is account-free, offline, extremely simple, and follows a clean, Teenage-Engineering-inspired design language.

**Core value:** reliable, configurable reminders with minimal UI overhead.

## Goals and Non-Goals
### Goals
- Reliable interval reminders in background and on lockscreen
- One-handed, fast interaction
- Clear visual separation of timers via color
- Fully local: no account, no sync

### Non-Goals
- No cloud sync
- No iOS (for now)
- No analytics/telemetry
- No accounts or profiles
- No complex wizards or sample timers

## Target Users and Roles
**Role:** single local user

**Audience (intentionally broad):**
- People who need regular reminders
- Focus, routine, or health use cases
- Tech-savvy users who want zero overhead

## Core Use Cases (User Stories)
- As a user, I open the app and see all timers in a list
- I can see at least 8 timers at once
- I create a new timer via a central plus button
- I configure interval, name, color, sound, and vibration
- I start/stop each timer directly in the list
- A timer reliably reminds me every X minutes
- Reminders work with screen off and app in background
- I delete timers by swiping left
- I define quiet hours (e.g., at night)
- I select custom audio files
- I enable a global mute button
- The app launches in dark mode
- I can switch language between DE and EN

## Feature Set
### MVP (Must-Have)
- Android app (APK, sideload)
- Flutter (Dart)
- Main screen with timer list
- Central plus button (FAB)
- Bottom-sheet timer editor (lower half)

**Timer fields:**
- Name
- Interval (minutes/hours)
- Endless or limited duration
- Color
- Sound (preset + file picker)
- Per-timer volume
- Vibration (on/off)
- Active/inactive

**Behavior and system:**
- Local notifications (sound + vibration)
- Background-capable, OS-compliant scheduling
- Swipe-to-delete
- Dark mode (default)
- DE/EN languages

### Nice-to-Have
- Custom vibration patterns
- Quiet hours (time window)
- Global mute button
- Light mode toggle
- Timer reordering (drag & drop)

### Future Ideas
- iOS port
- Export/import
- Presets
- Wearable support

## Information Architecture
### Screens
**Main Screen (single screen):**
- Timer list
- Start/stop per timer
- Central plus button (FAB)
- Optional global mute (top)

**Bottom Sheet: Timer Editor**
- Name
- Interval
- Duration / endless
- Sound picker
- File picker
- Color
- Vibration
- Quiet hours
- Save / cancel

**Settings (optional, minimal):**
- Language
- Light/dark mode

## High-Level Architecture
### Tech Stack (recommended)
- Flutter (Dart)
- Android SDK
- Gradle build
- Local Notifications plugin
- File Picker plugin

### Why Flutter?
- Clean, consistent UI
- Excellent bottom-sheet handling
- CLI-friendly (WSL, Git, CI)
- Android-first workflow is straightforward

## Components and Services
### Frontend
- Flutter widgets
- Simple state management (e.g., ChangeNotifier)

### Background / System
- Android local notifications
- OS-compliant scheduling (no hacky background service)

### Storage
- Local (key-value / JSON)
- No DB required for MVP

## Data Model Overview
### Timer
- id
- name
- intervalMinutes
- durationMinutes? (optional)
- isEndless
- color
- soundPath
- volume
- vibrationEnabled
- vibrationPattern?
- quietHours?
- isActive

## API / Interface Overview
**Internal only (no external API):**

**TimerService**
- createTimer()
- updateTimer()
- deleteTimer()
- startTimer()
- stopTimer()

**NotificationService**
- scheduleNotification()
- cancelNotification()

## Milestones
### Phase 0 — Setup
- Flutter project
- Git repo
- Android build via CLI
- APK sideload

### Phase 1 — MVP
- Main screen
- Timer CRUD
- Notifications
- Background handling

### Phase 2 — Hardening
- Edge cases (screen off, reboot)
- UI polish
- Performance cleanup

### Phase 3 — Enhancements
- Quiet hours
- Global mute
- Light mode

## Risks and Open Questions
- Android OEM battery optimizations (Doze)
- Notification reliability on aggressive ROMs
- File access permissions (Scoped Storage)
