import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/cnc_machine_model.dart';
import '../../viewmodel/energy/energy_cubit.dart';
import '../../viewmodel/events/events_cubit.dart';
import '../../viewmodel/maintenance/maintenance_cubit.dart';

class MachineDetailsScreen extends StatefulWidget {
  final CncMachine machine;

  const MachineDetailsScreen({super.key, required this.machine});

  @override
  State<MachineDetailsScreen> createState() => _MachineDetailsScreenState();
}

class _MachineDetailsScreenState extends State<MachineDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Load data for each tab
    context.read<EnergyCubit>().loadLogs(widget.machine.id);
    context.read<EventsCubit>().loadEvents(widget.machine.id);
    context.read<MaintenanceCubit>().loadRecords(widget.machine.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: Text(
          widget.machine.name,
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF58A6FF),
          labelColor: const Color(0xFF58A6FF),
          unselectedLabelColor: const Color(0xFF8B949E),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Energy'),
            Tab(text: 'Events'),
            Tab(text: 'Maintenance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildEnergyTab(),
          _buildEventsTab(),
          _buildMaintenanceTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Machine Information', [
            if (widget.machine.model != null)
              _buildInfoRow('Model', widget.machine.model!),
            if (widget.machine.manufacturer != null)
              _buildInfoRow('Manufacturer', widget.machine.manufacturer!),
            if (widget.machine.countryOfOrigin != null)
              _buildInfoRow('Country', widget.machine.countryOfOrigin!),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Purchase Information', [
            if (widget.machine.purchaseDate != null)
              _buildInfoRow(
                'Purchase Date',
                '${widget.machine.purchaseDate!.year}-${widget.machine.purchaseDate!.month.toString().padLeft(2, '0')}-${widget.machine.purchaseDate!.day.toString().padLeft(2, '0')}',
              ),
            if (widget.machine.purchasePrice != null)
              _buildInfoRow(
                'Purchase Price',
                '\$${widget.machine.purchasePrice!.toStringAsFixed(2)}',
              ),
            if (widget.machine.expectedLifetimeYears != null)
              _buildInfoRow(
                'Expected Lifetime',
                '${widget.machine.expectedLifetimeYears} years',
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEnergyTab() {
    return const Center(
      child: Text(
        'Energy logs will be displayed here',
        style: TextStyle(color: Color(0xFF8B949E)),
      ),
    );
  }

  Widget _buildEventsTab() {
    return const Center(
      child: Text(
        'Events will be displayed here',
        style: TextStyle(color: Color(0xFF8B949E)),
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    return const Center(
      child: Text(
        'Maintenance records will be displayed here',
        style: TextStyle(color: Color(0xFF8B949E)),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
