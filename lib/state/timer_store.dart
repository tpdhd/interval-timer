import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/timer_model.dart';
import '../services/notification_service.dart';
import '../services/timer_storage.dart';

class TimerStore extends ChangeNotifier {
  TimerStore({
    required TimerStorage storage,
    required NotificationService notifications,
  })  : _storage = storage,
        _notifications = notifications;

  final TimerStorage _storage;
  final NotificationService _notifications;
  final _uuid = const Uuid();

  final List<TimerModel> _timers = [];
  bool _globalMute = false;
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('en');

  List<TimerModel> get timers => List.unmodifiable(_timers);
  bool get globalMute => _globalMute;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> load() async {
    await _notifications.initialize();
    _timers
      ..clear()
      ..addAll(await _storage.loadTimers());
    _globalMute = await _storage.loadGlobalMute();
    _themeMode = _decodeThemeMode(await _storage.loadThemeMode());
    _locale = _decodeLocale(await _storage.loadLocaleCode());
    await _refreshActiveTimers();
    notifyListeners();
  }

  Future<void> addTimer(TimerModel timer) async {
    _timers.add(timer);
    await _persist();
  }

  Future<void> updateTimer(TimerModel timer) async {
    final index = _timers.indexWhere((item) => item.id == timer.id);
    if (index == -1) {
      return;
    }
    _timers[index] = timer;
    await _persist();
    if (timer.isActive) {
      await _notifications.scheduleTimer(timer, globalMute: _globalMute);
    } else {
      await _notifications.cancelTimer(timer);
    }
  }

  Future<void> deleteTimer(String id) async {
    final index = _timers.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    final timer = _timers.removeAt(index);
    await _notifications.cancelTimer(timer);
    await _persist();
  }

  Future<void> toggleTimerActive(String id, bool isActive) async {
    final index = _timers.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    final timer = _timers[index];
    final updated = timer.copyWith(
      isActive: isActive,
      startedAt: isActive ? DateTime.now() : null,
    );
    _timers[index] = updated;
    await _persist();
    if (isActive) {
      await _notifications.scheduleTimer(updated, globalMute: _globalMute);
    } else {
      await _notifications.cancelTimer(updated);
    }
  }

  Future<void> toggleGlobalMute() async {
    _globalMute = !_globalMute;
    await _storage.saveGlobalMute(_globalMute);
    for (final timer in _timers.where((item) => item.isActive)) {
      if (_globalMute) {
        await _notifications.cancelTimer(timer);
      } else {
        await _notifications.scheduleTimer(timer, globalMute: _globalMute);
      }
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.saveThemeMode(_encodeThemeMode(mode));
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _storage.saveLocaleCode(locale.languageCode);
    notifyListeners();
  }

  TimerModel createEmptyTimer() {
    return TimerModel(
      id: _uuid.v4(),
      name: '',
      intervalMinutes: 30,
      durationMinutes: null,
      isEndless: true,
      colorValue: Colors.cyan.value,
      soundPath: 'example',
      volume: 1.0,
      vibrationEnabled: true,
      vibrationPattern: null,
      quietHours: null,
      isActive: false,
      startedAt: null,
    );
  }

  Future<void> _persist() async {
    await _storage.saveTimers(_timers);
    notifyListeners();
  }

  Future<void> _refreshActiveTimers() async {
    for (var i = 0; i < _timers.length; i += 1) {
      final timer = _timers[i];
      if (!timer.isActive) {
        continue;
      }
      if (!_isTimerStillValid(timer)) {
        _timers[i] = timer.copyWith(isActive: false, startedAt: null);
        await _notifications.cancelTimer(timer);
        continue;
      }
      await _notifications.scheduleTimer(timer, globalMute: _globalMute);
    }
    await _persist();
  }

  bool _isTimerStillValid(TimerModel timer) {
    if (timer.isEndless || timer.durationMinutes == null || timer.startedAt == null) {
      return true;
    }
    final endAt = timer.startedAt!.add(Duration(minutes: timer.durationMinutes!));
    return DateTime.now().isBefore(endAt);
  }

  ThemeMode _decodeThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark;
    }
  }

  String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Locale _decodeLocale(String? code) {
    if (code == 'de') {
      return const Locale('de');
    }
    return const Locale('en');
  }
}
