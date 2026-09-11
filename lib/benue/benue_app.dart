import 'package:flutter/material.dart';
import 'operations_pages.dart';
import 'pages.dart';
import 'widgets.dart';

class BenueCampaignApp extends StatelessWidget {
  const BenueCampaignApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PoliSphere Benue — PDP Governorship Campaign',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(
            seedColor: pdpGreen,
            primary: pdpGreen,
            secondary: pdpRed,
            surface: Colors.white,
          ),
          fontFamily: 'Arial',
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
        ),
        home: const CampaignShell(),
      );
}

class CampaignShell extends StatefulWidget {
  const CampaignShell({super.key});

  @override
  State<CampaignShell> createState() => _CampaignShellState();
}

class _CampaignShellState extends State<CampaignShell> {
  int selected = 0;

  static const destinations = <_Destination>[
    _Destination('Command Overview', Icons.dashboard_rounded),
    _Destination('Campaign Operations', Icons.campaign_outlined),
    _Destination('Election Intelligence', Icons.analytics_rounded),
    _Destination('Campaign Trends', Icons.trending_up_rounded),
    _Destination('Media Intelligence', Icons.public_rounded),
    _Destination('Community Issues', Icons.forum_outlined),
    _Destination('Situation Room', Icons.radar_rounded),
    _Destination('Field Network', Icons.hub_rounded),
    _Destination('Logistics & Tasks', Icons.inventory_2_outlined),
    _Destination('Election Day', Icons.how_to_vote_rounded),
    _Destination('Reports & Documents', Icons.description_outlined),
    _Destination('Data & Governance', Icons.admin_panel_settings_rounded),
  ];

  static const pages = <Widget>[
    OverviewPage(),
    CampaignOperationsPage(),
    ElectionIntelligencePage(),
    CampaignTrendsPage(),
    MediaIntelligencePage(),
    CommunityIssuesPage(),
    SituationRoomPage(),
    FieldNetworkPage(),
    LogisticsTasksPage(),
    ElectionDayPage(),
    ReportsDocumentsPage(),
    DataGovernancePage(),
  ];

  void choose(int index) => setState(() => selected = index);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1040;
          return Scaffold(
            appBar: wide
                ? null
                : AppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    titleSpacing: 0,
                    title: const _CompactBrand(),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: StatusPill('PROTOTYPE'),
                      ),
                    ],
                  ),
            drawer: wide
                ? null
                : Drawer(
                    child: SafeArea(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(18, 18, 18, 12),
                            child: _Brand(),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: destinations.length,
                              itemBuilder: (context, index) {
                                final item = destinations[index];
                                return ListTile(
                                  selected: selected == index,
                                  selectedColor: pdpGreenDark,
                                  selectedTileColor: const Color(0xFFE8F4EB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  leading: Icon(item.icon),
                                  title: Text(item.label,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  onTap: () {
                                    choose(index);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            body: wide
                ? Row(
                    children: [
                      Container(
                        width: 270,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(color: Color(0xFFE0E8E2))),
                        ),
                        child: SafeArea(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(18, 22, 18, 18),
                                child: _Brand(),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Divider(height: 1),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  itemCount: destinations.length,
                                  itemBuilder: (context, index) {
                                    final item = destinations[index];
                                    final active = selected == index;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        selected: active,
                                        selectedColor: pdpGreenDark,
                                        selectedTileColor: const Color(0xFFE8F4EB),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13)),
                                        leading: Icon(item.icon,
                                            color: active ? pdpGreen : muted),
                                        title: Text(item.label,
                                            style: TextStyle(
                                                fontWeight: active
                                                    ? FontWeight.w900
                                                    : FontWeight.w700)),
                                        onTap: () => choose(index),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: _SidebarFooter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: IndexedStack(index: selected, children: pages),
                      ),
                    ],
                  )
                : IndexedStack(index: selected, children: pages),
          );
        },
      );
}

class _Destination {
  const _Destination(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [pdpGreen, pdpGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text('PDP',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('POLISPHERE BENUE',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: .4,
                        color: ink)),
                SizedBox(height: 2),
                Text('Governorship Command',
                    style: TextStyle(color: muted, fontSize: 12)),
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
          SizedBox(width: 8),
          Text('• PDP',
              style: TextStyle(color: pdpGreen, fontWeight: FontWeight.w800)),
        ],
      );
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E9E2)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill('PROTOTYPE BUILD'),
            SizedBox(height: 10),
            Text('Benue State • 23 LGAs',
                style: TextStyle(fontWeight: FontWeight.w900, color: ink)),
            SizedBox(height: 3),
            Text('276 wards • 5,102 polling units',
                style: TextStyle(fontSize: 12, color: muted)),
          ],
        ),
      );
}
