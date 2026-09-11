import 'package:flutter/material.dart';

import 'lga_historical_data.dart';
import 'widgets.dart';

class LgaHistoricalIntelligencePanel extends StatefulWidget {
  const LgaHistoricalIntelligencePanel({super.key});

  @override
  State<LgaHistoricalIntelligencePanel> createState() =>
      _LgaHistoricalIntelligencePanelState();
}

class _LgaHistoricalIntelligencePanelState
    extends State<LgaHistoricalIntelligencePanel> {
  int selectedYear = 2023;
  String selectedLga = 'Makurdi';
  String query = '';

  @override
  Widget build(BuildContext context) {
    final meta = lgaHistoricalDatasetMeta[selectedYear]!;
    final rows = lgaResultsForYear(selectedYear);
    final filtered = rows
        .where((row) => row.lga.toLowerCase().contains(query.toLowerCase()))
        .toList()
      ..sort((a, b) => a.lga.compareTo(b.lga));
    final selected = lgaResultFor(selectedYear, selectedLga) ??
        (filtered.isEmpty ? null : filtered.first);

    final pdpLed = rows.where((row) => row.leadingParty == 'PDP').length;
    final apcLed = rows.where((row) => row.leadingParty == 'APC').length;
    final otherLed = rows.length - pdpLed - apcLed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LgaArchiveHeader(
          selectedYear: selectedYear,
          meta: meta,
          onYearChanged: (year) {
            setState(() {
              selectedYear = year;
              final currentExists = lgaResultFor(year, selectedLga) != null;
              if (!currentExists) {
                final available = lgaResultsForYear(year);
                if (available.isNotEmpty) selectedLga = available.first.lga;
              }
            });
          },
        ),
        const SizedBox(height: 14),
        _LgaSummaryStrip(
          meta: meta,
          pdpLed: pdpLed,
          apcLed: apcLed,
          otherLed: otherLed,
          pdpVotesLoaded: lgaSumForParty(selectedYear, 'PDP'),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000;
            final explorer = _LgaExplorer(
              year: selectedYear,
              rows: filtered,
              selectedLga: selectedLga,
              query: query,
              onQueryChanged: (value) => setState(() => query = value),
              onSelected: (lga) => setState(() => selectedLga = lga),
            );
            final detail = _SelectedLgaPanel(
              year: selectedYear,
              result: selected,
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
                Expanded(flex: 13, child: explorer),
                const SizedBox(width: 14),
                Expanded(flex: 8, child: detail),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        const _PdpSwingBoard(),
      ],
    );
  }
}

class LgaHistoricalDetailPage extends StatelessWidget {
  const LgaHistoricalDetailPage({super.key, required this.lga});

  final String lga;

  @override
  Widget build(BuildContext context) {
    final rows = <LgaHistoricalResult?>[
      lgaResultFor(2015, lga),
      lgaResultFor(2019, lga),
      lgaResultFor(2023, lga),
    ];
    final r2019 = rows[1];
    final r2023 = rows[2];
    final pdpChange = r2019 != null && r2023 != null
        ? r2023.pdpVotes - r2019.pdpVotes
        : null;
    final apcChange = r2019 != null && r2023 != null
        ? r2023.apcVotes - r2019.apcVotes
        : null;

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 36),
        children: [
          _LgaDetailHero(lga: lga),
          const SizedBox(height: 16),
          _HistoricalIntegrityNotice(lga: lga),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1080
                  ? 3
                  : constraints.maxWidth >= 650
                      ? 2
                      : 1;
              const gap = 14.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [2015, 2019, 2023].map((year) {
                  return SizedBox(
                    width: width,
                    child: _LgaYearCard(
                      year: year,
                      result: lgaResultFor(year, lga),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          if (r2019 != null && r2023 != null)
            _LgaSwingSummary(
              lga: lga,
              pdpChange: pdpChange!,
              apcChange: apcChange!,
              r2019: r2019,
              r2023: r2023,
            ),
          const SizedBox(height: 16),
          _LgaSourceLedger(lga: lga, rows: rows),
        ],
      ),
    );
  }
}

class _LgaArchiveHeader extends StatelessWidget {
  const _LgaArchiveHeader({
    required this.selectedYear,
    required this.meta,
    required this.onYearChanged,
  });

  final int selectedYear;
  final LgaHistoricalDatasetMeta meta;
  final ValueChanged<int> onYearChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF10271D), Color(0xFF17452F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LGA ELECTION LANDSCAPE',
                  style: TextStyle(
                    color: Color(0xFFA8DDB9),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Benue 23-LGA Historical Intelligence',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  meta.note,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
            final controls = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _QualityBadge(meta: meta),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [2015, 2019, 2023].map((year) {
                    final active = year == selectedYear;
                    return ChoiceChip(
                      selected: active,
                      onSelected: (_) => onYearChanged(year),
                      label: Text('$year'),
                      labelStyle: TextStyle(
                        color: active ? pdpGreenDark : Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      backgroundColor: Colors.white.withValues(alpha: .08),
                      selectedColor: Colors.white,
                      side: BorderSide(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: .16),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text,
                  const SizedBox(height: 18),
                  Align(alignment: Alignment.centerLeft, child: controls),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: text),
                const SizedBox(width: 20),
                controls,
              ],
            );
          },
        ),
      );
}

class _QualityBadge extends StatelessWidget {
  const _QualityBadge({required this.meta});
  final LgaHistoricalDatasetMeta meta;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .16)),
        ),
        child: Text(
          meta.qualityLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: .5,
          ),
        ),
      );
}

class _LgaSummaryStrip extends StatelessWidget {
  const _LgaSummaryStrip({
    required this.meta,
    required this.pdpLed,
    required this.apcLed,
    required this.otherLed,
    required this.pdpVotesLoaded,
  });

  final LgaHistoricalDatasetMeta meta;
  final int pdpLed;
  final int apcLed;
  final int otherLed;
  final int pdpVotesLoaded;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MiniMetric(
        value: '${meta.recordsLoaded}/${meta.recordsExpected}',
        label: 'LGA rows loaded',
        icon: Icons.table_rows_outlined,
        color: pdpGreen,
      ),
      _MiniMetric(
        value: '$pdpLed',
        label: 'PDP-led LGAs',
        icon: Icons.flag_outlined,
        color: pdpGreen,
      ),
      _MiniMetric(
        value: '$apcLed',
        label: 'APC-led LGAs',
        icon: Icons.flag_outlined,
        color: const Color(0xFF2563EB),
      ),
      _MiniMetric(
        value: '$otherLed',
        label: 'Other / no poll',
        icon: Icons.more_horiz_rounded,
        color: const Color(0xFF7C3AED),
      ),
      _MiniMetric(
        value: _format(pdpVotesLoaded),
        label: 'PDP votes in loaded rows',
        icon: Icons.how_to_vote_outlined,
        color: const Color(0xFF0F766E),
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 5
            : constraints.maxWidth >= 620
                ? 3
                : 1;
        const gap = 10.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics
              .map((item) => SizedBox(width: width, child: item))
              .toList(),
        );
      },
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE1E9E3)),
        ),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(label,
                      maxLines: 2,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _LgaExplorer extends StatelessWidget {
  const _LgaExplorer({
    required this.year,
    required this.rows,
    required this.selectedLga,
    required this.query,
    required this.onQueryChanged,
    required this.onSelected,
  });

  final int year;
  final List<LgaHistoricalResult> rows;
  final String selectedLga;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => _Panel(
        title: '$year LGA comparison',
        subtitle: 'Select an LGA to inspect its vote profile and provenance',
        child: Column(
          children: [
            TextField(
              onChanged: onQueryChanged,
              decoration: const InputDecoration(
                hintText: 'Search LGA',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text('No LGA rows match this search.',
                    style: TextStyle(color: muted)),
              )
            else
              ...rows.map((row) {
                final active = row.lga == selectedLga;
                final leadColor = _partyColor(row.leadingParty);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onSelected(row.lga),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: active
                            ? leadColor.withValues(alpha: .08)
                            : const Color(0xFFF8FAF8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active
                              ? leadColor.withValues(alpha: .40)
                              : const Color(0xFFE8ECE9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: leadColor.withValues(alpha: .10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              row.leadingParty == 'NO ELECTION'
                                  ? '—'
                                  : row.leadingParty,
                              style: TextStyle(
                                color: leadColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(row.lga,
                                    style: const TextStyle(
                                        color: ink,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 3),
                                Text(
                                  row.hasElection
                                      ? 'APC ${_format(row.apcVotes)}  •  PDP ${_format(row.pdpVotes)}${row.lpVotes > 0 ? '  •  LP ${_format(row.lpVotes)}' : ''}'
                                      : row.sourceNote,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: muted,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (row.hasElection)
                            Text(
                              row.pdpKnownShare == null
                                  ? '—'
                                  : '${row.pdpKnownShare!.toStringAsFixed(1)}% PDP',
                              style: const TextStyle(
                                  color: pdpGreenDark,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900),
                            ),
                          const SizedBox(width: 7),
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

class _SelectedLgaPanel extends StatelessWidget {
  const _SelectedLgaPanel({required this.year, required this.result});
  final int year;
  final LgaHistoricalResult? result;

  @override
  Widget build(BuildContext context) {
    final row = result;
    if (row == null) {
      return const _Panel(
        title: 'LGA detail',
        subtitle: 'No result selected',
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text('Select an available LGA result.'),
        ),
      );
    }
    final maxVote = [row.apcVotes, row.pdpVotes, row.lpVotes]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    return _Panel(
      title: '${row.lga} • $year',
      subtitle: row.sourceLabel,
      trailing: _ResultQualityPill(quality: row.quality),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!row.hasElection)
            _NoElectionNotice(text: row.sourceNote)
          else ...[
            _PartyVoteBar(
                party: 'APC',
                votes: row.apcVotes,
                maxVote: maxVote,
                color: const Color(0xFF2563EB)),
            _PartyVoteBar(
                party: 'PDP',
                votes: row.pdpVotes,
                maxVote: maxVote,
                color: pdpGreen),
            if (row.lpVotes > 0)
              _PartyVoteBar(
                  party: 'LP',
                  votes: row.lpVotes,
                  maxVote: maxVote,
                  color: const Color(0xFF7C3AED)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusPill('${row.leadingParty} leads',
                    color: _partyColor(row.leadingParty)),
                StatusPill('Margin ${_format(row.leadingMargin)}',
                    color: const Color(0xFF7C3AED)),
                if (row.turnoutPercent != null)
                  StatusPill(
                      'Turnout ${row.turnoutPercent!.toStringAsFixed(1)}%',
                      color: const Color(0xFFD97706)),
              ],
            ),
            const SizedBox(height: 14),
          ],
          const Divider(height: 1),
          const SizedBox(height: 12),
          const Text('Source note',
              style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(row.sourceNote,
              style: const TextStyle(
                  color: muted, height: 1.4, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PartyVoteBar extends StatelessWidget {
  const _PartyVoteBar({
    required this.party,
    required this.votes,
    required this.maxVote,
    required this.color,
  });
  final String party;
  final int votes;
  final double maxVote;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(party,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
                const Spacer(),
                Text(_format(votes),
                    style: const TextStyle(
                        color: ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: maxVote == 0 ? 0 : votes / maxVote,
                minHeight: 10,
                backgroundColor: const Color(0xFFE9EEEA),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      );
}

class _PdpSwingBoard extends StatelessWidget {
  const _PdpSwingBoard();

  @override
  Widget build(BuildContext context) {
    final changes = <_SwingRow>[];
    for (final r2019 in benueLgaResults2019) {
      final r2023 = lgaResultFor(2023, r2019.lga);
      if (r2023 == null || !r2023.hasElection) continue;
      changes.add(_SwingRow(
        lga: r2019.lga,
        pdpChange: r2023.pdpVotes - r2019.pdpVotes,
        apcChange: r2023.apcVotes - r2019.apcVotes,
        oldLeader: r2019.leadingParty,
        newLeader: r2023.leadingParty,
      ));
    }
    final mostPositive = [...changes]
      ..sort((a, b) => b.pdpChange.compareTo(a.pdpChange));
    final biggestDrops = [...changes]
      ..sort((a, b) => a.pdpChange.compareTo(b.pdpChange));
    final changedLeader = changes
        .where((row) => row.oldLeader != row.newLeader)
        .toList()
      ..sort((a, b) => a.lga.compareTo(b.lga));

    return _Panel(
      title: '2019 → 2023 LGA swing desk',
      subtitle:
          'Raw vote movement from the loaded LGA tables. 2019 is explicitly unreconciled to final supplementary increments, so this is descriptive—not a substitute for official EC8E totals.',
      trailing: const StatusPill('QUALITY-CONTROLLED', color: Color(0xFFD97706)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final gain = _SwingList(
            title: 'Best PDP retention / movement',
            rows: mostPositive.take(5).toList(),
            positiveIsGood: true,
          );
          final drop = _SwingList(
            title: 'Largest PDP raw-vote declines',
            rows: biggestDrops.take(5).toList(),
            positiveIsGood: false,
          );
          final control = _ControlChangeList(rows: changedLeader);
          if (!wide) {
            return Column(
              children: [
                gain,
                const SizedBox(height: 14),
                drop,
                const SizedBox(height: 14),
                control,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: gain),
              const SizedBox(width: 14),
              Expanded(child: drop),
              const SizedBox(width: 14),
              Expanded(child: control),
            ],
          );
        },
      ),
    );
  }
}

class _SwingRow {
  const _SwingRow({
    required this.lga,
    required this.pdpChange,
    required this.apcChange,
    required this.oldLeader,
    required this.newLeader,
  });
  final String lga;
  final int pdpChange;
  final int apcChange;
  final String oldLeader;
  final String newLeader;
}

class _SwingList extends StatelessWidget {
  const _SwingList({
    required this.title,
    required this.rows,
    required this.positiveIsGood,
  });
  final String title;
  final List<_SwingRow> rows;
  final bool positiveIsGood;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6ECE7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            ...rows.map((row) {
              final color = row.pdpChange >= 0 ? pdpGreen : pdpRed;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(row.lga,
                          style: const TextStyle(
                              color: ink,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800)),
                    ),
                    Text(_signed(row.pdpChange),
                        style: TextStyle(
                            color: color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              );
            }),
          ],
        ),
      );
}

class _ControlChangeList extends StatelessWidget {
  const _ControlChangeList({required this.rows});
  final List<_SwingRow> rows;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6ECE7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Leader changed',
                style: TextStyle(
                    color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            if (rows.isEmpty)
              const Text('No leader changes in comparable loaded rows.',
                  style: TextStyle(color: muted, fontSize: 10))
            else
              ...rows.take(7).map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(row.lga,
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Text('${row.oldLeader} → ${row.newLeader}',
                            style: const TextStyle(
                                color: Color(0xFF7C3AED),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  )),
          ],
        ),
      );
}

class _LgaDetailHero extends StatelessWidget {
  const _LgaDetailHero({required this.lga});
  final String lga;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF071C13), Color(0xFF0B6C39)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.location_city_outlined,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LGA HISTORICAL ELECTION INTELLIGENCE',
                      style: TextStyle(
                          color: Color(0xFFA8DDB9),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  Text('$lga LGA',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  const Text('2015 • 2019 • 2023 sourced comparison',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _HistoricalIntegrityNotice extends StatelessWidget {
  const _HistoricalIntegrityNotice({required this.lga});
  final String lga;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFF0DCAC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.fact_check_outlined,
                color: Color(0xFFD97706)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'This page only shows $lga figures present in the loaded source archive. 2015 is partial, 2019 LGA rows are not fully reconciled to the final supplementary EC8E totals, and 2023 major-party LGA totals are reconciled. Missing figures stay missing.',
                style: const TextStyle(
                    color: Color(0xFF79550A),
                    height: 1.4,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
}

class _LgaYearCard extends StatelessWidget {
  const _LgaYearCard({required this.year, required this.result});
  final int year;
  final LgaHistoricalResult? result;

  @override
  Widget build(BuildContext context) {
    final row = result;
    return _Panel(
      title: '$year governorship',
      subtitle: lgaHistoricalDatasetMeta[year]!.qualityLabel,
      trailing: row == null
          ? const StatusPill('NOT LOADED', color: Color(0xFFD97706))
          : _ResultQualityPill(quality: row.quality),
      child: row == null
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No sourced LGA row is currently loaded for this election year. No estimate is generated.',
                style: TextStyle(color: muted, height: 1.4),
              ),
            )
          : !row.hasElection
              ? _NoElectionNotice(text: row.sourceNote)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CompactResultLine('APC', row.apcVotes,
                        const Color(0xFF2563EB)),
                    _CompactResultLine('PDP', row.pdpVotes, pdpGreen),
                    if (row.lpVotes > 0)
                      _CompactResultLine(
                          'LP', row.lpVotes, const Color(0xFF7C3AED)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        StatusPill('${row.leadingParty} led',
                            color: _partyColor(row.leadingParty)),
                        if (row.turnoutPercent != null)
                          StatusPill(
                              '${row.turnoutPercent!.toStringAsFixed(1)}% turnout',
                              color: const Color(0xFFD97706)),
                      ],
                    ),
                  ],
                ),
    );
  }
}

class _CompactResultLine extends StatelessWidget {
  const _CompactResultLine(this.party, this.votes, this.color);
  final String party;
  final int votes;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(party,
                  style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 9),
            Expanded(
                child: Text(_format(votes),
                    style: const TextStyle(
                        color: ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900))),
          ],
        ),
      );
}

class _LgaSwingSummary extends StatelessWidget {
  const _LgaSwingSummary({
    required this.lga,
    required this.pdpChange,
    required this.apcChange,
    required this.r2019,
    required this.r2023,
  });
  final String lga;
  final int pdpChange;
  final int apcChange;
  final LgaHistoricalResult r2019;
  final LgaHistoricalResult r2023;

  @override
  Widget build(BuildContext context) => _Panel(
        title: '$lga • 2019 → 2023 change',
        subtitle:
            'Raw vote movement in the loaded LGA tables; 2019 remains an unreconciled geographic reference.',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _ChangeCard(
                  label: 'PDP raw-vote change',
                  value: _signed(pdpChange),
                  color: pdpChange >= 0 ? pdpGreen : pdpRed),
              _ChangeCard(
                  label: 'APC raw-vote change',
                  value: _signed(apcChange),
                  color: apcChange >= 0
                      ? const Color(0xFF2563EB)
                      : pdpRed),
              _ChangeCard(
                  label: 'Leading party',
                  value: '${r2019.leadingParty} → ${r2023.leadingParty}',
                  color: const Color(0xFF7C3AED)),
            ];
            final cols = constraints.maxWidth >= 760 ? 3 : 1;
            const gap = 10.0;
            final width =
                (constraints.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children:
                  cards.map((c) => SizedBox(width: width, child: c)).toList(),
            );
          },
        ),
      );
}

class _ChangeCard extends StatelessWidget {
  const _ChangeCard(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: .14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: ink, fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _LgaSourceLedger extends StatelessWidget {
  const _LgaSourceLedger({required this.lga, required this.rows});
  final String lga;
  final List<LgaHistoricalResult?> rows;

  @override
  Widget build(BuildContext context) => _Panel(
        title: 'Source & data-quality ledger',
        subtitle: 'Provenance for every $lga historical row currently shown',
        child: Column(
          children: [2015, 2019, 2023].asMap().entries.map((entry) {
            final year = entry.value;
            final row = rows[entry.key];
            final meta = lgaHistoricalDatasetMeta[year]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5F1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text('$year',
                        style: const TextStyle(
                            color: ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row?.sourceLabel ?? 'No LGA row loaded',
                            style: const TextStyle(
                                color: ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 3),
                        Text(row?.sourceNote ?? meta.note,
                            style: const TextStyle(
                                color: muted,
                                fontSize: 9.5,
                                height: 1.35,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusPill(meta.qualityLabel,
                      color: year == 2023
                          ? pdpGreen
                          : const Color(0xFFD97706)),
                ],
              ),
            );
          }).toList(),
        ),
      );
}

class _ResultQualityPill extends StatelessWidget {
  const _ResultQualityPill({required this.quality});
  final LgaHistoricalQuality quality;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (quality) {
      LgaHistoricalQuality.reconciledMajorParties =>
        ('RECONCILED', pdpGreen),
      LgaHistoricalQuality.publishedUnreconciled =>
        ('UNRECONCILED', const Color(0xFFD97706)),
      LgaHistoricalQuality.partialPublished =>
        ('PARTIAL', const Color(0xFFD97706)),
      LgaHistoricalQuality.noElection => ('NO POLL', pdpRed),
    };
    return StatusPill(label, color: color);
  }
}

class _NoElectionNotice extends StatelessWidget {
  const _NoElectionNotice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: pdpRed.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: pdpRed.withValues(alpha: .15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.block_outlined, color: pdpRed, size: 19),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: ink,
                      fontSize: 10,
                      height: 1.35,
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
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000),
                blurRadius: 18,
                offset: Offset(0, 8)),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              color: muted,
                              fontSize: 10.5,
                              height: 1.3,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      );
}

Color _partyColor(String party) => switch (party) {
      'PDP' => pdpGreen,
      'APC' => const Color(0xFF2563EB),
      'LP' => const Color(0xFF7C3AED),
      'NO ELECTION' => pdpRed,
      _ => const Color(0xFF647067),
    };

String _signed(int value) =>
    '${value >= 0 ? '+' : '−'}${_format(value.abs())}';

String _format(int value) {
  final chars = value.toString().split('').reversed.toList();
  final out = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) out.add(',');
    out.add(chars[i]);
  }
  return out.reversed.join();
}
