import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/timer_model.dart';
import '../../services/timer_storage.dart';

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
  late String _soundSlot;
  String? _customSoundPath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _random = Random();
  final _storage = TimerStorage();

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
    _soundSlot = timer.soundPath ?? 'sound_01';
    // Ensure soundSlot is one of the valid options
    if (_soundSlot != 'sound_01' && _soundSlot != 'sound_02' && _soundSlot != 'sound_03') {
      _soundSlot = 'sound_01';
    }
    _volume = timer.volume;
    _vibrationEnabled = timer.vibrationEnabled;
    _loadCustomSound();
  }

  Future<void> _loadCustomSound() async {
    final path = await _storage.loadCustomSound(_soundSlot);
    if (mounted) {
      setState(() {
        _customSoundPath = path;
      });
    }
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
                const SizedBox(height: 4),
                Text(
                  'Built-in notification sounds. Custom files for preview only.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _soundSlot,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'sound_01', child: Text('Sound 01')),
                          DropdownMenuItem(value: 'sound_02', child: Text('Sound 02')),
                          DropdownMenuItem(value: 'sound_03', child: Text('Sound 03')),
                        ],
                        onChanged: (value) async {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _soundSlot = value;
                          });
                          await _loadCustomSound();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Pick custom sound for preview',
                      onPressed: _pickSoundFile,
                      icon: const Icon(Icons.folder_open),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (_customSoundPath != null && _customSoundPath!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Preview: ${_customSoundPath!.split('/').last}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${(_volume * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        label: '${(_volume * 100).round()}%',
                        onChanged: (value) => setState(() => _volume = value),
                      ),
                    ),
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
    if (_volume == 0) {
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
    // If custom sound is set for this slot, use it
    if (_customSoundPath != null && _customSoundPath!.isNotEmpty) {
      return DeviceFileSource(_customSoundPath!);
    }
    // Otherwise use the default example sound
    return AssetSource('sounds/interval_timer_example.ogg');
  }

  Future<void> _pickSoundFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || result.files.isEmpty) {
      return;
    }
    final filePath = result.files.single.path;
    if (filePath == null || filePath.isEmpty) {
      return;
    }
    await _storage.saveCustomSound(_soundSlot, filePath);
    setState(() {
      _customSoundPath = filePath;
    });
  }

  void _save() {
    final interval = int.tryParse(_intervalController.text);
    final resolvedInterval = interval == null || interval <= 0 ? _randomInterval() : interval;
    final name = _nameController.text.trim();
    final updated = widget.timer.copyWith(
      name: name.isEmpty ? _fallbackNames[_random.nextInt(_fallbackNames.length)] : name,
      intervalMinutes: resolvedInterval,
      durationMinutes: null,
      isEndless: true,
      colorValue: _colorValue,
      soundPath: _soundSlot,
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
