import 'package:flutter/material.dart';

import 'data.dart';
import 'election_intelligence_data.dart';
import 'widgets.dart';

class CleanElectionIntelligencePage extends StatefulWidget {
  const CleanElectionIntelligencePage({super.key, this.scopeLga});
  final String? scopeLga;

  @override
  State<CleanElectionIntelligencePage> createState() =>
      _CleanElectionIntelligencePageState();
}

class _CleanElectionIntelligencePageState
    extends State<CleanElectionIntelligencePage> {
  int section = 0;
  int selectedYear = 2023;
  double turnout = 38;
  double organization = 55;
  double oppositionFragmentation = 35;

  ElectionCycleIntelligence get cycle => intelligenceForYear(selectedYear);

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFF3F6F3),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 36),
          children: [
            _Hero(scopeLga: widget.scopeLga),
            const SizedBox(height: 16),
            _Navigation(
              selected: section,
              onSelected: (value) => setState(() => section = value),
            ),
            const SizedBox(height: 18),
            switch (section) {
              0 => _electionDrivers(),
              1 => _currentFactors(),
              2 => _challenges(),
              3 => _scenarios(),
              _ => _sources(),
            },
          ],
        ),
      );

  Widget _electionDrivers() => Column(
        children: [
          _YearSelector(
            selectedYear: selectedYear,
            onSelected: (year) => setState(() => selectedYear = year),
          ),
          const SizedBox(height: 14),
          _Panel(
            title: 'Why the election was won',
            subtitle: '${cycle.year} • ${cycle.winnerParty} • ${cycle.winnerName}',
            trailing: StatusPill(
              '${cycle.winnerParty} WON',
              color: _partyColor(cycle.winnerParty),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cycle.verdict,
                  style: const TextStyle(
                    color: ink,
                    height: 1.55,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _ResultMetric(
                      label: 'Winner',
                      value: _format(cycle.winnerVotes),
                      detail: '${cycle.winnerParty} • ${cycle.winnerName}',
                      color: _partyColor(cycle.winnerParty),
                    ),
                    _ResultMetric(
                      label: 'Runner-up',
                      value: _format(cycle.runnerUpVotes),
                      detail: '${cycle.runnerUpParty} • ${cycle.runnerUpName}',
                      color: _partyColor(cycle.runnerUpParty),
                    ),
                    _ResultMetric(
                      label: 'Winning margin',
                      value: _format(cycle.margin),
                      detail: 'Declared statewide margin',
                      color: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _DriverGrid(drivers: cycle.drivers),
          const SizedBox(height: 14),
          _RegionalDynamics(cycle: cycle),
          const SizedBox(height: 14),
          _TwoColumns(
            left: _BulletPanel(
              title: 'Winning narrative',
              subtitle: '${cycle.winnerParty} • ${cycle.winnerName}',
              items: cycle.winningNarrative,
              color: _partyColor(cycle.winnerParty),
            ),
            right: _BulletPanel(
              title: 'Losing narrative',
              subtitle: '${cycle.runnerUpParty} • ${cycle.runnerUpName}',
              items: cycle.losingNarrative,
              color: _partyColor(cycle.runnerUpParty),
            ),
          ),
          const SizedBox(height: 14),
          _Lessons(cycle: cycle),
          const SizedBox(height: 14),
          _LegalAftermath(cycle: cycle),
        ],
      );

  Widget _currentFactors() => Column(
        children: [
          const _IntroCard(
            icon: Icons.radar_rounded,
            title: 'Current strategic factors',
            subtitle:
                'Track the issues most likely to shape the campaign and keep their importance and confidence visible.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1050
                ? 3
                : constraints.maxWidth >= 680
                    ? 2
                    : 1;
            const gap = 12.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: currentFactors
                  .map((factor) => SizedBox(
                        width: width,
                        child: _FactorCard(factor: factor),
                      ))
                  .toList(),
            );
          }),
          const SizedBox(height: 14),
          const _Panel(
            title: 'Evidence to watch',
            subtitle: 'The strongest inputs for current campaign assessment',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip('Independent polling'),
                _Chip('Field reports'),
                _Chip('Campaign readiness'),
                _Chip('Issue trends'),
                _Chip('Media coverage'),
                _Chip('Election history'),
              ],
            ),
          ),
        ],
      );

  Widget _challenges() => Column(
        children: [
          const _IntroCard(
            icon: Icons.crisis_alert_outlined,
            title: 'Campaign challenge desk',
            subtitle:
                'Important campaign problems, their severity, responsible unit and the action they require.',
          ),
          const SizedBox(height: 14),
          ...campaignChallenges.map((challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChallengeCard(challenge: challenge),
              )),
        ],
      );

  Widget _scenarios() {
    final quality = ((organization * .45) + (turnout * .25) + 30)
        .clamp(0, 100)
        .toDouble();
    return Column(
      children: [
        const _IntroCard(
          icon: Icons.query_stats_rounded,
          title: 'Forecast & Scenarios',
          subtitle:
              'Explore how different turnout, organization and opposition conditions could change the campaign environment.',
        ),
        const SizedBox(height: 14),
        _Panel(
          title: 'Scenario outlook',
          subtitle:
              'Use this as a planning exercise, not as a prediction of the final vote.',
          trailing: StatusPill(
            quality >= 70 ? 'Confidence: Medium' : 'Confidence: Low',
            color: quality >= 70 ? pdpGreen : const Color(0xFFD97706),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill('Data quality ${quality.toStringAsFixed(0)}%'),
              const StatusPill(
                'SCENARIO — NOT PREDICTION',
                color: Color(0xFF7C3AED),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Panel(
          title: 'Scenario simulator',
          subtitle: 'Adjust the assumptions and compare the campaign picture.',
          child: Column(
            children: [
              _slider('Turnout assumption', turnout,
                  (value) => setState(() => turnout = value)),
              _slider('Campaign organization readiness', organization,
                  (value) => setState(() => organization = value)),
              _slider('Opposition fragmentation', oppositionFragmentation,
                  (value) => setState(() => oppositionFragmentation = value)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E8E2)),
                ),
                child: const Text(
                  'Stronger decisions come from combining election history, turnout patterns, polling, campaign organization and current field evidence.',
                  style: TextStyle(color: ink, height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: ink, fontWeight: FontWeight.w800)),
              ),
              Text('${value.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      color: pdpGreen, fontWeight: FontWeight.w900)),
            ]),
            Slider(value: value, min: 0, max: 100, onChanged: onChanged),
          ],
        ),
      );

  Widget _sources() => Column(
        children: [
          const _IntroCard(
            icon: Icons.fact_check_outlined,
            title: 'Evidence Sources',
            subtitle:
                'Review the sources behind each election explanation and the strength assigned to the evidence.',
          ),
          const SizedBox(height: 14),
          _YearSelector(
            selectedYear: selectedYear,
            onSelected: (year) => setState(() => selectedYear = year),
          ),
          const SizedBox(height: 14),
          _Panel(
            title: '${cycle.year} intelligence sources',
            subtitle: 'Sources supporting the selected election analysis',
            trailing: StatusPill('${cycle.sources.length} sources'),
            child: Column(
              children: cycle.sources
                  .map((source) => _SourceRow(source: source))
                  .toList(),
            ),
          ),
        ],
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.scopeLga});
  final String? scopeLga;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF061D13), Color(0xFF0A3D24), Color(0xFF0B7A3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22064F2A),
              blurRadius: 30,
              offset: Offset(0, 13),
            )
          ],
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 840;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                const _DarkPill('STRATEGIC INTELLIGENCE'),
                _DarkPill(
                    scopeLga == null ? 'BENUE STATE' : '${scopeLga!} LGA'),
              ]),
              const SizedBox(height: 18),
              Text(
                'Election Intelligence Centre',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 29 : 39,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Understand what happened, why it happened, where it happened and what it means for the campaign ahead.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
          const badges = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DarkPill('ELECTION HISTORY'),
              _DarkPill('CURRENT FACTORS'),
              _DarkPill('CAMPAIGN LESSONS'),
            ],
          );
          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 18), badges],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 12, child: copy),
                    const SizedBox(width: 22),
                    const Expanded(flex: 8, child: badges),
                  ],
                );
        }),
      );
}

class _DarkPill extends StatelessWidget {
  const _DarkPill(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .14)),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: .5)),
      );
}

class _Navigation extends StatelessWidget {
  const _Navigation({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;

  static const labels = [
    'Election Drivers',
    'Current Factors',
    'Challenges',
    'Forecast & Scenarios',
    'Evidence Sources',
  ];
  static const icons = [
    Icons.auto_graph_rounded,
    Icons.radar_rounded,
    Icons.crisis_alert_outlined,
    Icons.query_stats_rounded,
    Icons.fact_check_outlined,
  ];

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E8E2)),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(labels.length, (index) {
            final active = index == selected;
            return InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFE7F3EA)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icons[index],
                      size: 17, color: active ? pdpGreen : muted),
                  const SizedBox(width: 7),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: active ? pdpGreenDark : ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ]),
              ),
            );
          }),
        ),
      );
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({required this.selectedYear, required this.onSelected});
  final int selectedYear;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Election cycle',
        subtitle: 'Choose a governorship election to explore',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: electionCycleIntelligence.map((item) {
            final active = item.year == selectedYear;
            return ChoiceChip(
              selected: active,
              onSelected: (_) => onSelected(item.year),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                    '${item.year} • ${item.winnerParty} • ${item.winnerName}'),
              ),
              labelStyle: TextStyle(
                color: active ? pdpGreenDark : ink,
                fontWeight: FontWeight.w900,
              ),
              selectedColor: const Color(0xFFE7F3EA),
              backgroundColor: const Color(0xFFF7F9F7),
              side: BorderSide(
                color: active ? pdpGreen : const Color(0xFFE2E8E3),
              ),
            );
          }).toList(),
        ),
      );
}

class _DriverGrid extends StatelessWidget {
  const _DriverGrid({required this.drivers});
  final List<ElectionDriver> drivers;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Key election drivers',
        subtitle: 'The strongest factors behind the result',
        child: LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1000 ? 2 : 1;
          const gap = 12.0;
          final width =
              (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: drivers
                .map((driver) => SizedBox(
                      width: width,
                      child: _DriverCard(driver: driver),
                    ))
                .toList(),
          );
        }),
      );
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver});
  final ElectionDriver driver;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E9E4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(driver.title,
                  style: const TextStyle(
                      color: ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900)),
            ),
            StatusPill(_confidence(driver.confidence)),
          ]),
          const SizedBox(height: 6),
          Text(driver.effect,
              style: const TextStyle(
                  color: pdpGreenDark, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(driver.detail,
              style: const TextStyle(color: muted, height: 1.45, fontSize: 11)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Text(driver.category,
                  style: const TextStyle(color: muted, fontSize: 9.5)),
            ),
            _ImpactDots(value: driver.impact),
          ]),
        ]),
      );
}

class _ImpactDots extends StatelessWidget {
  const _ImpactDots({required this.value});
  final int value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < value ? pdpGreen : const Color(0xFFD9E2DB),
            ),
          ),
        ),
      );
}

class _RegionalDynamics extends StatelessWidget {
  const _RegionalDynamics({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Regional dynamics',
        subtitle: 'How the election behaved across major parts of Benue',
        child: Column(
          children: cycle.regionalDynamics
              .map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE4E9E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(item.title,
                                style: const TextStyle(
                                    color: ink,
                                    fontWeight: FontWeight.w900)),
                          ),
                          StatusPill(_confidence(item.confidence)),
                        ]),
                        const SizedBox(height: 4),
                        Text(item.geography,
                            style: const TextStyle(
                                color: pdpGreenDark,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(item.result,
                            style: const TextStyle(
                                color: ink, fontSize: 11.5, height: 1.4)),
                        const SizedBox(height: 5),
                        Text(item.interpretation,
                            style: const TextStyle(
                                color: muted, fontSize: 10.5, height: 1.45)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
}

class _BulletPanel extends StatelessWidget {
  const _BulletPanel({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.color,
  });
  final String title;
  final String subtitle;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) => _Panel(
        title: title,
        subtitle: subtitle,
        child: Column(
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 5),
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: color),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(item,
                            style: const TextStyle(
                                color: ink, height: 1.45, fontSize: 11)),
                      ),
                    ]),
                  ))
              .toList(),
        ),
      );
}

class _Lessons extends StatelessWidget {
  const _Lessons({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Campaign lessons',
        subtitle: 'What the result teaches both sides',
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth >= 900
              ? (constraints.maxWidth - 12) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cycle.lessons
                .map((lesson) => SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: lesson.forWinner
                              ? const Color(0xFFF1F8F3)
                              : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.title,
                                style: const TextStyle(
                                    color: ink, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text(lesson.detail,
                                style: const TextStyle(
                                    color: muted, height: 1.45, fontSize: 10.5)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        }),
      );
}

class _LegalAftermath extends StatelessWidget {
  const _LegalAftermath({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Legal & institutional aftermath',
        subtitle: 'Key legal milestones after the election',
        child: Column(
          children: cycle.legalAftermath
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.gavel_outlined,
                          color: Color(0xFF8A5B00), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.stage} • ${item.outcome}',
                                style: const TextStyle(
                                    color: ink, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text(item.detail,
                                style: const TextStyle(
                                    color: muted, height: 1.45, fontSize: 10.5)),
                          ],
                        ),
                      ),
                    ]),
                  ))
              .toList(),
        ),
      );
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({required this.factor});
  final IntelligenceFactor factor;

  @override
  Widget build(BuildContext context) => _Panel(
        title: factor.title,
        subtitle: factor.status,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(factor.detail,
              style: const TextStyle(color: muted, height: 1.45, fontSize: 11)),
          const SizedBox(height: 12),
          Wrap(spacing: 7, runSpacing: 7, children: [
            StatusPill(factor.importance),
            StatusPill('Confidence: ${factor.confidence}',
                color: const Color(0xFFD97706)),
          ]),
        ]),
      );
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});
  final CampaignChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final color = challenge.severity == 'Critical'
        ? pdpRed
        : challenge.severity == 'High'
            ? const Color(0xFFD97706)
            : pdpGreen;
    return _Panel(
      title: challenge.title,
      subtitle: challenge.owner,
      trailing: StatusPill(challenge.severity, color: color),
      child: Text(challenge.detail,
          style: const TextStyle(color: muted, height: 1.5, fontSize: 11.5)),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});
  final IntelligenceSourceRef source;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E9E5)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.article_outlined, color: pdpGreen, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(source.publisher,
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(source.title,
                  style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
              const SizedBox(height: 5),
              Text(source.reference,
                  style: const TextStyle(color: pdpGreenDark, fontSize: 9.5)),
            ]),
          ),
          const SizedBox(width: 8),
          StatusPill(source.quality),
        ]),
      );
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: pdpGreen),
          const SizedBox(width: 11),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: const TextStyle(color: muted, height: 1.4, fontSize: 11)),
            ]),
          ),
        ]),
      );
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7F4),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE0E8E2)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: ink, fontSize: 10, fontWeight: FontWeight.w800)),
      );
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });
  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: 190),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: .12)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: const TextStyle(
                  color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(detail, style: const TextStyle(color: muted, fontSize: 9.5)),
        ]),
      );
}

class _TwoColumns extends StatelessWidget {
  const _TwoColumns({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return Column(children: [left, const SizedBox(height: 14), right]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: left),
          const SizedBox(width: 14),
          Expanded(child: right),
        ]);
      });
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
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: const TextStyle(
                        color: ink, fontSize: 16.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35)),
              ]),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing!,
            ],
          ]),
          const SizedBox(height: 15),
          child,
        ]),
      );
}

String _confidence(IntelConfidence confidence) => switch (confidence) {
      IntelConfidence.high => 'High confidence',
      IntelConfidence.medium => 'Medium confidence',
      IntelConfidence.low => 'Low confidence',
    };

Color _partyColor(String party) => switch (party) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFFDC2626),
      _ => const Color(0xFF64748B),
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
