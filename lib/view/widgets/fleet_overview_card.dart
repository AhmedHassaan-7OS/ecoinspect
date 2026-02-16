import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../model/cnc_machine_model.dart';

class FleetOverviewCard extends StatelessWidget {
  final List<CncMachine> machines;

  const FleetOverviewCard({super.key, required this.machines});

  @override
  Widget build(BuildContext context) {
    final totalMachines = machines.length;
    final activeMachines = machines.length; // All are active for now
    final totalValue = machines.fold<double>(
      0,
      (sum, machine) => sum + (machine.purchasePrice ?? 0),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards Row - responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final statCards = [
                _buildStatCard(
                  'Total Machines',
                  totalMachines.toString(),
                  Icons.precision_manufacturing,
                  const Color(0xFF58A6FF),
                ),
                _buildStatCard(
                  'Active Now',
                  activeMachines.toString(),
                  Icons.check_circle,
                  const Color(0xFF3FB950),
                ),
                _buildStatCard(
                  'Fleet Value',
                  '\$${(totalValue / 1000).toStringAsFixed(1)}k',
                  Icons.attach_money,
                  const Color(0xFFD29922),
                ),
                _buildStatCard(
                  'Efficiency',
                  '94.6%',
                  Icons.trending_up,
                  const Color(0xFF58A6FF),
                ),
              ];

              if (isMobile) {
                // 2x2 Grid for mobile
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15, // Adjusted for better fit
                  children: statCards,
                );
              } else {
                return Row(
                  children:
                      statCards
                          .map(
                            (card) => Expanded(child: card),
                          ) // Wrap in Expanded here for Row
                          .expand((card) => [card, const SizedBox(width: 16)])
                          .toList()
                        ..removeLast(),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          // Chart Section
          Container(
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobileHeader = constraints.maxWidth < 400;
                    if (isMobileHeader) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fleet Performance',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildChartLegend(
                                'Production',
                                const Color(0xFF58A6FF),
                              ),
                              const SizedBox(width: 16),
                              _buildChartLegend(
                                'Downtime',
                                const Color(0xFFDA3633),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Fleet Performance',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _buildChartLegend(
                                'Production',
                                const Color(0xFF58A6FF),
                              ),
                              const SizedBox(width: 16),
                              _buildChartLegend(
                                'Downtime',
                                const Color(0xFFDA3633),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxBarHeight = math.max(0.0, constraints.maxHeight - 28);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(12, (index) {
                            final rawHeight = 50 + (index * 15) % 150;
                            final height = math.min(rawHeight.toDouble(), maxBarHeight);
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ), // Constant spacing
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 40,
                                    height: height,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          const Color(0xFF58A6FF),
                                          const Color(0xFF58A6FF).withOpacity(0.3),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Color(0xFF8B949E),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Recent Activity - responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              if (isMobile) {
                return Column(
                  children: [
                    _buildRecentActivity(),
                    const SizedBox(height: 16),
                    _buildQuickStats(),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRecentActivity()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildQuickStats()),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    // Removed Expanded from here - it must be applied by the parent if needed (e.g. in a Row)
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight > 0 && constraints.maxHeight < 90;
          final iconBoxPadding = compact ? 6.0 : 8.0;
          final iconSize = compact ? 18.0 : 20.0;
          final valueFontSize = compact ? 20.0 : 24.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(iconBoxPadding),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_vert,
                    color: Color(0xFF8B949E),
                    size: 18,
                  ),
                ],
              ),
              SizedBox(height: compact ? 8 : 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3FB950),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Machine ${index + 1} completed production run',
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${index + 1} hours ago',
                          style: const TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickStatItem('Uptime', '98.5%', const Color(0xFF3FB950)),
          _buildQuickStatItem('Energy Usage', '12.4t', const Color(0xFF58A6FF)),
          _buildQuickStatItem('Maintenance Due', '3', const Color(0xFFD29922)),
          _buildQuickStatItem('Alerts', '0', const Color(0xFF3FB950)),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
