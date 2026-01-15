import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_app/services/auth_service.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('AuthService', () {
    late AuthService authService;

    setUp(() async {
      authService = AuthService();
      await authService.initializeAuthTables();
    });

    tearDown(() async {
      // Clean up database between tests
      await authService.cleanDatabaseForTesting();
    });

    test('should register new user successfully', () async {
      final result = await authService.register(
        username: 'testuser_${DateTime.now().millisecondsSinceEpoch}',
        email: 'test@example.com',
        password: 'password123',
      );

      print('Register result: $result'); // Debug
      expect(result['success'], true);
      expect(result['userId'], isNotNull);
    });

    test('should not register user with existing username', () async {
      // First registration
      await authService.register(
        username: 'duplicateuser',
        email: 'first@example.com',
        password: 'password123',
      );

      // Second registration with same username
      final result = await authService.register(
        username: 'duplicateuser',
        email: 'second@example.com',
        password: 'password456',
      );

      expect(result['success'], false);
      expect(result['message'], contains('Tên đăng nhập hoặc email đã tồn tại'));
    });

    test('should not register user with existing email', () async {
      // First registration
      await authService.register(
        username: 'firstuser',
        email: 'same@example.com',
        password: 'password123',
      );

      // Second registration with same email
      final result = await authService.register(
        username: 'seconduser',
        email: 'same@example.com',
        password: 'password456',
      );

      expect(result['success'], false);
      expect(result['message'], contains('email'));
    });

    test('should login with correct credentials', () async {
      // Register user first
      await authService.register(
        username: 'loginuser',
        email: 'login@example.com',
        password: 'loginpass',
      );

      // Login
      final result = await authService.login(
        username: 'loginuser',
        password: 'loginpass',
      );

      expect(result['success'], true);
      expect(result['user'], isNotNull);
      expect(result['user'].username, 'loginuser');
    });

    test('should not login with wrong password', () async {
      // Register user first
      await authService.register(
        username: 'wrongpassuser',
        email: 'wrongpass@example.com',
        password: 'correctpass',
      );

      // Login with wrong password
      final result = await authService.login(
        username: 'wrongpassuser',
        password: 'wrongpass',
      );

      expect(result['success'], false);
      expect(result['message'], contains('Tên đăng nhập hoặc mật khẩu không đúng'));
    });

    test('should not login with non-existent user', () async {
      final result = await authService.login(
        username: 'nonexistent',
        password: 'password',
      );

      expect(result['success'], false);
      expect(result['message'], contains('Tên đăng nhập hoặc mật khẩu không đúng'));
    });

    test('should get user by id', () async {
      // Register user first
      final registerResult = await authService.register(
        username: 'getuser',
        email: 'get@example.com',
        password: 'getpass',
      );

      final userId = registerResult['userId'];

      // Get user by id
      final user = await authService.getUserById(userId);

      expect(user, isNotNull);
      expect(user!.username, 'getuser');
      expect(user.email, 'get@example.com');
    });

    test('should return null for non-existent user id', () async {
      final user = await authService.getUserById(99999);

      expect(user, isNull);
    });
  });
}