# Testing Patterns

**Analysis Date:** 2025-12-24

## Test Framework

**Runner:**
- flutter_test (Flutter SDK)
- Standard Flutter widget testing framework

**Assertion Library:**
- flutter_test built-in expect
- Matchers: `findsOneWidget`, `findsNothing`

**Run Commands:**
```bash
flutter test                          # Run all tests
flutter test --coverage               # Generate coverage report
flutter test test/widget_test.dart    # Run specific test file
```

## Test File Organization

**Location:**
- Single test file: `test/widget_test.dart`
- Tests are separate from source code (not co-located)

**Naming:**
- `*_test.dart` convention for all test files

**Structure:**
```
test/
└── widget_test.dart     # Single basic widget test
```

## Test Structure

**Suite Organization:**
```dart
void main() {
  testWidgets('App boots and shows title', (WidgetTester tester) async {
    final store = TimerStore(
      storage: TimerStorage(),
      notifications: NotificationService(),
    );
    await tester.pumpWidget(IntervalTimerApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('Interval Timer'), findsOneWidget);
  });
}
```

**Patterns:**
- Uses `testWidgets()` for widget tests
- Async/await for async operations
- `WidgetTester` utilities: `pumpWidget()`, `pumpAndSettle()`, `find.text()`
- Dependency injection for testing (passes store to app)

## Mocking

**Framework:**
- No mocking library used
- No mockito or mocktail dependencies

**Patterns:**
- Real service instances used in tests: `TimerStorage()`, `NotificationService()`
- No mocks or stubs currently

**What's Mocked:**
- Nothing (all real implementations)

**What's NOT Mocked:**
- Services, storage, notifications (all use real implementations)

## Fixtures and Factories

**Test Data:**
- No fixture files
- No factory functions for test data
- Minimal test setup

**Location:**
- No dedicated fixtures or factories directory

## Coverage

**Requirements:**
- No enforced coverage target
- No coverage configuration

**Configuration:**
- No coverage exclusions configured
- Run via: `flutter test --coverage`

**View Coverage:**
```bash
flutter test --coverage
# Coverage report generated in coverage/lcov.info
```

## Test Types

**Widget Tests:**
- Single integration-style test verifying app initialization
- Tests that app boots and displays title
- Location: `test/widget_test.dart`

**Unit Tests:**
- None present

**Integration Tests:**
- None present

**E2E Tests:**
- None present

## Common Patterns

**Async Testing:**
```dart
testWidgets('Description', (WidgetTester tester) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
  // assertions
});
```

**Widget Finding:**
```dart
expect(find.text('Interval Timer'), findsOneWidget);
```

## Test Coverage Gaps

**Critical Gaps:**
- No unit tests for `TimerModel` serialization/deserialization
- No tests for `TimerStore` state management and mutations
- No tests for `NotificationService` scheduling logic
- No tests for `TimerStorage` persistence operations
- No widget tests for individual UI components (`TimerCard`, `TimerEditorSheet`)
- No tests for time alignment algorithm (`_alignToNext()`)
- No error handling tests
- No edge case tests (DST, timezone changes, device rotation)

**Missing Test Areas:**
- Service layer: `TimerStorage`, `NotificationService`
- State management: `TimerStore` operations
- Data models: `TimerModel.copyWith()`, serialization
- UI components: All widgets untested individually
- Business logic: Timer activation, countdown calculation
- Time-sensitive logic: Timezone handling, DST transitions

---

*Testing analysis: 2025-12-24*
*Update when test patterns change*
