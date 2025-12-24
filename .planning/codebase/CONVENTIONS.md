# Coding Conventions

**Analysis Date:** 2025-12-24

## Naming Patterns

**Files:**
- snake_case for all Dart files
- Examples: `timer_model.dart`, `notification_service.dart`, `timer_editor_sheet.dart`
- Suffixes indicate purpose: `*_model.dart`, `*_service.dart`, `*_store.dart`, `*_test.dart`

**Functions:**
- camelCase for all functions and methods
- Public: `loadTimers()`, `saveTimers()`, `toggleGlobalMute()`, `scheduleTimer()`
- Private: `_persist()`, `_refreshActiveTimers()`, `_calculateNextTime()`
- Helper functions: `_formatCountdown()`, `_countdownText()`, `_buildOccurrences()`

**Variables:**
- camelCase for instance variables
- Private variables prefixed with `_`: `_timers`, `_globalMute`, `_storage`
- Boolean properties often prefixed with `is` or `has`: `isActive`, `isEndless`, `vibrationEnabled`
- Static constants in SCREAMING_SNAKE_CASE: `_defaultChannelId`, `_maxScheduledCount`

**Types:**
- PascalCase for classes and types
- No prefix for interfaces (interfaces are classes in Dart)
- Examples: `TimerModel`, `TimerStore`, `NotificationService`, `QuietHours`

## Code Style

**Formatting:**
- 2-space indentation throughout
- Const constructors used where possible: `const Duration(seconds: 1)`
- Material Design 3 implementation: `useMaterial3: true`
- Consistent spacing and alignment

**Linting:**
- Configuration: `analysis_options.yaml`
- Base ruleset: `package:flutter_lints/flutter.yaml`
- Standard Flutter recommended lints enabled
- No custom rules added or disabled

## Import Organization

**Order:**
1. Dart SDK imports (`dart:async`, `dart:convert`)
2. Flutter framework imports (`package:flutter/material.dart`)
3. Third-party package imports (`package:provider/provider.dart`)
4. Local project imports (relative paths)

**Grouping:**
- No explicit blank lines between groups in current code
- All imports at top of file

**Path Aliases:**
- No path aliases configured
- Relative imports used for local files

## Error Handling

**Patterns:**
- Try-catch for platform-specific exceptions (`lib/services/notification_service.dart`)
- Graceful fallback: Exact alarm scheduling falls back to inexact mode
- Limited error handling overall

**Error Types:**
- Platform exceptions caught: `PlatformException` during notification scheduling
- No custom error classes defined
- Storage operations lack error handling

## Logging

**Framework:**
- No logging framework used
- No console.log or debug output
- No error logging to external services

**Patterns:**
- Silent failures in storage operations
- No structured logging

## Comments

**When to Comment:**
- Business logic explanations: "Quiet hours are disabled for now; all occurrences are scheduled." (`lib/services/notification_service.dart:222`)
- Complex algorithms left uncommented (e.g., `_alignToNext()` method)

**JSDoc/TSDoc:**
- No Dart documentation comments (`///`)
- Code is generally self-documenting through clear naming

**TODO Comments:**
- No TODO, FIXME, or HACK comments found in codebase

## Function Design

**Size:**
- Most functions under 50 lines
- Largest file: `lib/ui/widgets/timer_editor_sheet.dart` (401 lines) - should be decomposed

**Parameters:**
- Clear, descriptive parameter names
- Named parameters used for optional arguments
- Required parameters: `@required` annotation or positional

**Return Values:**
- Explicit return types
- `void` for methods with no return
- `Future<void>` for async operations without return value

## Module Design

**Exports:**
- No barrel files (index.dart)
- Direct imports from specific files
- All public classes exported by default (Dart's module system)

**Patterns:**
- Immutability: Models use `final` fields and `copyWith()`
- Dependency injection: Services injected into store constructors
- Provider pattern: `ChangeNotifier` for state management

**Serialization:**
- Manual JSON serialization with `toJson()`/`fromJson()`
- No code generation (json_serializable, freezed)
- Static helpers: `encodeList()`, `decodeList()` for collections

**State Management:**
- Mutable state in stores with `notifyListeners()`
- Immutable models with `copyWith()` pattern
- Private state fields with public getter methods

---

*Convention analysis: 2025-12-24*
*Update when patterns change*
