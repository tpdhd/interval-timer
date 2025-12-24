Codex bootstrap

Where things live (WSL paths):
- Flutter: /tmp/flutter-sdk/bin/flutter
- Java (JDK): /home/hanspeter/jdk
- Android SDK: /home/hanspeter/Android

Repo root (Windows path):
- C:\Users\hans\Documents\Projekte\Invervall-Timer-GPT5.2

Build debug APK (and name next version):
1) Build:
   JAVA_HOME=/home/hanspeter/jdk ANDROID_SDK_ROOT=/home/hanspeter/Android /tmp/flutter-sdk/bin/flutter pub get
   JAVA_HOME=/home/hanspeter/jdk ANDROID_SDK_ROOT=/home/hanspeter/Android /tmp/flutter-sdk/bin/flutter build apk --debug
2) Next APK name:
   build/app/outputs/flutter-apk/interval_timer_v0.X-debug.apk
   (increment X to the next available number)
3) Copy:
   cp -f build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/interval_timer_v0.X-debug.apk

Rule:
- After any improvements, always run the build + versioned copy.
