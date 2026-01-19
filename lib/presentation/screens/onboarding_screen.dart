import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization.dart';
import '../../data/models/vehicle.dart';
import '../providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  FuelType _fuelType = FuelType.e5;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(vehicleRepositoryProvider);
    final vehicle = Vehicle(
      id: 0,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      defaultFuelType: _fuelType,
      distanceUnit: 'km',
      notes: '',
      createdAt: DateTime.now(),
    );
    await repo.insertVehicle(vehicle);
    ref.invalidate(vehicleListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.onboardingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(strings.onboardingSubtitle),
              const SizedBox(height: 16),
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
                  final year = int.tryParse(value);
                  if (year == null || year < 1900) return 'Ungültig';
                  return null;
                },
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(strings.createVehicle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
