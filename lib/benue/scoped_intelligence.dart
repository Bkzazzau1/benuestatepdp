import 'package:flutter/material.dart';

import 'analytics_pages.dart';
import 'app_scope.dart';
import 'data.dart';
import 'pages.dart';
import 'widgets.dart';

class ScopedHistoricalElectionsPage extends StatelessWidget {
  const ScopedHistoricalElectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    if (lga == null) return const HistoricalElectionsPage();

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: '$lga Historical Elections',
          subtitle:
              'LGA-level governorship history is kept separate from statewide totals so the system never mislabels state data as $lga data.',
          trailing: StatusPill('$lga LGA'),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5D9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFE19B)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.fact_check_outlined, color: Color(0xFF8A5B00)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Verified LGA-level results have not been imported yet. No LGA vote totals, turnout, swing or margins are fabricated. Statewide reference totals remain available separately.',
                  style: TextStyle(
                      color: Color(0xFF6D4A00), fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LGA result import status',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('$lga requires sourced election-result records for each comparison year.',
                  style: const TextStyle(color: muted)),
              const SizedBox(height: 12),
              ...historicalElections.map((e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('${e.year}')),
                    title: Text('$lga ${e.year} governorship result',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: const Text('No verified LGA figure loaded'),
                    trailing: const StatusPill('SOURCE REQUIRED',
                        color: Color(0xFFD68A00)),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Statewide reference — not LGA data',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text(
                'These known Benue totals are displayed only as statewide context.',
                style: TextStyle(color: muted),
              ),
              const SizedBox(height: 12),
              ...historicalElections.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('${e.year}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w900)),
                          const Spacer(),
                          const StatusPill('BENUE STATE TOTAL'),
                        ]),
                        ElectionBars(apc: e.apcVotes, pdp: e.pdpVotes),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class ScopedElectionIntelligencePage extends StatelessWidget {
  const ScopedElectionIntelligencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lga = CampaignScope.of(context).lgaName;
    if (lga == null) return const ElectionIntelligencePage();
    return Column(
      children: [
        _ScopeBanner(
          icon: Icons.analytics_outlined,
          title: '$lga intelligence scope',
          detail:
              'Statewide factors remain visible below, but $lga-specific polling, historical results and field evidence must be loaded before LGA-level conclusions are generated.',
        ),
        const Expanded(child: ElectionIntelligencePage()),
      ],
    );
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
