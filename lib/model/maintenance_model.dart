import 'package:equatable/equatable.dart';

enum MaintenanceType { preventive, corrective, software, hardware }

class Maintenance extends Equatable {
  final String id;
  final String cncId;
  final MaintenanceType maintenanceType;
  final double? cost;
  final double? downtimeHours;
  final String? notes;
  final DateTime performedAt;
  final String? technicianId;

  const Maintenance({
    required this.id,
    required this.cncId,
    required this.maintenanceType,
    this.cost,
    this.downtimeHours,
    this.notes,
    required this.performedAt,
    this.technicianId,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'] as String,
      cncId: json['cnc_id'] as String,
      maintenanceType: _parseMaintenanceType(
        json['maintenance_type'] as String,
      ),
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      downtimeHours: json['downtime_hours'] != null
          ? (json['downtime_hours'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      performedAt: DateTime.parse(json['performed_at'] as String),
      technicianId: json['technician_id'] as String?,
    );
  }

  static MaintenanceType _parseMaintenanceType(String type) {
    switch (type) {
      case 'preventive':
        return MaintenanceType.preventive;
      case 'corrective':
        return MaintenanceType.corrective;
      case 'software':
        return MaintenanceType.software;
      case 'hardware':
        return MaintenanceType.hardware;
      default:
        return MaintenanceType.preventive;
    }
  }

  String get maintenanceTypeString {
    switch (maintenanceType) {
      case MaintenanceType.preventive:
        return 'preventive';
      case MaintenanceType.corrective:
        return 'corrective';
      case MaintenanceType.software:
        return 'software';
      case MaintenanceType.hardware:
        return 'hardware';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnc_id': cncId,
      'maintenance_type': maintenanceTypeString,
      'cost': cost,
      'downtime_hours': downtimeHours,
      'notes': notes,
      'performed_at': performedAt.toIso8601String().split('T')[0],
      'technician_id': technicianId,
    };
  }

  @override
  List<Object?> get props => [
    id,
    cncId,
    maintenanceType,
    cost,
    downtimeHours,
    notes,
    performedAt,
    technicianId,
  ];
}
