import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Command Overview',
            subtitle:
                'Benue State PDP Governorship Campaign • Campaign intelligence, field operations and election readiness in one view.',
            trailing: StatusPill('STATEWIDE COMMAND'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final width = c.maxWidth;
              final columns = width > 1180 ? 4 : width > 680 ? 2 : 1;
              const gap = 14.0;
              final itemWidth = (width - gap * (columns - 1)) / columns;
              const cards = [
                MetricCard(
                    label: 'Local Government Areas',
                    value: '23',
                    icon: Icons.map_outlined),
                MetricCard(
                    label: 'Wards / Registration Areas',
                    value: '276',
                    icon: Icons.grid_view_rounded),
                MetricCard(
                    label: 'Polling Units',
                    value: '5,102',
                    icon: Icons.how_to_vote_outlined),
                MetricCard(
                    label: '2023 Registered Voters',
                    value: '2.78M',
                    icon: Icons.groups_2_outlined,
                    detail: 'Baseline; update before election'),
              ];
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: cards
                    .map((card) => SizedBox(width: itemWidth, child: card))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 980;
            final left = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Election history at a glance',
                      'Raw governorship vote totals for APC and PDP.'),
                  const SizedBox(height: 12),
                  ...historicalElections.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text('${e.year}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900)),
                            const Spacer(),
                            StatusPill('${e.winner} won',
                                color: e.winner == 'PDP'
                                    ? pdpGreen
                                    : const Color(0xFF2E62D8)),
                          ]),
                          ElectionBars(apc: e.apcVotes, pdp: e.pdpVotes),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
            final right = Column(
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Current intelligence factors',
                          'High-level signals requiring continuous evidence review.'),
                      const SizedBox(height: 8),
                      ...currentFactors.take(4).map(
                            (f) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFEAF5EE),
                                child: Icon(Icons.insights_rounded,
                                    size: 18, color: pdpGreen),
                              ),
                              title: Text(f.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              subtitle: Text(f.status),
                              trailing: StatusPill(f.importance),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Situation Room',
                          'Operational snapshot for the command team.'),
                      const SizedBox(height: 14),
                      const _StatRow('Critical incidents', '2', pdpRed),
                      const _StatRow('Reports awaiting review', '17', Color(0xFFD68A00)),
                      const _StatRow('LGAs reporting today', '14 / 23', pdpGreen),
                      const _StatRow('Data confidence', 'Prototype', Color(0xFF6657B5)),
                    ],
                  ),
                ),
              ],
            );
            if (!wide) return Column(children: [left, const SizedBox(height: 14), right]);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: left),
                const SizedBox(width: 14),
                Expanded(flex: 2, child: right),
              ],
            );
          }),
        ],
      );
}

class ElectionIntelligencePage extends StatefulWidget {
  const ElectionIntelligencePage({super.key});

  @override
  State<ElectionIntelligencePage> createState() => _ElectionIntelligencePageState();
}

class _ElectionIntelligencePageState extends State<ElectionIntelligencePage> {
  int tab = 0;
  double turnout = 38;
  double organization = 55;
  double oppositionFragmentation = 35;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Election Intelligence',
            subtitle:
                'Historical results, current factors, campaign challenges and transparent scenario analysis.',
            trailing: StatusPill('ANALYTICS'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tab('Historical Elections', 0),
              _tab('Current Factors', 1),
              _tab('Challenges', 2),
              _tab('Forecast & Scenarios', 3),
              _tab('Data Sources', 4),
            ],
          ),
          const SizedBox(height: 18),
          if (tab == 0) _historical(),
          if (tab == 1) _factors(),
          if (tab == 2) _challenges(),
          if (tab == 3) _forecast(),
          if (tab == 4) _sources(),
        ],
      );

  Widget _tab(String text, int index) => ChoiceChip(
        label: Text(text),
        selected: tab == index,
        onSelected: (_) => setState(() => tab = index),
        selectedColor: pdpGreen.withOpacity(.12),
        side: BorderSide(color: tab == index ? pdpGreen : const Color(0xFFDCE5DE)),
        labelStyle: TextStyle(
          color: tab == index ? pdpGreenDark : ink,
          fontWeight: FontWeight.w800,
        ),
      );

  Widget _historical() => Column(
        children: historicalElections
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5F1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text('${e.year}',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${e.winner} victory',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w900)),
                              Text(e.note, style: const TextStyle(color: muted)),
                            ],
                          ),
                        ),
                        StatusPill('Margin ${_num(e.margin)}'),
                      ]),
                      const SizedBox(height: 10),
                      ElectionBars(apc: e.apcVotes, pdp: e.pdpVotes),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );

  Widget _factors() => SectionCard(
        child: Column(
          children: currentFactors
              .map(
                (f) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFE8EEE9))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.adjust_rounded, color: pdpGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text(f.detail,
                                style: const TextStyle(color: muted, height: 1.45)),
                            const SizedBox(height: 8),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              StatusPill(f.status),
                              StatusPill('Importance: ${f.importance}',
                                  color: const Color(0xFF6A5ACD)),
                              StatusPill('Confidence: ${f.confidence}',
                                  color: const Color(0xFFD68A00)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _challenges() => Column(
        children: campaignChallenges
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 74,
                        decoration: BoxDecoration(
                          color: c.severity == 'Critical'
                              ? pdpRed
                              : c.severity == 'High'
                                  ? const Color(0xFFD68A00)
                                  : pdpGreen,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.title,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 5),
                            Text(c.detail,
                                style: const TextStyle(color: muted, height: 1.4)),
                            const SizedBox(height: 10),
                            Wrap(spacing: 8, children: [
                              StatusPill(c.severity,
                                  color: c.severity == 'Critical'
                                      ? pdpRed
                                      : const Color(0xFFD68A00)),
                              StatusPill(c.owner, color: const Color(0xFF5E5CB2)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );

  Widget _forecast() {
    final dataQuality = ((organization * .45) + (turnout * .25) + 30).clamp(0, 100);
    final confidence = dataQuality >= 70 ? 'Medium' : 'Low';
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(context, 'Forecast engine status',
                  'No fabricated win probability: the production model activates only after minimum evidence thresholds are met.'),
              const SizedBox(height: 16),
              Wrap(spacing: 10, runSpacing: 10, children: [
                StatusPill('Confidence: $confidence', color: const Color(0xFFD68A00)),
                StatusPill('Data quality ${dataQuality.toStringAsFixed(0)}%'),
                const StatusPill('Current output: Scenario only', color: Color(0xFF6A5ACD)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(context, 'Scenario simulator',
                  'Change assumptions to stress-test the race. These sliders do not represent measured voter intention.'),
              const SizedBox(height: 18),
              _slider('Turnout assumption', turnout, (v) => setState(() => turnout = v)),
              _slider('Campaign organization readiness', organization,
                  (v) => setState(() => organization = v)),
              _slider('Opposition fragmentation', oppositionFragmentation,
                  (v) => setState(() => oppositionFragmentation = v)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F7F4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: pdpGreen),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Production forecasting should use Monte Carlo simulation with LGA-level historical results, turnout distributions, current polling, organization data and explicit uncertainty ranges.',
                        style: TextStyle(fontWeight: FontWeight.w600, color: ink),
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

  Widget _slider(String label, double value, ValueChanged<double> onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
            Text('${value.toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w900, color: pdpGreen)),
          ]),
          Slider(value: value, min: 0, max: 100, onChanged: onChanged),
          const SizedBox(height: 8),
        ],
      );

  Widget _sources() => SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, 'Evidence and provenance',
                'Every production metric must retain source, timestamp, geography and confidence.'),
            const SizedBox(height: 12),
            ...dataSources.map((s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_outlined, color: pdpGreen),
                  title: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
          ],
        ),
      );
}

class CampaignTrendsPage extends StatelessWidget {
  const CampaignTrendsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Campaign Trends',
            subtitle:
                'Momentum, organization, public-signal and operational trends over time — with source quality kept visible.',
            trailing: StatusPill('TREND CENTRE'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (columns - 1)) / columns;
            const cards = [
              MetricCard(label: 'Momentum Index', value: '61', icon: Icons.trending_up_rounded),
              MetricCard(label: 'Field Coverage', value: '58%', icon: Icons.location_on_outlined),
              MetricCard(label: 'Organization', value: '55%', icon: Icons.account_tree_outlined),
              MetricCard(label: 'Data Confidence', value: 'Low', icon: Icons.fact_check_outlined, accent: Color(0xFFD68A00)),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList(),
            );
          }),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Campaign momentum — prototype series',
                    'Replace with verified weekly aggregates from field activity, polling, media and organization feeds.'),
                const SizedBox(height: 18),
                MiniLineChart(values: campaignTrend.map((e) => e.value).toList()),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: campaignTrend
                      .map((e) => Text(e.label,
                          style: const TextStyle(color: muted, fontWeight: FontWeight.w700)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 900;
            final issue = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Issue trend monitor',
                      'Aggregate public-interest topics; no individual political profiling.'),
                  const SizedBox(height: 14),
                  const _ProgressItem('Security', .78),
                  const _ProgressItem('Cost of living', .69),
                  const _ProgressItem('Agriculture', .57),
                  const _ProgressItem('Roads & infrastructure', .46),
                  const _ProgressItem('Employment', .35),
                ],
              ),
            );
            final timeline = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Campaign event timeline',
                      'Correlate major public events with later movement in verified indicators.'),
                  const SizedBox(height: 12),
                  const _TimelineItem('This week', 'State campaign structure review', 'Operations'),
                  const _TimelineItem('Last week', 'Stakeholder engagement series', 'Campaign'),
                  const _TimelineItem('2 weeks ago', 'Media narrative shift detected', 'Intelligence'),
                  const _TimelineItem('3 weeks ago', 'Ward coverage audit initiated', 'Field'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: issue),
                    const SizedBox(width: 14),
                    Expanded(child: timeline),
                  ])
                : Column(children: [issue, const SizedBox(height: 14), timeline]);
          }),
        ],
      );
}

class SituationRoomPage extends StatelessWidget {
  const SituationRoomPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Situation Room',
            subtitle: 'Live field reporting, incidents, escalation, communications and command decisions.',
            trailing: StatusPill('LIVE OPERATIONS', color: pdpRed),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final count = c.maxWidth > 1000 ? 4 : c.maxWidth > 600 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (count - 1)) / count;
            const items = [
              MetricCard(label: 'Field officers online', value: '128', icon: Icons.radar_rounded),
              MetricCard(label: 'Open incidents', value: '23', icon: Icons.warning_amber_rounded, accent: Color(0xFFD68A00)),
              MetricCard(label: 'Critical alerts', value: '2', icon: Icons.crisis_alert_rounded, accent: pdpRed),
              MetricCard(label: 'Reports today', value: '184', icon: Icons.feed_outlined),
            ];
            return Wrap(spacing: gap, runSpacing: gap, children: items.map((e) => SizedBox(width: width, child: e)).toList());
          }),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 960;
            final map = SectionCard(
              child: SizedBox(
                height: 430,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'Benue operational map',
                        'Interactive LGA → ward → polling-unit layer will connect to field coordinates.'),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE6F2E8), Color(0xFFD7E8DA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: benueLgas
                                .map((lga) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.86),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(lga,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            final feed = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Priority feed', 'Structured operational events.'),
                  const SizedBox(height: 8),
                  const _Incident('Critical', 'Logistics interruption reported', 'Makurdi', pdpRed),
                  const _Incident('High', 'Field report awaiting verification', 'Gboko', Color(0xFFD68A00)),
                  const _Incident('Medium', 'Ward coordinator check-in overdue', 'Otukpo', Color(0xFF6A5ACD)),
                  const _Incident('Info', 'Campaign activity completed', 'Vandeikya', pdpGreen),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: map),
                    const SizedBox(width: 14),
                    Expanded(flex: 2, child: feed),
                  ])
                : Column(children: [map, const SizedBox(height: 14), feed]);
          }),
        ],
      );
}

class FieldNetworkPage extends StatelessWidget {
  const FieldNetworkPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Field Network & Readiness',
            subtitle: 'Campaign structure, agent coverage, ward readiness, tasks and logistics.',
            trailing: StatusPill('23 LGAs'),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'LGA readiness board',
                    'Prototype coverage values; production values come from assignments, training, check-ins and logistics.'),
                const SizedBox(height: 16),
                ...benueLgas.asMap().entries.map((entry) {
                  final pct = 35 + ((entry.key * 13) % 61);
                  return _ReadinessRow(entry.value, pct);
                }),
              ],
            ),
          ),
        ],
      );
}

class ElectionDayPage extends StatelessWidget {
  const ElectionDayPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Election Day Command',
            subtitle:
                'Agent deployment, polling-unit reporting, incident command, unofficial campaign result capture and verification.',
            trailing: StatusPill('READINESS MODE', color: Color(0xFFD68A00)),
          ),
          const SizedBox(height: 18),
          const PrototypeBanner(),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 600 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            const items = [
              MetricCard(label: 'Polling units', value: '5,102', icon: Icons.how_to_vote_outlined),
              MetricCard(label: 'Agent coverage', value: '0%', icon: Icons.badge_outlined, detail: 'Awaiting verified roster'),
              MetricCard(label: 'Results verified', value: '0', icon: Icons.verified_outlined),
              MetricCard(label: 'Disputed entries', value: '0', icon: Icons.gavel_outlined, accent: pdpRed),
            ];
            return Wrap(spacing: gap, runSpacing: gap, children: items.map((e) => SizedBox(width: width, child: e)).toList());
          }),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Election-day workflow',
                    'Every result remains explicitly labelled campaign-collected and unofficial until INEC declares official results.'),
                const SizedBox(height: 16),
                const _WorkflowStep('1', 'Agent arrival & check-in', 'Confirm assigned polling unit and operational readiness.'),
                const _WorkflowStep('2', 'Poll opening report', 'Record opening status and permitted observations.'),
                const _WorkflowStep('3', 'Incident reporting', 'Escalate security, logistics or legal issues with evidence.'),
                const _WorkflowStep('4', 'Result capture', 'Upload permitted result image and enter figures.'),
                const _WorkflowStep('5', 'Independent verification', 'Second authorized officer verifies critical entries.'),
                const _WorkflowStep('6', 'State aggregation', 'Aggregate PU → ward → LGA → state with anomaly flags.'),
              ],
            ),
          ),
        ],
      );
}

class DataGovernancePage extends StatelessWidget {
  const DataGovernancePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const PageHeading(
            title: 'Data, Reports & Governance',
            subtitle: 'Source provenance, access control, audit trails and export-ready reporting.',
            trailing: StatusPill('AUDITABLE'),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 900;
            final source = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Data source registry', 'Required production evidence channels.'),
                  const SizedBox(height: 12),
                  ...dataSources.map((s) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.storage_rounded, color: pdpGreen),
                        title: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
                        trailing: const StatusPill('Tracked'),
                      )),
                ],
              ),
            );
            final controls = SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Governance controls', 'Baseline controls for the production platform.'),
                  const SizedBox(height: 12),
                  const _Control('Role-based access', 'Limit modules and geography by assigned role.'),
                  const _Control('Audit history', 'Record who changed critical data and when.'),
                  const _Control('Evidence provenance', 'Retain source, time, geography and verifier.'),
                  const _Control('No individual political profiling', 'Use aggregate public and campaign-operational data.'),
                  const _Control('Forecast transparency', 'Expose assumptions, confidence and missing data.'),
                  const _Control('Export controls', 'Authorized PDF/CSV reports with version metadata.'),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: source),
                    const SizedBox(width: 14),
                    Expanded(child: controls),
                  ])
                : Column(children: [source, const SizedBox(height: 14), controls]);
          }),
        ],
      );
}

Widget _sectionTitle(BuildContext context, String title, String subtitle) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted)),
      ],
    );

String _num(int value) {
  final chars = value.toString().split('').reversed.toList();
  final out = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) out.add(',');
    out.add(chars[i]);
  }
  return out.reversed.join();
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(color: muted))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
        ]),
      );
}

class _ProgressItem extends StatelessWidget {
  const _ProgressItem(this.label, this.value);
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
              Text('${(value * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(value: value, minHeight: 9, backgroundColor: const Color(0xFFE8EFEA)),
            ),
          ],
        ),
      );
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem(this.when, this.title, this.category);
  final String when;
  final String title;
  final String category;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: const BoxDecoration(color: pdpGreen, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text('$when • $category', style: const TextStyle(color: muted)),
          ])),
        ]),
      );
}

class _Incident extends StatelessWidget {
  const _Incident(this.severity, this.title, this.lga, this.color);
  final String severity;
  final String title;
  final String lga;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE8EEE9)))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.circle, size: 12, color: color),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text('$lga • $severity', style: const TextStyle(color: muted)),
          ])),
        ]),
      );
}

class _ReadinessRow extends StatelessWidget {
  const _ReadinessRow(this.name, this.value);
  final String name;
  final int value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          SizedBox(width: 120, child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(value: value / 100, minHeight: 10, backgroundColor: const Color(0xFFE7EEE8)),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 44, child: Text('$value%', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w900))),
        ]),
      );
}

class _WorkflowStep extends StatelessWidget {
  const _WorkflowStep(this.number, this.title, this.detail);
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(backgroundColor: pdpGreen, foregroundColor: Colors.white, child: Text(number, style: const TextStyle(fontWeight: FontWeight.w900))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted)),
          ])),
        ]),
      );
}

class _Control extends StatelessWidget {
  const _Control(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF5EE),
          child: Icon(Icons.shield_outlined, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(detail),
      );
}
