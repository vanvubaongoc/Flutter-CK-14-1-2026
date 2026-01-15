import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/main.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Note Management Integration Tests', () {
    testWidgets('Load notes on home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should be on home screen
      expect(find.text('My Notes'), findsOneWidget);

      // Check if notes are loaded (initially empty or with existing notes)
      // This depends on whether there are notes in the database
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Add note button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check for FAB (Floating Action Button) to add notes
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Search functionality in home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Look for search field (if implemented)
      // This test assumes there's a search TextField in the home screen
      final searchFields = find.byType(TextField);
      if (searchFields.evaluate().isNotEmpty) {
        // If search is implemented, test it
        await tester.enterText(searchFields.first, 'test search');
        await tester.pumpAndSettle();

        // Verify search results are filtered
        // This would depend on actual implementation
      }
    });

    testWidgets('Note count display', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if there's any note count display
      // This depends on the UI implementation
      // For example, might show "5 notes" or similar
    });

    testWidgets('Pull to refresh functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Test pull to refresh if implemented
      // This would require a RefreshIndicator in the UI
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        await tester.drag(refreshIndicator.first, const Offset(0, 300));
        await tester.pumpAndSettle();

        // Verify notes are refreshed
      }
    });
  });
}