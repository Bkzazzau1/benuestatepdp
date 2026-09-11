import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

class HistoricalElectionsPage extends StatelessWidget {
  const HistoricalElectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final e2015 = historicalElections[0];
    final e2019 = historicalElections[1];
    final e2023 = historicalElections[2];

    final pdp1519 = e2019.pdpVotes - e2015.pdpVotes;
    final pdp1923 = e2023.pdpVotes - e2019.pdpVotes;
    final apc1519 = e2019.apcVotes - e2015.apcVotes;
    final apc1923 = e2023.apcVotes - e2019.apcVotes;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const PageHeading(
          title: 'Historical Elections',
          subtitle:
              'Benue governorship election comparison for 2015, 2019 and 2023, with transparent swing calculations and data limitations.',
          trailing: StatusPill('2015 • 2019 • 2023'),
        ),
        const SizedBox(height: 18),
        const _HistoricalDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 1100 ? 4 : c.maxWidth > 650 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (cols - 1)) / cols;
          final cards = [
            MetricCard(
                label: 'PDP change 2015 → 2019',
                value: _signed(pdp1519),
                icon: Icons.trending_up_rounded,
                accent: pdpGreen,
                detail: '${_pctChange(e2015.pdpVotes, e2019.pdpVotes)}%'),
            MetricCard(
                label: 'PDP change 2019 → 2023',
                value: _signed(pdp1923),
                icon: Icons.trending_down_rounded,
                accent: pdpRed,
                detail: '${_pctChange(e2019.pdpVotes, e2023.pdpVotes)}%'),
            MetricCard(
                label: 'APC change 2015 → 2019',
                value: _signed(apc1519),
                icon: Icons.swap_vert_rounded,
                accent: const Color(0xFF2E62D8),
                detail: '${_pctChange(e2015.apcVotes, e2019.apcVotes)}%'),
            MetricCard(
                label: 'APC change 2019 → 2023',
                value: _signed(apc1923),
                icon: Icons.trending_up_rounded,
                accent: const Color(0xFF2E62D8),
                detail: '${_pctChange(e2019.apcVotes, e2023.apcVotes)}%'),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children:
                cards.map((e) => SizedBox(width: width, child: e)).toList(),
          );
        }),
        const SizedBox(height: 14),
        ...historicalElections.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5F1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('${e.year}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${e.winner} won Benue',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(e.note,
                                  style: const TextStyle(color: muted)),
                            ],
                          ),
                        ),
                        StatusPill('Margin ${_format(e.margin)}',
                            color: e.winner == 'PDP'
                                ? pdpGreen
                                : const Color(0xFF2E62D8)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElectionBars(apc: e.apcVotes, pdp: e.pdpVotes),
                    const SizedBox(height: 12),
                    _TwoPartyShare(
                      apc: e.apcVotes,
                      pdp: e.pdpVotes,
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 2),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 930;
          final interpretation = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Title('What the history shows',
                    'The three elections should be treated as changing political environments, not fixed party loyalty.'),
                SizedBox(height: 14),
                _Insight(
                    '2015 → 2019',
                    'PDP raw votes increased while APC raw votes declined. Candidate movement and changing political alignment mean party labels alone cannot explain the swing.'),
                _Insight(
                    '2019 → 2023',
                    'PDP raw votes fell sharply while APC raw votes increased. The production model should locate this change by LGA, ward and polling unit before drawing operational conclusions.'),
                _Insight(
                    'Forecast implication',
                    'Historical totals establish a baseline, but current polling, turnout assumptions, organization readiness and current conditions are required for a defensible forecast.'),
              ],
            ),
          );
          final gaps = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Title('Data still required',
                    'Forecast confidence stays low until these datasets are loaded and validated.'),
                SizedBox(height: 12),
                _Gap('LGA-level results for 2015, 2019 and 2023'),
                _Gap('Ward and polling-unit historical results where reliably available'),
                _Gap('Registered voters and turnout by election and geography'),
                _Gap('Third-party and other-candidate vote totals'),
                _Gap('Current methodologically sound polling'),
                _Gap('Verified campaign organization and field-readiness data'),
              ],
            ),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: interpretation),
                  const SizedBox(width: 14),
                  Expanded(child: gaps),
                ])
              : Column(children: [
                  interpretation,
                  const SizedBox(height: 14),
                  gaps,
                ]);
        }),
      ],
    );
  }
}

class _HistoricalDataBanner extends StatelessWidget {
  const _HistoricalDataBanner();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5EE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCFE7D5)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_outlined, color: pdpGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'The statewide APC/PDP totals shown here are historical sourced values. Two-party share below uses APC + PDP only and must not be read as total statewide vote share where other candidates participated.',
                style: TextStyle(
                    color: pdpGreenDark, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
}

class _TwoPartyShare extends StatelessWidget {
  const _TwoPartyShare({required this.apc, required this.pdp});
  final int apc;
  final int pdp;

  @override
  Widget build(BuildContext context) {
    final total = apc + pdp;
    final apcShare = apc / total * 100;
    final pdpShare = pdp / total * 100;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatusPill('APC two-party ${apcShare.toStringAsFixed(1)}%',
            color: const Color(0xFF2E62D8)),
        StatusPill('PDP two-party ${pdpShare.toStringAsFixed(1)}%'),
        const StatusPill('APC + PDP only', color: Color(0xFF6A5ACD)),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: muted)),
        ],
      );
}

class _Insight extends StatelessWidget {
  const _Insight(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.insights_outlined, color: pdpGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(detail,
                    style: const TextStyle(color: muted, height: 1.4)),
              ],
            ),
          ),
        ]),
      );
}

class _Gap extends StatelessWidget {
  const _Gap(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          const Icon(Icons.pending_actions_outlined,
              size: 19, color: Color(0xFFD68A00)),
          const SizedBox(width: 9),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
      );
}

String _pctChange(int from, int to) {
  final value = (to - from) / from * 100;
  return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}';
}

String _signed(int value) => '${value >= 0 ? '+' : '−'}${_format(value.abs())}';

String _format(int value) {
  final chars = value.toString().split('').reversed.toList();
  final out = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) out.add(',');
    out.add(chars[i]);
  }
  return out.reversed.join();
}
