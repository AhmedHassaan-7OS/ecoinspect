import 'package:equatable/equatable.dart';

class EnergyLog extends Equatable {
  final String id;
  final String cncId;
  final DateTime logDate;
  final double? operatingHours;
  final double? idleHours;
  final double? energyKwh;
  final double? co2EstimatedKg;
  final DateTime createdAt;

  const EnergyLog({
    required this.id,
    required this.cncId,
    required this.logDate,
    this.operatingHours,
    this.idleHours,
    this.energyKwh,
    this.co2EstimatedKg,
    required this.createdAt,
  });

  factory EnergyLog.fromJson(Map<String, dynamic> json) {
    return EnergyLog(
      id: json['id'] as String,
      cncId: json['cnc_id'] as String,
      logDate: DateTime.parse(json['log_date'] as String),
      operatingHours: json['operating_hours'] != null
          ? (json['operating_hours'] as num).toDouble()
          : null,
      idleHours: json['idle_hours'] != null
          ? (json['idle_hours'] as num).toDouble()
          : null,
      energyKwh: json['energy_kwh'] != null
          ? (json['energy_kwh'] as num).toDouble()
          : null,
      co2EstimatedKg: json['co2_estimated_kg'] != null
          ? (json['co2_estimated_kg'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnc_id': cncId,
      'log_date': logDate.toIso8601String().split('T')[0],
      'operating_hours': operatingHours,
      'idle_hours': idleHours,
      'energy_kwh': energyKwh,
      'co2_estimated_kg': co2EstimatedKg,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    cncId,
    logDate,
    operatingHours,
    idleHours,
    energyKwh,
    co2EstimatedKg,
    createdAt,
  ];
}
