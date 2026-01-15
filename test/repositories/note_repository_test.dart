import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/repositories/note_repository.dart';
import 'package:note_app/services/database_service.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('NoteRepository Integration Tests', () {
    late NoteRepository repository;

    setUp(() async {
      repository = NoteRepository();
      // Initialize database tables
      final db = await DatabaseService().database;
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          tag TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
    });

    test('should add and get note', () async {
      final note = NoteModel(
        title: 'Test Note',
        content: 'Test Content',
        tag: 'test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add note
      final addedNoteId = await repository.addNote(note);
      expect(addedNoteId, isNotNull);
      expect(addedNoteId, isA<int>());

      // Get the added note to verify
      final addedNote = await repository.getNoteById(addedNoteId);
      expect(addedNote, isNotNull);
      expect(addedNote!.title, 'Test Note');

      // Get all notes
      final notes = await repository.getAllNotes();
      expect(notes.length, greaterThan(0));
      expect(notes.any((n) => n.title == 'Test Note'), true);
    });

    test('should update note', () async {
      // First add a note to update
      final originalNote = NoteModel(
        title: 'Original Note',
        content: 'Original Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final addedNoteId = await repository.addNote(originalNote);
      expect(addedNoteId, isNotNull);

      // Get the original note
      final addedNote = await repository.getNoteById(addedNoteId);
      expect(addedNote, isNotNull);

      // Update the note
      final updatedNote = NoteModel(
        id: addedNoteId,
        title: 'Updated Note',
        content: 'Updated Content',
        createdAt: addedNote!.createdAt,
        updatedAt: DateTime.now(),
      );

      final updateResult = await repository.updateNote(updatedNote);
      expect(updateResult, 1); // SQLite update returns number of rows affected

      // Verify update
      final notes = await repository.getAllNotes();
      final foundNote = notes.firstWhere((n) => n.id == addedNoteId);
      expect(foundNote.title, 'Updated Note');
      expect(foundNote.content, 'Updated Content');
    });

    test('should delete note', () async {
      // First add a note to delete
      final note = NoteModel(
        title: 'Note to Delete',
        content: 'Content to Delete',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final addedNoteId = await repository.addNote(note);
      expect(addedNoteId, isNotNull);

      // Delete the note
      final result = await repository.deleteNote(addedNoteId);
      expect(result, 1); // SQLite delete returns number of rows affected

      // Verify deletion
      final notes = await repository.getAllNotes();
      expect(notes.any((n) => n.id == addedNoteId), false);
    });

    test('should search notes', () async {
      // Add test notes
      final note1 = NoteModel(
        title: 'Flutter Development',
        content: 'Learning Flutter',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final note2 = NoteModel(
        title: 'Dart Programming',
        content: 'Learning Dart',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addNote(note1);
      await repository.addNote(note2);

      // Search for 'Flutter'
      final results = await repository.searchNotes('Flutter');
      expect(results.length, greaterThan(0));
      expect(results.any((n) => n.title.contains('Flutter')), true);
    });

    test('should get notes by tag', () async {
      // Add notes with tags
      final note1 = NoteModel(
        title: 'Work Note',
        content: 'Work content',
        tag: 'work',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final note2 = NoteModel(
        title: 'Personal Note',
        content: 'Personal content',
        tag: 'personal',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addNote(note1);
      await repository.addNote(note2);

      // Get notes by tag
      final workNotes = await repository.getNotesByTag('work');
      expect(workNotes.length, greaterThan(0));
      expect(workNotes.every((n) => n.tag == 'work'), true);
    });
  });
}