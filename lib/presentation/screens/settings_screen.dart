import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/localization.dart';
import '../../data/export_csv.dart';
import '../providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportCsv(WidgetRef ref, int vehicleId) async {
    final fuelEntries = await ref.read(fuelEntriesProvider(vehicleId).future);
    final costEntries = await ref.read(costEntriesProvider(vehicleId).future);
    final fuelCsv = buildFuelCsv(fuelEntries);
    final costCsv = buildCostCsv(costEntries);
    await Share.share(
      '---fuel_entries.csv---\n$fuelCsv\n\n---cost_entries.csv---\n$costCsv',
      subject: 'StatCar Export',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vehicleId = ref.watch(activeVehicleIdProvider);
    return ListView(
      children: [
        ListTile(
          title: Text(strings.language),
          subtitle: const Text('Deutsch / English'),
          trailing: DropdownButton<Locale>(
            value: ref.watch(localeProvider) ?? const Locale('de'),
            items: const [
              DropdownMenuItem(value: Locale('de'), child: Text('Deutsch')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
            onChanged: (value) {
              ref.read(localeProvider.notifier).state = value;
            },
          ),
        ),
        ListTile(
          title: Text(strings.exportCsv),
          subtitle: const Text('Fuel + costs'),
          onTap: vehicleId == null ? null : () => _exportCsv(ref, vehicleId),
        ),
        ListTile(
          title: Text(strings.importCsv),
          subtitle: const Text('TODO'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CSV-Import TODO')),
            );
          },
        ),
      ],
    );
  }
}
