import 'package:collection/collection.dart';

import '../../domain/calculators.dart';
import '../models/cost_entry.dart';
import '../models/fuel_entry.dart';

class MonthBucket {
  const MonthBucket(this.year, this.month, this.amount);

  final int year;
  final int month;
  final double amount;
}

class VehicleStats {
  const VehicleStats({
    required this.avgConsumption30d,
    required this.avgPricePerLiter,
    required this.monthlyCost,
    required this.consumptionSeries,
    required this.monthlyCosts,
    required this.priceSeries,
  });

  final double? avgConsumption30d;
  final double avgPricePerLiter;
  final double monthlyCost;
  final List<ConsumptionSample> consumptionSeries;
  final List<MonthBucket> monthlyCosts;
  final List<ConsumptionSample> priceSeries;
}

class StatsRepository {
  VehicleStats buildStats({
    required List<FuelEntry> fuelEntries,
    required List<CostEntry> costEntries,
  }) {
    final avgConsumption30d = averageConsumptionLastDays(fuelEntries, 30);
    final avgPrice = averagePricePerLiter(fuelEntries);
    final monthCosts = _buildMonthlyCosts(fuelEntries, costEntries);
    final currentMonth = DateTime.now();
    final monthlyCost = monthCosts
        .firstWhereOrNull(
          (bucket) =>
              bucket.year == currentMonth.year &&
              bucket.month == currentMonth.month,
        )
        ?.amount ??
        0;
    final consumptionSeries = buildConsumptionSeries(fuelEntries);
    final priceSeries = fuelEntries
        .map((entry) => ConsumptionSample(entry.date, entry.pricePerLiter))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return VehicleStats(
      avgConsumption30d: avgConsumption30d,
      avgPricePerLiter: avgPrice,
      monthlyCost: monthlyCost,
      consumptionSeries: consumptionSeries,
      monthlyCosts: monthCosts,
      priceSeries: priceSeries,
    );
  }

  List<MonthBucket> _buildMonthlyCosts(
    List<FuelEntry> fuelEntries,
    List<CostEntry> costEntries,
  ) {
    final Map<String, double> bucketMap = {};
    for (final entry in fuelEntries) {
      final key = '${entry.date.year}-${entry.date.month}';
      bucketMap[key] = (bucketMap[key] ?? 0) + entry.totalCostEur;
    }
    for (final entry in costEntries) {
      final key = '${entry.date.year}-${entry.date.month}';
      bucketMap[key] = (bucketMap[key] ?? 0) + entry.amountEur;
    }
    final buckets = bucketMap.entries.map((entry) {
      final parts = entry.key.split('-');
      return MonthBucket(
        int.parse(parts[0]),
        int.parse(parts[1]),
        entry.value,
      );
    }).toList();
    buckets.sort((a, b) {
      if (a.year != b.year) return a.year.compareTo(b.year);
      return a.month.compareTo(b.month);
    });
    return buckets;
  }
}
