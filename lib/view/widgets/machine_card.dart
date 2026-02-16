import 'package:flutter/material.dart';
import '../../model/cnc_machine_model.dart';

class MachineCard extends StatelessWidget {
  final CncMachine machine;
  final VoidCallback onTap;

  const MachineCard({super.key, required this.machine, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF161B22),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF30363D)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      size: 32,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        if (machine.model != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            machine.model!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF8B949E)),
                ],
              ),
              if (machine.manufacturer != null ||
                  machine.purchasePrice != null) ...[
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF30363D), height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (machine.manufacturer != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Manufacturer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B949E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              machine.manufacturer!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (machine.purchasePrice != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Purchase Price',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B949E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${machine.purchasePrice!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF3FB950),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
