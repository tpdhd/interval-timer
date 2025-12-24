// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:interval_timer/main.dart';
import 'package:interval_timer/services/notification_service.dart';
import 'package:interval_timer/services/timer_storage.dart';
import 'package:interval_timer/state/timer_store.dart';

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
