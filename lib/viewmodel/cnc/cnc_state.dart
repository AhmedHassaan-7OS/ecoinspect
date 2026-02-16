import 'package:equatable/equatable.dart';
import '../../model/cnc_machine_model.dart';

enum CncStatus { initial, loading, loaded, error }

class CncState extends Equatable {
  final CncStatus status;
  final List<CncMachine> machines;
  final String? errorMessage;

  const CncState({
    this.status = CncStatus.initial,
    this.machines = const [],
    this.errorMessage,
  });

  CncState copyWith({
    CncStatus? status,
    List<CncMachine>? machines,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CncState(
      status: status ?? this.status,
      machines: machines ?? this.machines,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, machines, errorMessage];
}
