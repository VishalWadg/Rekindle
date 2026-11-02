import 'dart:convert';
import 'dart:io';

const denylistedPackages = [
  'dio',
  'http',
  'firebase_core',
  'firebase_messaging',
  'firebase_analytics',
  'firebase_crashlytics',
  'google_mobile_ads',
  'sentry',
  'mixpanel_flutter',
  'amplitude_flutter',
];

const bannedWords = [
  'overdue',
  'streak',
  'missed',
  'due',
  "don't forget",
  'dont forget',
  "you haven't",
  'you havent',
  'last chance',
  'hurry',
];

void main() {
  stdout.writeln('=== Rekindle Offline & Copy Guard ===');
  var hasErrors = false;

  // 1. Check pubspec.lock files for denylisted network packages
  final lockFiles = [
    File('app/pubspec.lock'),
    File('packages/rekindle_core/pubspec.lock'),
  ];

  for (final lockFile in lockFiles) {
    if (!lockFile.existsSync()) continue;
    final content = lockFile.readAsStringSync().toLowerCase();
    for (final pkg in denylistedPackages) {
      if (content.contains('$pkg:')) {
        stderr.writeln('ERROR: Forbidden network dependency "$pkg" found in ${lockFile.path}');
        hasErrors = true;
      }
    }
  }

  // 2. Check Android release manifest for INTERNET permission
  final releaseManifest = File('app/android/app/src/release/AndroidManifest.xml');
  final mainManifest = File('app/android/app/src/main/AndroidManifest.xml');
  for (final manifest in [releaseManifest, mainManifest]) {
    if (!manifest.existsSync()) continue;
    final content = manifest.readAsStringSync();
    if (content.contains('android.permission.INTERNET')) {
      stderr.writeln('ERROR: android.permission.INTERNET declared in ${manifest.path}');
      hasErrors = true;
    }
  }

  // 3. Check Dart source files for raw socket / http imports
  final sourceDirs = [
    Directory('app/lib'),
    Directory('packages/rekindle_core/lib'),
  ];

  final forbiddenSymbols = ['HttpClient', 'Socket', 'WebSocket', 'RawSocket', 'SecureSocket'];

  for (final dir in sourceDirs) {
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        for (final symbol in forbiddenSymbols) {
          if (content.contains(symbol)) {
            stderr.writeln('ERROR: Forbidden network symbol "$symbol" used in ${entity.path}');
            hasErrors = true;
          }
        }
      }
    }
  }

  // 4. Copy Lint: check copy file and arb files for banned words & lengths
  final copyFile = File('assets/copy/nudge_copy_en.json');
  if (copyFile.existsSync()) {
    try {
      final jsonMap = jsonDecode(copyFile.readAsStringSync()) as Map<String, dynamic>;
      final templates = jsonMap['templates'] as Map<String, dynamic>? ?? {};
      templates.forEach((templateName, voices) {
        if (voices is Map<String, dynamic>) {
          voices.forEach((voice, variants) {
            if (variants is List) {
              for (final item in variants) {
                if (item is Map) {
                  final title = (item['title'] ?? '').toString();
                  final body = (item['body'] ?? '').toString();

                  if (title.length > 40) {
                    stderr.writeln('ERROR: Title exceeds 40 characters ($templateName/$voice): "$title" (${title.length} chars)');
                    hasErrors = true;
                  }
                  if (body.length > 140) {
                    stderr.writeln('ERROR: Body exceeds 140 characters ($templateName/$voice): "$body" (${body.length} chars)');
                    hasErrors = true;
                  }

                  final combined = '$title $body'.toLowerCase();
                  for (final word in bannedWords) {
                    if (combined.contains(word)) {
                      stderr.writeln('ERROR: Banned word "$word" found in ($templateName/$voice): "$combined"');
                      hasErrors = true;
                    }
                  }
                }
              }
            }
          });
        }
      });
    } catch (e) {
      stderr.writeln('ERROR: Failed to parse copy json: $e');
      hasErrors = true;
    }
  }

  if (hasErrors) {
    stderr.writeln('FAILED: Rekindle offline or copy guard failed.');
    exit(1);
  } else {
    stdout.writeln('SUCCESS: Offline and copy integrity verified.');
  }
}
