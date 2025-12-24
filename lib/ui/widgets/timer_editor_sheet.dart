import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/timer_model.dart';

class TimerEditorSheet extends StatefulWidget {
  const TimerEditorSheet({super.key, required this.timer, required this.isEditing});

  final TimerModel timer;
  final bool isEditing;

  @override
  State<TimerEditorSheet> createState() => _TimerEditorSheetState();
}

class _TimerEditorSheetState extends State<TimerEditorSheet> {
  static const _fallbackNames = [
    '20-20-20 eye break',
    'Drink 200 ml water',
    'Posture reset',
    'Stretch neck',
    'Stretch shoulders',
    'Stand up and move',
    'Deep breathing',
    'Refocus distance',
    'Blink break',
    'Wrist stretch',
    'Jaw relax',
    'Hydrate and sip',
    'Tidy one item',
    'Clear desk surface',
    'Walk for 1 minute',
    'Check lighting',
    'Open window',
    'One push-up',
    'One squat',
    'Calf raises',
    'Shoulder rolls',
    'Back extension',
    'Eye roll break',
    'Short meditation',
    'Gratitude note',
    'Inbox cleanup',
    'Plan next task',
    'Refill water',
    'Breathing box',
    'Hand stretch',
    'Finger stretch',
    'Quick tidy',
    'Neck rotation',
    'Look far away',
    'Unclench jaw',
    'Relax hands',
    'Foot stretch',
    'Hip stretch',
    'Stand tall',
    'Take a lap',
    'Check posture',
    'Drink tea',
    'Update to-do',
    'Clear tabs',
    'Refocus goal',
    'Micro break',
    'Reset shoulders',
    'Check ergonomics',
    'Open blinds',
    'Mini walk',
    'Screen off',
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _intervalController;
  late int _colorValue;
  late bool _vibrationEnabled;
  late double _volume;
  String? _soundPath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _random = Random();

  final _colors = <int>[
    Colors.cyan.value,
    Colors.lime.value,
    Colors.orange.value,
    Colors.pink.value,
    Colors.teal.value,
  ];

  @override
  void initState() {
    super.initState();
    final timer = widget.timer;
    _nameController = TextEditingController(
      text: widget.isEditing ? timer.name : '',
    );
    _intervalController = TextEditingController(
      text: widget.isEditing ? timer.intervalMinutes.toString() : '',
    );
    _intervalController.addListener(_handleIntervalHint);
    _colorValue = timer.colorValue;
    _soundPath = timer.soundPath;
    _volume = timer.volume;
    _vibrationEnabled = timer.vibrationEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _intervalController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final hintStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 16 + bottomPadding),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? strings.text('editTimer') : strings.text('addTimer'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.text('name')),
                          TextField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: _nameHintText(),
                              hintStyle: hintStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${strings.text('interval')} (min)'),
                          TextField(
                            controller: _intervalController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '25',
                              hintStyle: hintStyle,
                              suffixText: 'min',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(strings.text('color')),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._colors.map((value) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text(''),
                              selected: _colorValue == value,
                              onSelected: (_) => setState(() => _colorValue = value),
                              avatar: CircleAvatar(backgroundColor: Color(value)),
                            ),
                          )),
                      ChoiceChip(
                        label: const Icon(Icons.shuffle),
                        selected: !_colors.contains(_colorValue),
                        onSelected: (_) => setState(() => _colorValue = _randomColorValue()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(strings.text('sound')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _soundDropdownValue(),
                        items: [
                          DropdownMenuItem(
                              value: 'default', child: Text(strings.text('defaultSound'))),
                          DropdownMenuItem(
                              value: 'example', child: Text(strings.text('exampleSound'))),
                          DropdownMenuItem(value: 'silent', child: Text(strings.text('silent'))),
                          DropdownMenuItem(value: 'custom', child: Text(strings.text('customSound'))),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            if (value == 'default') {
                              _soundPath = null;
                            } else if (value == 'example') {
                              _soundPath = 'example';
                            } else if (value == 'silent') {
                              _soundPath = 'silent';
                            } else if (value == 'custom') {
                              if (_soundPath == null || _soundPath == 'silent') {
                                _soundPath = '';
                              }
                            }
                          });
                        },
                      ),
                    ),
                    if (_soundDropdownValue() == 'custom')
                      TextButton.icon(
                        onPressed: _pickSoundFile,
                        icon: const Icon(Icons.attach_file),
                        label: Text(strings.text('pickFile')),
                      ),
                  ],
                ),
                if (_soundDropdownValue() == 'custom')
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _soundPath == null || _soundPath!.isEmpty
                          ? strings.text('soundFile')
                          : _soundPath!,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 16),
                const Icon(Icons.volume_up),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        onChanged: (value) => setState(() => _volume = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: strings.text('testSound'),
                      onPressed: _testSound,
                      icon: const Icon(Icons.play_arrow),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: strings.text('vibration'),
                      onPressed: () => setState(() => _vibrationEnabled = !_vibrationEnabled),
                      icon: Icon(_vibrationEnabled ? Icons.vibration : Icons.vibration_outlined),
                      style: IconButton.styleFrom(
                        backgroundColor: _vibrationEnabled
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: _save,
                child: const Icon(Icons.check),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _soundDropdownValue() {
    if (_soundPath == 'silent') {
      return 'silent';
    }
    if (_soundPath == 'example') {
      return 'example';
    }
    if (_soundPath == null || _soundPath!.isEmpty) {
      return 'default';
    }
    return 'custom';
  }

  void _handleIntervalHint() {
    if (mounted) {
      setState(() {});
    }
  }

  String _nameHintText() {
    final interval = int.tryParse(_intervalController.text) ?? 25;
    final example = _fallbackNames[interval % _fallbackNames.length];
    return 'Example: $example ($interval min)';
  }

  Future<void> _testSound() async {
    if (_soundDropdownValue() == 'silent') {
      return;
    }
    final source = _resolvePreviewSource();
    if (source == null) {
      return;
    }
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(_volume.clamp(0.0, 1.0));
    await _audioPlayer.play(source);
  }

  Source? _resolvePreviewSource() {
    if (_soundDropdownValue() == 'custom') {
      if (_soundPath == null || _soundPath!.isEmpty) {
        return null;
      }
      return DeviceFileSource(_soundPath!);
    }
    return AssetSource('assets/sounds/interval_timer_example.ogg');
  }

  Future<void> _pickSoundFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || result.files.isEmpty) {
      return;
    }
    setState(() {
      _soundPath = result.files.single.path ?? '';
    });
  }

  void _save() {
    final interval = int.tryParse(_intervalController.text);
    final resolvedInterval = interval == null || interval <= 0 ? _randomInterval() : interval;
    final resolvedSound = _soundPath == null || _soundPath!.isEmpty ? null : _soundPath;
    final name = _nameController.text.trim();
    final updated = widget.timer.copyWith(
      name: name.isEmpty ? _fallbackNames[_random.nextInt(_fallbackNames.length)] : name,
      intervalMinutes: resolvedInterval,
      durationMinutes: null,
      isEndless: true,
      colorValue: _colorValue,
      soundPath: resolvedSound,
      volume: _volume,
      vibrationEnabled: _vibrationEnabled,
      quietHours: null,
    );
    Navigator.of(context).pop(updated);
  }

  int _randomInterval() {
    const options = [5, 10, 15, 20, 25, 30, 45, 60];
    return options[_random.nextInt(options.length)];
  }

  int _randomColorValue() {
    int value;
    do {
      final hue = _random.nextDouble() * 360;
      final color = HSVColor.fromAHSV(1, hue, 0.65, 0.95).toColor();
      value = color.value;
    } while (_colors.contains(value) || value == _colorValue);
    return value;
  }
}
