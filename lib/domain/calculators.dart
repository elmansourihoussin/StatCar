import '../data/models/cost_entry.dart';
import '../data/models/fuel_entry.dart';

class ConsumptionSample {
  const ConsumptionSample(this.date, this.value);

  final DateTime date;
  final double value;
}

double? calculateConsumptionLPer100({
  required FuelEntry previous,
  required FuelEntry current,
}) {
  if (!previous.isFullTank ||
      !current.isFullTank ||
      previous.missedFillUp ||
      current.missedFillUp) {
    return null;
  }
  final kmDiff = current.odometerKm - previous.odometerKm;
  if (kmDiff <= 0) return null;
  return current.liters / (kmDiff / 100);
}

List<ConsumptionSample> buildConsumptionSeries(List<FuelEntry> entries) {
  final samples = <ConsumptionSample>[];
  for (var i = 1; i < entries.length; i++) {
    final previous = entries[i];
    final current = entries[i - 1];
    final value = calculateConsumptionLPer100(
      previous: previous,
      current: current,
    );
    if (value != null) {
      samples.add(ConsumptionSample(current.date, value));
    }
  }
  return samples.reversed.toList();
}

double? averageConsumptionLastDays(
  List<FuelEntry> entries,
  int days,
) {
  final cutoff = DateTime.now().subtract(Duration(days: days));
  final filtered = entries
      .where((entry) => entry.date.isAfter(cutoff))
      .toList(growable: false);
  final samples = buildConsumptionSeries(filtered);
  if (samples.isEmpty) return null;
  final sum = samples.fold<double>(0, (prev, s) => prev + s.value);
  return sum / samples.length;
}

double averagePricePerLiter(List<FuelEntry> entries) {
  if (entries.isEmpty) return 0;
  final sum = entries.fold<double>(0, (prev, entry) => prev + entry.pricePerLiter);
  return sum / entries.length;
}

double totalFuelCost(List<FuelEntry> entries) {
  return entries.fold<double>(0, (prev, entry) => prev + entry.totalCostEur);
}

double totalCostEntries(List<CostEntry> entries) {
  return entries.fold<double>(0, (prev, entry) => prev + entry.amountEur);
}
