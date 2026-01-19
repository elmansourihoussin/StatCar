enum CostCategory {
  fuel,
  insurance,
  tax,
  inspection,
  workshop,
  tires,
  parking,
  toll,
  wash,
  repairs,
  accessories,
  other,
}

class CostEntry {
  const CostEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.category,
    required this.amountEur,
    required this.odometerKm,
    required this.vendor,
    required this.notes,
    required this.createdAt,
  });

  final int id;
  final int vehicleId;
  final DateTime date;
  final CostCategory category;
  final double amountEur;
  final double? odometerKm;
  final String? vendor;
  final String notes;
  final DateTime createdAt;

  CostEntry copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    CostCategory? category,
    double? amountEur,
    double? odometerKm,
    String? vendor,
    String? notes,
    DateTime? createdAt,
  }) {
    return CostEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      category: category ?? this.category,
      amountEur: amountEur ?? this.amountEur,
      odometerKm: odometerKm ?? this.odometerKm,
      vendor: vendor ?? this.vendor,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'category': category.name,
      'amountEur': amountEur,
      'odometerKm': odometerKm,
      'vendor': vendor,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static CostEntry fromMap(Map<String, Object?> map) {
    return CostEntry(
      id: map['id'] as int,
      vehicleId: map['vehicleId'] as int,
      date: DateTime.parse(map['date'] as String),
      category: CostCategory.values.byName(map['category'] as String),
      amountEur: (map['amountEur'] as num).toDouble(),
      odometerKm: map['odometerKm'] == null
          ? null
          : (map['odometerKm'] as num).toDouble(),
      vendor: map['vendor'] as String?,
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
