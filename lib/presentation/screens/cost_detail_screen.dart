import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting.dart';
import '../../core/localization.dart';
import '../../data/models/cost_entry.dart';
import '../providers.dart';
import 'cost_form_screen.dart';

class CostDetailScreen extends ConsumerWidget {
  const CostDetailScreen({super.key, required this.entry});

  final CostEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.costs),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CostFormScreen(entry: entry),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref
                  .read(costRepositoryProvider)
                  .deleteCostEntry(entry.id);
              ref.invalidate(costEntriesProvider(entry.vehicleId));
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
          _DetailRow(label: strings.costCategory, value: entry.category.name),
          _DetailRow(
            label: strings.amount,
            value: Formatters.currency(entry.amountEur),
          ),
          if (entry.odometerKm != null)
            _DetailRow(
              label: strings.odometer,
              value: '${entry.odometerKm!.toStringAsFixed(0)} km',
            ),
          if (entry.vendor != null)
            _DetailRow(label: strings.vendor, value: entry.vendor!),
          if (entry.notes.isNotEmpty)
            _DetailRow(label: strings.notes, value: entry.notes),
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
