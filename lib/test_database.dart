// lib/test_database.dart
// Run this to test if database works!

import 'package:flutter/material.dart';
import 'shared/data/datasources/database_datasource.dart';

class TestDatabaseScreen extends StatefulWidget {
  const TestDatabaseScreen({Key? key}) : super(key: key);

  @override
  State<TestDatabaseScreen> createState() => _TestDatabaseScreenState();
}

class _TestDatabaseScreenState extends State<TestDatabaseScreen> {
  String status = 'Testing database...';

  @override
  void initState() {
    super.initState();
    testDatabase();
  }

  Future<void> testDatabase() async {
    try {
      final dbSource = DatabaseDataSource();
      final db = await dbSource.database;

      setState(() {
        status = '✅ Database connected successfully!\nPath: ${db.path}';
      });
    } catch (e) {
      setState(() {
        status = '❌ Database error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
