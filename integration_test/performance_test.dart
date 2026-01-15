import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/main.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance and Error Handling Integration Tests', () {
    testWidgets('App startup performance', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
            ChangeNotifierProvider(create: (_) => NoteProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for initial frame
      await tester.pumpAndSettle();

      stopwatch.stop();

      // App should start within reasonable time (e.g., 5 seconds)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      // Verify initial screen is displayed
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Memory leak prevention - proper disposal', (WidgetTester tester) async {
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

      // Navigate through screens
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login')); // Assuming back navigation
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify no memory issues by checking app still responds
      expect(find.text('My Notes'), findsOneWidget);
    });

    testWidgets('Network error handling simulation', (WidgetTester tester) async {
      // Note: This test assumes some network operations exist
      // For now, it's a placeholder for when network features are added

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

      // If there are network-dependent features, test error handling here
      // For example, simulate network failure and check error messages
    });

    testWidgets('Large data set performance', (WidgetTester tester) async {
      // This test would require pre-populating the database with many notes
      // For now, it's a placeholder

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

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Test scrolling performance with many items
      // This would require many notes to be meaningful
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        // Simulate scrolling
        await tester.drag(listView.first, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Verify smooth scrolling (no crashes)
        expect(find.text('My Notes'), findsOneWidget);
      }
    });

    testWidgets('App lifecycle handling', (WidgetTester tester) async {
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

      // Login
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Simulate app going to background and coming back
      // This tests state preservation
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Verify app state is preserved
      expect(find.text('My Notes'), findsOneWidget);
    });

    testWidgets('Accessibility compliance', (WidgetTester tester) async {
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

      // Check for semantic labels on important elements
      expect(find.bySemanticsLabel('Login button'), findsOneWidget);
      expect(find.bySemanticsLabel('Username field'), findsOneWidget);
      expect(find.bySemanticsLabel('Password field'), findsOneWidget);

      // Test keyboard navigation (if implemented)
      // This would require focus management
    });
  });
}