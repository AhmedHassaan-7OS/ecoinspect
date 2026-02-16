import 'package:equatable/equatable.dart';
import '../../model/maintenance_model.dart';

enum MaintenanceStatus { initial, loading, loaded, error }

class MaintenanceState extends Equatable {
  final MaintenanceStatus status;
  final List<Maintenance> records;
  final String? errorMessage;

  const MaintenanceState({
    this.status = MaintenanceStatus.initial,
    this.records = const [],
    this.errorMessage,
  });

  MaintenanceState copyWith({
    MaintenanceStatus? status,
    List<Maintenance>? records,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MaintenanceState(
      status: status ?? this.status,
      records: records ?? this.records,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, records, errorMessage];
}
