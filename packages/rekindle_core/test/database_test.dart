import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:rekindle_core/src/data/database.dart';

void main() {
  late AppDatabase db;
  const uuid = Uuid();

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Schema v1 Tests', () {
    test('creates and queries interest and snippet', () async {
      final interestId = uuid.v4();
      final now = DateTime.now().toUtc();

      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Distributed systems',
              nameKey: 'distributed systems',
              createdAt: now,
            ),
          );

      final snippetId = uuid.v4();
      await db.into(db.snippetsTable).insert(
            SnippetsTableCompanion.insert(
              id: snippetId,
              interestId: interestId,
              content: 'Raft consensus algorithm ensures safety across network partitions.',
              source: 'MANUAL',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final allInterests = await db.select(db.interestsTable).get();
      expect(allInterests.length, equals(1));
      expect(allInterests.first.name, equals('Distributed systems'));

      final snippets = await (db.select(db.snippetsTable)..where((tbl) => tbl.interestId.equals(interestId))).get();
      expect(snippets.length, equals(1));
      expect(snippets.first.content, contains('Raft consensus'));
    });

    test('cascade deletes snippets when interest is deleted', () async {
      final interestId = uuid.v4();
      final now = DateTime.now().toUtc();

      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Philosophy',
              nameKey: 'philosophy',
              createdAt: now,
            ),
          );

      await db.into(db.snippetsTable).insert(
            SnippetsTableCompanion.insert(
              id: uuid.v4(),
              interestId: interestId,
              content: 'Stoicism emphasizes focusing on what is within your control.',
              source: 'ONBOARDING',
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Verify snippet exists
      var snippets = await db.select(db.snippetsTable).get();
      expect(snippets.length, equals(1));

      // Delete interest
      await (db.delete(db.interestsTable)..where((tbl) => tbl.id.equals(interestId))).go();

      // Snippet should be deleted via cascade
      snippets = await db.select(db.snippetsTable).get();
      expect(snippets.isEmpty, isTrue);
    });

    test('enforces unique name_key on interests', () async {
      final now = DateTime.now().toUtc();

      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: uuid.v4(),
              name: 'Quantum Physics',
              nameKey: 'quantum physics',
              createdAt: now,
            ),
          );

      // Inserting duplicate name_key should throw
      expect(
        () => db.into(db.interestsTable).insert(
              InterestsTableCompanion.insert(
                id: uuid.v4(),
                name: 'Quantum physics',
                nameKey: 'quantum physics',
                createdAt: now,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('manages app_state single row', () async {
      final now = DateTime.now().toUtc();
      await db.into(db.appStates).insert(
            AppStatesCompanion.insert(
              installSeed: 98765,
              timezone: 'UTC',
              createdAt: now,
            ),
          );

      final state = await db.select(db.appStates).getSingle();
      expect(state.id, equals(1));
      expect(state.installSeed, equals(98765));
      expect(state.insightsEnabled, isTrue);
    });
  });
}
