import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'lga_historical_page.dart';
import 'official_historical_page.dart';
import 'pages.dart';
import 'premium_intelligence_page.dart';
import 'widgets.dart';

class ScopedHistoricalElectionsPage extends StatelessWidget {
  const ScopedHistoricalElectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    if (lga == null) return const HistoricalElectionsHub();
    return LgaHistoricalDetailPage(lga: lga);
  }
}

class HistoricalElectionsHub extends StatelessWidget {
  const HistoricalElectionsHub({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: ColoredBox(
          color: const Color(0xFFF3F6F3),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5EE),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.how_to_vote_outlined,
                          color: pdpGreen),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Historical Elections',
                              style: TextStyle(
                                  color: ink,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text(
                            'Statewide INEC archive and LGA-level historical intelligence',
                            style: TextStyle(
                                color: muted,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const StatusPill('SOURCE-AWARE'),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: pdpGreenDark,
                  unselectedLabelColor: muted,
                  indicatorColor: pdpGreen,
                  dividerColor: Color(0xFFE5EBE6),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.account_balance_outlined, size: 18),
                      text: 'Statewide INEC Archive',
                    ),
                    Tab(
                      icon: Icon(Icons.grid_view_rounded, size: 18),
                      text: '23-LGA Landscape',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    const OfficialHistoricalElectionsPage(),
                    ListView(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 36),
                      children: const [
                        LgaHistoricalIntelligencePanel(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class ScopedElectionIntelligencePage extends StatelessWidget {
  const ScopedElectionIntelligencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lga = CampaignScope.of(context).lgaName;
    return PremiumElectionIntelligencePage(scopeLga: lga);
  }
}

class ScopedCampaignTrendsPage extends StatelessWidget {
  const ScopedCampaignTrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lga = CampaignScope.of(context).lgaName;
    if (lga == null) return const CampaignTrendsPage();
    return Column(
      children: [
        _ScopeBanner(
          icon: Icons.trending_up_rounded,
          title: '$lga campaign trend context',
          detail:
              'Prototype statewide trend series remains visible below. Production $lga trends will be calculated only from geography-tagged field, media, event and polling records.',
        ),
        const Expanded(child: CampaignTrendsPage()),
      ],
    );
  }
}

class _ScopeBanner extends StatelessWidget {
  const _ScopeBanner({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(28, 18, 28, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: pdpGreen),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: ink, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(detail,
                      style: const TextStyle(color: muted, height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      );
}
