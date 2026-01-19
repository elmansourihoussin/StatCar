import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization.dart';
import '../../data/models/cost_entry.dart';
import '../providers.dart';

class CostFormScreen extends ConsumerStatefulWidget {
  const CostFormScreen({super.key, this.entry});

  final CostEntry? entry;

  @override
  ConsumerState<CostFormScreen> createState() => _CostFormScreenState();
}

class _CostFormScreenState extends ConsumerState<CostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _odometerController = TextEditingController();
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  CostCategory _category = CostCategory.workshop;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    if (entry != null) {
      _date = entry.date;
      _category = entry.category;
      _amountController.text = entry.amountEur.toStringAsFixed(2);
      _odometerController.text =
          entry.odometerKm == null ? '' : entry.odometerKm!.toStringAsFixed(0);
      _vendorController.text = entry.vendor ?? '';
      _notesController.text = entry.notes;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _odometerController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vehicleId = ref.read(activeVehicleIdProvider);
    if (vehicleId == null) return;
    final entry = CostEntry(
      id: widget.entry?.id ?? 0,
      vehicleId: vehicleId,
      date: _date,
      category: _category,
      amountEur: double.parse(_amountController.text.replaceAll(',', '.')),
      odometerKm: _odometerController.text.isEmpty
          ? null
          : double.parse(_odometerController.text),
      vendor: _vendorController.text.isEmpty
          ? null
          : _vendorController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
    );
    final repo = ref.read(costRepositoryProvider);
    if (widget.entry == null) {
      await repo.insertCostEntry(entry);
    } else {
      await repo.updateCostEntry(entry);
    }
    ref.invalidate(costEntriesProvider(vehicleId));
    ref.invalidate(vehicleStatsProvider(vehicleId));
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? strings.addCost : strings.edit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                DropdownButtonFormField<CostCategory>(
                  value: _category,
                  decoration: InputDecoration(labelText: strings.costCategory),
                  items: CostCategory.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (value) => setState(
                    () => _category = value ?? CostCategory.workshop,
                  ),
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: strings.amount),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed =
                        double.tryParse(value?.replaceAll(',', '.') ?? '');
                    if (parsed == null || parsed <= 0) return 'Ungültig';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _odometerController,
                  decoration: InputDecoration(labelText: strings.odometer),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _vendorController,
                  decoration: InputDecoration(labelText: strings.vendor),
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
