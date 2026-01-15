import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/models/user_model.dart';

void main() {
  group('UserModel', () {
    final testUser = UserModel(
      id: 1,
      username: 'testuser',
      email: 'test@example.com',
      password: 'hashedpassword',
      createdAt: DateTime(2024, 1, 1),
    );

    test('should create UserModel with required parameters', () {
      final user = UserModel(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );

      expect(user.username, 'newuser');
      expect(user.email, 'new@example.com');
      expect(user.password, 'password123');
      expect(user.id, isNull);
    });

    test('should create UserModel with all parameters', () {
      expect(testUser.id, 1);
      expect(testUser.username, 'testuser');
      expect(testUser.email, 'test@example.com');
      expect(testUser.password, 'hashedpassword');
      expect(testUser.createdAt, DateTime(2024, 1, 1));
    });

    test('toMap should return correct Map', () {
      final map = testUser.toMap();

      expect(map['id'], 1);
      expect(map['username'], 'testuser');
      expect(map['email'], 'test@example.com');
      expect(map['password'], 'hashedpassword');
      expect(map['createdAt'], '2024-01-01T00:00:00.000');
    });

    test('fromMap should create UserModel from Map', () {
      final map = {
        'id': 2,
        'username': 'frommap',
        'email': 'map@example.com',
        'password': 'mappassword',
        'createdAt': '2024-01-02T00:00:00.000',
      };

      final user = UserModel.fromMap(map);

      expect(user.id, 2);
      expect(user.username, 'frommap');
      expect(user.email, 'map@example.com');
      expect(user.password, 'mappassword');
      expect(user.createdAt, DateTime(2024, 1, 2));
    });

    test('copyWith should return new instance with updated fields', () {
      final updatedUser = testUser.copyWith(
        username: 'updateduser',
        email: 'updated@example.com',
      );

      expect(updatedUser.id, testUser.id);
      expect(updatedUser.username, 'updateduser');
      expect(updatedUser.email, 'updated@example.com');
      expect(updatedUser.password, testUser.password);
      expect(updatedUser.createdAt, testUser.createdAt);
    });

    test('copyWith should return same instance if no changes', () {
      final sameUser = testUser.copyWith();

      expect(sameUser.username, testUser.username);
      expect(sameUser.email, testUser.email);
      expect(sameUser.password, testUser.password);
      expect(sameUser.createdAt, testUser.createdAt);
    });
  });
}