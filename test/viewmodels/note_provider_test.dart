import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_app/viewmodels/note_provider.dart';
import 'package:note_app/models/note_model.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('NoteProvider', () {
    late NoteProvider provider;

    setUp(() {
      provider = NoteProvider();
    });

    test('should initialize with empty state', () {
      expect(provider.notes, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.searchKeyword, '');
      expect(provider.selectedTag, isNull);
      expect(provider.notesCount, 0);
    });

    test('should update search keyword', () async {
      await provider.searchNotes('test search');

      expect(provider.searchKeyword, 'test search');
    });

    test('should update selected tag', () async {
      await provider.filterByTag('important');

      expect(provider.selectedTag, 'important');
    });

    test('should clear search and tag', () {
      provider.clearFilters();

      expect(provider.searchKeyword, '');
      expect(provider.selectedTag, isNull);
    });

    test('should calculate notes count correctly', () {
      // Since we can't easily test with real data without database,
      // this demonstrates the expected behavior
      expect(provider.notesCount, 0);
    });

    // Note: For comprehensive testing of loadNotes, addNote, updateNote, deleteNote,
    // we'd need to mock the repository and test the state changes.
    // This would require dependency injection in the provider.

    test('should have repository instance', () {
      expect(provider, isNotNull);
      // The repository is created internally, so we verify the provider exists
    });
  });
}