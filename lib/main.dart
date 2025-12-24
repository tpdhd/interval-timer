import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'services/notification_service.dart';
import 'services/timer_storage.dart';
import 'state/timer_store.dart';
import 'ui/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IntervalTimerApp());
}

class IntervalTimerApp extends StatelessWidget {
  const IntervalTimerApp({super.key, this.store});

  final TimerStore? store;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final resolvedStore = store ??
            TimerStore(
              storage: TimerStorage(),
              notifications: NotificationService(),
            );
        if (store == null) {
          resolvedStore.load();
        }
        return resolvedStore;
      },
      child: Consumer<TimerStore>(
        builder: (context, store, _) {
          return MaterialApp(
            title: 'Interval Timer',
            debugShowCheckedModeBanner: false,
            themeMode: store.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
            ),
            locale: store.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
