import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'constants.dart';
import 'viewmodel/auth/auth_cubit.dart';
import 'viewmodel/auth/auth_state.dart';
import 'viewmodel/cnc/cnc_cubit.dart';
import 'viewmodel/energy/energy_cubit.dart';
import 'viewmodel/events/events_cubit.dart';
import 'viewmodel/maintenance/maintenance_cubit.dart';
import 'viewmodel/true_cost/true_cost_cubit.dart';
import 'view/auth/login_screen.dart';
import 'view/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: kSupabaseUrl, anonKey: kSupabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(supabase)..loadCurrentUser()),
        BlocProvider(create: (_) => CncCubit(supabase)),
        BlocProvider(create: (_) => EnergyCubit(supabase)),
        BlocProvider(create: (_) => EventsCubit(supabase)),
        BlocProvider(create: (_) => MaintenanceCubit(supabase)),
        BlocProvider(create: (_) => TrueCostCubit(supabase)),
      ],
      child: MaterialApp(
        title: 'CNC Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(kPrimaryBackground),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF58A6FF),
            secondary: const Color(0xFF238636),
            surface: const Color(0xFF161B22),
            error: const Color(0xFFDA3633),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF161B22),
            foregroundColor: Color(kPrimaryTextColor),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF161B22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF30363D)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF161B22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF58A6FF)),
            ),
          ),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.loading) {
              return const Scaffold(
                backgroundColor: Color(kPrimaryBackground),
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF58A6FF)),
                ),
              );
            }

            if (state.status == AuthStatus.authenticated) {
              return const DashboardScreen();
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
