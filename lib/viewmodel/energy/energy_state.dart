import 'package:equatable/equatable.dart';
import '../../model/energy_log_model.dart';

enum EnergyStatus { initial, loading, loaded, error }

class EnergyState extends Equatable {
  final EnergyStatus status;
  final List<EnergyLog> logs;
  final String? errorMessage;

  const EnergyState({
    this.status = EnergyStatus.initial,
    this.logs = const [],
    this.errorMessage,
  });

  EnergyState copyWith({
    EnergyStatus? status,
    List<EnergyLog>? logs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EnergyState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, logs, errorMessage];
}
