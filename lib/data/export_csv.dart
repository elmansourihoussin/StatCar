import 'package:csv/csv.dart';

import 'models/cost_entry.dart';
import 'models/fuel_entry.dart';

String buildFuelCsv(List<FuelEntry> entries) {
  final rows = [
    [
      'id',
      'vehicleId',
      'date',
      'odometerKm',
      'liters',
      'totalCostEur',
      'pricePerLiter',
      'stationName',
      'fuelType',
      'isFullTank',
      'missedFillUp',
      'notes',
      'receiptImagePath',
      'createdAt',
    ],
    ...entries.map(
      (entry) => [
        entry.id,
        entry.vehicleId,
        entry.date.toIso8601String(),
        entry.odometerKm,
        entry.liters,
        entry.totalCostEur,
        entry.pricePerLiter,
        entry.stationName,
        entry.fuelType.name,
        entry.isFullTank,
        entry.missedFillUp,
        entry.notes,
        entry.receiptImagePath,
        entry.createdAt.toIso8601String(),
      ],
    ),
  ];
  return const ListToCsvConverter().convert(rows);
}

String buildCostCsv(List<CostEntry> entries) {
  final rows = [
    [
      'id',
      'vehicleId',
      'date',
      'category',
      'amountEur',
      'odometerKm',
      'vendor',
      'notes',
      'createdAt',
    ],
    ...entries.map(
      (entry) => [
        entry.id,
        entry.vehicleId,
        entry.date.toIso8601String(),
        entry.category.name,
        entry.amountEur,
        entry.odometerKm,
        entry.vendor,
        entry.notes,
        entry.createdAt.toIso8601String(),
      ],
    ),
  ];
  return const ListToCsvConverter().convert(rows);
}
