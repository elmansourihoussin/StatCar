enum FuelType { e5, e10, diesel, superPlus, other }

class Vehicle {
  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.defaultFuelType,
    required this.distanceUnit,
    required this.notes,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final FuelType defaultFuelType;
  final String distanceUnit;
  final String notes;
  final DateTime createdAt;

  Vehicle copyWith({
    int? id,
    String? name,
    String? brand,
    String? model,
    int? year,
    FuelType? defaultFuelType,
    String? distanceUnit,
    String? notes,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      defaultFuelType: defaultFuelType ?? this.defaultFuelType,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'year': year,
      'defaultFuelType': defaultFuelType.name,
      'distanceUnit': distanceUnit,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Vehicle fromMap(Map<String, Object?> map) {
    return Vehicle(
      id: map['id'] as int,
      name: map['name'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      defaultFuelType:
          FuelType.values.byName(map['defaultFuelType'] as String),
      distanceUnit: map['distanceUnit'] as String,
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
