import 'package:shared_preferences/shared_preferences.dart';

import '../models/timer_model.dart';

class TimerStorage {
  static const _timersKey = 'timers';
  static const _muteKey = 'globalMute';
  static const _themeKey = 'themeMode';
  static const _localeKey = 'localeCode';
  static const _customSound01Key = 'customSound01';
  static const _customSound02Key = 'customSound02';
  static const _customSound03Key = 'customSound03';

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

  Future<String?> loadCustomSound(String soundId) async {
    final prefs = await SharedPreferences.getInstance();
    switch (soundId) {
      case 'sound_01':
        return prefs.getString(_customSound01Key);
      case 'sound_02':
        return prefs.getString(_customSound02Key);
      case 'sound_03':
        return prefs.getString(_customSound03Key);
      default:
        return null;
    }
  }

  Future<void> saveCustomSound(String soundId, String? filePath) async {
    final prefs = await SharedPreferences.getInstance();
    switch (soundId) {
      case 'sound_01':
        if (filePath == null) {
          await prefs.remove(_customSound01Key);
        } else {
          await prefs.setString(_customSound01Key, filePath);
        }
        break;
      case 'sound_02':
        if (filePath == null) {
          await prefs.remove(_customSound02Key);
        } else {
          await prefs.setString(_customSound02Key, filePath);
        }
        break;
      case 'sound_03':
        if (filePath == null) {
          await prefs.remove(_customSound03Key);
        } else {
          await prefs.setString(_customSound03Key, filePath);
        }
        break;
    }
  }
}
