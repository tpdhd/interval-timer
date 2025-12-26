import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/timer_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // Track scheduled notification counts per timer to avoid unnecessary cancellations
  final Map<String, int> _scheduledCounts = {};

  static const _defaultChannelId = 'interval_timer_reminders_v6';
  static const _exampleChannelId = 'interval_timer_reminders_example_v6';
  static const _silentChannelId = 'interval_timer_reminders_silent_v6';
  static const _sound01ChannelId = 'interval_timer_sound_01_v6';
  static const _sound02ChannelId = 'interval_timer_sound_02_v6';
  static const _sound03ChannelId = 'interval_timer_sound_03_v6';
  static const _channelName = 'Interval Reminders';
  static const _channelDescription = 'Interval timer reminders';
  static const _exampleSoundName = 'interval_timer_example';
  static const _sound01Name = 'interval_timer_sound_01';
  static const _sound02Name = 'interval_timer_sound_02';
  static const _sound03Name = 'interval_timer_sound_03';
  static const _legacyChannels = <String>[
    'interval_timer_reminders',
    'interval_timer_reminders_example',
    'interval_timer_reminders_silent',
    'interval_timer_reminders_v2',
    'interval_timer_reminders_example_v2',
    'interval_timer_reminders_silent_v2',
    'interval_timer_reminders_v3',
    'interval_timer_reminders_example_v3',
    'interval_timer_reminders_silent_v3',
    'interval_timer_sound_01_v4',
    'interval_timer_sound_02_v4',
    'interval_timer_sound_03_v4',
    'interval_timer_reminders_v5',
    'interval_timer_reminders_example_v5',
    'interval_timer_reminders_silent_v5',
    'interval_timer_sound_01_v5',
    'interval_timer_sound_02_v5',
    'interval_timer_sound_03_v5',
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    // Default channel uses system default notification sound
    const defaultChannel = AndroidNotificationChannel(
      _defaultChannelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    // Example channel uses custom sound
    final exampleChannel = const AndroidNotificationChannel(
      _exampleChannelId,
      'Interval Reminders (Example Sound)',
      description: 'Interval timer reminders with example sound',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(_exampleSoundName),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    // Silent channel
    const silentChannel = AndroidNotificationChannel(
      _silentChannelId,
      'Interval Reminders (Silent)',
      description: 'Silent interval timer reminders',
      importance: Importance.max,
      playSound: false,
    );
    // Sound 01 channel
    const sound01Channel = AndroidNotificationChannel(
      _sound01ChannelId,
      'Interval Reminders (Sound 01)',
      description: 'Interval timer reminders with sound 01',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(_sound01Name),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    // Sound 02 channel
    const sound02Channel = AndroidNotificationChannel(
      _sound02ChannelId,
      'Interval Reminders (Sound 02)',
      description: 'Interval timer reminders with sound 02',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(_sound02Name),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    // Sound 03 channel
    const sound03Channel = AndroidNotificationChannel(
      _sound03ChannelId,
      'Interval Reminders (Sound 03)',
      description: 'Interval timer reminders with sound 03',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(_sound03Name),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      for (final legacy in _legacyChannels) {
        await androidPlugin.deleteNotificationChannel(legacy);
      }
      await androidPlugin.createNotificationChannel(defaultChannel);
      await androidPlugin.createNotificationChannel(exampleChannel);
      await androidPlugin.createNotificationChannel(silentChannel);
      await androidPlugin.createNotificationChannel(sound01Channel);
      await androidPlugin.createNotificationChannel(sound02Channel);
      await androidPlugin.createNotificationChannel(sound03Channel);
    }
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> cancelTimer(TimerModel timer) async {
    // Only cancel notifications that were actually scheduled
    final count = _scheduledCounts[timer.id] ?? _maxScheduledCount;
    for (var i = 0; i < count; i += 1) {
      await _plugin.cancel(_notificationId(timer.id, i));
    }
    _scheduledCounts.remove(timer.id);
  }

  Future<void> scheduleTimer(TimerModel timer, {required bool globalMute}) async {
    if (globalMute) {
      return;
    }

    await cancelTimer(timer);

    final now = tz.TZDateTime.now(tz.local);
    final startAt = timer.startedAt == null
        ? now
        : tz.TZDateTime.from(timer.startedAt!, tz.local);

    final occurrences = _buildOccurrences(timer, startAt, now);
    // Track how many notifications we actually schedule
    _scheduledCounts[timer.id] = occurrences.length;

    for (var i = 0; i < occurrences.length; i += 1) {
      final scheduled = occurrences[i];
      final soundSettings = _resolveSoundSettings(timer.soundPath);
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          soundSettings.channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: soundSettings.playSound,
          sound: soundSettings.sound,
          enableVibration: timer.vibrationEnabled,
          vibrationPattern: timer.vibrationPattern == null
              ? null
              : Int64List.fromList(timer.vibrationPattern!),
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
          showWhen: true,
        ),
      );

      await _scheduleOccurrence(
        id: _notificationId(timer.id, i),
        timer: timer,
        scheduled: scheduled,
        details: details,
      );
    }
  }

  static const int _maxScheduledCount = 96;

  int _notificationId(String id, int offset) {
    final base = int.tryParse(id.replaceAll('-', '').substring(0, 8), radix: 16) ?? id.hashCode;
    return (base % 100000) + offset;
  }

  Future<void> _scheduleOccurrence({
    required int id,
    required TimerModel timer,
    required tz.TZDateTime scheduled,
    required NotificationDetails details,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        timer.name,
        'Interval: ${timer.intervalMinutes} min',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
      );
    } on PlatformException {
      await _plugin.zonedSchedule(
        id,
        timer.name,
        'Interval: ${timer.intervalMinutes} min',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
      );
    }
  }

  _SoundSettings _resolveSoundSettings(String? soundPath) {
    // Map sound slots to their dedicated channels with unique sounds
    if (soundPath == 'sound_01') {
      return const _SoundSettings(
        channelId: _sound01ChannelId,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_sound01Name),
      );
    }
    if (soundPath == 'sound_02') {
      return const _SoundSettings(
        channelId: _sound02ChannelId,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_sound02Name),
      );
    }
    if (soundPath == 'sound_03') {
      return const _SoundSettings(
        channelId: _sound03ChannelId,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_sound03Name),
      );
    }
    if (soundPath == 'example') {
      return const _SoundSettings(
        channelId: _exampleChannelId,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_exampleSoundName),
      );
    }
    // Default: use system default notification sound (no sound specified)
    return const _SoundSettings(
      channelId: _defaultChannelId,
      playSound: true,
    );
  }

  List<tz.TZDateTime> _buildOccurrences(
    TimerModel timer,
    tz.TZDateTime startedAt,
    tz.TZDateTime now,
  ) {
    final interval = Duration(minutes: timer.intervalMinutes);
    final endAt = timer.isEndless || timer.durationMinutes == null
        ? null
        : startedAt.add(Duration(minutes: timer.durationMinutes!));

    final occurrences = <tz.TZDateTime>[];
    var current = _alignToNext(startedAt, now, interval);

    while (occurrences.length < _maxScheduledCount) {
      if (endAt != null && current.isAfter(endAt)) {
        break;
      }

      occurrences.add(current);

      current = current.add(interval);
    }

    // Add final notification at end time for non-endless timers
    if (endAt != null &&
        !endAt.isBefore(now) &&
        occurrences.length < _maxScheduledCount &&
        (occurrences.isEmpty || !occurrences.last.isAtSameMomentAs(endAt))) {
      occurrences.add(endAt);
    }

    return occurrences;
  }

  tz.TZDateTime _alignToNext(
    tz.TZDateTime start,
    tz.TZDateTime now,
    Duration interval,
  ) {
    if (!now.isAfter(start)) {
      return start.add(interval);
    }

    final elapsed = now.difference(start).inMinutes;
    final step = max(1, interval.inMinutes);
    final remainder = elapsed % step;
    final minutesToAdd = remainder == 0 ? step : step - remainder;
    return now.add(Duration(minutes: minutesToAdd));
  }

  // Quiet hours are disabled for now; all occurrences are scheduled.
}

class _SoundSettings {
  const _SoundSettings({
    required this.channelId,
    required this.playSound,
    this.sound,
  });

  final String channelId;
  final bool playSound;
  final AndroidNotificationSound? sound;
}
