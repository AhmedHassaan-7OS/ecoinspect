import 'package:flutter/material.dart';

enum _EventFilter { all, errors, toolChange, maintenance }

class EventLogCard extends StatefulWidget {
  const EventLogCard({super.key});

  @override
  State<EventLogCard> createState() => _EventLogCardState();
}

class _EventLogCardState extends State<EventLogCard> {
  _EventFilter _selectedFilter = _EventFilter.all;

  List<Map<String, String>> _allEvents() {
    return [
      {
        'time': '10:23 AM',
        'machine': 'Haas VF-2',
        'type': 'Tool Change',
        'severity': 'Low',
        'desc': 'Tool #5 replaced',
      },
      {
        'time': '09:45 AM',
        'machine': 'MAZAK DT-200',
        'type': 'Error',
        'severity': 'High',
        'desc': 'Spindle overload detected',
      },
      {
        'time': '09:12 AM',
        'machine': 'Brother Speedio',
        'type': 'Cycle Started',
        'severity': 'Info',
        'desc': 'Production run initiated',
      },
      {
        'time': '08:30 AM',
        'machine': 'Haas VF-2',
        'type': 'Maintenance',
        'severity': 'Medium',
        'desc': 'Scheduled lubrication',
      },
      {
        'time': '07:55 AM',
        'machine': 'DMG Mori NLX',
        'type': 'Alarm',
        'severity': 'Critical',
        'desc': 'Emergency stop activated',
      },
      {
        'time': '07:20 AM',
        'machine': 'Okuma Genos',
        'type': 'Tool Change',
        'severity': 'Low',
        'desc': 'Tool #12 replaced',
      },
      {
        'time': '06:45 AM',
        'machine': 'Haas VF-2',
        'type': 'Cycle Completed',
        'severity': 'Info',
        'desc': 'Part #1234 finished',
      },
      {
        'time': '06:15 AM',
        'machine': 'MAZAK VCN-530C',
        'type': 'Error',
        'severity': 'Medium',
        'desc': 'Coolant level low',
      },
    ];
  }

  List<Map<String, String>> _filteredEvents() {
    final events = _allEvents();

    switch (_selectedFilter) {
      case _EventFilter.all:
        return events;
      case _EventFilter.errors:
        return events.where((e) => e['type'] == 'Error').toList();
      case _EventFilter.toolChange:
        return events.where((e) => e['type'] == 'Tool Change').toList();
      case _EventFilter.maintenance:
        return events.where((e) => e['type'] == 'Maintenance').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Log',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          isSelected: _selectedFilter == _EventFilter.all,
                          onTap: () {
                            setState(() => _selectedFilter = _EventFilter.all);
                          },
                        ),
                        _buildFilterChip(
                          label: 'Errors',
                          isSelected: _selectedFilter == _EventFilter.errors,
                          onTap: () {
                            setState(
                              () => _selectedFilter = _EventFilter.errors,
                            );
                          },
                        ),
                        _buildFilterChip(
                          label: 'Tool Change',
                          isSelected: _selectedFilter == _EventFilter.toolChange,
                          onTap: () {
                            setState(
                              () => _selectedFilter = _EventFilter.toolChange,
                            );
                          },
                        ),
                        _buildFilterChip(
                          label: 'Maintenance',
                          isSelected: _selectedFilter == _EventFilter.maintenance,
                          onTap: () {
                            setState(
                              () => _selectedFilter = _EventFilter.maintenance,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  const Text(
                    'Event Log',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildFilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == _EventFilter.all,
                    onTap: () {
                      setState(() => _selectedFilter = _EventFilter.all);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Errors',
                    isSelected: _selectedFilter == _EventFilter.errors,
                    onTap: () {
                      setState(() => _selectedFilter = _EventFilter.errors);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Tool Change',
                    isSelected: _selectedFilter == _EventFilter.toolChange,
                    onTap: () {
                      setState(
                        () => _selectedFilter = _EventFilter.toolChange,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Maintenance',
                    isSelected: _selectedFilter == _EventFilter.maintenance,
                    onTap: () {
                      setState(
                        () => _selectedFilter = _EventFilter.maintenance,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: Column(
              children: [
                _buildEventHeader(),
                ...events.map(_buildEventRow).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF58A6FF) : const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF58A6FF) : const Color(0xFF30363D),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B949E),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF30363D))),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Time', flex: 1),
          _buildHeaderCell('Machine', flex: 2),
          _buildHeaderCell('Event Type', flex: 2),
          _buildHeaderCell('Severity', flex: 1),
          _buildHeaderCell('Description', flex: 3),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF8B949E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEventRow(Map<String, String> event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF30363D))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              event['time']!,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event['machine']!,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  _getEventIcon(event['type']!),
                  size: 16,
                  color: const Color(0xFF58A6FF),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event['type']!,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getSeverityColor(event['severity']!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event['severity']!,
                style: TextStyle(
                  color: _getSeverityColor(event['severity']!),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              event['desc']!,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Error':
        return Icons.error_outline;
      case 'Tool Change':
        return Icons.build_outlined;
      case 'Maintenance':
        return Icons.settings_outlined;
      case 'Alarm':
        return Icons.warning_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return const Color(0xFFDA3633);
      case 'High':
        return const Color(0xFFFF6B6B);
      case 'Medium':
        return const Color(0xFFD29922);
      case 'Low':
        return const Color(0xFF58A6FF);
      default:
        return const Color(0xFF8B949E);
    }
  }
}
