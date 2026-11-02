import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rekindle_app/app/providers.dart';
import 'package:rekindle_app/main.dart';
import 'package:rekindle_core/rekindle_core.dart';

void main() {
  testWidgets('RekindleApp smoke test loads onboarding', (WidgetTester tester) async {
    final testDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: const RekindleApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('rekindle'), findsOneWidget);
    expect(find.text('Begin'), findsOneWidget);

    await testDb.close();
  });
}
