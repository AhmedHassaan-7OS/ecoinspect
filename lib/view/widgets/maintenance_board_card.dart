import 'package:flutter/material.dart';

class MaintenanceBoardCard extends StatelessWidget {
  const MaintenanceBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Maintenance Board',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Schedule Maintenance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildColumn('Pending', const Color(0xFFD29922))),
              const SizedBox(width: 16),
              Expanded(
                child: _buildColumn('In Progress', const Color(0xFF58A6FF)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildColumn('Completed', const Color(0xFF3FB950)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, Color color) {
    final tasks = _getTasksForColumn(title);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tasks.length.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tasks.map((task) => _buildTaskCard(task, color)).toList(),
        ],
      ),
    );
  }

  List<Map<String, String>> _getTasksForColumn(String column) {
    switch (column) {
      case 'Pending':
        return [
          {
            'title': 'Mazak - Spindle Overhaul',
            'machine': 'MAZAK DT-200',
            'priority': 'High',
            'date': 'Jan 15',
          },
          {
            'title': 'Haas - Tool Calibration',
            'machine': 'Haas VF-2',
            'priority': 'Medium',
            'date': 'Jan 18',
          },
        ];
      case 'In Progress':
        return [
          {
            'title': 'Okuma - Oil Change',
            'machine': 'Okuma Genos',
            'priority': 'Medium',
            'date': 'Today',
          },
        ];
      case 'Completed':
        return [
          {
            'title': 'Brother - Software Update',
            'machine': 'Brother Speedio',
            'priority': 'Low',
            'date': 'Jan 12',
          },
          {
            'title': 'DMG - Coolant System',
            'machine': 'DMG Mori NLX',
            'priority': 'High',
            'date': 'Jan 10',
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildTaskCard(Map<String, String> task, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task['title']!,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task['priority']!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task['priority']!,
                  style: TextStyle(
                    color: _getPriorityColor(task['priority']!),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.precision_manufacturing,
                size: 14,
                color: Color(0xFF8B949E),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  task['machine']!,
                  style: const TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: Color(0xFF8B949E),
              ),
              const SizedBox(width: 4),
              Text(
                task['date']!,
                style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFDA3633);
      case 'Medium':
        return const Color(0xFFD29922);
      case 'Low':
        return const Color(0xFF58A6FF);
      default:
        return const Color(0xFF8B949E);
    }
  }
}
