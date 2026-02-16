import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/cnc_machine_model.dart';
import 'cnc_state.dart';

class CncCubit extends Cubit<CncState> {
  final SupabaseClient _supabase;

  CncCubit(this._supabase) : super(const CncState());

  Future<void> loadMachines() async {
    emit(state.copyWith(status: CncStatus.loading, clearError: true));
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('cnc_machines')
          .select()
          .eq('owner_id', userId)
          .order('created_at', ascending: false);

      final machines = (response as List)
          .map((json) => CncMachine.fromJson(json))
          .toList();

      emit(state.copyWith(status: CncStatus.loaded, machines: machines));
    } catch (e) {
      emit(state.copyWith(status: CncStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> addMachine(CncMachine machine) async {
    emit(state.copyWith(status: CncStatus.loading, clearError: true));
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final data = machine.toJson();
      data['owner_id'] = userId;
      data.remove('id');
      data.remove('created_at');

      await _supabase.from('cnc_machines').insert(data);
      await loadMachines();
    } catch (e) {
      emit(state.copyWith(status: CncStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateMachine(CncMachine machine) async {
    emit(state.copyWith(status: CncStatus.loading, clearError: true));
    try {
      final data = machine.toJson();
      data.remove('created_at');
      data.remove('owner_id');

      await _supabase.from('cnc_machines').update(data).eq('id', machine.id);
      await loadMachines();
    } catch (e) {
      emit(state.copyWith(status: CncStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> deleteMachine(String machineId) async {
    emit(state.copyWith(status: CncStatus.loading, clearError: true));
    try {
      await _supabase.from('cnc_machines').delete().eq('id', machineId);
      await loadMachines();
    } catch (e) {
      emit(state.copyWith(status: CncStatus.error, errorMessage: e.toString()));
    }
  }
}
