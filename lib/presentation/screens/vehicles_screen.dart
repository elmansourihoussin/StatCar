import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization.dart';
import '../../data/models/vehicle.dart';
import '../providers.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vehiclesAsync = ref.watch(vehicleListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(strings.vehicles)),
      body: vehiclesAsync.when(
        data: (vehicles) => ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return ListTile(
              title: Text(vehicle.name),
              subtitle: Text('${vehicle.brand} ${vehicle.model}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await ref
                      .read(vehicleRepositoryProvider)
                      .deleteVehicle(vehicle.id);
                  ref.invalidate(vehicleListProvider);
                },
              ),
              onTap: () {
                ref.read(activeVehicleIdProvider.notifier).state = vehicle.id;
                Navigator.of(context).pop();
              },
              onLongPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehicleFormScreen(vehicle: vehicle),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();

  FuelType _fuelType = FuelType.e5;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    if (vehicle != null) {
      _nameController.text = vehicle.name;
      _brandController.text = vehicle.brand;
      _modelController.text = vehicle.model;
      _yearController.text = vehicle.year.toString();
      _notesController.text = vehicle.notes;
      _fuelType = vehicle.defaultFuelType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(vehicleRepositoryProvider);
    final vehicle = Vehicle(
      id: widget.vehicle?.id ?? 0,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      defaultFuelType: _fuelType,
      distanceUnit: 'km',
      notes: _notesController.text.trim(),
      createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
    );
    if (widget.vehicle == null) {
      await repo.insertVehicle(vehicle);
    } else {
      await repo.updateVehicle(vehicle);
    }
    ref.invalidate(vehicleListProvider);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? strings.createVehicle : strings.edit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: strings.vehicleName),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pflichtfeld' : null,
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: strings.brand),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pflichtfeld' : null,
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: strings.model),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pflichtfeld' : null,
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: strings.year),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Pflichtfeld';
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed < 1900) return 'Ungültig';
                    return null;
                  },
                ),
                DropdownButtonFormField<FuelType>(
                  value: _fuelType,
                  decoration: InputDecoration(labelText: strings.defaultFuel),
                  items: FuelType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _fuelType = value ?? FuelType.e5),
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: strings.notes),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _save,
                  child: Text(strings.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
