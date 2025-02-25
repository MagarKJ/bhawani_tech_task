import 'dart:developer';

import 'package:bhawani_tech_task/presentation/dashboard/model/expense_mode.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for the database helper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE expenses(
            id TEXT PRIMARY KEY, -- Local ID for SQLite
            name TEXT,
            token TEXT,
            userId TEXT,
            title TEXT,
            description TEXT,
            amount REAL,
            receiptImage TEXT,
            status TEXT,
            createdAt INTEGER,
            isSynced INTEGER DEFAULT 0, -- Tracking sync status
            firestoreDocId TEXT  -- Firestore Document ID
          )
          ''',
        );
      },
      version: 3, // Increment version for database migration
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Drop the old table if upgrading
          await db.execute('DROP TABLE IF EXISTS expenses');

          // Create a new table with the updated schema
          await db.execute(
            '''
            CREATE TABLE expenses(
              id TEXT PRIMARY KEY, -- Local ID for SQLite
              name TEXT,
              token TEXT,
              userId TEXT,
              title TEXT,
              description TEXT,
              amount REAL,
              receiptImage TEXT,
              status TEXT,
              createdAt INTEGER,
              isSynced INTEGER DEFAULT 0, -- Tracking sync status
              firestoreDocId TEXT  -- Firestore Document ID
            )
            ''',
          );
        }
      },
    );
  }

  // Insert an expense into the database (with local ID)
  Future<void> insertExpense(ExpensModel expense) async {
    final db = await database;

    // Generate a local ID using UUID
    String localId = Uuid().v4();

    // Insert expense into SQLite with a generated local ID
    await db.insert(
      'expenses',
      {
        'id': localId,
        'name': expense.name,
        'token': expense.token,
        'userId': expense.userId,
        'title': expense.title,
        'description': expense.description,
        'amount': expense.amount,
        'receiptImage': expense.receiptImage,
        'status': expense.status,
        'createdAt': expense.createdAt,
        'isSynced': expense.isSynced ? 1 : 0,
        'firestoreDocId': '', // Leave Firestore Doc ID empty initially
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all expenses from the database
  Future<List<ExpensModel>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    return List.generate(maps.length, (i) {
      return ExpensModel.fromMap(maps[i]);
    });
  }

  // Update an expense in the database
  Future<void> updateExpense(ExpensModel expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense from the database
  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    log('Expense deleted successfully');
  }

  // Delete the database
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_database.db');
    await databaseFactory.deleteDatabase(path);
    log('Database deleted successfully');
  }

  // Fetch unsynced expenses from the SQLite database
  Future<List<ExpensModel>> getUnsyncedExpenses() async {
    final db = await database;
    final result = await db.query(
      'expenses',
      where: 'isSynced = ?',
      whereArgs: [
        0
      ], // 0 represents false, while 1 represents true for isSynced
    );

    return result.map((e) => ExpensModel.fromMap(e)).toList();
  }

  // Update Firestore Document ID after syncing
  Future<void> updateFirestoreDocId(
      String localId, String firestoreDocId) async {
    final db = await database;

    await db.update(
      'expenses',
      {'firestoreDocId': firestoreDocId},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }
}
