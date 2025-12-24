# Architecture

**Analysis Date:** 2025-12-24

## Pattern Overview

**Overall:** Feature-focused Flutter application with clean layered architecture

**Key Characteristics:**
- Single-screen app with modal dialogs for secondary flows
- Local-first, offline-capable design
- Real-time state synchronization with persistent storage
- Provider-based reactive UI updates

## Layers

**Presentation Layer (UI):**
- Purpose: User interface and interaction
- Contains: Screens, widgets, UI components
- Locations:
  - Main screen: `lib/ui/main_screen.dart`
  - Widgets: `lib/ui/widgets/timer_card.dart`, `lib/ui/widgets/timer_editor_sheet.dart`
- Depends on: State layer (Provider), models, localization
- Used by: Main app entry point

**State Management Layer:**
- Purpose: Central application state and business logic orchestration
- Contains: ChangeNotifier stores
- Location: `lib/state/timer_store.dart`
- Depends on: Models, services (storage, notifications)
- Used by: UI layer via Provider pattern
- Key operations: Timer CRUD, global settings, persistence coordination

**Service Layer:**
- Purpose: External system abstractions (storage, notifications)
- Contains: Service implementations
- Locations:
  - `lib/services/timer_storage.dart` - SharedPreferences wrapper
  - `lib/services/notification_service.dart` - Android notification scheduler
- Depends on: Flutter platform channels, third-party packages
- Used by: State layer
- Pattern: Dependency injection into store

**Data Model Layer:**
- Purpose: Immutable data structures
- Contains: Models with serialization logic
- Location: `lib/models/timer_model.dart`
- Depends on: Nothing (isolated)
- Used by: All layers
- Pattern: Immutable classes with copyWith()

**Localization Layer:**
- Purpose: Internationalization (i18n)
- Contains: Translation strings and delegates
- Location: `lib/l10n/app_localizations.dart`
- Depends on: Nothing (isolated)
- Used by: UI layer
- Supports: English (en), German (de)

## Data Flow

**Create Timer Flow:**

1. User taps FAB → `MainScreen._openEditor()` shows modal
2. Modal displays `TimerEditorSheet` with empty timer
3. User edits: name, interval, color, sound, volume, vibration
4. `TimerEditorSheet._save()` returns updated `TimerModel`
5. `MainScreen` calls `store.addTimer(result)`
6. `TimerStore.addTimer()`:
   - Adds to `_timers` list
   - Calls `_persist()` → saves to storage
   - Calls `notifyListeners()` → UI rebuilds

**Activate Timer Flow:**

1. User toggles switch on `TimerCard`
2. `onToggleActive` callback invokes `store.toggleTimerActive(id, true)`
3. `TimerStore.toggleTimerActive()`:
   - Updates timer with `isActive=true`, `startedAt=DateTime.now()`
   - Persists changes via `_persist()`
   - Calls `_notifications.scheduleTimer(timer, globalMute)`
4. `NotificationService.scheduleTimer()`:
   - Calculates next 96 occurrences from start time
   - Schedules Android notifications with sound/vibration

**Display Countdown Flow:**

1. `TimerCard` builds with `StreamBuilder<DateTime>` updating every second
2. Calls `_calculateNextTime()` - finds next occurrence from `startedAt + interval`
3. Formats remaining time as HH:MM:SS countdown
4. Displays "Inactive" state if timer not active

**State Persistence:**
- On app load: `TimerStore.load()` restores from SharedPreferences
- On changes: Automatic save via `_persist()` after any mutation
- Storage backend: SharedPreferences (key-value)

## Key Abstractions

**TimerStore (ChangeNotifier):**
- Purpose: Central state management and business logic coordinator
- Location: `lib/state/timer_store.dart`
- Pattern: Provider pattern with ChangeNotifier
- Key methods: `addTimer()`, `updateTimer()`, `deleteTimer()`, `toggleTimerActive()`

**TimerModel (Immutable Data):**
- Purpose: Timer data structure
- Location: `lib/models/timer_model.dart`
- Pattern: Immutable with `copyWith()` for updates
- Serialization: Manual `toJson()`/`fromJson()`

**Services (Dependency Injection):**
- Purpose: Abstract external systems
- Locations: `lib/services/timer_storage.dart`, `lib/services/notification_service.dart`
- Pattern: Constructor injection into TimerStore
- Benefit: Testability via mocking

**Modal Navigation:**
- Purpose: Component separation for secondary flows
- Pattern: `showModalBottomSheet()` with typed returns
- Examples: Timer editor (`TimerEditorSheet`), settings modal

## Entry Points

**Main Entry:**
- Location: `lib/main.dart`
- Triggers: App launch
- Responsibilities:
  - Initialize WidgetsFlutterBinding
  - Create ChangeNotifierProvider with TimerStore
  - Inject dependencies (TimerStorage, NotificationService)
  - Call `store.load()` to restore state
  - Render `IntervalTimerApp` with Material3 theme

**App Root:**
- Location: `lib/ui/main_screen.dart`
- Triggers: Main app renders after initialization
- Responsibilities: Primary scaffold, timer list, FAB, settings

## Error Handling

**Strategy:** Limited error handling with graceful fallbacks

**Patterns:**
- `NotificationService`: Try-catch for PlatformException (exact alarm scheduling)
- Fallback: Exact alarm scheduling falls back to inexact mode if permission denied
- Storage: No explicit error handling (operations can fail silently)

**Gaps:**
- No error boundaries or global error handling
- Storage failures not communicated to user
- No retry mechanisms

## Cross-Cutting Concerns

**Logging:**
- No logging framework
- No debug output or error logging

**Validation:**
- Minimal input validation in `TimerEditorSheet`
- No maximum limits on interval values
- No comprehensive file path validation

**Theme Management:**
- Material Design 3 with color seed (teal)
- Light/dark mode support via `ThemeMode` stored in preferences
- Runtime theme switching without restart

---

*Architecture analysis: 2025-12-24*
*Update when major patterns change*
