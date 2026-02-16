import 'package:equatable/equatable.dart';

class ProductionRun extends Equatable {
  final String id;
  final String cncId;
  final int producedParts;
  final DateTime runDate;

  const ProductionRun({
    required this.id,
    required this.cncId,
    required this.producedParts,
    required this.runDate,
  });

  factory ProductionRun.fromJson(Map<String, dynamic> json) {
    return ProductionRun(
      id: json['id'] as String,
      cncId: json['cnc_id'] as String,
      producedParts: json['produced_parts'] as int,
      runDate: DateTime.parse(json['run_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnc_id': cncId,
      'produced_parts': producedParts,
      'run_date': runDate.toIso8601String().split('T')[0],
    };
  }

  @override
  List<Object?> get props => [id, cncId, producedParts, runDate];
}
