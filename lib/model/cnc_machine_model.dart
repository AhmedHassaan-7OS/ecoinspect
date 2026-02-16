import 'package:equatable/equatable.dart';

class CncMachine extends Equatable {
  final String id;
  final String name;
  final String? model;
  final String? manufacturer;
  final String? countryOfOrigin;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final int? expectedLifetimeYears;
  final String ownerId;
  final DateTime createdAt;

  const CncMachine({
    required this.id,
    required this.name,
    this.model,
    this.manufacturer,
    this.countryOfOrigin,
    this.purchaseDate,
    this.purchasePrice,
    this.expectedLifetimeYears,
    required this.ownerId,
    required this.createdAt,
  });

  factory CncMachine.fromJson(Map<String, dynamic> json) {
    return CncMachine(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String?,
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      purchasePrice: json['purchase_price'] != null
          ? (json['purchase_price'] as num).toDouble()
          : null,
      expectedLifetimeYears: json['expected_lifetime_years'] as int?,
      ownerId: json['owner_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'manufacturer': manufacturer,
      'country_of_origin': countryOfOrigin,
      'purchase_date': purchaseDate?.toIso8601String().split('T')[0],
      'purchase_price': purchasePrice,
      'expected_lifetime_years': expectedLifetimeYears,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CncMachine copyWith({
    String? id,
    String? name,
    String? model,
    String? manufacturer,
    String? countryOfOrigin,
    DateTime? purchaseDate,
    double? purchasePrice,
    int? expectedLifetimeYears,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return CncMachine(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      manufacturer: manufacturer ?? this.manufacturer,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      expectedLifetimeYears:
          expectedLifetimeYears ?? this.expectedLifetimeYears,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    model,
    manufacturer,
    countryOfOrigin,
    purchaseDate,
    purchasePrice,
    expectedLifetimeYears,
    ownerId,
    createdAt,
  ];
}
