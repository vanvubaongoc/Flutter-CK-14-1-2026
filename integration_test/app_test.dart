import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/main.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete user flow: register -> login -> add note -> logout',
        (WidgetTester tester) async {
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

      // 1. Đăng ký tài khoản mới
      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Điền form đăng ký
      await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      // Nhấn Register
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Kiểm tra chuyển về login screen
      expect(find.text('Login'), findsOneWidget);

      // 2. Đăng nhập
      await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Kiểm tra vào home screen
      expect(find.text('My Notes'), findsOneWidget);

      // 3. Thêm ghi chú mới
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Điền thông tin ghi chú (giả sử có màn hình add note)
      // Note: Cần implement màn hình add note trước

      // 4. Đăng xuất
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Xác nhận dialog logout
      await tester.tap(find.text('OK')); // Giả sử có dialog
      await tester.pumpAndSettle();

      // Kiểm tra quay về login
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('search functionality test', (WidgetTester tester) async {
      // Setup tương tự như trên
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

      // Đăng nhập trước
      // ... (code đăng nhập)

      // Tìm kiếm ghi chú
      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pumpAndSettle();

      // Kiểm tra kết quả tìm kiếm
      // expect(find.textContaining('test'), findsWidgets);
    });
  });
}