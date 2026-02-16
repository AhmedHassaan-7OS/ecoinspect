import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodel/auth/auth_cubit.dart';
import '../../viewmodel/auth/auth_state.dart';
import '../../viewmodel/cnc/cnc_cubit.dart';
import '../../viewmodel/cnc/cnc_state.dart';
import '../widgets/custom_loading_indecator.dart';
import '../widgets/machine_card.dart';
import '../machines/add_machine_screen.dart';
import '../machines/machine_details_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CncCubit>().loadMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text(
          'CNC Manager',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return PopupMenuButton<void>(
                icon: const Icon(
                  Icons.account_circle,
                  color: Color(0xFFFFFFFF),
                ),
                color: const Color(0xFF161B22),
                itemBuilder: (context) => <PopupMenuEntry<void>>[
                  PopupMenuItem<void>(
                    child: Text(
                      state.user?.email ?? 'User',
                      style: const TextStyle(color: Color(0xFF8B949E)),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<void>(
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xFFDA3633)),
                        SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(color: Color(0xFFDA3633)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CncCubit, CncState>(
        builder: (context, state) {
          if (state.status == CncStatus.loading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state.status == CncStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFDA3633),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: const TextStyle(color: Color(0xFF8B949E)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CncCubit>().loadMachines(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF238636),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.machines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.precision_manufacturing_outlined,
                    size: 80,
                    color: Color(0xFF8B949E),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No CNC Machines',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first machine to get started',
                    style: TextStyle(color: Color(0xFF8B949E)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddMachineScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Machine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF238636),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CncCubit>().loadMachines(),
            backgroundColor: const Color(0xFF161B22),
            color: const Color(0xFF58A6FF),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.machines.length,
              itemBuilder: (context, index) {
                final machine = state.machines[index];
                return MachineCard(
                  machine: machine,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MachineDetailsScreen(machine: machine),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddMachineScreen()));
        },
        backgroundColor: const Color(0xFF238636),
        child: const Icon(Icons.add),
      ),
    );
  }
}
