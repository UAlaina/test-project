import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Note Model
class Note {
  final int id;
  final String title;
  final String description;

  Note({required this.id, required this.title, required this.description});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description}';
  }
}

class NotesDbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes_db.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      //note.toMap(),
      {'title': note.title, 'description': note.description},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> query = await db.query('notes');
    return query
        .map((map) =>
        Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    ))
        //Note.fromMap(map))
        .toList();
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDB() async {
    final dbPath = join(await getDatabasesPath(), 'notes_db.db');
    await deleteDatabase(dbPath);
  }
}