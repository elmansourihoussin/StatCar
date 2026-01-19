import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../../data/models/fuel_entry.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import 'fuel_detail_screen.dart';
import 'fuel_form_screen.dart';

class FuelListScreen extends ConsumerWidget {
  const FuelListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vehicleId = ref.watch(activeVehicleIdProvider);
    if (vehicleId == null) {
      return Center(child: Text(strings.noActiveVehicle));
    }
    final entriesAsync = ref.watch(fuelEntriesProvider(vehicleId));
    return Scaffold(
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return EmptyState(message: strings.emptyFuel);
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(
                  '${Formatters.date(entry.date)} • ${entry.liters.toStringAsFixed(1)} L',
                ),
                subtitle: Text(
                  '${Formatters.shortDecimal(entry.pricePerLiter)} €/L • ${Formatters.currency(entry.totalCostEur)}',
                ),
                trailing: Text('${entry.odometerKm.toStringAsFixed(0)} km'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FuelDetailScreen(entry: entry),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FuelFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension FuelEntryFormatting on FuelEntry {
  String get fuelLabel => fuelType.name.toUpperCase();
}
