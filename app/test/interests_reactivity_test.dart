import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekindle_app/app/providers.dart';
import 'package:rekindle_app/features/interests/interests_screen.dart';
import 'package:rekindle_core/rekindle_core.dart';

void main() {
  late AppDatabase db;

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

  testWidgets(
    'InterestsScreen updates snippet count immediately after adding a snippet to a new interest',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: InterestsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No interests yet.'), findsOneWidget);

      // 1. Add a new interest via the app bar action
      await tester.tap(find.byTooltip('Add interest'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Astronomy');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Astronomy'), findsOneWidget);
      expect(find.text('add a snippet'), findsOneWidget);

      // 2. Add a snippet directly to the newly created interest
      await tester.tap(find.byTooltip('Add snippet'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Pulsars spin rapidly');
      await tester.tap(find.text('Save thought'));
      await tester.pumpAndSettle();

      // 3. Verify count updates immediately on the same tab without restarting
      expect(find.text('1 thoughts'), findsOneWidget);
      expect(find.text('add a snippet'), findsNothing);

      // Flush Drift stream subscription cancellation timers before tearDown closes DB
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );
}
