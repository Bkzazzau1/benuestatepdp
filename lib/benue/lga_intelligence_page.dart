import 'package:flutter/material.dart';

import 'lga_historical_data.dart';
import 'lga_intelligence_data.dart';
import 'widgets.dart';

class LgaIntelligenceCommandPage extends StatefulWidget {
  const LgaIntelligenceCommandPage({super.key, this.initialLga});

  final String? initialLga;

  @override
  State<LgaIntelligenceCommandPage> createState() =>
      _LgaIntelligenceCommandPageState();
}

class _LgaIntelligenceCommandPageState
    extends State<LgaIntelligenceCommandPage> {
  late String selectedLga;
  int selectedYear = 2023;
  String query = '';
  String zone = 'ALL';

  @override
  void initState() {
    super.initState();
    selectedLga = widget.initialLga ?? 'Makurdi';
  }

  @override
  Widget build(BuildContext context) {
    final profile = intelligenceProfileFor(selectedLga);
    final filtered = lgaIntelligenceProfiles.where((item) {
      final matchesQuery =
          item.lga.toLowerCase().contains(query.trim().toLowerCase());
      final matchesZone = zone == 'ALL' || item.zone.startsWith(zone);
      return matchesQuery && matchesZone;
    }).toList()
      ..sort((a, b) => a.lga.compareTo(b.lga));

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          const _LocalIntelHero(),
          const SizedBox(height: 16),
          const _StateSummaryStrip(),
          const SizedBox(height: 16),
          const _StatewideCycleSummary(),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1080;
              final explorer = _LgaExplorer(
                rows: filtered,
                selectedLga: selectedLga,
                query: query,
                zone: zone,
                onQuery: (value) => setState(() => query = value),
                onZone: (value) => setState(() => zone = value),
                onSelect: (value) => setState(() => selectedLga = value),
              );
              final detail = _LgaDetail(
                profile: profile,
                selectedYear: selectedYear,
                onYear: (value) => setState(() => selectedYear = value),
              );
              if (!wide) {
                return Column(
                  children: [
                    explorer,
                    const SizedBox(height: 14),
                    detail,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 9, child: explorer),
                  const SizedBox(width: 14),
                  Expanded(flex: 16, child: detail),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const _WardReadinessNotice(),
          const SizedBox(height: 16),
          const _CurrentCycleSources(),
        ],
      ),
    );
  }
}

class _LocalIntelHero extends StatelessWidget {
  const _LocalIntelHero();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF061D13), Color(0xFF123D29), Color(0xFF0B7A3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22064F2A),
              blurRadius: 30,
              offset: Offset(0, 13),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 820;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroPill(Icons.location_city_outlined, '23-LGA INTELLIGENCE'),
                    _HeroPill(Icons.fact_check_outlined, 'SOURCE-CONTROLLED'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Local Government Intelligence Unit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 29 : 38,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'One statewide command view with LGA-by-LGA election history, political dynamics, evidence quality, historical counterfactuals and a clearly labelled 2027 scenario outlook.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.48,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
            final right = const Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                _HeroPill(Icons.history_rounded, '2015 • 2019 • 2023'),
                _HeroPill(Icons.query_stats_rounded, '2027 = SCENARIO'),
                _HeroPill(Icons.shield_outlined, 'NO INDIVIDUAL PROFILING'),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [left, const SizedBox(height: 20), right],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 13, child: left),
                const SizedBox(width: 22),
                Expanded(flex: 8, child: right),
              ],
            );
          },
        ),
      );
}

class _HeroPill extends StatelessWidget {
  const _HeroPill(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white70),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .45)),
          ],
        ),
      );
}

class _StateSummaryStrip extends StatelessWidget {
  const _StateSummaryStrip();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      _Metric('23', 'LGAs profiled', Icons.map_outlined, pdpGreen),
      _Metric('3', 'Historical cycles', Icons.history_rounded, Color(0xFF2563EB)),
      _Metric('69', 'LGA-cycle slots', Icons.grid_view_rounded, Color(0xFF7C3AED)),
      _Metric('2027', 'Scenario layer', Icons.query_stats_rounded, Color(0xFFD97706)),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 560
                ? 2
                : 1;
        const gap = 11.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics
              .map((metric) => SizedBox(width: width, child: _MetricCard(metric)))
              .toList(),
        );
      },
    );
  }
}

class _Metric {
  const _Metric(this.value, this.label, this.icon, this.color);
  final String value;
  final String label;
  final IconData icon;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.metric);
  final _Metric metric;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E9E3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: metric.color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(metric.icon, color: metric.color, size: 21),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metric.value,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 21,
                          fontWeight: FontWeight.w900)),
                  Text(metric.label,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _StatewideCycleSummary extends StatelessWidget {
  const _StatewideCycleSummary();

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'One-page Benue election summary',
        subtitle:
            'The structural story across the three completed governorship cycles and the verified 2027 candidate position',
        trailing: const StatusPill('COMMAND SUMMARY'),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 1040 ? 4 : constraints.maxWidth >= 620 ? 2 : 1;
            const gap = 12.0;
            final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
            final cards = [
              const _CycleSummaryCard(
                year: '2015',
                winner: 'APC • Samuel Ortom',
                score: '422,932 vs 313,878',
                story:
                    'Statewide anti-incumbency, salary/pension pressure, PDP fracture and the national change environment combined with highly local political alignments.',
                color: Color(0xFF2563EB),
              ),
              const _CycleSummaryCard(
                year: '2019',
                winner: 'PDP • Samuel Ortom',
                score: '434,473 vs 345,155',
                story:
                    'Security identity, anti-open-grazing politics and Ortom’s coalition reshaped the map; the election required supplementary voting.',
                color: pdpGreen,
              ),
              const _CycleSummaryCard(
                year: '2023',
                winner: 'APC • Hyacinth Alia',
                score: '473,933 vs 223,913',
                story:
                    'A large anti-incumbency and candidate-centered Alia wave produced a much broader APC geographic advantage than in 2019.',
                color: Color(0xFF2563EB),
              ),
              const _CycleSummaryCard(
                year: '2027',
                winner: 'Alia (APC) vs Aondoakaa (PDP)',
                score: 'NO FORECAST YET',
                story:
                    'Current public candidate status is verified; LGA outlooks remain scenarios until fresh polling, organization, issue and turnout evidence reaches minimum quality thresholds.',
                color: Color(0xFFD97706),
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
            );
          },
        ),
      );
}

class _CycleSummaryCard extends StatelessWidget {
  const _CycleSummaryCard({
    required this.year,
    required this.winner,
    required this.score,
    required this.story,
    required this.color,
  });
  final String year;
  final String winner;
  final String score;
  final String story;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .045),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: color.withValues(alpha: .15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(year,
                    style: TextStyle(
                        color: color,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
                const Spacer(),
                Icon(Icons.arrow_outward_rounded, color: color, size: 19),
              ],
            ),
            const SizedBox(height: 8),
            Text(winner,
                style: const TextStyle(
                    color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(score,
                style: TextStyle(
                    color: color, fontSize: 10.5, fontWeight: FontWeight.w900)),
            const SizedBox(height: 9),
            Text(story,
                style: const TextStyle(
                    color: muted,
                    fontSize: 10.5,
                    height: 1.45,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _LgaExplorer extends StatelessWidget {
  const _LgaExplorer({
    required this.rows,
    required this.selectedLga,
    required this.query,
    required this.zone,
    required this.onQuery,
    required this.onZone,
    required this.onSelect,
  });

  final List<LgaIntelligenceProfile> rows;
  final String selectedLga;
  final String query;
  final String zone;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onZone;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => _Panel(
        title: '23-LGA intelligence index',
        subtitle: 'Search, filter by official senatorial zone and open a complete local profile',
        child: Column(
          children: [
            TextField(
              onChanged: onQuery,
              decoration: const InputDecoration(
                hintText: 'Search local government',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ['ALL', 'Zone A', 'Zone B', 'Zone C'].map((item) {
                final active = zone == item;
                return ChoiceChip(
                  selected: active,
                  onSelected: (_) => onZone(item),
                  label: Text(item),
                  selectedColor: const Color(0xFFE5F2E8),
                  labelStyle: TextStyle(
                    color: active ? pdpGreenDark : ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 10.5,
                  ),
                  side: BorderSide(
                      color: active ? pdpGreen : const Color(0xFFDDE5DF)),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No LGA matches the current filter.',
                    style: TextStyle(color: muted)),
              )
            else
              ...rows.map((profile) {
                final selected = profile.lga == selectedLga;
                final r2023 = lgaResultFor(2023, profile.lga);
                final lead = r2023?.leadingParty ?? 'SOURCE GAP';
                final color = _partyColor(lead);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onSelect(profile.lga),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected
                            ? color.withValues(alpha: .075)
                            : const Color(0xFFF8FAF8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? color.withValues(alpha: .35)
                              : const Color(0xFFE7ECE8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text(
                              lead == 'SOURCE GAP' ? '—' : lead,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.lga,
                                    style: const TextStyle(
                                        color: ink,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 2),
                                Text(profile.zone,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: muted,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              size: 18, color: muted),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      );
}

class _LgaDetail extends StatelessWidget {
  const _LgaDetail({
    required this.profile,
    required this.selectedYear,
    required this.onYear,
  });

  final LgaIntelligenceProfile profile;
  final int selectedYear;
  final ValueChanged<int> onYear;

  @override
  Widget build(BuildContext context) {
    final narrative = cycleNarrativeFor(profile.lga, selectedYear);
    final result = lgaResultFor(selectedYear, profile.lga);
    return Column(
      children: [
        _Panel(
          title: profile.lga,
          subtitle: '${profile.zone} • ${profile.cluster}',
          trailing: const StatusPill('LOCAL INTELLIGENCE'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [2015, 2019, 2023].map((year) {
                  final active = selectedYear == year;
                  return ChoiceChip(
                    selected: active,
                    onSelected: (_) => onYear(year),
                    label: Text('$year'),
                    selectedColor: const Color(0xFFE5F2E8),
                    side: BorderSide(
                        color: active ? pdpGreen : const Color(0xFFDDE5DF)),
                    labelStyle: TextStyle(
                        color: active ? pdpGreenDark : ink,
                        fontWeight: FontWeight.w900),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              _ResultCard(year: selectedYear, result: result),
              const SizedBox(height: 14),
              if (narrative != null) _NarrativeCard(narrative: narrative),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _OutlookCard(profile: profile),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.year, required this.result});
  final int year;
  final LgaHistoricalResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7E8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFFFDDA6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$year result: SOURCE GAP. A narrative may be retained as an analyst hypothesis, but the system will not manufacture a winner or vote total.',
                style: const TextStyle(
                    color: Color(0xFF7A4B00),
                    height: 1.4,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }
    final lead = result.leadingParty;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1E8E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill('$year • $lead', color: _partyColor(lead)),
              const Spacer(),
              Text(_qualityLabel(result.quality),
                  style: const TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _VoteChip('APC', result.apcVotes, const Color(0xFF2563EB)),
              _VoteChip('PDP', result.pdpVotes, pdpGreen),
              if (result.lpVotes > 0)
                _VoteChip('LP', result.lpVotes, const Color(0xFF7C3AED)),
              _VoteChip('Margin', result.leadingMargin, _partyColor(lead)),
            ],
          ),
          const SizedBox(height: 10),
          Text(result.sourceNote,
              style: const TextStyle(
                  color: muted,
                  fontSize: 10,
                  height: 1.4,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _VoteChip extends StatelessWidget {
  const _VoteChip(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('$label ${_format(value)}',
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w900)),
      );
}

class _NarrativeCard extends StatelessWidget {
  const _NarrativeCard({required this.narrative});
  final LgaCycleNarrative narrative;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _InsightBlock(
            icon: Icons.insights_rounded,
            title: 'What happened locally',
            text: narrative.dynamic,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 9),
          _InsightBlock(
            icon: Icons.psychology_alt_outlined,
            title: 'Why it may have happened',
            text: narrative.why,
            color: pdpGreen,
          ),
          const SizedBox(height: 9),
          _InsightBlock(
            icon: Icons.alt_route_rounded,
            title: 'Historical counterfactual',
            text: narrative.counterfactual,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _SmallBadge(_classification(narrative.classification),
                  _classificationColor(narrative.classification)),
              const SizedBox(width: 7),
              _SmallBadge('Confidence ${_confidence(narrative.confidence)}',
                  _confidenceColor(narrative.confidence)),
            ],
          ),
        ],
      );
}

class _InsightBlock extends StatelessWidget {
  const _InsightBlock({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .045),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: .12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 19, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(text,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 10.5,
                          height: 1.45,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _OutlookCard extends StatelessWidget {
  const _OutlookCard({required this.profile});
  final LgaIntelligenceProfile profile;

  @override
  Widget build(BuildContext context) {
    final outlook = profile.outlook2027;
    return _Panel(
      title: '2027 outlook • ${profile.lga}',
      subtitle:
          'Scenario monitor only — public issues and structural factors, not a prediction of individual voting behavior',
      trailing: const StatusPill('NOT A FORECAST', color: Color(0xFFD97706)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(outlook.status,
              style: const TextStyle(
                  color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          _TagSection('Public issue watch', outlook.publicIssues, pdpGreen),
          const SizedBox(height: 12),
          _TagSection('Structural factors', outlook.structuralFactors,
              const Color(0xFF2563EB)),
          const SizedBox(height: 12),
          _TagSection('Evidence required before stronger conclusions',
              outlook.evidenceNeeds, const Color(0xFF7C3AED)),
          const SizedBox(height: 11),
          _SmallBadge('Scenario confidence ${_confidence(outlook.confidence)}',
              _confidenceColor(outlook.confidence)),
        ],
      ),
    );
  }
}

class _TagSection extends StatelessWidget {
  const _TagSection(this.title, this.items, this.color);
  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: items
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 7),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(item,
                          style: TextStyle(
                              color: color,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800)),
                    ))
                .toList(),
          ),
        ],
      );
}

class _WardReadinessNotice extends StatelessWidget {
  const _WardReadinessNotice();

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Ward intelligence readiness',
        subtitle:
            'The architecture is ready for all 276 wards, but production ward-level behavior must come from verified election or field datasets',
        trailing: const StatusPill('SOURCE GAP', color: Color(0xFFD97706)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PoliSphere will not infer ward winners, ethnic/clan behavior or voter intention from an LGA result. Once verified ward/PU data is imported, each LGA profile can drill down to ward result history, turnout, incidents, field reports, public issues and evidence quality.',
              style: TextStyle(
                  color: muted,
                  height: 1.5,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SmallBadge('276 wards / RAs', pdpGreen),
                _SmallBadge('5,102 polling units', Color(0xFF2563EB)),
                _SmallBadge('No fabricated ward inference', Color(0xFF7C3AED)),
              ],
            ),
          ],
        ),
      );
}

class _CurrentCycleSources extends StatelessWidget {
  const _CurrentCycleSources();

  @override
  Widget build(BuildContext context) => _Panel(
        title: '2027 current-cycle source registry',
        subtitle:
            'Current candidate status is verified; LGA political outlooks remain analytical scenarios',
        trailing: const StatusPill('SEP 2026'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...verified2027CandidateFacts.map((fact) => _SourceLine(
                  icon: Icons.verified_outlined,
                  text: fact,
                  color: pdpGreen,
                )),
            const Divider(height: 24),
            ...current2027SourceRegistry.map((source) => _SourceLine(
                  icon: Icons.source_outlined,
                  text: source,
                  color: const Color(0xFF2563EB),
                )),
          ],
        ),
      );
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 9),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: ink,
                      fontSize: 10.5,
                      height: 1.4,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E8E2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              color: muted,
                              fontSize: 10,
                              height: 1.35,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 10),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      );
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .085),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.w900)),
      );
}

Color _partyColor(String party) => switch (party) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFF7C3AED),
      _ => const Color(0xFFD97706),
    };

String _qualityLabel(LgaHistoricalQuality quality) => switch (quality) {
      LgaHistoricalQuality.reconciledMajorParties => 'RECONCILED MAJOR PARTIES',
      LgaHistoricalQuality.publishedUnreconciled => 'PUBLISHED / UNRECONCILED',
      LgaHistoricalQuality.partialPublished => 'PARTIAL PUBLISHED SOURCE',
      LgaHistoricalQuality.noElection => 'NO ELECTION',
    };

String _classification(LocalIntelClass value) => switch (value) {
      LocalIntelClass.verifiedResult => 'Verified result conflict check',
      LocalIntelClass.sourceBackedInterpretation => 'Source-backed interpretation',
      LocalIntelClass.analystHypothesis => 'Analyst hypothesis',
      LocalIntelClass.scenarioOutlook => 'Scenario outlook',
      LocalIntelClass.sourceGap => 'Source gap',
    };

Color _classificationColor(LocalIntelClass value) => switch (value) {
      LocalIntelClass.verifiedResult => pdpGreen,
      LocalIntelClass.sourceBackedInterpretation => const Color(0xFF0F766E),
      LocalIntelClass.analystHypothesis => const Color(0xFF7C3AED),
      LocalIntelClass.scenarioOutlook => const Color(0xFFD97706),
      LocalIntelClass.sourceGap => pdpRed,
    };

String _confidence(LocalIntelConfidence value) => switch (value) {
      LocalIntelConfidence.high => 'High',
      LocalIntelConfidence.medium => 'Medium',
      LocalIntelConfidence.low => 'Low',
    };

Color _confidenceColor(LocalIntelConfidence value) => switch (value) {
      LocalIntelConfidence.high => pdpGreen,
      LocalIntelConfidence.medium => const Color(0xFFD97706),
      LocalIntelConfidence.low => pdpRed,
    };

String _format(int value) {
  final chars = value.toString().split('').reversed.toList();
  final out = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) out.add(',');
    out.add(chars[i]);
  }
  return out.reversed.join();
}
