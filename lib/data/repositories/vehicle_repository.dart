import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/vehicle.dart';

class VehicleRepository {
  VehicleRepository(this.database);

  final AppDatabase database;

  Future<List<Vehicle>> fetchVehicles() async {
    final db = await database.database;
    final data = await db.query('vehicles', orderBy: 'createdAt DESC');
    return data.map(Vehicle.fromMap).toList();
  }

  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await database.database;
    return db.insert('vehicles', vehicle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final db = await database.database;
    await db.update('vehicles', vehicle.toMap(),
        where: 'id = ?', whereArgs: [vehicle.id]);
  }

  Future<void> deleteVehicle(int id) async {
    final db = await database.database;
    await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
    await db.delete('fuel_entries', where: 'vehicleId = ?', whereArgs: [id]);
    await db.delete('cost_entries', where: 'vehicleId = ?', whereArgs: [id]);
  }
}
