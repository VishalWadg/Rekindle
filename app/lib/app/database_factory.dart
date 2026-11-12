import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rekindle_core/rekindle_core.dart';

/// Opens the local Rekindle SQLite database with foreign keys and WAL enabled.
AppDatabase openRekindleDatabase() {
  final executor = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rekindle.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
        rawDb.execute('PRAGMA journal_mode = WAL;');
        rawDb.execute('PRAGMA synchronous = NORMAL;');
        rawDb.execute('PRAGMA busy_timeout = 5000;');
      },
    );
  });

  return AppDatabase(executor);
}
