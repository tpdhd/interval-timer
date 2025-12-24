import 'package:shared_preferences/shared_preferences.dart';

import '../models/timer_model.dart';

class TimerStorage {
  static const _timersKey = 'timers';
  static const _muteKey = 'globalMute';
  static const _themeKey = 'themeMode';
  static const _localeKey = 'localeCode';

  Future<List<TimerModel>> loadTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_timersKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    return TimerModel.decodeList(raw);
  }

  Future<void> saveTimers(List<TimerModel> timers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timersKey, TimerModel.encodeList(timers));
  }

  Future<bool> loadGlobalMute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_muteKey) ?? false;
  }

  Future<void> saveGlobalMute(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muteKey, value);
  }

  Future<String?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  Future<void> saveThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, value);
  }

  Future<String?> loadLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }

  Future<void> saveLocaleCode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, value);
  }
}
