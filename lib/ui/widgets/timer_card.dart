import 'package:flutter/material.dart';

import '../../models/timer_model.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({
    super.key,
    required this.timer,
    required this.globalMute,
    required this.onTap,
    required this.onToggleActive,
  });

  final TimerModel timer;
  final bool globalMute;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleActive;

  @override
  Widget build(BuildContext context) {
    final color = Color(timer.colorValue);
    final nowStream = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 1.2),
        ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timer.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${timer.intervalMinutes} min',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: StreamBuilder<DateTime>(
                      stream: nowStream,
                      builder: (context, snapshot) {
                        final now = snapshot.data ?? DateTime.now();
                        final countdown = _countdownText(now);
                        return Text(
                          countdown,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              Switch(
                value: timer.isActive,
                onChanged: onToggleActive,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _calculateNextTime(TimerModel timer, DateTime now) {
    if (!timer.isActive || timer.startedAt == null) {
      return null;
    }
    final interval = Duration(minutes: timer.intervalMinutes);
    var current = timer.startedAt!.add(interval);
    while (current.isBefore(now)) {
      current = current.add(interval);
    }
    return current;
  }

  String _countdownText(DateTime now) {
    if (timer.isActive && timer.startedAt != null) {
      final next = _calculateNextTime(timer, now);
      if (next != null) {
        return _formatCountdown(next.difference(now));
      }
    }
    return _formatCountdown(Duration(minutes: timer.intervalMinutes));
  }

  String _formatCountdown(Duration remaining) {
    if (remaining.isNegative) {
      remaining = Duration.zero;
    }
    final totalSeconds = remaining.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
