
// this part is for web version

import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  // Store names
  final String moodStore = 'moods';
  final String journalStore = 'journals';
  final String habitStore = 'habits';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Use sembast_web for browser storage (IndexedDB)
    final factory = databaseFactoryWeb;
    return await factory.openDatabase('SereNote_database.db');
  }

  // Generic CRUD operations
  Future<void> insert(String storeName, Map<String, dynamic> data) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.add(db, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String storeName) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    final snapshots = await store.find(db);
    return snapshots.map((snapshot) {
      final data = Map<String, dynamic>.from(snapshot.value);
      data['id'] = snapshot.key;
      return data;
    }).toList();
  }

  Future<void> update(String storeName, int id, Map<String, dynamic> data) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.record(id).update(db, data);
  }

  Future<void> delete(String storeName, int id) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.record(id).delete(db);
  }

  // Clear all data (useful for testing)
  Future<void> clearAll() async {
    final db = await database;
    await intMapStoreFactory.store(moodStore).delete(db);
    await intMapStoreFactory.store(journalStore).delete(db);
    await intMapStoreFactory.store(habitStore).delete(db);
  }

  // Get database size info (web uses IndexedDB)
  Future<int> getStoreCount(String storeName) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    return await store.count(db);
  }
}

/*
// this part is for mobile version 
import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  // Store names
  final String moodStore = 'moods';
  final String journalStore = 'journals';
  final String habitStore = 'habits';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDir.path, 'SereNote_database.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  // Generic CRUD operations
  Future<void> insert(String storeName, Map<String, dynamic> data) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.add(db, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String storeName) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    final snapshots = await store.find(db);
    return snapshots.map((snapshot) {
      final data = Map<String, dynamic>.from(snapshot.value);
      data['id'] = snapshot.key;
      return data;
    }).toList();
  }

  Future<void> update(String storeName, int id, Map<String, dynamic> data) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.record(id).update(db, data);
  }

  Future<void> delete(String storeName, int id) async {
    final db = await database;
    final store = intMapStoreFactory.store(storeName);
    await store.record(id).delete(db);
  }

  // Add this to the DatabaseService class
final String habitCompletionStore = 'habit_completions';

// Add a method to get completions by habit ID
Future<List<Map<String, dynamic>>> getCompletionsByHabit(int habitId) async {
  final db = await database;
  final store = intMapStoreFactory.store(habitCompletionStore);
  final finder = Finder(
    filter: Filter.equals('habitId', habitId),
  );
  final snapshots = await store.find(db, finder: finder);
  return snapshots.map((snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value);
    data['id'] = snapshot.key;
    return data;
  }).toList();
}

// Get completions for a specific date
Future<List<Map<String, dynamic>>> getCompletionsForDate(DateTime date) async {
  final db = await database;
  final store = intMapStoreFactory.store(habitCompletionStore);
  
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  final snapshots = await store.find(db);
  
  return snapshots.where((snapshot) {
    final completedAt = DateTime.parse(snapshot.value['completedAt'] as String);
    return completedAt.isAfter(startOfDay) && completedAt.isBefore(endOfDay);
  }).map((snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value);
    data['id'] = snapshot.key;
    return data;
  }).toList();
}
}*/