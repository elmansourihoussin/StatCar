import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import 'cost_detail_screen.dart';
import 'cost_form_screen.dart';

class CostListScreen extends ConsumerWidget {
  const CostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vehicleId = ref.watch(activeVehicleIdProvider);
    if (vehicleId == null) {
      return Center(child: Text(strings.noActiveVehicle));
    }
    final entriesAsync = ref.watch(costEntriesProvider(vehicleId));
    return Scaffold(
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return EmptyState(message: strings.emptyCosts);
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(
                  '${Formatters.date(entry.date)} • ${entry.category.name}',
                ),
                subtitle: Text(Formatters.currency(entry.amountEur)),
                trailing: entry.odometerKm == null
                    ? null
                    : Text('${entry.odometerKm!.toStringAsFixed(0)} km'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CostDetailScreen(entry: entry),
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
            MaterialPageRoute(builder: (_) => const CostFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
