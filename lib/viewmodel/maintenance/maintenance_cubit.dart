import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/maintenance_model.dart';
import 'maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {
  final SupabaseClient _supabase;

  MaintenanceCubit(this._supabase) : super(const MaintenanceState());

  Future<void> loadRecords(String cncId) async {
    emit(state.copyWith(status: MaintenanceStatus.loading, clearError: true));
    try {
      final response = await _supabase
          .from('cnc_maintenance')
          .select()
          .eq('cnc_id', cncId)
          .order('performed_at', ascending: false);

      final records = (response as List)
          .map((json) => Maintenance.fromJson(json))
          .toList();

      emit(state.copyWith(status: MaintenanceStatus.loaded, records: records));
    } catch (e) {
      emit(
        state.copyWith(
          status: MaintenanceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addRecord(Maintenance record) async {
    emit(state.copyWith(status: MaintenanceStatus.loading, clearError: true));
    try {
      final userId = _supabase.auth.currentUser?.id;
      final data = record.toJson();
      data.remove('id');
      data['technician_id'] = userId;

      await _supabase.from('cnc_maintenance').insert(data);
      await loadRecords(record.cncId);
    } catch (e) {
      emit(
        state.copyWith(
          status: MaintenanceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteRecord(String recordId, String cncId) async {
    emit(state.copyWith(status: MaintenanceStatus.loading, clearError: true));
    try {
      await _supabase.from('cnc_maintenance').delete().eq('id', recordId);
      await loadRecords(cncId);
    } catch (e) {
      emit(
        state.copyWith(
          status: MaintenanceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
