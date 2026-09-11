import 'package:flutter/material.dart';

import 'data.dart';
import 'election_intelligence_data.dart';
import 'lga_historical_data.dart';
import 'widgets.dart';

class PremiumElectionIntelligencePage extends StatefulWidget {
  const PremiumElectionIntelligencePage({super.key, this.scopeLga});

  final String? scopeLga;

  @override
  State<PremiumElectionIntelligencePage> createState() =>
      _PremiumElectionIntelligencePageState();
}

class _PremiumElectionIntelligencePageState
    extends State<PremiumElectionIntelligencePage> {
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
            _IntelligenceHero(scopeLga: widget.scopeLga),
            const SizedBox(height: 16),
            _SectionNavigation(
              selected: section,
              onSelected: (value) => setState(() => section = value),
            ),
            const SizedBox(height: 18),
            if (section == 0) _drivers(),
            if (section == 1) _currentFactors(),
            if (section == 2) _challenges(),
            if (section == 3) _forecast(),
            if (section == 4) _sources(),
          ],
        ),
      );

  Widget _drivers() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CycleSelector(
            selectedYear: selectedYear,
            onSelected: (year) => setState(() => selectedYear = year),
          ),
          const SizedBox(height: 14),
          _ElectionVerdict(cycle: cycle),
          const SizedBox(height: 14),
          _DriverBoard(cycle: cycle),
          if (widget.scopeLga != null) ...[
            const SizedBox(height: 14),
            _LgaEvidenceOverlay(lga: widget.scopeLga!, year: selectedYear),
          ],
          const SizedBox(height: 14),
          _RegionalDynamics(cycle: cycle),
          const SizedBox(height: 14),
          _NarrativeComparison(cycle: cycle),
          const SizedBox(height: 14),
          _LessonsBoard(cycle: cycle),
          const SizedBox(height: 14),
          _LegalAftermath(cycle: cycle),
          const SizedBox(height: 14),
          const _MethodologyLegend(),
        ],
      );

  Widget _currentFactors() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionIntro(
            icon: Icons.radar_rounded,
            title: 'Current strategic factors',
            subtitle:
                'Present-day signals are kept separate from historical explanations. Their effect size remains provisional until supported by current polling, field evidence and operational data.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
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
                          child: _CurrentFactorCard(factor: factor),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 14),
          const _EvidenceGate(),
        ],
      );

  Widget _challenges() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionIntro(
            icon: Icons.crisis_alert_outlined,
            title: 'Campaign challenge desk',
            subtitle:
                'Problems are framed as measurable operational questions, with clear owners and evidence requirements rather than vague political assumptions.',
          ),
          const SizedBox(height: 14),
          ...campaignChallenges.map((challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChallengeCard(challenge: challenge),
              )),
          const _ChallengeDoctrine(),
        ],
      );

  Widget _forecast() {
    final dataQuality =
        ((organization * .45) + (turnout * .25) + 30).clamp(0, 100).toDouble();
    final confidence = dataQuality >= 70 ? 'Medium' : 'Low';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionIntro(
          icon: Icons.query_stats_rounded,
          title: 'Forecast & scenario laboratory',
          subtitle:
              'Scenario analysis stress-tests assumptions. It does not become a win-probability forecast until minimum evidence thresholds are satisfied.',
        ),
        const SizedBox(height: 14),
        _IntelligencePanel(
          title: 'Forecast engine status',
          subtitle:
              'No fabricated win probability: the production model activates only after minimum evidence thresholds are met.',
          trailing: StatusPill('Confidence: $confidence',
              color: confidence == 'Medium' ? pdpGreen : const Color(0xFFD97706)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill('Data quality ${dataQuality.toStringAsFixed(0)}%'),
                  const StatusPill('Current output: Scenario only',
                      color: Color(0xFF7C3AED)),
                  const StatusPill('Human review required',
                      color: Color(0xFF0F766E)),
                ],
              ),
              const SizedBox(height: 16),
              const _ForecastGateGrid(),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _IntelligencePanel(
          title: 'Scenario simulator',
          subtitle:
              'Change assumptions to stress-test the race. These sliders do not represent measured voter intention.',
          child: Column(
            children: [
              _slider('Turnout assumption', turnout,
                  (value) => setState(() => turnout = value)),
              _slider('Campaign organization readiness', organization,
                  (value) => setState(() => organization = value)),
              _slider('Opposition fragmentation', oppositionFragmentation,
                  (value) => setState(() => oppositionFragmentation = value)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.science_outlined, color: pdpGreen),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Production forecasting should use Monte Carlo simulation with LGA-level historical results, turnout distributions, methodologically sound polling, current organization data and explicit uncertainty ranges.',
                        style: TextStyle(
                          color: ink,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
  ) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: ink, fontWeight: FontWeight.w800)),
                ),
                Text('${value.toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: pdpGreen, fontWeight: FontWeight.w900)),
              ],
            ),
            Slider(value: value, min: 0, max: 100, onChanged: onChanged),
          ],
        ),
      );

  Widget _sources() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionIntro(
            icon: Icons.fact_check_outlined,
            title: 'Evidence & source registry',
            subtitle:
                'Every historical explanation exposes its source class and confidence. Facts, interpretations and campaign lessons are never silently mixed.',
          ),
          const SizedBox(height: 14),
          _CycleSelector(
            selectedYear: selectedYear,
            onSelected: (year) => setState(() => selectedYear = year),
          ),
          const SizedBox(height: 14),
          _IntelligencePanel(
            title: '${cycle.year} intelligence sources',
            subtitle:
                'Sources supporting the current election-cycle explanation',
            trailing: StatusPill('${cycle.sources.length} sources'),
            child: Column(
              children: cycle.sources
                  .map((source) => _SourceRow(source: source))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _IntelligencePanel(
            title: 'Production evidence channels',
            subtitle:
                'Evidence that can feed current-cycle intelligence once connected and quality-checked',
            child: Column(
              children: dataSources
                  .map((source) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.verified_outlined,
                            color: pdpGreen),
                        title: Text(source,
                            style: const TextStyle(
                                color: ink, fontWeight: FontWeight.w800)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          const _MethodologyLegend(),
        ],
      );
}

class _IntelligenceHero extends StatelessWidget {
  const _IntelligenceHero({required this.scopeLga});
  final String? scopeLga;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
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
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 840;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const _HeroPill(Icons.psychology_alt_outlined,
                        'STRATEGIC INTELLIGENCE'),
                    _HeroPill(Icons.location_on_outlined,
                        scopeLga == null ? 'BENUE STATE' : '$scopeLga LGA'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Election Intelligence Centre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 29 : 39,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -.8,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Understand what happened, why it happened, where it happened, how strong the evidence is — and what lessons should shape the next campaign decision.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
            final safeguards = const Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                _HeroPill(Icons.fact_check_outlined, 'SOURCE-AWARE'),
                _HeroPill(Icons.person_search_outlined, 'HUMAN REVIEW'),
                _HeroPill(Icons.shield_outlined, 'NO INDIVIDUAL PROFILING'),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 20), safeguards],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 12, child: copy),
                const SizedBox(width: 24),
                Expanded(flex: 8, child: safeguards),
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
                    letterSpacing: .5)),
          ],
        ),
      );
}

class _SectionNavigation extends StatelessWidget {
  const _SectionNavigation({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;

  static const items = [
    ('Election Drivers', Icons.auto_graph_rounded),
    ('Current Factors', Icons.radar_rounded),
    ('Challenges', Icons.crisis_alert_outlined),
    ('Forecast & Scenarios', Icons.query_stats_rounded),
    ('Evidence Sources', Icons.fact_check_outlined),
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
          children: List.generate(items.length, (index) {
            final active = index == selected;
            return InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFE7F3EA)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[index].$2,
                        size: 17, color: active ? pdpGreen : muted),
                    const SizedBox(width: 7),
                    Text(items[index].$1,
                        style: TextStyle(
                            color: active ? pdpGreenDark : ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            );
          }),
        ),
      );
}

class _CycleSelector extends StatelessWidget {
  const _CycleSelector({required this.selectedYear, required this.onSelected});
  final int selectedYear;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Election cycle',
        subtitle: 'Select a governorship election to inspect the causal narrative',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: electionCycleIntelligence.map((cycle) {
            final active = cycle.year == selectedYear;
            return InkWell(
              onTap: () => onSelected(cycle.year),
              borderRadius: BorderRadius.circular(15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                width: 190,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFE7F3EA)
                      : const Color(0xFFF7F9F7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: active ? pdpGreen : const Color(0xFFE3E9E4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? pdpGreen : const Color(0xFFE7ECE8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${cycle.year}',
                          style: TextStyle(
                              color: active ? Colors.white : ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${cycle.winnerParty} victory',
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(cycle.winnerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: muted,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _ElectionVerdict extends StatelessWidget {
  const _ElectionVerdict({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) {
    final winnerColor = _partyColor(cycle.winnerParty);
    return _IntelligencePanel(
      title: '${cycle.year} intelligence verdict',
      subtitle: 'Result facts plus the current best-supported explanation',
      trailing: StatusPill('${cycle.winnerParty} WON', color: winnerColor),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          final result = Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: winnerColor.withValues(alpha: .055),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: winnerColor.withValues(alpha: .14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DECLARED RESULT',
                    style: TextStyle(
                        color: muted,
                        fontSize: 9.5,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(cycle.winnerName,
                    style: const TextStyle(
                        color: ink,
                        fontSize: 21,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${cycle.winnerParty} • ${_format(cycle.winnerVotes)} votes',
                    style: TextStyle(
                        color: winnerColor, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text(
                    'Runner-up: ${cycle.runnerUpName} (${cycle.runnerUpParty}) • ${_format(cycle.runnerUpVotes)}',
                    style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Winning margin: ${_format(cycle.margin)}',
                    style: const TextStyle(
                        color: ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          );
          final verdict = Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8F6),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology_alt_outlined,
                        size: 19, color: pdpGreen),
                    SizedBox(width: 8),
                    Text('WHY THE ELECTION WAS WON',
                        style: TextStyle(
                            color: pdpGreenDark,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .7)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(cycle.verdict,
                    style: const TextStyle(
                        color: ink,
                        height: 1.55,
                        fontSize: 12,
                        fontWeight: FontWeight.w650)),
              ],
            ),
          );
          if (compact) {
            return Column(children: [result, const SizedBox(height: 12), verdict]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: result),
              const SizedBox(width: 12),
              Expanded(flex: 13, child: verdict),
            ],
          );
        },
      ),
    );
  }
}

class _DriverBoard extends StatelessWidget {
  const _DriverBoard({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Why the election was won',
        subtitle:
            'Ranked drivers with explicit evidence class and confidence — not a claim that one factor alone caused the result',
        trailing: StatusPill('${cycle.drivers.length} drivers'),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1020
                ? 2
                : 1;
            const gap = 12.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: cycle.drivers
                  .map((driver) => SizedBox(
                        width: width,
                        child: _DriverCard(driver: driver),
                      ))
                  .toList(),
            );
          },
        ),
      );
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver});
  final ElectionDriver driver;

  @override
  Widget build(BuildContext context) {
    final color = driver.effect.toLowerCase().contains('pdp')
        ? pdpGreen
        : driver.effect.toLowerCase().contains('apc')
            ? const Color(0xFF2563EB)
            : const Color(0xFF7C3AED);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE3E9E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(driver.title,
                    style: const TextStyle(
                        color: ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
              ),
              StatusPill('Impact ${driver.impact}/5', color: color),
            ],
          ),
          const SizedBox(height: 7),
          Text(driver.category.toUpperCase(),
              style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7)),
          const SizedBox(height: 8),
          Text(driver.detail,
              style: const TextStyle(
                  color: muted,
                  height: 1.48,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _ImpactMeter(value: driver.impact, color: color),
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              StatusPill(driver.effect, color: color),
              StatusPill('Confidence: ${confidenceLabel(driver.confidence)}',
                  color: _confidenceColor(driver.confidence)),
              StatusPill(evidenceTypeLabel(driver.evidenceType),
                  color: const Color(0xFF0F766E)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactMeter extends StatelessWidget {
  const _ImpactMeter({required this.value, required this.color});
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(5, (index) {
          final active = index < value;
          return Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
              decoration: BoxDecoration(
                color: active ? color : const Color(0xFFE7ECE8),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          );
        }),
      );
}

class _LgaEvidenceOverlay extends StatelessWidget {
  const _LgaEvidenceOverlay({required this.lga, required this.year});
  final String lga;
  final int year;

  @override
  Widget build(BuildContext context) {
    final row = lgaResultFor(year, lga);
    if (row == null) {
      return _IntelligencePanel(
        title: '$lga evidence overlay • $year',
        subtitle: 'The statewide intelligence remains visible, but this LGA needs a sourced historical row for this cycle.',
        trailing: const StatusPill('SOURCE GAP', color: Color(0xFFD97706)),
        child: const _Notice(
          icon: Icons.warning_amber_rounded,
          text:
              'PoliSphere will not manufacture an LGA-level explanation from statewide totals. Import or validate a sourced LGA record before generating local historical conclusions.',
          color: Color(0xFFD97706),
        ),
      );
    }
    if (!row.hasElection) {
      return _IntelligencePanel(
        title: '$lga evidence overlay • $year',
        subtitle: row.sourceLabel,
        trailing: const StatusPill('NO POLL', color: Color(0xFFD97706)),
        child: _Notice(
          icon: Icons.do_not_disturb_alt_outlined,
          text: row.sourceNote,
          color: const Color(0xFFD97706),
        ),
      );
    }
    final partyColor = _partyColor(row.leadingParty);
    return _IntelligencePanel(
      title: '$lga evidence overlay • $year',
      subtitle:
          'Local result evidence layered over the statewide causal narrative',
      trailing: StatusPill('${row.leadingParty} LED', color: partyColor),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final values = [
            _OverlayMetric('APC', _format(row.apcVotes), const Color(0xFF2563EB)),
            _OverlayMetric('PDP', _format(row.pdpVotes), pdpGreen),
            if (row.lpVotes > 0)
              _OverlayMetric('LP', _format(row.lpVotes), const Color(0xFF7C3AED)),
            _OverlayMetric('Lead margin', _format(row.leadingMargin), partyColor),
            if (row.turnoutPercent != null)
              _OverlayMetric('Turnout', '${row.turnoutPercent!.toStringAsFixed(1)}%',
                  const Color(0xFFD97706)),
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: values
                    .map((metric) => _OverlayMetricChip(metric: metric))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Text(row.sourceNote,
                  style: const TextStyle(
                      color: muted,
                      fontSize: 10.5,
                      height: 1.4,
                      fontWeight: FontWeight.w600)),
            ],
          );
        },
      ),
    );
  }
}

class _OverlayMetric {
  const _OverlayMetric(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;
}

class _OverlayMetricChip extends StatelessWidget {
  const _OverlayMetricChip({required this.metric});
  final _OverlayMetric metric;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: metric.color.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: metric.color.withValues(alpha: .14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(metric.label,
                style: const TextStyle(
                    color: muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800)),
            const SizedBox(width: 7),
            Text(metric.value,
                style: TextStyle(
                    color: metric.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      );
}

class _RegionalDynamics extends StatelessWidget {
  const _RegionalDynamics({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Regional dynamics',
        subtitle:
            'Where the statewide result was built — with data-quality limits kept visible',
        child: Column(
          children: cycle.regionalDynamics
              .map((region) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9F7),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE4E9E5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F2E8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.map_outlined,
                                color: pdpGreen, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(region.title,
                                          style: const TextStyle(
                                              color: ink,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900)),
                                    ),
                                    StatusPill(
                                        'Confidence: ${confidenceLabel(region.confidence)}',
                                        color: _confidenceColor(region.confidence)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(region.geography,
                                    style: const TextStyle(
                                        color: pdpGreenDark,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 7),
                                Text(region.result,
                                    style: const TextStyle(
                                        color: ink,
                                        fontSize: 10.5,
                                        height: 1.4,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(region.interpretation,
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
                    ),
                  ))
              .toList(),
        ),
      );
}

class _NarrativeComparison extends StatelessWidget {
  const _NarrativeComparison({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final winning = _NarrativeCard(
            title: 'Winning narrative',
            subtitle: '${cycle.winnerParty} / ${cycle.winnerName}',
            points: cycle.winningNarrative,
            color: _partyColor(cycle.winnerParty),
            icon: Icons.emoji_events_outlined,
          );
          final losing = _NarrativeCard(
            title: 'Losing narrative',
            subtitle: '${cycle.runnerUpParty} / ${cycle.runnerUpName}',
            points: cycle.losingNarrative,
            color: _partyColor(cycle.runnerUpParty),
            icon: Icons.trending_down_rounded,
          );
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: winning),
                    const SizedBox(width: 14),
                    Expanded(child: losing),
                  ],
                )
              : Column(children: [winning, const SizedBox(height: 14), losing]);
        },
      );
}

class _NarrativeCard extends StatelessWidget {
  const _NarrativeCard({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.color,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final List<String> points;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: title,
        subtitle: subtitle,
        trailing: Icon(icon, color: color),
        child: Column(
          children: points
              .map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(point,
                              style: const TextStyle(
                                  color: muted,
                                  height: 1.45,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w650)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
}

class _LessonsBoard extends StatelessWidget {
  const _LessonsBoard({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) {
    final winner = cycle.lessons.where((lesson) => lesson.forWinner).toList();
    final loser = cycle.lessons.where((lesson) => !lesson.forWinner).toList();
    return _IntelligencePanel(
      title: 'What could the campaigns have done differently?',
      subtitle:
          'Retrospective campaign lessons — explicitly separated from verified election facts',
      trailing: const StatusPill('CAMPAIGN LESSONS', color: Color(0xFF7C3AED)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final winnerColumn = _LessonColumn(
            title: '${cycle.winnerParty} / winner lessons',
            items: winner,
            color: _partyColor(cycle.winnerParty),
          );
          final loserColumn = _LessonColumn(
            title: '${cycle.runnerUpParty} / losing-campaign lessons',
            items: loser,
            color: _partyColor(cycle.runnerUpParty),
          );
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: winnerColumn),
                    const SizedBox(width: 14),
                    Expanded(child: loserColumn),
                  ],
                )
              : Column(
                  children: [
                    winnerColumn,
                    const SizedBox(height: 14),
                    loserColumn,
                  ],
                );
        },
      ),
    );
  }
}

class _LessonColumn extends StatelessWidget {
  const _LessonColumn(
      {required this.title, required this.items, required this.color});
  final String title;
  final List<StrategicLesson> items;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .045),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: .12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...items.map((lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson.title,
                          style: const TextStyle(
                              color: ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(lesson.detail,
                          style: const TextStyle(
                              color: muted,
                              height: 1.42,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
          ],
        ),
      );
}

class _LegalAftermath extends StatelessWidget {
  const _LegalAftermath({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Legal & institutional aftermath',
        subtitle:
            'What happened after the vote — important for distinguishing political narrative from the legally sustained result',
        child: Column(
          children: cycle.legalAftermath.asMap().entries.map((entry) {
            final item = entry.value;
            final last = entry.key == cycle.legalAftermath.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 13,
                        height: 13,
                        decoration: const BoxDecoration(
                          color: pdpGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!last)
                        Container(
                          width: 2,
                          height: 70,
                          color: const Color(0xFFDCE7DE),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: last ? 0 : 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.stage,
                            style: const TextStyle(
                                color: muted,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 3),
                        Text(item.outcome,
                            style: const TextStyle(
                                color: ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(item.detail,
                            style: const TextStyle(
                                color: muted,
                                height: 1.42,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
}

class _CurrentFactorCard extends StatelessWidget {
  const _CurrentFactorCard({required this.factor});
  final IntelligenceFactor factor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E9E3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.insights_outlined,
                      color: pdpGreen, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(factor.title,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(factor.detail,
                style: const TextStyle(
                    color: muted,
                    height: 1.45,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                StatusPill(factor.status),
                StatusPill('Importance: ${factor.importance}',
                    color: const Color(0xFF7C3AED)),
                StatusPill('Confidence: ${factor.confidence}',
                    color: const Color(0xFFD97706)),
              ],
            ),
          ],
        ),
      );
}

class _EvidenceGate extends StatelessWidget {
  const _EvidenceGate();

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Current-factor evidence gate',
        subtitle:
            'What PoliSphere needs before converting a current signal into a quantified forecast input',
        child: const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _GateChip('Current independent polling', Icons.poll_outlined),
            _GateChip('Geography-tagged field evidence', Icons.map_outlined),
            _GateChip('Organization/readiness records', Icons.hub_outlined),
            _GateChip('Issue-trend time series', Icons.timeline_outlined),
            _GateChip('Fresh source timestamps', Icons.schedule_outlined),
            _GateChip('Analyst review', Icons.fact_check_outlined),
          ],
        ),
      );
}

class _GateChip extends StatelessWidget {
  const _GateChip(this.label, this.icon);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E8E2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: pdpGreen),
            const SizedBox(width: 7),
            Text(label,
                style: const TextStyle(
                    color: ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ],
        ),
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
    return _IntelligencePanel(
      title: challenge.title,
      subtitle: challenge.owner,
      trailing: StatusPill(challenge.severity, color: color),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 74,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(challenge.detail,
                style: const TextStyle(
                    color: muted,
                    height: 1.48,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ChallengeDoctrine extends StatelessWidget {
  const _ChallengeDoctrine();

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'Intelligence doctrine',
        subtitle: 'How the challenge desk should operate',
        child: const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _GateChip('Problem → evidence', Icons.arrow_forward_rounded),
            _GateChip('Evidence → geography', Icons.location_on_outlined),
            _GateChip('Geography → owner', Icons.person_outline_rounded),
            _GateChip('Owner → action', Icons.task_alt_rounded),
            _GateChip('Action → measured outcome', Icons.analytics_outlined),
          ],
        ),
      );
}

class _ForecastGateGrid extends StatelessWidget {
  const _ForecastGateGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Historical LGA coverage', 'Loaded with quality flags', true),
      ('Current polling', 'Methodologically sound poll required', false),
      ('Turnout distribution', 'Scenario ranges available; validation required', false),
      ('Campaign readiness', 'Prototype operational records only', false),
      ('Current factors', 'Qualitative; effect sizes not yet calibrated', false),
      ('Uncertainty model', 'Monte Carlo architecture planned', false),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth >= 760
            ? (constraints.maxWidth - 10) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9F7),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFE3E9E4)),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.$3
                          ? Icons.check_circle_outline_rounded
                          : Icons.pending_outlined,
                      size: 18,
                      color: item.$3 ? pdpGreen : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$1,
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(item.$2,
                              style: const TextStyle(
                                  color: muted,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});
  final IntelligenceSourceRef source;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E9E4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F2E8),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.source_outlined,
                  color: pdpGreen, size: 19),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.publisher,
                      style: const TextStyle(
                          color: pdpGreenDark,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(source.title,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(source.reference,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusPill(source.quality.toUpperCase(),
                color: const Color(0xFF0F766E)),
          ],
        ),
      );
}

class _MethodologyLegend extends StatelessWidget {
  const _MethodologyLegend();

  @override
  Widget build(BuildContext context) => _IntelligencePanel(
        title: 'How to read PoliSphere intelligence',
        subtitle:
            'The system distinguishes evidence from interpretation so decision-makers can see uncertainty instead of receiving artificial certainty',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 900
                ? (constraints.maxWidth - 20) / 3
                : constraints.maxWidth;
            const items = [
              (
                'Verified fact',
                'Declared result, judicial outcome or directly sourced measurable event.',
                Icons.verified_outlined,
                pdpGreen
              ),
              (
                'Source-backed interpretation',
                'A reasoned explanation supported by contemporaneous reporting or analysis, but not treated as mathematical proof of causation.',
                Icons.psychology_alt_outlined,
                Color(0xFF7C3AED)
              ),
              (
                'Campaign lesson',
                'A retrospective strategic inference about what a campaign could improve; useful for planning but not an historical fact.',
                Icons.lightbulb_outline_rounded,
                Color(0xFFD97706)
              ),
            ];
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: items
                  .map((item) => SizedBox(
                        width: width,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.$4.withValues(alpha: .055),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: item.$4.withValues(alpha: .13)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(item.$3, color: item.$4, size: 20),
                              const SizedBox(height: 9),
                              Text(item.$1,
                                  style: TextStyle(
                                      color: item.$4,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 5),
                              Text(item.$2,
                                  style: const TextStyle(
                                      color: muted,
                                      fontSize: 9.5,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      );
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF10271D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFA9DFBB), size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white70,
                          height: 1.45,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _IntelligencePanel extends StatelessWidget {
  const _IntelligencePanel({
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
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: const Color(0xFFE1E8E2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 18,
              offset: Offset(0, 7),
            ),
          ],
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
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              color: muted,
                              fontSize: 10.5,
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 19),
            const SizedBox(width: 9),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: ink,
                      height: 1.4,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w650)),
            ),
          ],
        ),
      );
}

Color _partyColor(String party) => switch (party.toUpperCase()) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFF7C3AED),
      _ => const Color(0xFF647067),
    };

Color _confidenceColor(IntelConfidence confidence) => switch (confidence) {
      IntelConfidence.high => pdpGreen,
      IntelConfidence.medium => const Color(0xFFD97706),
      IntelConfidence.low => pdpRed,
    };

String _format(int value) {
  final characters = value.toString().split('').reversed.toList();
  final output = <String>[];
  for (var i = 0; i < characters.length; i++) {
    if (i > 0 && i % 3 == 0) output.add(',');
    output.add(characters[i]);
  }
  return output.reversed.join();
}
