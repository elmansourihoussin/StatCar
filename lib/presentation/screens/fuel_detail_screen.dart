import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../../data/models/fuel_entry.dart';
import '../providers.dart';
import 'fuel_form_screen.dart';

class FuelDetailScreen extends ConsumerWidget {
  const FuelDetailScreen({super.key, required this.entry});

  final FuelEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.fuel),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FuelFormScreen(entry: entry),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref
                  .read(fuelRepositoryProvider)
                  .deleteFuelEntry(entry.id);
              ref.invalidate(fuelEntriesProvider(entry.vehicleId));
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(Formatters.date(entry.date),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _DetailRow(label: strings.station, value: entry.stationName),
          _DetailRow(
            label: strings.liters,
            value: '${entry.liters.toStringAsFixed(2)} L',
          ),
          _DetailRow(
            label: strings.pricePerLiter,
            value: '${Formatters.shortDecimal(entry.pricePerLiter)} €/L',
          ),
          _DetailRow(
            label: strings.totalCost,
            value: Formatters.currency(entry.totalCostEur),
          ),
          _DetailRow(
            label: strings.odometer,
            value: '${entry.odometerKm.toStringAsFixed(0)} km',
          ),
          _DetailRow(label: strings.fuelType, value: entry.fuelType.name),
          _DetailRow(
            label: strings.fullTank,
            value: entry.isFullTank ? 'Ja' : 'Nein',
          ),
          _DetailRow(
            label: strings.missedFillUp,
            value: entry.missedFillUp ? 'Ja' : 'Nein',
          ),
          if (entry.notes.isNotEmpty)
            _DetailRow(label: strings.notes, value: entry.notes),
          if (entry.receiptImagePath != null)
            _DetailRow(
              label: strings.receiptPhoto,
              value: entry.receiptImagePath!,
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
