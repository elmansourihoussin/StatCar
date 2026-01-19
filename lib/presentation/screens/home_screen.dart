import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization.dart';
import '../providers.dart';
import 'cost_list_screen.dart';
import 'dashboard_screen.dart';
import 'fuel_list_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'vehicles_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final activeVehicleId = ref.watch(activeVehicleIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_car_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VehiclesScreen()),
              );
            },
          ),
        ],
      ),
      body: activeVehicleId == null
          ? Center(child: Text(strings.noActiveVehicle))
          : IndexedStack(
              index: _index,
              children: const [
                DashboardScreen(),
                FuelListScreen(),
                CostListScreen(),
                StatsScreen(),
                SettingsScreen(),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: strings.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_gas_station_outlined),
            label: strings.fuel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            label: strings.costs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_graph_outlined),
            label: strings.stats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: strings.settings,
          ),
        ],
      ),
    );
  }
}
