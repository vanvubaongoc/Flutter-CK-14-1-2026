import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/views/screens/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    testWidgets('should display login form', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => authProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Check if login screen elements are present
      expect(find.text('Note App'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // username and password fields
      expect(find.byType(ElevatedButton), findsOneWidget); // login button
      expect(find.text('Chưa có tài khoản? Đăng ký ngay'), findsOneWidget); // register link
    });

    testWidgets('should show validation errors for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => authProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Tap login button without filling fields
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Vui lòng nhập tên đăng nhập'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    });

    testWidgets('should navigate to register screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => authProvider,
            child: const LoginScreen(),
          ),
          routes: {
            '/register': (context) => const Scaffold(body: Text('Register Screen')),
          },
        ),
      );

      // Tap register link
      await tester.tap(find.text('Chưa có tài khoản? Đăng ký ngay'));
      await tester.pumpAndSettle();

      // Should navigate to register screen
      expect(find.text('Register Screen'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => authProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Find password field
      final passwordField = find.byType(TextFormField).at(1);

      // Find the TextField inside the TextFormField
      final textFieldFinder = find.descendant(
        of: passwordField,
        matching: find.byType(TextField),
      );

      // Initially password should be obscured
      var textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.obscureText, true);

      // Tap visibility toggle (eye icon)
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Password should now be visible
      textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.obscureText, false);
    });
  });
}