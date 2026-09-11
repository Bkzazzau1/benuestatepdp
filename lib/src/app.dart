import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/session.dart';
import 'package:polisphere/src/screens/app_shell.dart';
import 'package:polisphere/src/screens/auth/role_select_page.dart';
import 'package:polisphere/src/screens/auth/welcome_page.dart';
import 'package:polisphere/src/theme/app_theme.dart';

class PoliSphereApp extends StatefulWidget {
  const PoliSphereApp({super.key});

  @override
  State<PoliSphereApp> createState() => _PoliSphereAppState();
}

class _PoliSphereAppState extends State<PoliSphereApp> {
  final _session = AppSession();
  bool _pastWelcome = false;

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SessionScope(
        session: _session,
        child: MaterialApp(
          title: 'Hon. Suleiman Ibrahim Dabo — Situation Room',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: AnimatedBuilder(
            animation: _session,
            builder: (context, _) {
              if (_session.isSignedIn) return const AppShell();
              if (!_pastWelcome) {
                return WelcomePage(
                    onContinue: () => setState(() => _pastWelcome = true));
              }
              return const RoleSelectPage();
            },
          ),
        ),
      );
}
