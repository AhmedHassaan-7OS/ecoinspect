import 'package:equatable/equatable.dart';

enum EventType { error, alarm, toolChange, crash, softwareIssue }

enum EventSeverity { low, medium, high, critical }

class CncEvent extends Equatable {
  final String id;
  final String cncId;
  final EventType eventType;
  final EventSeverity severity;
  final String? description;
  final DateTime occurredAt;
  final String? reportedBy;

  const CncEvent({
    required this.id,
    required this.cncId,
    required this.eventType,
    required this.severity,
    this.description,
    required this.occurredAt,
    this.reportedBy,
  });

  factory CncEvent.fromJson(Map<String, dynamic> json) {
    return CncEvent(
      id: json['id'] as String,
      cncId: json['cnc_id'] as String,
      eventType: _parseEventType(json['event_type'] as String),
      severity: _parseSeverity(json['severity'] as String),
      description: json['description'] as String?,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      reportedBy: json['reported_by'] as String?,
    );
  }

  static EventType _parseEventType(String type) {
    switch (type) {
      case 'error':
        return EventType.error;
      case 'alarm':
        return EventType.alarm;
      case 'tool_change':
        return EventType.toolChange;
      case 'crash':
        return EventType.crash;
      case 'software_issue':
        return EventType.softwareIssue;
      default:
        return EventType.error;
    }
  }

  static EventSeverity _parseSeverity(String severity) {
    switch (severity) {
      case 'low':
        return EventSeverity.low;
      case 'medium':
        return EventSeverity.medium;
      case 'high':
        return EventSeverity.high;
      case 'critical':
        return EventSeverity.critical;
      default:
        return EventSeverity.low;
    }
  }

  String get eventTypeString {
    switch (eventType) {
      case EventType.error:
        return 'error';
      case EventType.alarm:
        return 'alarm';
      case EventType.toolChange:
        return 'tool_change';
      case EventType.crash:
        return 'crash';
      case EventType.softwareIssue:
        return 'software_issue';
    }
  }

  String get severityString {
    switch (severity) {
      case EventSeverity.low:
        return 'low';
      case EventSeverity.medium:
        return 'medium';
      case EventSeverity.high:
        return 'high';
      case EventSeverity.critical:
        return 'critical';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnc_id': cncId,
      'event_type': eventTypeString,
      'severity': severityString,
      'description': description,
      'occurred_at': occurredAt.toIso8601String(),
      'reported_by': reportedBy,
    };
  }

  @override
  List<Object?> get props => [
    id,
    cncId,
    eventType,
    severity,
    description,
    occurredAt,
    reportedBy,
  ];
}
