import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:note_app/views/screens/home_screen.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('HomeScreen Widget Tests', () {
    late AuthProvider authProvider;
    late NoteProvider noteProvider;

    setUp(() {
      authProvider = AuthProvider();
      noteProvider = NoteProvider();
    });

    tearDown(() {
      authProvider.dispose();
      noteProvider.dispose();
    });

    testWidgets('should display home screen with app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<NoteProvider>(create: (_) => noteProvider),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Just pump once without settle to avoid timeout
      await tester.pump();

      // Check if home screen elements are present
      expect(find.text('Ghi Chú Của Tôi'), findsOneWidget); // App bar title
      expect(find.byIcon(Icons.logout), findsOneWidget); // Logout button
      expect(find.byIcon(Icons.add), findsOneWidget); // Add note FAB
    });

    testWidgets('should show loading indicator when loading', (WidgetTester tester) async {
      // Set loading state through provider methods
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<NoteProvider>(create: (_) => noteProvider),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Trigger loading state by calling loadNotes
      noteProvider.loadNotes();
      await tester.pump();

      // Check for loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display notes list when loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<NoteProvider>(create: (_) => noteProvider),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should not show loading when not loading
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // Should show notes list or empty state
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should logout when logout button pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<NoteProvider>(create: (_) => noteProvider),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
            routes: {
              '/login': (context) => const Scaffold(body: Text('Login Screen')),
            },
          ),
        ),
      );

      // Tap logout button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('should show add note FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<NoteProvider>(create: (_) => noteProvider),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // FAB should be present
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}