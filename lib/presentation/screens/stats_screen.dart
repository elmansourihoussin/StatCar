import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../providers.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

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
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(strings.stats, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _ChartCard(
              title: 'Verbrauch (L/100km)',
              chart: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: stats.consumptionSeries
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.value,
                              ))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            _ChartCard(
              title: 'Preis/Liter',
              chart: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: stats.priceSeries
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.value,
                              ))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.secondary,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            _ChartCard(
              title: 'Monatliche Kosten',
              chart: BarChart(
                BarChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: stats.monthlyCosts
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.amount,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              subtitle: stats.monthlyCosts.isEmpty
                  ? 'Noch keine Daten'
                  : Formatters.currency(stats.monthlyCosts.last.amount),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.chart, this.subtitle});

  final String title;
  final Widget chart;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            SizedBox(height: 180, child: chart),
          ],
        ),
      ),
    );
  }
}
