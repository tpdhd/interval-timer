import 'dart:convert';

class QuietHours {
  final int startMinutes;
  final int endMinutes;

  const QuietHours({required this.startMinutes, required this.endMinutes});

  Map<String, dynamic> toJson() => {
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };

  factory QuietHours.fromJson(Map<String, dynamic> json) {
    return QuietHours(
      startMinutes: json['startMinutes'] as int,
      endMinutes: json['endMinutes'] as int,
    );
  }

  bool includesMinuteOfDay(int minuteOfDay) {
    if (startMinutes == endMinutes) {
      return false;
    }
    if (startMinutes < endMinutes) {
      return minuteOfDay >= startMinutes && minuteOfDay < endMinutes;
    }
    return minuteOfDay >= startMinutes || minuteOfDay < endMinutes;
  }
}

class TimerModel {
  final String id;
  final String name;
  final int intervalMinutes;
  final int? durationMinutes;
  final bool isEndless;
  final int colorValue;
  final String? soundPath;
  final double volume;
  final bool vibrationEnabled;
  final List<int>? vibrationPattern;
  final QuietHours? quietHours;
  final bool isActive;
  final DateTime? startedAt;

  const TimerModel({
    required this.id,
    required this.name,
    required this.intervalMinutes,
    required this.durationMinutes,
    required this.isEndless,
    required this.colorValue,
    required this.soundPath,
    required this.volume,
    required this.vibrationEnabled,
    required this.vibrationPattern,
    required this.quietHours,
    required this.isActive,
    required this.startedAt,
  });

  TimerModel copyWith({
    String? name,
    int? intervalMinutes,
    int? durationMinutes,
    bool? isEndless,
    int? colorValue,
    String? soundPath,
    double? volume,
    bool? vibrationEnabled,
    List<int>? vibrationPattern,
    QuietHours? quietHours,
    bool? isActive,
    DateTime? startedAt,
  }) {
    return TimerModel(
      id: id,
      name: name ?? this.name,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isEndless: isEndless ?? this.isEndless,
      colorValue: colorValue ?? this.colorValue,
      soundPath: soundPath ?? this.soundPath,
      volume: volume ?? this.volume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
      quietHours: quietHours ?? this.quietHours,
      isActive: isActive ?? this.isActive,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'intervalMinutes': intervalMinutes,
        'durationMinutes': durationMinutes,
        'isEndless': isEndless,
        'colorValue': colorValue,
        'soundPath': soundPath,
        'volume': volume,
        'vibrationEnabled': vibrationEnabled,
        'vibrationPattern': vibrationPattern,
        'quietHours': quietHours?.toJson(),
        'isActive': isActive,
        'startedAt': startedAt?.toIso8601String(),
      };

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      intervalMinutes: json['intervalMinutes'] as int,
      durationMinutes: json['durationMinutes'] as int?,
      isEndless: json['isEndless'] as bool? ?? true,
      colorValue: json['colorValue'] as int,
      soundPath: json['soundPath'] as String?,
      volume: (json['volume'] as num?)?.toDouble() ?? 1.0,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      vibrationPattern: (json['vibrationPattern'] as List?)?.map((e) => e as int).toList(),
      quietHours: json['quietHours'] == null
          ? null
          : QuietHours.fromJson(json['quietHours'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? false,
      startedAt: json['startedAt'] == null ? null : DateTime.parse(json['startedAt'] as String),
    );
  }

  static String encodeList(List<TimerModel> timers) {
    final data = timers.map((timer) => timer.toJson()).toList();
    return jsonEncode(data);
  }

  static List<TimerModel> decodeList(String raw) {
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((item) => TimerModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
