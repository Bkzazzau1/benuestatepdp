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
            _Hero(scopeLga: widget.scopeLga),
            const SizedBox(height: 16),
            _Nav(selected: section, onSelected: (v) => setState(() => section = v)),
            const SizedBox(height: 18),
            switch (section) {
              0 => _drivers(),
              1 => _factors(),
              2 => _challenges(),
              3 => _forecast(),
              _ => _sources(),
            },
          ],
        ),
      );

  Widget _drivers() => Column(
        children: [
          _YearSelector(
            selectedYear: selectedYear,
            onSelected: (v) => setState(() => selectedYear = v),
          ),
          const SizedBox(height: 14),
          _ResultVerdict(cycle: cycle),
          const SizedBox(height: 14),
          _DriverGrid(cycle: cycle),
          if (widget.scopeLga != null) ...[
            const SizedBox(height: 14),
            _LgaOverlay(lga: widget.scopeLga!, year: selectedYear),
          ],
          const SizedBox(height: 14),
          _RegionalBoard(cycle: cycle),
          const SizedBox(height: 14),
          _TwoColumn(
            left: _ListPanel(
              title: 'Winning narrative',
              subtitle: '${cycle.winnerParty} • ${cycle.winnerName}',
              items: cycle.winningNarrative,
              color: _partyColor(cycle.winnerParty),
            ),
            right: _ListPanel(
              title: 'Losing narrative',
              subtitle: '${cycle.runnerUpParty} • ${cycle.runnerUpName}',
              items: cycle.losingNarrative,
              color: _partyColor(cycle.runnerUpParty),
            ),
          ),
          const SizedBox(height: 14),
          _Lessons(cycle: cycle),
          const SizedBox(height: 14),
          _Legal(cycle: cycle),
          const SizedBox(height: 14),
          const _Methodology(),
        ],
      );

  Widget _factors() => Column(
        children: [
          const _Intro(
            icon: Icons.radar_rounded,
            title: 'Current strategic factors',
            subtitle:
                'Current signals are kept separate from historical explanations. Their forecast weight stays provisional until backed by fresh polling, field evidence and operational data.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth >= 1050 ? 3 : c.maxWidth >= 680 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
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
            title: 'Current-factor evidence gate',
            subtitle: 'Minimum evidence before a qualitative signal becomes a quantified model input',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Gate('Independent polling'),
                _Gate('Geography-tagged field evidence'),
                _Gate('Organization/readiness records'),
                _Gate('Issue-trend time series'),
                _Gate('Fresh source timestamps'),
                _Gate('Analyst review'),
              ],
            ),
          ),
        ],
      );

  Widget _challenges() => Column(
        children: [
          const _Intro(
            icon: Icons.crisis_alert_outlined,
            title: 'Campaign challenge desk',
            subtitle:
                'Convert political problems into measurable questions with evidence, geography, ownership, action and progress.',
          ),
          const SizedBox(height: 14),
          ...campaignChallenges.map((challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChallengeCard(challenge: challenge),
              )),
          const _Panel(
            title: 'Intelligence doctrine',
            subtitle: 'Every challenge should move through the same evidence discipline',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Gate('Problem → Evidence'),
                _Gate('Evidence → Geography'),
                _Gate('Geography → Owner'),
                _Gate('Owner → Action'),
                _Gate('Action → Measured outcome'),
              ],
            ),
          ),
        ],
      );

  Widget _forecast() {
    final quality = ((organization * .45) + (turnout * .25) + 30)
        .clamp(0, 100)
        .toDouble();
    return Column(
      children: [
        const _Intro(
          icon: Icons.query_stats_rounded,
          title: 'Forecast & scenario laboratory',
          subtitle:
              'Scenario analysis stress-tests assumptions. It is not a win-probability forecast until evidence thresholds are met.',
        ),
        const SizedBox(height: 14),
        _Panel(
          title: 'Forecast engine status',
          subtitle:
              'No fabricated win probability: the production model activates only after minimum evidence thresholds are met.',
          trailing: StatusPill(
            quality >= 70 ? 'Confidence: Medium' : 'Confidence: Low',
            color: quality >= 70 ? pdpGreen : const Color(0xFFD97706),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill('Data quality ${quality.toStringAsFixed(0)}%'),
                  const StatusPill('SCENARIO — NOT PREDICTION', color: Color(0xFF7C3AED)),
                  const StatusPill('Human review required', color: Color(0xFF0F766E)),
                ],
              ),
              const SizedBox(height: 14),
              const _ForecastGates(),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Panel(
          title: 'Scenario simulator',
          subtitle: 'These controls are assumptions, not measured voter intention.',
          child: Column(
            children: [
              _slider('Turnout assumption', turnout, (v) => setState(() => turnout = v)),
              _slider('Campaign organization readiness', organization,
                  (v) => setState(() => organization = v)),
              _slider('Opposition fragmentation', oppositionFragmentation,
                  (v) => setState(() => oppositionFragmentation = v)),
              const _Notice(
                icon: Icons.science_outlined,
                color: pdpGreen,
                text:
                    'Production forecasting should use Monte Carlo simulation with LGA-level history, turnout distributions, methodologically sound polling, current organization data and explicit uncertainty ranges.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
              ),
              Text('${value.toStringAsFixed(0)}%',
                  style: const TextStyle(color: pdpGreen, fontWeight: FontWeight.w900)),
            ]),
            Slider(value: value, min: 0, max: 100, onChanged: onChanged),
          ],
        ),
      );

  Widget _sources() => Column(
        children: [
          const _Intro(
            icon: Icons.fact_check_outlined,
            title: 'Evidence & source registry',
            subtitle:
                'Facts, source-backed interpretations and campaign lessons are labeled separately so uncertainty stays visible.',
          ),
          const SizedBox(height: 14),
          _YearSelector(
            selectedYear: selectedYear,
            onSelected: (v) => setState(() => selectedYear = v),
          ),
          const SizedBox(height: 14),
          _Panel(
            title: '${cycle.year} intelligence sources',
            subtitle: 'Evidence supporting the selected cycle explanation',
            trailing: StatusPill('${cycle.sources.length} sources'),
            child: Column(
              children: cycle.sources.map((source) => _SourceRow(source: source)).toList(),
            ),
          ),
          const SizedBox(height: 14),
          const _Methodology(),
        ],
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.scopeLga});
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
          boxShadow: const [BoxShadow(color: Color(0x22064F2A), blurRadius: 30, offset: Offset(0, 13))],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 840;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                const _DarkPill('STRATEGIC INTELLIGENCE'),
                _DarkPill(scopeLga == null ? 'BENUE STATE' : '$scopeLga LGA'),
              ]),
              const SizedBox(height: 18),
              Text('Election Intelligence Centre',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 29 : 39,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -.8)),
              const SizedBox(height: 10),
              const Text(
                'Understand what happened, why it happened, where it happened, how strong the evidence is — and what lessons should shape the next campaign decision.',
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5, fontWeight: FontWeight.w600),
              ),
            ],
          );
          const safeguards = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DarkPill('SOURCE-AWARE'),
              _DarkPill('HUMAN REVIEW'),
              _DarkPill('NO INDIVIDUAL PROFILING'),
            ],
          );
          return compact
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, const SizedBox(height: 18), safeguards])
              : Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(flex: 12, child: copy), const SizedBox(width: 22), const Expanded(flex: 8, child: safeguards)]);
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
            style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900, letterSpacing: .5)),
      );
}

class _Nav extends StatelessWidget {
  const _Nav({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;
  static const labels = ['Election Drivers', 'Current Factors', 'Challenges', 'Forecast & Scenarios', 'Evidence Sources'];
  static const icons = [Icons.auto_graph_rounded, Icons.radar_rounded, Icons.crisis_alert_outlined, Icons.query_stats_rounded, Icons.fact_check_outlined];

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE1E8E2))),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(labels.length, (i) {
            final active = i == selected;
            return InkWell(
              onTap: () => onSelected(i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                decoration: BoxDecoration(color: active ? const Color(0xFFE7F3EA) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icons[i], size: 17, color: active ? pdpGreen : muted),
                  const SizedBox(width: 7),
                  Text(labels[i], style: TextStyle(color: active ? pdpGreenDark : ink, fontSize: 11, fontWeight: FontWeight.w900)),
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
        subtitle: 'Select a governorship election to inspect the causal narrative',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: electionCycleIntelligence.map((c) {
            final active = c.year == selectedYear;
            return ChoiceChip(
              selected: active,
              onSelected: (_) => onSelected(c.year),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text('${c.year} • ${c.winnerParty} • ${c.winnerName}'),
              ),
              labelStyle: TextStyle(color: active ? pdpGreenDark : ink, fontWeight: FontWeight.w900),
              selectedColor: const Color(0xFFE7F3EA),
              backgroundColor: const Color(0xFFF7F9F7),
              side: BorderSide(color: active ? pdpGreen : const Color(0xFFE2E8E3)),
            );
          }).toList(),
        ),
      );
}

class _ResultVerdict extends StatelessWidget {
  const _ResultVerdict({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _Panel(
        title: '${cycle.year} intelligence verdict',
        subtitle: 'Declared result plus the current best-supported explanation',
        trailing: StatusPill('${cycle.winnerParty} WON', color: _partyColor(cycle.winnerParty)),
        child: LayoutBuilder(builder: (context, c) {
          final result = _Box(
            color: _partyColor(cycle.winnerParty),
            title: '${cycle.winnerName} • ${cycle.winnerParty}',
            body:
                '${_format(cycle.winnerVotes)} votes\nRunner-up: ${cycle.runnerUpName} (${cycle.runnerUpParty}) ${_format(cycle.runnerUpVotes)}\nWinning margin: ${_format(cycle.margin)}',
          );
          final verdict = _Box(color: pdpGreen, title: 'WHY THE ELECTION WAS WON', body: cycle.verdict);
          return c.maxWidth < 800
              ? Column(children: [result, const SizedBox(height: 12), verdict])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 7, child: result), const SizedBox(width: 12), Expanded(flex: 13, child: verdict)]);
        }),
      );
}

class _DriverGrid extends StatelessWidget {
  const _DriverGrid({required this.cycle});
  final ElectionCycleIntelligence cycle;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Why the election was won',
        subtitle: 'Ranked drivers with impact, evidence class and confidence — not a claim that one factor alone caused the result',
        trailing: StatusPill('${cycle.drivers.length} drivers'),
        child: LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth >= 1020 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cycle.drivers.map((d) => SizedBox(width: width, child: _DriverCard(driver: d))).toList(),
          );
        }),
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
      decoration: BoxDecoration(color: const Color(0xFFFAFBFA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE4E9E5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(driver.title, style: const TextStyle(color: ink, fontSize: 13.5, fontWeight: FontWeight.w900))), StatusPill('Impact ${driver.impact}/5', color: color)]),
        const SizedBox(height: 5),
        Text(driver.category.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .7)),
        const SizedBox(height: 8),
        Text(driver.detail, style: const TextStyle(color: muted, height: 1.47, fontSize: 10.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 11),
        Row(children: List.generate(5, (i) => Expanded(child: Container(height: 6, margin: EdgeInsets.only(right: i == 4 ? 0 : 4), decoration: BoxDecoration(color: i < driver.impact ? color : const Color(0xFFE7ECE8), borderRadius: BorderRadius.circular(99)))))),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          StatusPill(driver.effect, color: color),
          StatusPill('Confidence: ${confidenceLabel(driver.confidence)}', color: _confidenceColor(driver.confidence)),
          StatusPill(evidenceTypeLabel(driver.evidenceType), color: const Color(0xFF0F766E)),
        ]),
      ]),
    );
  }
}

class _LgaOverlay extends StatelessWidget {
  const _LgaOverlay({required this.lga, required this.year});
  final String lga;
  final int year;
  @override
  Widget build(BuildContext context) {
    final row = lgaResultFor(year, lga);
    if (row == null) {
      return _Panel(
        title: '$lga evidence overlay • $year',
        subtitle: 'No sourced LGA result is loaded for this cycle.',
        trailing: const StatusPill('SOURCE GAP', color: Color(0xFFD97706)),
        child: const _Notice(icon: Icons.warning_amber_rounded, color: Color(0xFFD97706), text: 'PoliSphere will not manufacture an LGA-level explanation from statewide totals. Historical local conclusions unlock only after a sourced LGA row is available.'),
      );
    }
    if (!row.hasElection) {
      return _Panel(title: '$lga evidence overlay • $year', subtitle: row.sourceLabel, trailing: const StatusPill('NO POLL', color: Color(0xFFD97706)), child: _Notice(icon: Icons.do_not_disturb_alt_outlined, color: const Color(0xFFD97706), text: row.sourceNote));
    }
    return _Panel(
      title: '$lga evidence overlay • $year',
      subtitle: 'Local result evidence layered over the statewide explanation',
      trailing: StatusPill('${row.leadingParty} LED', color: _partyColor(row.leadingParty)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          _Metric('APC', _format(row.apcVotes), const Color(0xFF2563EB)),
          _Metric('PDP', _format(row.pdpVotes), pdpGreen),
          if (row.lpVotes > 0) _Metric('LP', _format(row.lpVotes), const Color(0xFF7C3AED)),
          _Metric('Lead margin', _format(row.leadingMargin), _partyColor(row.leadingParty)),
          if (row.turnoutPercent != null) _Metric('Turnout', '${row.turnoutPercent!.toStringAsFixed(1)}%', const Color(0xFFD97706)),
        ]),
        const SizedBox(height: 11),
        Text(row.sourceNote, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.4, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(color: color.withValues(alpha: .07), borderRadius: BorderRadius.circular(11), border: Border.all(color: color.withValues(alpha: .14))),
        child: Text('$label  $value', style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w900)),
      );
}

class _RegionalBoard extends StatelessWidget {
  const _RegionalBoard({required this.cycle});
  final ElectionCycleIntelligence cycle;
  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Regional dynamics',
        subtitle: 'Where the result was built, with data-quality limitations kept visible',
        child: Column(
          children: cycle.regionalDynamics.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF7F9F7), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE4E9E5))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Expanded(child: Text(r.title, style: const TextStyle(color: ink, fontSize: 12.5, fontWeight: FontWeight.w900))), StatusPill('Confidence: ${confidenceLabel(r.confidence)}', color: _confidenceColor(r.confidence))]),
              const SizedBox(height: 3),
              Text(r.geography, style: const TextStyle(color: pdpGreenDark, fontSize: 9.5, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              Text(r.result, style: const TextStyle(color: ink, fontSize: 10.5, height: 1.4, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(r.interpretation, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.45, fontWeight: FontWeight.w600)),
            ]),
          )).toList(),
        ),
      );
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.left, required this.right});
  final Widget left;
  final Widget right;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) => c.maxWidth >= 900
      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: left), const SizedBox(width: 14), Expanded(child: right)])
      : Column(children: [left, const SizedBox(height: 14), right]));
}

class _ListPanel extends StatelessWidget {
  const _ListPanel({required this.title, required this.subtitle, required this.items, required this.color});
  final String title;
  final String subtitle;
  final List<String> items;
  final Color color;
  @override
  Widget build(BuildContext context) => _Panel(
        title: title,
        subtitle: subtitle,
        child: Column(children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 7, height: 7, margin: const EdgeInsets.only(top: 5), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 9),
            Expanded(child: Text(item, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.45, fontWeight: FontWeight.w600))),
          ]),
        )).toList()),
      );
}

class _Lessons extends StatelessWidget {
  const _Lessons({required this.cycle});
  final ElectionCycleIntelligence cycle;
  @override
  Widget build(BuildContext context) {
    final winner = cycle.lessons.where((e) => e.forWinner).toList();
    final loser = cycle.lessons.where((e) => !e.forWinner).toList();
    return _Panel(
      title: 'What could the campaigns have done differently?',
      subtitle: 'Retrospective lessons — explicitly separated from historical facts',
      trailing: const StatusPill('CAMPAIGN LESSONS', color: Color(0xFF7C3AED)),
      child: _TwoColumn(
        left: _LessonBox('${cycle.winnerParty} / winner lessons', winner, _partyColor(cycle.winnerParty)),
        right: _LessonBox('${cycle.runnerUpParty} / losing-campaign lessons', loser, _partyColor(cycle.runnerUpParty)),
      ),
    );
  }
}

class _LessonBox extends StatelessWidget {
  const _LessonBox(this.title, this.items, this.color);
  final String title;
  final List<StrategicLesson> items;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color.withValues(alpha: .045), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: .12))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(item.detail, style: const TextStyle(color: muted, fontSize: 10, height: 1.42, fontWeight: FontWeight.w600)),
          ]))),
        ]),
      );
}

class _Legal extends StatelessWidget {
  const _Legal({required this.cycle});
  final ElectionCycleIntelligence cycle;
  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Legal & institutional aftermath',
        subtitle: 'What happened after the vote and how the declared result survived institutional review',
        child: Column(children: cycle.legalAftermath.map((item) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(backgroundColor: Color(0xFFE6F3E9), child: Icon(Icons.gavel_outlined, color: pdpGreen, size: 19)),
          title: Text('${item.stage} — ${item.outcome}', style: const TextStyle(color: ink, fontSize: 11.5, fontWeight: FontWeight.w900)),
          subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(item.detail, style: const TextStyle(color: muted, fontSize: 10, height: 1.4, fontWeight: FontWeight.w600))),
        )).toList()),
      );
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({required this.factor});
  final IntelligenceFactor factor;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFE2E9E3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(factor.title, style: const TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(factor.detail, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.45, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: [StatusPill(factor.status), StatusPill('Importance: ${factor.importance}', color: const Color(0xFF7C3AED)), StatusPill('Confidence: ${factor.confidence}', color: const Color(0xFFD97706))]),
        ]),
      );
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});
  final CampaignChallenge challenge;
  @override
  Widget build(BuildContext context) {
    final color = challenge.severity == 'Critical' ? pdpRed : challenge.severity == 'High' ? const Color(0xFFD97706) : pdpGreen;
    return _Panel(
      title: challenge.title,
      subtitle: 'Owner: ${challenge.owner}',
      trailing: StatusPill(challenge.severity, color: color),
      child: Text(challenge.detail, style: const TextStyle(color: muted, fontSize: 11, height: 1.48, fontWeight: FontWeight.w600)),
    );
  }
}

class _ForecastGates extends StatelessWidget {
  const _ForecastGates();
  @override
  Widget build(BuildContext context) {
    const rows = [
      ['Historical LGA coverage', 'Loaded with quality flags', 'yes'],
      ['Current polling', 'Methodologically sound poll required', 'no'],
      ['Turnout distribution', 'Validation still required', 'no'],
      ['Campaign readiness', 'Prototype records only', 'no'],
      ['Current factor calibration', 'Effect sizes not calibrated', 'no'],
      ['Uncertainty model', 'Monte Carlo architecture planned', 'no'],
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: rows.map((r) => Container(
        width: 310,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: const Color(0xFFF7F9F7), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE3E9E4))),
        child: Row(children: [
          Icon(r[2] == 'yes' ? Icons.check_circle_outline_rounded : Icons.pending_outlined, size: 18, color: r[2] == 'yes' ? pdpGreen : const Color(0xFFD97706)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r[0], style: const TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.w900)), Text(r[1], style: const TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w600))])),
        ]),
      )).toList(),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});
  final IntelligenceSourceRef source;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFF7F9F7), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE3E9E4))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.source_outlined, color: pdpGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(source.publisher, style: const TextStyle(color: pdpGreenDark, fontSize: 9.5, fontWeight: FontWeight.w900)),
            Text(source.title, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
            Text(source.reference, style: const TextStyle(color: muted, fontSize: 9.5, fontWeight: FontWeight.w600)),
          ])),
          const SizedBox(width: 8),
          StatusPill(source.quality.toUpperCase(), color: const Color(0xFF0F766E)),
        ]),
      );
}

class _Methodology extends StatelessWidget {
  const _Methodology();
  @override
  Widget build(BuildContext context) => const _Panel(
        title: 'How to read PoliSphere intelligence',
        subtitle: 'Evidence, interpretation and strategic inference are deliberately separated',
        child: Wrap(spacing: 10, runSpacing: 10, children: [
          _Method('Verified fact', 'Declared result, judicial outcome or directly sourced measurable event.', pdpGreen),
          _Method('Source-backed interpretation', 'Reasoned explanation supported by contemporary reporting; not mathematical proof of causation.', Color(0xFF7C3AED)),
          _Method('Campaign lesson', 'Retrospective strategic inference useful for planning, but not an historical fact.', Color(0xFFD97706)),
        ]),
      );
}

class _Method extends StatelessWidget {
  const _Method(this.title, this.body, this.color);
  final String title;
  final String body;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: 300,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: color.withValues(alpha: .055), borderRadius: BorderRadius.circular(13), border: Border.all(color: color.withValues(alpha: .13))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(body, style: const TextStyle(color: muted, fontSize: 9.5, height: 1.4, fontWeight: FontWeight.w600))]),
      );
}

class _Gate extends StatelessWidget {
  const _Gate(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(color: const Color(0xFFF5F8F5), borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFFE1E8E2))),
        child: Text(label, style: const TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.w800)),
      );
}

class _Intro extends StatelessWidget {
  const _Intro({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: const Color(0xFF10271D), borderRadius: BorderRadius.circular(20)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: const Color(0xFFA9DFBB), size: 23),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.45, fontWeight: FontWeight.w600))])),
        ]),
      );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.subtitle, required this.child, this.trailing});
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE1E8E2)), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 18, offset: Offset(0, 7))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: muted, fontSize: 10.5, height: 1.35, fontWeight: FontWeight.w600))])),
            if (trailing != null) ...[const SizedBox(width: 10), trailing!],
          ]),
          const SizedBox(height: 15),
          child,
        ]),
      );
}

class _Box extends StatelessWidget {
  const _Box({required this.color, required this.title, required this.body});
  final Color color;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withValues(alpha: .055), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withValues(alpha: .13))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(body, style: const TextStyle(color: ink, fontSize: 10.5, height: 1.5, fontWeight: FontWeight.w600))]),
      );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: color.withValues(alpha: .07), borderRadius: BorderRadius.circular(12)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 19), const SizedBox(width: 9), Expanded(child: Text(text, style: const TextStyle(color: ink, fontSize: 10.5, height: 1.4, fontWeight: FontWeight.w600)))]),
      );
}

Color _partyColor(String party) => switch (party.toUpperCase()) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFF7C3AED),
      _ => muted,
    };

Color _confidenceColor(IntelConfidence value) => switch (value) {
      IntelConfidence.high => pdpGreen,
      IntelConfidence.medium => const Color(0xFFD97706),
      IntelConfidence.low => pdpRed,
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
