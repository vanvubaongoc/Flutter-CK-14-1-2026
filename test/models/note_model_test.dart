import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/models/note_model.dart';

void main() {
  group('NoteModel', () {
    final testNote = NoteModel(
      id: 1,
      title: 'Test Note',
      content: 'This is a test note content',
      tag: 'test',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should create NoteModel with required parameters', () {
      final note = NoteModel(
        title: 'Test Title',
        content: 'Test Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.title, 'Test Title');
      expect(note.content, 'Test Content');
      expect(note.id, isNull);
      expect(note.tag, isNull);
    });

    test('should create NoteModel with all parameters', () {
      expect(testNote.id, 1);
      expect(testNote.title, 'Test Note');
      expect(testNote.content, 'This is a test note content');
      expect(testNote.tag, 'test');
      expect(testNote.createdAt, DateTime(2024, 1, 1));
      expect(testNote.updatedAt, DateTime(2024, 1, 1));
    });

    test('toMap should return correct Map', () {
      final map = testNote.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test Note');
      expect(map['content'], 'This is a test note content');
      expect(map['tag'], 'test');
      expect(map['createdAt'], '2024-01-01T00:00:00.000');
      expect(map['updatedAt'], '2024-01-01T00:00:00.000');
    });

    test('fromMap should create NoteModel from Map', () {
      final map = {
        'id': 2,
        'title': 'From Map Note',
        'content': 'Content from map',
        'tag': 'map',
        'createdAt': '2024-01-02T00:00:00.000',
        'updatedAt': '2024-01-02T00:00:00.000',
      };

      final note = NoteModel.fromMap(map);

      expect(note.id, 2);
      expect(note.title, 'From Map Note');
      expect(note.content, 'Content from map');
      expect(note.tag, 'map');
      expect(note.createdAt, DateTime(2024, 1, 2));
      expect(note.updatedAt, DateTime(2024, 1, 2));
    });

    test('fromMap should handle null tag', () {
      final map = {
        'id': 3,
        'title': 'No Tag Note',
        'content': 'Content without tag',
        'tag': null,
        'createdAt': '2024-01-03T00:00:00.000',
        'updatedAt': '2024-01-03T00:00:00.000',
      };

      final note = NoteModel.fromMap(map);

      expect(note.tag, isNull);
    });

    test('copyWith should return new instance with updated fields', () {
      final updatedNote = testNote.copyWith(
        title: 'Updated Title',
        tag: 'updated',
      );

      expect(updatedNote.id, testNote.id);
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.content, testNote.content);
      expect(updatedNote.tag, 'updated');
      expect(updatedNote.createdAt, testNote.createdAt);
      expect(updatedNote.updatedAt, testNote.updatedAt);
    });

    test('copyWith should return same instance if no changes', () {
      final sameNote = testNote.copyWith();

      expect(sameNote.title, testNote.title);
      expect(sameNote.content, testNote.content);
      expect(sameNote.tag, testNote.tag);
      expect(sameNote.createdAt, testNote.createdAt);
      expect(sameNote.updatedAt, testNote.updatedAt);
    });
  });
}