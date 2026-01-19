import 'vehicle.dart';

class FuelEntry {
  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.odometerKm,
    required this.liters,
    required this.totalCostEur,
    required this.pricePerLiter,
    required this.stationName,
    required this.fuelType,
    required this.isFullTank,
    required this.missedFillUp,
    required this.notes,
    required this.receiptImagePath,
    required this.createdAt,
  });

  final int id;
  final int vehicleId;
  final DateTime date;
  final double odometerKm;
  final double liters;
  final double totalCostEur;
  final double pricePerLiter;
  final String stationName;
  final FuelType fuelType;
  final bool isFullTank;
  final bool missedFillUp;
  final String notes;
  final String? receiptImagePath;
  final DateTime createdAt;

  FuelEntry copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    double? odometerKm,
    double? liters,
    double? totalCostEur,
    double? pricePerLiter,
    String? stationName,
    FuelType? fuelType,
    bool? isFullTank,
    bool? missedFillUp,
    String? notes,
    String? receiptImagePath,
    DateTime? createdAt,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      odometerKm: odometerKm ?? this.odometerKm,
      liters: liters ?? this.liters,
      totalCostEur: totalCostEur ?? this.totalCostEur,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      stationName: stationName ?? this.stationName,
      fuelType: fuelType ?? this.fuelType,
      isFullTank: isFullTank ?? this.isFullTank,
      missedFillUp: missedFillUp ?? this.missedFillUp,
      notes: notes ?? this.notes,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'odometerKm': odometerKm,
      'liters': liters,
      'totalCostEur': totalCostEur,
      'pricePerLiter': pricePerLiter,
      'stationName': stationName,
      'fuelType': fuelType.name,
      'isFullTank': isFullTank ? 1 : 0,
      'missedFillUp': missedFillUp ? 1 : 0,
      'notes': notes,
      'receiptImagePath': receiptImagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static FuelEntry fromMap(Map<String, Object?> map) {
    return FuelEntry(
      id: map['id'] as int,
      vehicleId: map['vehicleId'] as int,
      date: DateTime.parse(map['date'] as String),
      odometerKm: (map['odometerKm'] as num).toDouble(),
      liters: (map['liters'] as num).toDouble(),
      totalCostEur: (map['totalCostEur'] as num).toDouble(),
      pricePerLiter: (map['pricePerLiter'] as num).toDouble(),
      stationName: map['stationName'] as String,
      fuelType: FuelType.values.byName(map['fuelType'] as String),
      isFullTank: (map['isFullTank'] as int) == 1,
      missedFillUp: (map['missedFillUp'] as int) == 1,
      notes: map['notes'] as String,
      receiptImagePath: map['receiptImagePath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
