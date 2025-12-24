import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timer_model.dart';
import '../state/timer_store.dart';
import 'widgets/timer_card.dart';
import 'widgets/timer_editor_sheet.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('appTitle')),
        actions: [
          Consumer<TimerStore>(
            builder: (context, store, _) {
              return IconButton(
                tooltip: strings.text('globalMute'),
                icon: Icon(store.globalMute ? Icons.notifications_off : Icons.notifications),
                onPressed: store.toggleGlobalMute,
              );
            },
          ),
          IconButton(
            tooltip: strings.text('settings'),
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => _openEditor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Consumer<TimerStore>(
        builder: (context, store, _) {
          if (store.timers.isEmpty) {
            return Center(
              child: Text(
                strings.text('addTimer'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: store.timers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final timer = store.timers[index];
              return Dismissible(
                key: ValueKey(timer.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Colors.red.shade700,
                  child: Icon(Icons.delete, color: Colors.white.withOpacity(0.9)),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => store.deleteTimer(timer.id),
                child: TimerCard(
                  timer: timer,
                  globalMute: store.globalMute,
                  onTap: () => _openEditor(context, timer: timer),
                  onToggleActive: (value) => store.toggleTimerActive(timer.id, value),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {TimerModel? timer}) async {
    final store = context.read<TimerStore>();
    final base = timer ?? store.createEmptyTimer();
    final result = await showModalBottomSheet<TimerModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (_) => TimerEditorSheet(timer: base, isEditing: timer != null),
    );
    if (result == null) {
      return;
    }
    if (timer == null) {
      await store.addTimer(result);
    } else {
      await store.updateTimer(result);
    }
  }

  void _openSettings(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final store = context.read<TimerStore>();
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.text('settings'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(strings.text('language'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<Locale>(
                segments: [
                  ButtonSegment(value: const Locale('en'), label: Text('EN')),
                  ButtonSegment(value: const Locale('de'), label: Text('DE')),
                ],
                selected: {store.locale},
                onSelectionChanged: (value) => store.setLocale(value.first),
              ),
              const SizedBox(height: 12),
              Text(strings.text('theme'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.dark, label: Text(strings.text('dark'))),
                  ButtonSegment(value: ThemeMode.light, label: Text(strings.text('light'))),
                ],
                selected: {store.themeMode},
                onSelectionChanged: (value) => store.setThemeMode(value.first),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
