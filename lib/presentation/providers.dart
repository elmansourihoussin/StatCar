import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../data/models/cost_entry.dart';
import '../data/models/fuel_entry.dart';
import '../data/models/vehicle.dart';
import '../data/repositories/cost_repository.dart';
import '../data/repositories/fuel_repository.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/vehicle_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ref.read(databaseProvider));
});

final fuelRepositoryProvider = Provider<FuelRepository>((ref) {
  return FuelRepository(ref.read(databaseProvider));
});

final costRepositoryProvider = Provider<CostRepository>((ref) {
  return CostRepository(ref.read(databaseProvider));
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository();
});

final vehicleListProvider = FutureProvider<List<Vehicle>>((ref) async {
  final repo = ref.read(vehicleRepositoryProvider);
  return repo.fetchVehicles();
});

final activeVehicleIdProvider = StateProvider<int?>((ref) => null);

final fuelEntriesProvider =
    FutureProvider.family<List<FuelEntry>, int>((ref, vehicleId) async {
  final repo = ref.read(fuelRepositoryProvider);
  return repo.fetchForVehicle(vehicleId);
});

final costEntriesProvider =
    FutureProvider.family<List<CostEntry>, int>((ref, vehicleId) async {
  final repo = ref.read(costRepositoryProvider);
  return repo.fetchForVehicle(vehicleId);
});

final vehicleStatsProvider =
    FutureProvider.family<VehicleStats, int>((ref, vehicleId) async {
  final fuelEntries = await ref.watch(fuelEntriesProvider(vehicleId).future);
  final costEntries = await ref.watch(costEntriesProvider(vehicleId).future);
  return ref
      .read(statsRepositoryProvider)
      .buildStats(fuelEntries: fuelEntries, costEntries: costEntries);
});

final localeProvider = StateProvider<Locale?>((ref) => const Locale('de'));
