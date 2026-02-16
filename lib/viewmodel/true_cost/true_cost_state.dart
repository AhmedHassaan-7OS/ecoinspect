import 'package:equatable/equatable.dart';
import '../../model/true_cost_model.dart';

enum TrueCostStatus { initial, loading, loaded, error }

class TrueCostState extends Equatable {
  final TrueCostStatus status;
  final List<TrueCost> costs;
  final String? errorMessage;

  const TrueCostState({
    this.status = TrueCostStatus.initial,
    this.costs = const [],
    this.errorMessage,
  });

  TrueCostState copyWith({
    TrueCostStatus? status,
    List<TrueCost>? costs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TrueCostState(
      status: status ?? this.status,
      costs: costs ?? this.costs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, costs, errorMessage];
}
