import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/services/database_service.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseService', () {
    late DatabaseService databaseService;
    late Database db;

    setUp(() async {
      databaseService = DatabaseService();
      db = await databaseService.database;
    });

    tearDown(() async {
      // Don't close database here as DatabaseService is singleton
      // Database will be reused across tests
    });

    test('should initialize database', () async {
      expect(db, isNotNull);
      expect(db.isOpen, true);
    });

    test('should create notes table', () async {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='notes'",
      );
      expect(tables.length, 1);
    });

    test('should insert and retrieve note', () async {
      final note = NoteModel(
        title: 'Test Note',
        content: 'Test Content',
        tag: 'test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await databaseService.insertNote(note);
      expect(id, isNotNull);
      expect(id, greaterThan(0));

      final retrievedNote = await databaseService.getNoteById(id);
      expect(retrievedNote, isNotNull);
      expect(retrievedNote!.title, 'Test Note');
      expect(retrievedNote.content, 'Test Content');
      expect(retrievedNote.tag, 'test');
    });

    test('should update note', () async {
      final note = NoteModel(
        title: 'Original Note',
        content: 'Original Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await databaseService.insertNote(note);

      final updatedNote = NoteModel(
        id: id,
        title: 'Updated Note',
        content: 'Updated Content',
        tag: 'updated',
        createdAt: note.createdAt,
        updatedAt: DateTime.now(),
      );

      final rowsAffected = await databaseService.updateNote(updatedNote);
      expect(rowsAffected, 1);

      final retrievedNote = await databaseService.getNoteById(id);
      expect(retrievedNote!.title, 'Updated Note');
      expect(retrievedNote.content, 'Updated Content');
      expect(retrievedNote.tag, 'updated');
    });

    test('should delete note', () async {
      final note = NoteModel(
        title: 'Note to Delete',
        content: 'Content to Delete',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await databaseService.insertNote(note);

      final rowsAffected = await databaseService.deleteNote(id);
      expect(rowsAffected, 1);

      final retrievedNote = await databaseService.getNoteById(id);
      expect(retrievedNote, isNull);
    });

    test('should get all notes', () async {
      // Clear existing notes
      await db.delete('notes');

      final notes = [
        NoteModel(
          title: 'Note 1',
          content: 'Content 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NoteModel(
          title: 'Note 2',
          content: 'Content 2',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final note in notes) {
        await databaseService.insertNote(note);
      }

      final allNotes = await databaseService.getAllNotes();
      expect(allNotes.length, 2);
      expect(allNotes[0].title, 'Note 1');
      expect(allNotes[1].title, 'Note 2');
    });

    test('should search notes', () async {
      await db.delete('notes');

      final notes = [
        NoteModel(
          title: 'Flutter Note',
          content: 'Flutter content',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NoteModel(
          title: 'Dart Note',
          content: 'Dart content',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NoteModel(
          title: 'Other Note',
          content: 'Other content',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final note in notes) {
        await databaseService.insertNote(note);
      }

      final searchResults = await databaseService.searchNotes('Flutter');
      expect(searchResults.length, 1);
      expect(searchResults[0].title, 'Flutter Note');
    });

    test('should get notes by tag', () async {
      await db.delete('notes');

      final notes = [
        NoteModel(
          title: 'Work Note',
          content: 'Work content',
          tag: 'work',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NoteModel(
          title: 'Personal Note',
          content: 'Personal content',
          tag: 'personal',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NoteModel(
          title: 'Another Work Note',
          content: 'Another work content',
          tag: 'work',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final note in notes) {
        await databaseService.insertNote(note);
      }

      final workNotes = await databaseService.getNotesByTag('work');
      expect(workNotes.length, 2);
      expect(workNotes.every((note) => note.tag == 'work'), true);
    });
  });
}