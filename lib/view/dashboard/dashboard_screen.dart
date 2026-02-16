import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodel/auth/auth_cubit.dart';
import '../../viewmodel/auth/auth_state.dart';
import '../../viewmodel/cnc/cnc_cubit.dart';
import '../../viewmodel/cnc/cnc_state.dart';
import '../widgets/custom_loading_indecator.dart';
import '../widgets/fleet_overview_card.dart';
import '../widgets/machine_scorecard.dart';
import '../widgets/event_log_card.dart';
import '../widgets/maintenance_board_card.dart';
import '../machines/add_machine_screen.dart';
import '../auth/login_screen.dart';
import '../profile/edit_account_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<CncCubit>().loadMachines();
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar for desktop only
            if (!_isMobile) _buildSidebar(),
            // Main Content
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 76),
                    child: _buildMainContent(),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: _buildFloatingTopIconsBar(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar for mobile
      bottomNavigationBar: _isMobile ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildFloatingTopIconsBar() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22).withOpacity(0.92),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF30363D)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_isMobile)
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sidebar is available on larger screens'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu, color: Color(0xFF8B949E)),
                ),
              Expanded(
                child: Text(
                  _getPageTitle(),
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (MediaQuery.of(context).size.width > 380)
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF8B949E)),
                  onPressed: () {},
                ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF8B949E),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddMachineScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                ),
              ),
              const SizedBox(width: 6),
              PopupMenuButton<void>(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF58A6FF),
                  child: Text(
                    (authState.user?.email ?? 'U')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: const Color(0xFF161B22),
                itemBuilder: (context) => <PopupMenuEntry<void>>[
                  PopupMenuItem<void>(
                    onTap: () {
                      Future.microtask(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditAccountScreen(),
                          ),
                        );
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.manage_accounts, color: Color(0xFF8B949E)),
                        SizedBox(width: 10),
                        Text(
                          'Edit Account',
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<void>(
                    onTap: () {
                      Future.microtask(() {
                        context.read<AuthCubit>().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xFFDA3633)),
                        SizedBox(width: 10),
                        Text(
                          'Sign Out',
                          style: TextStyle(color: Color(0xFFDA3633)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(top: BorderSide(color: Color(0xFF30363D), width: 1)),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF161B22),
          selectedItemColor: const Color(0xFF58A6FF),
          unselectedItemColor: const Color(0xFF8B949E),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 22),
              label: 'Fleet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined, size: 22),
              label: 'Scorecard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt, size: 22),
              label: 'Machines',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note, size: 22),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined, size: 22),
              label: 'Maintenance',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(right: BorderSide(color: Color(0xFF30363D), width: 1)),
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58A6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.precision_manufacturing,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PULLSETA',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Technical Data & Maintenance',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF30363D), height: 1),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, 'Fleet Overview'),
                _buildNavItem(1, Icons.analytics_outlined, 'Machine Scorecard'),
                _buildNavItem(2, Icons.list_alt, 'Machines/Deep Dive'),
                _buildNavItem(3, Icons.event_note, 'Event Log'),
                _buildNavItem(4, Icons.build_outlined, 'Maintenance Board'),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'PROFESSIONAL EMAIL',
                    style: TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                _buildEmailField(),
              ],
            ),
          ),
          // User Section
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFF30363D), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF58A6FF),
                      child: Text(
                        (state.user?.email ?? 'U')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user?.fullName ?? 'User',
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.user?.email ?? '',
                            style: const TextStyle(
                              color: Color(0xFF8B949E),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFF8B949E)),
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1C2128) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: const Color(0xFF58A6FF).withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF58A6FF) : const Color(0xFF8B949E),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF8B949E),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13),
        decoration: InputDecoration(
          hintText: 'name@company.com',
          hintStyle: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF0D1117),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF58A6FF)),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(bottom: BorderSide(color: Color(0xFF30363D), width: 1)),
      ),
      child: Row(
        children: [
          // Title - flexible to prevent overflow
          Flexible(
            child: Text(
              _getPageTitle(),
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          // Hide search on very small screens
          if (MediaQuery.of(context).size.width > 400)
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF8B949E)),
              onPressed: () {},
            ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF8B949E),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          // Responsive button - icon only on small screens
          _isMobile
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddMachineScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 24),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF238636),
                    foregroundColor: Colors.white,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddMachineScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Machine'),
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
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Fleet Overview';
      case 1:
        return 'Machine Scorecard';
      case 2:
        return 'Machines / Deep Dive';
      case 3:
        return 'Event Log';
      case 4:
        return 'Maintenance Board';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildMainContent() {
    return BlocBuilder<CncCubit, CncState>(
      builder: (context, state) {
        if (state.status == CncStatus.loading) {
          return const Center(child: CustomLoadingIndicator());
        }

        switch (_selectedIndex) {
          case 0:
            return FleetOverviewCard(machines: state.machines);
          case 1:
            return MachineScorecard(machines: state.machines);
          case 2:
            return _buildMachinesDeepDive(state.machines);
          case 3:
            return const EventLogCard();
          case 4:
            return const MaintenanceBoardCard();
          default:
            return FleetOverviewCard(machines: state.machines);
        }
      },
    );
  }

  Widget _buildMachinesDeepDive(List machines) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Machines',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (machines.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.precision_manufacturing_outlined,
                    size: 80,
                    color: Color(0xFF8B949E),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No machines added yet',
                    style: TextStyle(color: Color(0xFF8B949E), fontSize: 16),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                if (constraints.maxWidth < 600) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 900) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: machines.length,
                  itemBuilder: (context, index) {
                    final machine = machines[index];
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
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
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF238636,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                    color: Color(0xFF3FB950),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            machine.name,
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (machine.model != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              machine.model!,
                              style: const TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.factory_outlined,
                                color: Color(0xFF8B949E),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  machine.manufacturer ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Color(0xFF8B949E),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
