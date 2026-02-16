import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/true_cost_model.dart';
import 'true_cost_state.dart';

class TrueCostCubit extends Cubit<TrueCostState> {
  final SupabaseClient _supabase;

  TrueCostCubit(this._supabase) : super(const TrueCostState());

  Future<void> loadCosts() async {
    emit(state.copyWith(status: TrueCostStatus.loading, clearError: true));
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Query the view and filter by owner
      final response = await _supabase
          .from('cnc_true_cost')
          .select('*, cnc_machines!inner(owner_id)')
          .eq('cnc_machines.owner_id', userId);

      final costs = (response as List)
          .map((json) => TrueCost.fromJson(json))
          .toList();

      emit(state.copyWith(status: TrueCostStatus.loaded, costs: costs));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrueCostStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
