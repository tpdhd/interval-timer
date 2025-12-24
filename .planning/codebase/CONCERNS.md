# Codebase Concerns

**Analysis Date:** 2025-12-24

## Tech Debt

**Stream Management - Memory Leak Risk:**
- Issue: Periodic stream created in build method without proper cleanup
- Files: `lib/ui/widgets/timer_card.dart` (lines 22-25, 72-84)
- Why: Quick implementation without lifecycle management
- Impact: Stream persists and recreates on every rebuild, potential memory leaks
- Fix approach: Move stream creation to `initState()`, use `StreamController`, dispose in `dispose()`

**SharedPreferences Inefficiency:**
- Issue: Repeated `SharedPreferences.getInstance()` calls in every method
- File: `lib/services/timer_storage.dart` (all methods, lines 11-53)
- Why: No instance caching implemented
- Impact: Wasteful async operations, harder to test
- Fix approach: Cache instance as static or instance variable

**Large Widget - Too Much Responsibility:**
- Issue: Single widget handles too many concerns (401 lines)
- File: `lib/ui/widgets/timer_editor_sheet.dart`
- Why: Rapid development without decomposition
- Impact: Hard to test, maintain, and reuse
- Fix approach: Extract color picker, sound selector, vibration settings into separate widgets

**Incomplete Feature - QuietHours:**
- Issue: Feature model exists but is disabled/unused
- Files: `lib/models/timer_model.dart` (line 43), `lib/services/notification_service.dart` (line 222)
- Why: Feature started but not completed
- Impact: Dead code, model complexity, unclear intent
- Fix approach: Either complete the feature or remove QuietHours model entirely

## Known Bugs

**No known bugs identified**
- Codebase appears functionally complete for current feature set
- Testing would likely reveal edge cases

## Security Considerations

**No security-sensitive patterns detected:**
- No hardcoded secrets (app is fully local)
- No API keys or credentials (no external services)
- No user authentication (no need for security)

**Permissions properly scoped:**
- Android permissions declared in `android/app/src/main/AndroidManifest.xml`
- All permissions justified for functionality

## Performance Bottlenecks

**Real-time Countdown - Frequent Rebuilds:**
- Problem: Stream fires every second, triggering widget rebuilds
- File: `lib/ui/widgets/timer_card.dart` (lines 22-25, 72-84)
- Measurement: Every timer card rebuilds every second
- Cause: StreamBuilder with periodic stream in build method
- Improvement path: Use `Timer` instead of `Stream`, implement shouldRebuild checks

**No other performance concerns identified:**
- Local storage operations are fast
- UI is responsive
- No complex computations

## Fragile Areas

**Time Alignment Algorithm - Undocumented:**
- File: `lib/services/notification_service.dart` (lines 206-220)
- Why fragile: Complex modulo arithmetic without documentation
- Common failures: Edge cases with DST, timezone changes not tested
- Safe modification: Add comprehensive tests before changing, document algorithm
- Test coverage: None

**Error Handling Gaps:**
- Files: `lib/services/timer_storage.dart`, `lib/state/timer_store.dart`, `lib/services/notification_service.dart`
- Why fragile: Operations can fail silently without user feedback
- Common failures: Storage operations fail, notifications fail to schedule
- Safe modification: Add error handling before making changes
- Test coverage: None

## Scaling Limits

**No scaling concerns:**
- Local-only app
- No server infrastructure
- No user growth considerations
- Performance adequate for personal use

## Dependencies at Risk

**All dependencies up-to-date:**
- No deprecated packages detected
- No unmaintained dependencies
- All packages have recent updates (2025-compatible)

## Missing Critical Features

**Error Handling & User Feedback:**
- Problem: No error UI when storage, notifications, or initialization fails
- Current workaround: Silent failures
- Blocks: Users unaware of issues, no recovery path
- Implementation complexity: Low (add error dialogs/snackbars)

**Comprehensive Testing:**
- Problem: Only 1 basic widget test exists
- Current workaround: Manual testing only
- Blocks: Can't refactor confidently, bugs may go undetected
- Implementation complexity: Medium (need fixtures, mocks, test infrastructure)

## Test Coverage Gaps

**Business Logic - Not Tested:**
- What's not tested: `TimerStore` state management, timer CRUD operations
- Files: `lib/state/timer_store.dart`
- Risk: State mutations could break silently
- Priority: High
- Difficulty to test: Low (straightforward unit tests)

**Notification Scheduling - Not Tested:**
- What's not tested: Time alignment algorithm, occurrence calculation, DST handling
- Files: `lib/services/notification_service.dart`
- Risk: Timers could schedule incorrectly, especially around DST transitions
- Priority: High
- Difficulty to test: Medium (need to mock timezone data)

**Data Serialization - Not Tested:**
- What's not tested: `TimerModel.toJson()`, `fromJson()`, list encoding/decoding
- Files: `lib/models/timer_model.dart`
- Risk: Data corruption on save/load
- Priority: High
- Difficulty to test: Low (straightforward JSON tests)

**UI Components - Not Tested:**
- What's not tested: `TimerCard`, `TimerEditorSheet`, `MainScreen` behavior
- Files: `lib/ui/**/*.dart`
- Risk: UI bugs, user interaction failures
- Priority: Medium
- Difficulty to test: Medium (widget tests require more setup)

**Storage Operations - Not Tested:**
- What's not tested: `TimerStorage` save/load operations
- Files: `lib/services/timer_storage.dart`
- Risk: Data persistence failures
- Priority: High
- Difficulty to test: Low (can mock SharedPreferences)

## Documentation Gaps

**Complex Algorithms Undocumented:**
- File: `lib/services/notification_service.dart` - `_alignToNext()` method (lines 206-220)
- What's missing: Explanation of modulo arithmetic for time alignment
- Impact: Hard to understand, modify, or debug
- Priority: Medium

**No Architectural Documentation:**
- What's missing: High-level overview of app architecture, data flow
- Impact: Onboarding is slower, design decisions unclear
- Priority: Low (addressed by this codebase mapping)

---

*Concerns audit: 2025-12-24*
*Update as issues are fixed or new ones discovered*
