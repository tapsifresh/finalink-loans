import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/admin/admin_dashboard.dart';
import '../screens/borrower/borrower_dashboard.dart';
import '../screens/landing/landing_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  static const double desktopBreakpoint = 900;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _userId;
  Future<String?>? _roleFuture;

  Future<String?> _fetchRole(String userId) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return response?['role'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? supabase.auth.currentSession;

        if (session == null) {
          return const LandingPage();
        }

        final user = session.user;
        if (_userId != user.id) {
          _userId = user.id;
          _roleFuture = _fetchRole(user.id);
        }

        return FutureBuilder<String?>(
          future: _roleFuture,
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final isAdmin = roleSnapshot.data == 'admin';
            final isWide = MediaQuery.of(context).size.width >= AuthGate.desktopBreakpoint;

            if (isAdmin && isWide) {
              return const AdminDashboard();
            }

            return const BorrowerDashboard();
          },
        );
      },
    );
  }
}

