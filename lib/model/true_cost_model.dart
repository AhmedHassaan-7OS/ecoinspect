import 'package:equatable/equatable.dart';

class TrueCost extends Equatable {
  final String cncId;
  final String name;
  final double? purchasePrice;
  final double totalEnergyKwh;
  final double estimatedEnergyCost;
  final double maintenanceCost;
  final double totalDowntimeHours;
  final double trueCost;

  const TrueCost({
    required this.cncId,
    required this.name,
    this.purchasePrice,
    required this.totalEnergyKwh,
    required this.estimatedEnergyCost,
    required this.maintenanceCost,
    required this.totalDowntimeHours,
    required this.trueCost,
  });

  factory TrueCost.fromJson(Map<String, dynamic> json) {
    return TrueCost(
      cncId: json['cnc_id'] as String,
      name: json['name'] as String,
      purchasePrice: json['purchase_price'] != null
          ? (json['purchase_price'] as num).toDouble()
          : null,
      totalEnergyKwh: (json['total_energy_kwh'] as num?)?.toDouble() ?? 0.0,
      estimatedEnergyCost:
          (json['estimated_energy_cost'] as num?)?.toDouble() ?? 0.0,
      maintenanceCost: (json['maintenance_cost'] as num?)?.toDouble() ?? 0.0,
      totalDowntimeHours:
          (json['total_downtime_hours'] as num?)?.toDouble() ?? 0.0,
      trueCost: (json['true_cost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
    cncId,
    name,
    purchasePrice,
    totalEnergyKwh,
    estimatedEnergyCost,
    maintenanceCost,
    totalDowntimeHours,
    trueCost,
  ];
}
