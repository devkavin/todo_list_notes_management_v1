import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE myNotesDB(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdAt TEXT DEFAULT CURRENT_TIMESTAMP, updatedAt TEXT DEFAULT CURRENT_TIMESTAMP)');
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'myNotesDB.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        // debug statement
        debugPrint('Creating tables..');
        await createTables(database);
      },
    );
  }

  static Future<int> createNote(String title, String? description,
      String createdAt, String? updatedAt) async {
    final sql.Database db = await SQLHelper.database();

    final data = {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': '',
    };
    final id = await db.insert('myNotesDB', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    debugPrint(
        'Created note with id: $id, createdAt: $createdAt, updatedAt: $updatedAt');
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final sql.Database db = await SQLHelper.database();
    final notes = await db.query('myNotesDB');
    debugPrint('Got ${notes.length} note');
    return notes;
  }

  // getMyNotesById widgets.id
  static Future<List<Map<String, dynamic>>> getNotesById(int id) async {
    final sql.Database db = await SQLHelper.database();
    final notes = await db.query('myNotesDB', where: 'id = ?', whereArgs: [id]);
    debugPrint('Got ${notes.length} notes');
    return notes;
  }

  static Future<int> updateNote(
      int id, String title, String? description, String? updatedAt) async {
    final sql.Database db = await SQLHelper.database();
    final data = {
      'title': title,
      'description': description,
      'updatedAt': updatedAt,
    };
    final count =
        await db.update('myNotesDB', data, where: 'id = ?', whereArgs: [id]);
    debugPrint('Updated $count note with id: $id');
    return count;
  }

  static Future<int> deleteNote(int id) async {
    final sql.Database db = await SQLHelper.database();
    final count =
        await db.delete('myNotesDB', where: 'id = ?', whereArgs: [id]);
    debugPrint('Deleted $count note');
    return count;
  }

  // search
  static Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    final sql.Database db = await SQLHelper.database();
    final notes = await db.query('myNotesDB',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%']);
    debugPrint('found ${notes.length} notes');
    return notes;
  }
}
