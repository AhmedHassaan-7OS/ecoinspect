import 'package:equatable/equatable.dart';
import '../../model/cnc_event_model.dart';

enum EventsStatus { initial, loading, loaded, error }

class EventsState extends Equatable {
  final EventsStatus status;
  final List<CncEvent> events;
  final String? errorMessage;

  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const [],
    this.errorMessage,
  });

  EventsState copyWith({
    EventsStatus? status,
    List<CncEvent>? events,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, events, errorMessage];
}
