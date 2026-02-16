import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/energy_log_model.dart';
import 'energy_state.dart';

class EnergyCubit extends Cubit<EnergyState> {
  final SupabaseClient _supabase;

  EnergyCubit(this._supabase) : super(const EnergyState());

  Future<void> loadLogs(String cncId) async {
    emit(state.copyWith(status: EnergyStatus.loading, clearError: true));
    try {
      final response = await _supabase
          .from('cnc_energy_logs')
          .select()
          .eq('cnc_id', cncId)
          .order('log_date', ascending: false);

      final logs = (response as List)
          .map((json) => EnergyLog.fromJson(json))
          .toList();

      emit(state.copyWith(status: EnergyStatus.loaded, logs: logs));
    } catch (e) {
      emit(
        state.copyWith(status: EnergyStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addLog(EnergyLog log) async {
    emit(state.copyWith(status: EnergyStatus.loading, clearError: true));
    try {
      final data = log.toJson();
      data.remove('id');
      data.remove('created_at');

      await _supabase.from('cnc_energy_logs').insert(data);
      await loadLogs(log.cncId);
    } catch (e) {
      emit(
        state.copyWith(status: EnergyStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteLog(String logId, String cncId) async {
    emit(state.copyWith(status: EnergyStatus.loading, clearError: true));
    try {
      await _supabase.from('cnc_energy_logs').delete().eq('id', logId);
      await loadLogs(cncId);
    } catch (e) {
      emit(
        state.copyWith(status: EnergyStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
