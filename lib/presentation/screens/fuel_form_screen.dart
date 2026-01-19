import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/localization.dart';
import '../../data/models/fuel_entry.dart';
import '../../data/models/vehicle.dart';
import '../providers.dart';

class FuelFormScreen extends ConsumerStatefulWidget {
  const FuelFormScreen({super.key, this.entry});

  final FuelEntry? entry;

  @override
  ConsumerState<FuelFormScreen> createState() => _FuelFormScreenState();
}

class _FuelFormScreenState extends ConsumerState<FuelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _litersController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _pricePerLiterController = TextEditingController();
  final _stationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  FuelType _fuelType = FuelType.e5;
  bool _fullTank = true;
  bool _missedFillUp = false;
  String? _receiptPath;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    if (entry != null) {
      _date = entry.date;
      _fuelType = entry.fuelType;
      _fullTank = entry.isFullTank;
      _missedFillUp = entry.missedFillUp;
      _receiptPath = entry.receiptImagePath;
      _odometerController.text = entry.odometerKm.toStringAsFixed(0);
      _litersController.text = entry.liters.toStringAsFixed(2);
      _totalCostController.text = entry.totalCostEur.toStringAsFixed(2);
      _pricePerLiterController.text = entry.pricePerLiter.toStringAsFixed(3);
      _stationController.text = entry.stationName;
      _notesController.text = entry.notes;
    }
    _litersController.addListener(_syncCosts);
    _totalCostController.addListener(_syncCosts);
    _pricePerLiterController.addListener(_syncCosts);
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _litersController.dispose();
    _totalCostController.dispose();
    _pricePerLiterController.dispose();
    _stationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _syncCosts() {
    final liters = double.tryParse(_litersController.text.replaceAll(',', '.'));
    final total = double.tryParse(_totalCostController.text.replaceAll(',', '.'));
    final price =
        double.tryParse(_pricePerLiterController.text.replaceAll(',', '.'));
    if (liters != null && total != null && price == null) {
      final calculated = total / liters;
      _pricePerLiterController.text = calculated.toStringAsFixed(3);
    } else if (liters != null && price != null && total == null) {
      final calculated = liters * price;
      _totalCostController.text = calculated.toStringAsFixed(2);
    }
  }

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _receiptPath = image.path);
  }

  Future<void> _duplicateLastEntry() async {
    final vehicleId = ref.read(activeVehicleIdProvider);
    if (vehicleId == null) return;
    final lastEntry =
        await ref.read(fuelRepositoryProvider).fetchLastForVehicle(vehicleId);
    if (lastEntry == null) return;
    setState(() {
      _stationController.text = lastEntry.stationName;
      _fuelType = lastEntry.fuelType;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vehicleId = ref.read(activeVehicleIdProvider);
    if (vehicleId == null) return;
    final entry = FuelEntry(
      id: widget.entry?.id ?? 0,
      vehicleId: vehicleId,
      date: _date,
      odometerKm: double.parse(_odometerController.text),
      liters: double.parse(_litersController.text.replaceAll(',', '.')),
      totalCostEur: double.parse(_totalCostController.text.replaceAll(',', '.')),
      pricePerLiter:
          double.parse(_pricePerLiterController.text.replaceAll(',', '.')),
      stationName: _stationController.text.trim(),
      fuelType: _fuelType,
      isFullTank: _fullTank,
      missedFillUp: _missedFillUp,
      notes: _notesController.text.trim(),
      receiptImagePath: _receiptPath,
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
    );
    final repo = ref.read(fuelRepositoryProvider);
    if (widget.entry == null) {
      await repo.insertFuelEntry(entry);
    } else {
      await repo.updateFuelEntry(entry);
    }
    ref.invalidate(fuelEntriesProvider(vehicleId));
    ref.invalidate(vehicleStatsProvider(vehicleId));
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? strings.addFuel : strings.edit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _duplicateLastEntry,
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(strings.duplicateLast),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(strings.date),
                  subtitle: Text(_date.toLocal().toString().split(' ').first),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _date = picked);
                    }
                  },
                ),
                TextFormField(
                  controller: _odometerController,
                  decoration: InputDecoration(labelText: strings.odometer),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) return 'Ungültig';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _litersController,
                  decoration: InputDecoration(labelText: strings.liters),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed =
                        double.tryParse(value?.replaceAll(',', '.') ?? '');
                    if (parsed == null || parsed <= 0) return 'Ungültig';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalCostController,
                  decoration: InputDecoration(labelText: strings.totalCost),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed =
                        double.tryParse(value?.replaceAll(',', '.') ?? '');
                    if (parsed == null || parsed <= 0) return 'Ungültig';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pricePerLiterController,
                  decoration: InputDecoration(labelText: strings.pricePerLiter),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _stationController,
                  decoration: InputDecoration(labelText: strings.station),
                ),
                DropdownButtonFormField<FuelType>(
                  value: _fuelType,
                  decoration: InputDecoration(labelText: strings.fuelType),
                  items: FuelType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _fuelType = value ?? FuelType.e5),
                ),
                SwitchListTile(
                  value: _fullTank,
                  onChanged: (value) => setState(() => _fullTank = value),
                  title: Text(strings.fullTank),
                ),
                SwitchListTile(
                  value: _missedFillUp,
                  onChanged: (value) => setState(() => _missedFillUp = value),
                  title: Text(strings.missedFillUp),
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: strings.notes),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(strings.receiptPhoto),
                  subtitle: Text(
                    _receiptPath ?? 'TODO: Optionaler Upload',
                  ),
                  trailing: const Icon(Icons.image_outlined),
                  onTap: _pickReceipt,
                ),
                if (_receiptPath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Image.file(
                      File(_receiptPath!),
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),
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
