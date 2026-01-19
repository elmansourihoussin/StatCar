import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _dbName = 'statcar.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _create,
    );
  }

  Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        defaultFuelType TEXT NOT NULL,
        distanceUnit TEXT NOT NULL,
        notes TEXT NOT NULL,
        createdAt TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE fuel_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER NOT NULL,
        date TEXT NOT NULL,
        odometerKm REAL NOT NULL,
        liters REAL NOT NULL,
        totalCostEur REAL NOT NULL,
        pricePerLiter REAL NOT NULL,
        stationName TEXT NOT NULL,
        fuelType TEXT NOT NULL,
        isFullTank INTEGER NOT NULL,
        missedFillUp INTEGER NOT NULL,
        notes TEXT NOT NULL,
        receiptImagePath TEXT,
        createdAt TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE cost_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        amountEur REAL NOT NULL,
        odometerKm REAL,
        vendor TEXT,
        notes TEXT NOT NULL,
        createdAt TEXT NOT NULL
      );
    ''');
  }
}
