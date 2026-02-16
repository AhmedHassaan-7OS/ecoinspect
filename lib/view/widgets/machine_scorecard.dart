import 'package:flutter/material.dart';
import '../../model/cnc_machine_model.dart';

class MachineScorecard extends StatelessWidget {
  final List<CncMachine> machines;

  const MachineScorecard({super.key, required this.machines});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Machine Performance Scorecard',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (machines.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.analytics_outlined,
                    size: 80,
                    color: Color(0xFF8B949E),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No machine data available',
                    style: TextStyle(color: Color(0xFF8B949E), fontSize: 16),
                  ),
                ],
              ),
            )
          else
            ...machines.map((machine) => _buildMachineCard(machine)).toList(),
        ],
      ),
    );
  }

  Widget _buildMachineCard(CncMachine machine) {
    // Generate random scores for demonstration
    final efficiency = 85 + (machine.name.hashCode % 15);
    final uptime = 90 + (machine.name.hashCode % 10);
    final quality = 92 + (machine.name.hashCode % 8);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.precision_manufacturing,
                  color: Color(0xFF58A6FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      machine.name,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (machine.model != null)
                      Text(
                        machine.model!,
                        style: const TextStyle(
                          color: Color(0xFF8B949E),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getScoreColor(efficiency).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$efficiency%',
                  style: TextStyle(
                    color: _getScoreColor(efficiency),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildMetric('Efficiency', efficiency, '%')),
              Expanded(child: _buildMetric('Uptime', uptime, '%')),
              Expanded(child: _buildMetric('Quality', quality, '%')),
              Expanded(child: _buildMetric('Output', 1240, ' pcs')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, int value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 2),
                    child: Text(
                      unit,
                      style: const TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: const Color(0xFF0D1117),
          valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(value)),
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return const Color(0xFF3FB950);
    if (score >= 75) return const Color(0xFF58A6FF);
    if (score >= 60) return const Color(0xFFD29922);
    return const Color(0xFFDA3633);
  }
}
