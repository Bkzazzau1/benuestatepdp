import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'command_actions.dart';
import 'community/community_store.dart';
import 'community/discussion_forum.dart';
import 'community/meeting_room.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'login_page.dart';
import 'operations_pages.dart';
import 'record_pages.dart';
import 'records_governance.dart';
import 'role_command_views.dart';
import 'scoped_communications.dart';
import 'scoped_intelligence.dart';
import 'scoped_map.dart';
import 'session.dart';
import 'widgets.dart';

class BenueCampaignApp extends StatefulWidget {
  const BenueCampaignApp({super.key});

  @override
  State<BenueCampaignApp> createState() => _BenueCampaignAppState();
}

class _BenueCampaignAppState extends State<BenueCampaignApp> {
  final scopeController = CampaignScopeController();
  final recordsController = CampaignRecordsController.prototypeSeed();
  final communityController = CampaignCommunityController.prototypeSeed();
  final sessionController = CampaignSessionController();

  @override
  void dispose() {
    scopeController.dispose();
    recordsController.dispose();
    communityController.dispose();
    sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CampaignSession(
        controller: sessionController,
        child: CampaignScope(
          controller: scopeController,
          child: CampaignRecords(
            controller: recordsController,
            child: CampaignCommunity(
              controller: communityController,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'PoliSphere Benue — PDP Governorship Campaign',
                theme: _theme(),
                home: const _AuthenticationGate(),
              ),
            ),
          ),
        ),
      );

  ThemeData _theme() => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pdpGreen,
          primary: pdpGreen,
          secondary: pdpRed,
          surface: Colors.white,
        ),
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          indicatorColor: Color(0xFFE4F3E8),
          selectedIconTheme: IconThemeData(color: pdpGreen),
          selectedLabelTextStyle:
              TextStyle(color: pdpGreenDark, fontWeight: FontWeight.w800),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: pdpGreen,
          thumbColor: pdpGreen,
          inactiveTrackColor: Color(0xFFDDE7DF),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE5DF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE5DF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: pdpGreen, width: 1.5),
          ),
        ),
      );
}

class _AuthenticationGate extends StatelessWidget {
  const _AuthenticationGate();

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: session.isAuthenticated
          ? const CampaignShell(key: ValueKey('campaign-shell'))
          : const CampaignLoginPage(key: ValueKey('campaign-login')),
    );
  }
}

class CampaignShell extends StatefulWidget {
  const CampaignShell({super.key});

  @override
  State<CampaignShell> createState() => _CampaignShellState();
}

class _CampaignShellState extends State<CampaignShell> {
  AppModule selectedModule = AppModule.overview;

  List<_Destination> get destinations => <_Destination>[
        _Destination(
          AppModule.overview,
          'Command Overview',
          Icons.dashboard_rounded,
          RoleCommandRouter(
            role: CampaignSession.of(context).role!,
            onOpenModule: choose,
          ),
        ),
        const _Destination(AppModule.benueMap, 'Benue Map', Icons.map_outlined,
            ScopedBenueMapPage()),
        const _Destination(AppModule.campaignOperations, 'Campaign Operations',
            Icons.campaign_outlined, RecordsCampaignOperationsPage()),
        const _Destination(AppModule.historicalElections, 'Historical Elections',
            Icons.history_rounded, ScopedHistoricalElectionsPage()),
        const _Destination(AppModule.electionIntelligence, 'Election Intelligence',
            Icons.analytics_rounded, ScopedElectionIntelligencePage()),
        const _Destination(AppModule.campaignTrends, 'Campaign Trends',
            Icons.trending_up_rounded, ScopedCampaignTrendsPage()),
        const _Destination(AppModule.mediaIntelligence, 'Media Intelligence',
            Icons.public_rounded, MediaIntelligencePage()),
        const _Destination(AppModule.communityIssues, 'Community Issues',
            Icons.forum_outlined, CommunityIssuesPage()),
        const _Destination(AppModule.situationRoom, 'Situation Room', Icons.radar_rounded,
            RecordsSituationRoomPage()),
        const _Destination(AppModule.communications, 'Communications',
            Icons.chat_bubble_outline_rounded, ScopedCommunicationsPage()),
        const _Destination(AppModule.discussionForum, 'Discussion Forum',
            Icons.forum_rounded, DiscussionForumPage()),
        const _Destination(AppModule.meetingRoom, 'Meeting Room',
            Icons.video_call_rounded, MeetingRoomPage()),
        const _Destination(AppModule.fieldNetwork, 'Field Network', Icons.hub_rounded,
            RecordsFieldNetworkPage()),
        const _Destination(AppModule.logisticsTasks, 'Logistics & Tasks',
            Icons.inventory_2_outlined, RecordsLogisticsTasksPage()),
        const _Destination(AppModule.electionDay, 'Election Day',
            Icons.how_to_vote_rounded, RecordsElectionDayPage()),
        const _Destination(AppModule.reportsDocuments, 'Reports & Documents',
            Icons.description_outlined, ReportsDocumentsPage()),
        const _Destination(AppModule.dataGovernance, 'Data & Governance',
            Icons.admin_panel_settings_rounded, RecordsGovernancePage()),
      ];

  void choose(AppModule module) => setState(() => selectedModule = module);

  List<_Destination> visibleDestinations(CampaignRole role) {
    final allowed = allowedModules(role);
    return destinations.where((item) => allowed.contains(item.module)).toList();
  }

  int get selectedIndex {
    final index = destinations.indexWhere((item) => item.module == selectedModule);
    return index < 0 ? 0 : index;
  }

  bool _showActionBar(CampaignRole role) => switch (role) {
        CampaignRole.directorGeneral ||
        CampaignRole.situationRoomDirector ||
        CampaignRole.stateAdministrator ||
        CampaignRole.operationsOfficer ||
        CampaignRole.logisticsOfficer ||
        CampaignRole.lgaCoordinator => true,
        _ => false,
      };

  Widget _content(CampaignRole role) => Column(
        children: [
          ActiveScopeBar(onOpenMap: () => choose(AppModule.benueMap)),
          if (_showActionBar(role))
            CommandActionsBar(onOpenMap: () => choose(AppModule.benueMap)),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: destinations.map((item) => item.page).toList(),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    final role = session.role!;
    final visible = visibleDestinations(role);

    if (!visible.any((item) => item.module == selectedModule)) {
      selectedModule = visible.first.module;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1080;
        return Scaffold(
          appBar: wide
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  titleSpacing: 14,
                  title: const _CompactBrand(),
                  actions: [
                    _RoleChip(role: role),
                    const SizedBox(width: 6),
                    PopupMenuButton<String>(
                      tooltip: 'Account',
                      onSelected: (value) {
                        if (value == 'logout') {
                          CampaignSession.of(context, listen: false).signOut();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'logout', child: Text('Sign out')),
                      ],
                      icon: const CandidatePortrait(size: 34, borderWidth: 1.5),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
          drawer: wide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: _MobileNavigation(
                      destinations: visible,
                      selectedModule: selectedModule,
                      role: role,
                      onChoose: (module) {
                        choose(module);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
          body: wide
              ? Row(
                  children: [
                    _DesktopSidebar(
                      destinations: visible,
                      selectedModule: selectedModule,
                      role: role,
                      onChoose: choose,
                    ),
                    Expanded(child: _content(role)),
                  ],
                )
              : _content(role),
        );
      },
    );
  }
}

class _Destination {
  const _Destination(this.module, this.label, this.icon, this.page);
  final AppModule module;
  final String label;
  final IconData icon;
  final Widget page;
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.destinations,
    required this.selectedModule,
    required this.role,
    required this.onChoose,
  });

  final List<_Destination> destinations;
  final AppModule selectedModule;
  final CampaignRole role;
  final ValueChanged<AppModule> onChoose;

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    return Container(
      width: 292,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE0E8E2))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 14),
              child: _Brand(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5FAF6), Color(0xFFFFF8F8)],
                  ),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFE2EAE4)),
                ),
                child: const CandidateIdentityCard(compact: true),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final item = destinations[index];
                  final active = selectedModule == item.module;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: Colors.white,
                      child: ListTile(
                        dense: true,
                        minLeadingWidth: 28,
                        selected: active,
                        selectedColor: pdpGreenDark,
                        selectedTileColor: const Color(0xFFE8F4EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(item.icon,
                            size: 21, color: active ? pdpGreen : muted),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                        onTap: () => onChoose(item.module),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: _SignedInCard(
                operatorName: session.operatorName,
                role: role,
                onSignOut: session.signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  const _MobileNavigation({
    required this.destinations,
    required this.selectedModule,
    required this.role,
    required this.onChoose,
  });

  final List<_Destination> destinations;
  final AppModule selectedModule;
  final CampaignRole role;
  final ValueChanged<AppModule> onChoose;

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: _Brand(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: CandidateIdentityCard(compact: true),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final item = destinations[index];
              final active = selectedModule == item.module;
              return ListTile(
                selected: active,
                selectedColor: pdpGreenDark,
                selectedTileColor: const Color(0xFFE8F4EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: Icon(item.icon),
                title: Text(item.label,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => onChoose(item.module),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: _SignedInCard(
            operatorName: session.operatorName,
            role: role,
            onSignOut: session.signOut,
          ),
        ),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const PdpLogo(),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('POLISPHERE BENUE',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: .3,
                        color: ink)),
                SizedBox(height: 2),
                Text('Governorship Command',
                    style: TextStyle(color: muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      );
}

class _CompactBrand extends StatelessWidget {
  const _CompactBrand();

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Text('PoliSphere Benue',
              style: TextStyle(fontWeight: FontWeight.w900, color: ink)),
          SizedBox(width: 7),
          Text('• PDP',
              style: TextStyle(color: pdpGreen, fontWeight: FontWeight.w800)),
        ],
      );
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});
  final CampaignRole role;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          roleLabel(role),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: pdpGreenDark,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

class _SignedInCard extends StatelessWidget {
  const _SignedInCard({
    required this.operatorName,
    required this.role,
    required this.onSignOut,
  });

  final String operatorName;
  final CampaignRole role;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E8E2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: const Color(0xFFE2F1E6),
              child: Icon(roleIcon(role), size: 19, color: pdpGreen),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(operatorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(roleLabel(role),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 10.5)),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Sign out',
              visualDensity: VisualDensity.compact,
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded, size: 19),
            ),
          ],
        ),
      );
}
