import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'historical_election_data.dart';
import 'widgets.dart';

class OfficialHistoricalElectionsPage extends StatefulWidget {
  const OfficialHistoricalElectionsPage({super.key});

  @override
  State<OfficialHistoricalElectionsPage> createState() =>
      _OfficialHistoricalElectionsPageState();
}

class _OfficialHistoricalElectionsPageState
    extends State<OfficialHistoricalElectionsPage> {
  int selectedYear = 2023;

  BenueHistoricalElection get selected => benueHistoricalElectionsOfficial
      .firstWhere((election) => election.year == selectedYear);

  @override
  Widget build(BuildContext context) {
    final election = selected;
    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 36),
        children: [
          _ArchiveHero(
            selectedYear: selectedYear,
            onSelected: (year) => setState(() => selectedYear = year),
          ),
          const SizedBox(height: 18),
          const _OfficialDataNotice(),
          const SizedBox(height: 18),
          _ElectionSnapshot(election: election),
          const SizedBox(height: 18),
          _VoterRollStory(selectedYear: selectedYear),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1020;
              final result = _ResultBreakdown(election: election);
              final integrity = _ElectionIntegrityCard(election: election);
              if (!wide) {
                return Column(
                  children: [result, const SizedBox(height: 16), integrity],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 13, child: result),
                  const SizedBox(width: 16),
                  Expanded(flex: 8, child: integrity),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          _CandidateTable(election: election),
          const SizedBox(height: 18),
          const _CrossElectionIntelligence(),
          const SizedBox(height: 18),
          _SourceRegistry(election: election),
        ],
      ),
    );
  }
}

class _ArchiveHero extends StatelessWidget {
  const _ArchiveHero({
    required this.selectedYear,
    required this.onSelected,
  });

  final int selectedYear;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF071C13), Color(0xFF0B4D2B), Color(0xFF0B7A3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22064F2A),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 820;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DarkPill(
                        icon: Icons.account_balance_outlined,
                        text: 'INEC ELECTION ARCHIVE'),
                    _DarkPill(
                        icon: Icons.location_on_outlined,
                        text: 'BENUE STATE'),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Historical Election Intelligence',
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
                  'A sourced comparison of Benue governorship elections — results, participation, voter-roll growth, margins and election context.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.45,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );

            final selector = Wrap(
              spacing: 9,
              runSpacing: 9,
              children: benueHistoricalElectionsOfficial.map((election) {
                final active = election.year == selectedYear;
                return InkWell(
                  onTap: () => onSelected(election.year),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 108,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white.withValues(alpha: .09),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: .14),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${election.year}',
                          style: TextStyle(
                            color: active ? pdpGreenDark : Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          election.winnerParty,
                          style: TextStyle(
                            color: active ? muted : Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 22), selector],
              );
            }
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 24),
                selector,
              ],
            );
          },
        ),
      );
}

class _OfficialDataNotice extends StatelessWidget {
  const _OfficialDataNotice();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5EE),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFCDE5D4)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_rounded, color: pdpGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Primary source layer: INEC. 2019 candidate figures are loaded from the official Benue EC8E result sheet; registered-voter, PVC, geography and election-context fields are drawn from INEC general-election reports. 2015 participation figures come from an INEC-hosted declaration-derived dataset.',
                style: TextStyle(
                  color: pdpGreenDark,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ElectionSnapshot extends StatelessWidget {
  const _ElectionSnapshot({required this.election});
  final BenueHistoricalElection election;

  @override
  Widget build(BuildContext context) {
    final turnout = election.turnoutPercent;
    final metrics = <_SnapshotMetric>[
      _SnapshotMetric(
        'Winner',
        election.winnerParty,
        election.winnerName,
        Icons.emoji_events_outlined,
        election.winnerParty == 'PDP' ? pdpGreen : const Color(0xFF2563EB),
      ),
      _SnapshotMetric(
        'Winning margin',
        _format(election.margin),
        '${election.winnerParty} over ${election.runnerUpParty}',
        Icons.stacked_line_chart_rounded,
        const Color(0xFF7C3AED),
      ),
      _SnapshotMetric(
        'Registered voters',
        _format(election.registeredVoters),
        election.pvcsCollected == null
            ? 'INEC voter register'
            : '${_format(election.pvcsCollected!)} PVCs collected',
        Icons.how_to_reg_outlined,
        const Color(0xFF0F766E),
      ),
      _SnapshotMetric(
        'Turnout / participation',
        turnout == null ? 'Not loaded' : '${turnout.toStringAsFixed(1)}%',
        election.accreditedVoters == null
            ? 'Awaiting complete official participation fields'
            : '${_format(election.accreditedVoters!)} accredited',
        Icons.groups_rounded,
        const Color(0xFFD97706),
      ),
    ];

    return _Panel(
      title: '${election.year} election snapshot',
      subtitle: '${election.electionDateLabel} • ${election.supplementary ? 'Supplementary election cycle' : 'Governorship election'}',
      trailing: StatusPill(
        election.supplementary ? 'SUPPLEMENTARY' : 'OFFICIAL ARCHIVE',
        color: election.supplementary ? const Color(0xFFD97706) : pdpGreen,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth >= 1000
              ? 4
              : constraints.maxWidth >= 620
                  ? 2
                  : 1;
          const gap = 12.0;
          final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: metrics
                .map((metric) => SizedBox(
                      width: width,
                      child: _SnapshotMetricCard(metric: metric),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class _SnapshotMetric {
  const _SnapshotMetric(
      this.label, this.value, this.detail, this.icon, this.color);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
}

class _SnapshotMetricCard extends StatelessWidget {
  const _SnapshotMetricCard({required this.metric});
  final _SnapshotMetric metric;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: metric.color.withValues(alpha: .055),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: metric.color.withValues(alpha: .12)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: metric.color.withValues(alpha: .11),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(metric.icon, color: metric.color, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metric.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(metric.label,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(metric.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 9.5,
                          height: 1.25,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _VoterRollStory extends StatelessWidget {
  const _VoterRollStory({required this.selectedYear});
  final int selectedYear;

  @override
  Widget build(BuildContext context) {
    final maxVoters = benueHistoricalElectionsOfficial
        .map((item) => item.registeredVoters)
        .reduce(math.max)
        .toDouble();
    return _Panel(
      title: 'Benue voter-register growth',
      subtitle: 'How the registered electorate changed across the three governorship cycles',
      trailing: const StatusPill('INEC REGISTER DATA'),
      child: Column(
        children: benueHistoricalElectionsOfficial.map((election) {
          final active = election.year == selectedYear;
          final previousIndex = benueHistoricalElectionsOfficial.indexOf(election) - 1;
          final previous = previousIndex >= 0
              ? benueHistoricalElectionsOfficial[previousIndex]
              : null;
          final growth = previous == null
              ? null
              : (election.registeredVoters - previous.registeredVoters) /
                  previous.registeredVoters *
                  100;
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                SizedBox(
                  width: 54,
                  child: Text('${election.year}',
                      style: TextStyle(
                          color: active ? pdpGreenDark : ink,
                          fontWeight: FontWeight.w900)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: election.registeredVoters / maxVoters,
                      minHeight: 14,
                      backgroundColor: const Color(0xFFE9EEEA),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        active ? pdpGreen : const Color(0xFF7FA78C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 118,
                  child: Text(
                    _format(election.registeredVoters),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: ink, fontWeight: FontWeight.w900),
                  ),
                ),
                if (growth != null) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 62,
                    child: Text(
                      '+${growth.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: pdpGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResultBreakdown extends StatelessWidget {
  const _ResultBreakdown({required this.election});
  final BenueHistoricalElection election;

  @override
  Widget build(BuildContext context) {
    final displayCandidates = election.candidates.take(6).toList();
    final maxVotes = displayCandidates.map((e) => e.votes).reduce(math.max).toDouble();
    return _Panel(
      title: 'Result breakdown',
      subtitle: 'Leading candidates and known vote distribution',
      trailing: StatusPill('${election.candidates.length} candidates loaded'),
      child: Column(
        children: displayCandidates.map((candidate) {
          final color = _partyColor(candidate.party);
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(candidate.party,
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(candidate.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: ink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          ),
                          Text(_format(candidate.votes),
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: candidate.votes / maxVotes,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFEDF1EE),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                ),
                if (candidate.elected) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.verified_rounded,
                      color: pdpGreen, size: 18),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ElectionIntegrityCard extends StatelessWidget {
  const _ElectionIntegrityCard({required this.election});
  final BenueHistoricalElection election;

  @override
  Widget build(BuildContext context) {
    final rows = <_InfoRow>[
      _InfoRow('LGAs', '${election.lgas}', 'Administrative coverage'),
      _InfoRow(
          'Registration Areas',
          election.registrationAreas?.toString() ?? 'Not loaded',
          election.registrationAreas == null ? 'Source gap' : 'INEC delimitation'),
      _InfoRow(
          'Polling Units',
          election.pollingUnits == null ? 'Not loaded' : _format(election.pollingUnits!),
          election.pollingUnits == null ? 'Source gap' : 'INEC election structure'),
      _InfoRow(
          'Valid votes',
          election.validVotes == null ? 'Not loaded' : _format(election.validVotes!),
          election.year == 2019
              ? 'Sum of official EC8E candidate scores'
              : 'INEC participation data'),
      _InfoRow(
          'Rejected votes',
          election.rejectedVotes == null ? 'Not loaded' : _format(election.rejectedVotes!),
          election.rejectedVotes == null ? 'Source gap' : 'INEC participation data'),
    ];

    final loaded = rows.where((row) => row.value != 'Not loaded').length;
    final completeness = loaded / rows.length;

    return _Panel(
      title: 'Data completeness',
      subtitle: 'What has been ingested from official-source material',
      trailing: StatusPill('${(completeness * 100).round()}% fields'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: completeness,
              minHeight: 9,
              backgroundColor: const Color(0xFFE9EEEA),
              valueColor: const AlwaysStoppedAnimation<Color>(pdpGreen),
            ),
          ),
          const SizedBox(height: 16),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      row.value == 'Not loaded'
                          ? Icons.pending_outlined
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: row.value == 'Not loaded'
                          ? const Color(0xFFD97706)
                          : pdpGreen,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${row.label}: ${row.value}',
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(row.detail,
                              style: const TextStyle(
                                  color: muted,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9F7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              election.context,
              style: const TextStyle(
                  color: muted,
                  height: 1.45,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow(this.label, this.value, this.detail);
  final String label;
  final String value;
  final String detail;
}

class _CandidateTable extends StatelessWidget {
  const _CandidateTable({required this.election});
  final BenueHistoricalElection election;

  @override
  Widget build(BuildContext context) {
    final complete = election.year == 2019 || election.year == 2015;
    return _Panel(
      title: '${election.year} candidate result archive',
      subtitle: complete
          ? 'Candidate/party results loaded from the available official-source result material'
          : 'Leading declared totals loaded; full 2023 party-by-party EC8E ingestion remains a data task',
      trailing: StatusPill(
        complete ? 'TABLE LOADED' : 'PARTIAL TABLE',
        color: complete ? pdpGreen : const Color(0xFFD97706),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8F5),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              children: [
                SizedBox(width: 46, child: Text('Party', style: _tableHead)),
                SizedBox(width: 10),
                Expanded(child: Text('Candidate / record', style: _tableHead)),
                SizedBox(width: 110, child: Text('Votes', textAlign: TextAlign.right, style: _tableHead)),
                SizedBox(width: 90, child: Text('Status', textAlign: TextAlign.right, style: _tableHead)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          ...election.candidates.asMap().entries.map((entry) {
            final candidate = entry.value;
            final partyColor = _partyColor(candidate.party);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: entry.key == election.candidates.length - 1
                        ? Colors.transparent
                        : const Color(0xFFE9EEEA),
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    child: Text(candidate.party,
                        style: TextStyle(
                            color: partyColor,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(candidate.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    width: 110,
                    child: Text(_format(candidate.votes),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                  ),
                  SizedBox(
                    width: 90,
                    child: candidate.elected
                        ? const Align(
                            alignment: Alignment.centerRight,
                            child: StatusPill('ELECTED'),
                          )
                        : const Text('—',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: muted)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

const _tableHead = TextStyle(
  color: muted,
  fontSize: 9.5,
  fontWeight: FontWeight.w900,
  letterSpacing: .3,
);

class _CrossElectionIntelligence extends StatelessWidget {
  const _CrossElectionIntelligence();

  @override
  Widget build(BuildContext context) {
    final e2015 = benueHistoricalElectionsOfficial[0];
    final e2019 = benueHistoricalElectionsOfficial[1];
    final e2023 = benueHistoricalElectionsOfficial[2];

    return _Panel(
      title: 'What changed across the three cycles?',
      subtitle: 'Executive interpretation anchored to the official result history',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth >= 900 ? 3 : 1;
          const gap = 12.0;
          final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final cards = [
            _InsightData(
              '2015 → 2019',
              'Power changed party',
              'PDP gained ${_signed(e2019.runnerUpVotes == e2019.winnerVotes ? 0 : 120595)} raw votes versus its 2015 total while APC fell. Candidate realignment matters: Samuel Ortom moved from APC in 2015 to PDP in 2019.',
              Icons.swap_horiz_rounded,
              const Color(0xFF7C3AED),
            ),
            _InsightData(
              '2019 → 2023',
              'PDP vote contraction',
              'PDP fell from 434,473 to 223,913 (−210,560), while APC rose to 473,933. This is the largest party-level shift in the three-cycle statewide baseline.',
              Icons.trending_down_rounded,
              pdpRed,
            ),
            _InsightData(
              'Voter register',
              'Electorate expanded',
              'Registered voters increased from 1,927,062 in 2015 to 2,777,727 in 2023 — an increase of ${_format(2777727 - 1927062)} voters.',
              Icons.group_add_outlined,
              pdpGreen,
            ),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards
                .map((card) => SizedBox(
                      width: width,
                      child: _InsightCard(data: card),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class _InsightData {
  const _InsightData(
      this.period, this.title, this.detail, this.icon, this.color);
  final String period;
  final String title;
  final String detail;
  final IconData icon;
  final Color color;
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.data});
  final _InsightData data;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: data.color.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: data.color.withValues(alpha: .11)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.color, size: 20),
                ),
                const Spacer(),
                Text(data.period,
                    style: TextStyle(
                        color: data.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 14),
            Text(data.title,
                style: const TextStyle(
                    color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            Text(data.detail,
                style: const TextStyle(
                    color: muted,
                    height: 1.45,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _SourceRegistry extends StatelessWidget {
  const _SourceRegistry({required this.election});
  final BenueHistoricalElection election;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'INEC source registry',
        subtitle: 'Provenance shown with the selected election — no silent mixing of sources',
        trailing: const StatusPill('SOURCE-AWARE'),
        child: Column(
          children: election.sources.map((source) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9F7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE4EAE5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F3E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance_outlined,
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
                                child: Text(source.label,
                                    style: const TextStyle(
                                        color: ink,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900)),
                              ),
                              StatusPill(source.quality.toUpperCase()),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(source.reference,
                              style: const TextStyle(
                                  color: muted,
                                  fontSize: 10,
                                  height: 1.4,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          Text('Coverage: ${source.coverage}',
                              style: const TextStyle(
                                  color: pdpGreenDark,
                                  fontSize: 9.5,
                                  height: 1.35,
                                  fontWeight: FontWeight.w800)),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E9E3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x09000000),
              blurRadius: 20,
              offset: Offset(0, 8),
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
                              fontSize: 16,
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
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      );
}

class _DarkPill extends StatelessWidget {
  const _DarkPill({required this.icon, required this.text});
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
            Icon(icon, color: Colors.white70, size: 14),
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

Color _partyColor(String party) => switch (party.toUpperCase()) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFFDB2777),
      'PRP' => const Color(0xFFEA580C),
      'SDP' => const Color(0xFF7C3AED),
      _ => const Color(0xFF647067),
    };

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
