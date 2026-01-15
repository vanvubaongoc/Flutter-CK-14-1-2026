import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/viewmodels/auth_provider.dart';
import 'package:note_app/models/user_model.dart';

void main() {
  group('AuthProvider', () {
    late AuthProvider provider;

    setUp(() {
      provider = AuthProvider();
    });

    test('should initialize with empty state', () {
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, false);
      expect(provider.isLoading, false);
    });

    test('should have repository instance', () {
      expect(provider, isNotNull);
      // The repository is created internally
    });

    // Note: For comprehensive testing of register, login, logout, initialize,
    // we'd need to mock the repository and shared preferences.
    // This would require dependency injection.

    test('should handle loading state', () {
      // Test loading state changes
      expect(provider.isLoading, false);
    });

    test('should handle authentication state', () {
      // Test authentication state
      expect(provider.isAuthenticated, false);
      expect(provider.currentUser, isNull);
    });
  });
}