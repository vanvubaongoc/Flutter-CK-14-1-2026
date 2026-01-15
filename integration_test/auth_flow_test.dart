import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/main.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Integration Tests', () {
    testWidgets('User registration and login flow', (WidgetTester tester) async {
      // Khởi động app
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

      // Verify we're on login screen
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // username and password fields
      expect(find.text('Register'), findsOneWidget);

      // Navigate to register screen
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Verify register screen
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3)); // username, email, password

      // Fill registration form
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'integration@test.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'testpassword123');

      // Submit registration
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should navigate back to login screen
      expect(find.text('Login'), findsOneWidget);

      // Now login with the registered account
      await tester.enterText(find.byType(TextFormField).at(0), 'integration_test_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'testpassword123');

      // Submit login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should navigate to home screen
      expect(find.text('My Notes'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('Login with invalid credentials', (WidgetTester tester) async {
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

      // Try to login with non-existent user
      await tester.enterText(find.byType(TextFormField).at(0), 'nonexistent_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should still be on login screen with error message
      expect(find.text('Login'), findsOneWidget);
      // Note: Error message display depends on implementation
    });

    testWidgets('Session persistence after app restart', (WidgetTester tester) async {
      // First, login and verify we're on home screen
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

      expect(find.text('My Notes'), findsOneWidget);

      // Simulate app restart by recreating the widget tree
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

      // Should automatically navigate to home screen due to saved session
      expect(find.text('My Notes'), findsOneWidget);
    });

    testWidgets('Logout functionality', (WidgetTester tester) async {
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

      expect(find.text('My Notes'), findsOneWidget);

      // Logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Should navigate back to login screen
      expect(find.text('Login'), findsOneWidget);
    });
  });
}