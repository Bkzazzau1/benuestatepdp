import 'package:flutter/material.dart';
import 'package:polisphere/src/auth/app_role.dart';
import 'package:polisphere/src/auth/session.dart';
import 'package:polisphere/src/screens/home/home_page.dart';
import 'package:polisphere/src/screens/incidents/incidents_page.dart';
import 'package:polisphere/src/screens/more/tools_page.dart';
import 'package:polisphere/src/screens/reports/new_report_page.dart';
import 'package:polisphere/src/screens/reports/reports_page.dart';
import 'package:polisphere/src/screens/situation_room/situation_room_page.dart';
import 'package:polisphere/src/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final role = SessionScope.of(context).role!;
    if (!role.usesFieldApp) {
      return const SituationRoomPage();
    }
    const pages = [HomePage(), ReportsPage(), IncidentsPage(), ToolsPage()];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const NewReportPage(),
                ),
              ),
              backgroundColor: AppColors.emerald,
              foregroundColor: AppColors.bronzeLight,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'New report',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Incidents',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
