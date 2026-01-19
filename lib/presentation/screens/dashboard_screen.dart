import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../providers.dart';
import '../widgets/kpi_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vehicleId = ref.watch(activeVehicleIdProvider);
    if (vehicleId == null) {
      return Center(child: Text(strings.noActiveVehicle));
    }
    final statsAsync = ref.watch(vehicleStatsProvider(vehicleId));
    return statsAsync.when(
      data: (stats) {
        final consumption = stats.avgConsumption30d;
        final avgConsumptionText = consumption == null
            ? '--'
            : '${Formatters.shortDecimal(consumption)} L/100km';
        final avgPrice = '${Formatters.shortDecimal(stats.avgPricePerLiter)} €';
        final monthlyCost = Formatters.currency(stats.monthlyCost);
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            KpiCard(title: strings.avgConsumption, value: avgConsumptionText),
            KpiCard(title: strings.avgPrice, value: avgPrice),
            KpiCard(title: strings.monthlyCost, value: monthlyCost),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: stats.consumptionSeries
                              .asMap()
                              .entries
                              .map(
                                (entry) => FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.value,
                                ),
                              )
                              .toList(),
                          isCurved: true,
                          dotData: const FlDotData(show: false),
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
