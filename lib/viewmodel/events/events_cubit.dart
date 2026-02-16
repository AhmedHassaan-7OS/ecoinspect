import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/cnc_event_model.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final SupabaseClient _supabase;

  EventsCubit(this._supabase) : super(const EventsState());

  Future<void> loadEvents(String cncId) async {
    emit(state.copyWith(status: EventsStatus.loading, clearError: true));
    try {
      final response = await _supabase
          .from('cnc_events')
          .select()
          .eq('cnc_id', cncId)
          .order('occurred_at', ascending: false);

      final events = (response as List)
          .map((json) => CncEvent.fromJson(json))
          .toList();

      emit(state.copyWith(status: EventsStatus.loaded, events: events));
    } catch (e) {
      emit(
        state.copyWith(status: EventsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addEvent(CncEvent event) async {
    emit(state.copyWith(status: EventsStatus.loading, clearError: true));
    try {
      final userId = _supabase.auth.currentUser?.id;
      final data = event.toJson();
      data.remove('id');
      data['reported_by'] = userId;

      await _supabase.from('cnc_events').insert(data);
      await loadEvents(event.cncId);
    } catch (e) {
      emit(
        state.copyWith(status: EventsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteEvent(String eventId, String cncId) async {
    emit(state.copyWith(status: EventsStatus.loading, clearError: true));
    try {
      await _supabase.from('cnc_events').delete().eq('id', eventId);
      await loadEvents(cncId);
    } catch (e) {
      emit(
        state.copyWith(status: EventsStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
