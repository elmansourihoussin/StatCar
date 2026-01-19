import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/fuel_entry.dart';

class FuelRepository {
  FuelRepository(this.database);

  final AppDatabase database;

  Future<List<FuelEntry>> fetchForVehicle(int vehicleId) async {
    final db = await database.database;
    final data = await db.query(
      'fuel_entries',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
    );
    return data.map(FuelEntry.fromMap).toList();
  }

  Future<FuelEntry?> fetchLastForVehicle(int vehicleId) async {
    final db = await database.database;
    final data = await db.query(
      'fuel_entries',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
      limit: 1,
    );
    if (data.isEmpty) {
      return null;
    }
    return FuelEntry.fromMap(data.first);
  }

  Future<int> insertFuelEntry(FuelEntry entry) async {
    final db = await database.database;
    return db.insert('fuel_entries', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateFuelEntry(FuelEntry entry) async {
    final db = await database.database;
    await db.update('fuel_entries', entry.toMap(),
        where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteFuelEntry(int id) async {
    final db = await database.database;
    await db.delete('fuel_entries', where: 'id = ?', whereArgs: [id]);
  }
}
