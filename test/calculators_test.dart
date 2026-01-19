import 'package:flutter_test/flutter_test.dart';
import 'package:statcar/data/models/cost_entry.dart';
import 'package:statcar/data/models/fuel_entry.dart';
import 'package:statcar/data/models/vehicle.dart';
import 'package:statcar/domain/calculators.dart';

void main() {
  test('calculates consumption between full tanks', () {
    final previous = FuelEntry(
      id: 1,
      vehicleId: 1,
      date: DateTime(2024, 1, 1),
      odometerKm: 10000,
      liters: 40,
      totalCostEur: 70,
      pricePerLiter: 1.75,
      stationName: 'Aral',
      fuelType: FuelType.e5,
      isFullTank: true,
      missedFillUp: false,
      notes: '',
      receiptImagePath: null,
      createdAt: DateTime(2024, 1, 1),
    );
    final current = previous.copyWith(
      id: 2,
      date: DateTime(2024, 1, 15),
      odometerKm: 10500,
      liters: 35,
    );
    final consumption =
        calculateConsumptionLPer100(previous: previous, current: current);
    expect(consumption, closeTo(7.0, 0.1));
  });

  test('totals include cost entries', () {
    final costs = [
      CostEntry(
        id: 1,
        vehicleId: 1,
        date: DateTime(2024, 1, 1),
        category: CostCategory.insurance,
        amountEur: 100,
        odometerKm: null,
        vendor: 'Allianz',
        notes: '',
        createdAt: DateTime(2024, 1, 1),
      ),
    ];
    expect(totalCostEntries(costs), 100);
  });
}
