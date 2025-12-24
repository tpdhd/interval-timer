import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('de'),
  ];

  static const _localizedValues = {
    'en': {
      'appTitle': 'Interval Timer',
      'timers': 'Timers',
      'addTimer': 'Add Timer',
      'editTimer': 'Edit Timer',
      'name': 'Name',
      'interval': 'Interval',
      'duration': 'Duration (min)',
      'endless': 'Endless',
      'color': 'Color',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'quietHours': 'Quiet Hours',
      'start': 'Start',
      'stop': 'Stop',
      'cancel': 'Cancel',
      'save': 'Save',
      'globalMute': 'Mute All',
      'language': 'Language',
      'theme': 'Theme',
      'dark': 'Dark',
      'light': 'Light',
      'customSound': 'Custom Sound',
      'defaultSound': 'Default',
      'exampleSound': 'Example Sound',
      'silent': 'Silent',
      'none': 'None',
      'volume': 'Volume',
      'nextReminder': 'Next',
      'settings': 'Settings',
      'delete': 'Delete',
      'startLabel': 'Start',
      'endLabel': 'End',
      'everyPrefix': 'Every',
      'intervalHint': 'Every X minutes',
      'durationHint': 'Leave empty for endless',
      'quietHoursHint': 'Skip reminders during this window',
      'soundFile': 'Sound file',
      'pickFile': 'Pick file',
      'testSound': 'Test sound',
    },
    'de': {
      'appTitle': 'Intervall-Timer',
      'timers': 'Timer',
      'addTimer': 'Timer hinzufügen',
      'editTimer': 'Timer bearbeiten',
      'name': 'Name',
      'interval': 'Intervall',
      'duration': 'Dauer (Min.)',
      'endless': 'Endlos',
      'color': 'Farbe',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'quietHours': 'Ruhezeiten',
      'start': 'Start',
      'stop': 'Stopp',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'globalMute': 'Alles stumm',
      'language': 'Sprache',
      'theme': 'Design',
      'dark': 'Dunkel',
      'light': 'Hell',
      'customSound': 'Eigener Sound',
      'defaultSound': 'Standard',
      'exampleSound': 'Beispielton',
      'silent': 'Stumm',
      'none': 'Keine',
      'volume': 'Lautstärke',
      'nextReminder': 'Nächster',
      'settings': 'Einstellungen',
      'delete': 'Löschen',
      'startLabel': 'Start',
      'endLabel': 'Ende',
      'everyPrefix': 'Alle',
      'intervalHint': 'Alle X Minuten',
      'durationHint': 'Leer lassen für endlos',
      'quietHoursHint': 'Erinnerungen in diesem Zeitraum aussetzen',
      'soundFile': 'Sound-Datei',
      'pickFile': 'Datei wählen',
      'testSound': 'Sound testen',
    },
  };

  String text(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
