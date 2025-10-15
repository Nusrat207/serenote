// lib/shared/data/datasources/database_datasource.dart

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseDataSource {
  static Database? _database;
  static const String _databaseName = 'serenote.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // For web
      final factory = databaseFactoryWeb;
      return await factory.openDatabase(_databaseName);
    } else {
      // For mobile
      final appDir = await getApplicationDocumentsDirectory();
      await appDir.create(recursive: true);
      final dbPath = join(appDir.path, _databaseName);

      final factory = databaseFactoryIo;
      return await factory.openDatabase(dbPath);
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
