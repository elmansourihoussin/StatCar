import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/cost_entry.dart';

class CostRepository {
  CostRepository(this.database);

  final AppDatabase database;

  Future<List<CostEntry>> fetchForVehicle(int vehicleId) async {
    final db = await database.database;
    final data = await db.query(
      'cost_entries',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
    );
    return data.map(CostEntry.fromMap).toList();
  }

  Future<int> insertCostEntry(CostEntry entry) async {
    final db = await database.database;
    return db.insert('cost_entries', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCostEntry(CostEntry entry) async {
    final db = await database.database;
    await db.update('cost_entries', entry.toMap(),
        where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteCostEntry(int id) async {
    final db = await database.database;
    await db.delete('cost_entries', where: 'id = ?', whereArgs: [id]);
  }
}
