import 'package:flutter/material.dart';

import 'data.dart';
import 'domain/geography_catalog.dart';
import 'widgets.dart';

class BenueGeographyPage extends StatefulWidget {
  const BenueGeographyPage({super.key});

  @override
  State<BenueGeographyPage> createState() => _BenueGeographyPageState();
}

class _BenueGeographyPageState extends State<BenueGeographyPage> {
  final _searchController = TextEditingController();
  int _selectedIndex = 12;
  int _selectedTab = 0;
  String _query = '';

  List<LgaRecord> get _allLgas => BenueBaseGeography.lgas;

  List<LgaRecord> get _filteredLgas {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _allLgas;
    return _allLgas
        .where((lga) => lga.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  LgaRecord get _selectedLga {
    final safeIndex = _selectedIndex < 0
        ? 0
        : _selectedIndex >= _allLgas.length
            ? _allLgas.length - 1
            : _selectedIndex;
    return _allLgas[safeIndex];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLga(LgaRecord lga) {
    final index = _allLgas.indexWhere((item) => item.id == lga.id);
    if (index < 0) return;
    setState(() {
      _selectedIndex = index;
      _selectedTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedLga;
    final demo = _DemoLgaMetrics.fromIndex(_selectedIndex);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const PageHeading(
          title: 'Benue Geographic Command',
          subtitle:
              'State → LGA → ward → polling-unit command structure for readiness, incidents, field teams, historical results and election-day operations.',
          trailing: StatusPill('23 LGA COMMANDS'),
        ),
        const SizedBox(height: 18),
        const _DataIntegrityBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1050;
            final list = _LgaList(
              controller: _searchController,
              lgas: _filteredLgas,
              selectedId: selected.id,
              onSearch: (value) => setState(() => _query = value),
              onSelect: _selectLga,
            );
            final detail = _LgaCommandView(
              lga: selected,
              metrics: demo,
              selectedTab: _selectedTab,
              onTabChanged: (value) => setState(() => _selectedTab = value),
            );

            if (!wide) {
              return Column(
                children: [
                  list,
                  const SizedBox(height: 14),
                  detail,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 330, child: list),
                const SizedBox(width: 14),
                Expanded(child: detail),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LgaList extends StatelessWidget {
  const _LgaList({
    required this.controller,
    required this.lgas,
    required this.selectedId,
    required this.onSearch,
    required this.onSelect,
  });

  final TextEditingController controller;
  final List<LgaRecord> lgas;
  final String selectedId;
  final ValueChanged<String> onSearch;
  final ValueChanged<LgaRecord> onSelect;

  @override
  Widget build(BuildContext context) => SectionCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LGA command nodes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  SizedBox(height: 3),
                  Text('Select any LGA to open its operational workspace.',
                      style: TextStyle(color: muted)),
                ],
              ),
            ),
            TextField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search LGA',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: const Color(0xFFF4F7F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 610,
              child: lgas.isEmpty
                  ? const Center(
                      child: Text('No LGA matches your search.',
                          style: TextStyle(color: muted)),
                    )
                  : ListView.separated(
                      itemCount: lgas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final lga = lgas[index];
                        final active = lga.id == selectedId;
                        final globalIndex = BenueBaseGeography.lgas
                            .indexWhere((item) => item.id == lga.id);
                        final metrics = _DemoLgaMetrics.fromIndex(globalIndex);
                        return ListTile(
                          selected: active,
                          selectedTileColor: const Color(0xFFE8F4EB),
                          selectedColor: pdpGreenDark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          onTap: () => onSelect(lga),
                          leading: CircleAvatar(
                            backgroundColor: active
                                ? pdpGreen.withOpacity(.12)
                                : const Color(0xFFF0F3F0),
                            child: Text(
                              '${globalIndex + 1}',
                              style: TextStyle(
                                color: active ? pdpGreenDark : muted,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          title: Text(lga.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          subtitle: Text(
                            '${metrics.readiness}% readiness • ${metrics.openIncidents} incidents',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
}

class _LgaCommandView extends StatelessWidget {
  const _LgaCommandView({
    required this.lga,
    required this.metrics,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final LgaRecord lga;
  final _DemoLgaMetrics metrics;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4EB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.location_city_rounded,
                          color: pdpGreen, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${lga.name} LGA Command',
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('${lga.id} • Benue State',
                              style: const TextStyle(color: muted)),
                        ],
                      ),
                    ),
                    const StatusPill('PROTOTYPE METRICS',
                        color: Color(0xFFD68A00)),
                  ],
                ),
                const SizedBox(height: 18),
                _metricsGrid(context),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _tab('Overview', 0),
                    _tab('Wards & PUs', 1),
                    _tab('Historical', 2),
                    _tab('Operations', 3),
                  ],
                ),
                const SizedBox(height: 18),
                if (selectedTab == 0) _overview(),
                if (selectedTab == 1) _hierarchy(),
                if (selectedTab == 2) _historical(),
                if (selectedTab == 3) _operations(),
              ],
            ),
          ),
        ],
      );

  Widget _metricsGrid(BuildContext context) => LayoutBuilder(
        builder: (context, c) {
          final columns = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
          const gap = 10.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            _MiniMetric('Readiness', '${metrics.readiness}%', Icons.speed_rounded,
                pdpGreen),
            _MiniMetric('Open incidents', '${metrics.openIncidents}',
                Icons.warning_amber_rounded, const Color(0xFFD68A00)),
            _MiniMetric('Field teams', '${metrics.activeTeams}',
                Icons.groups_2_outlined, const Color(0xFF5E5CB2)),
            _MiniMetric('Reports today', '${metrics.reportsToday}',
                Icons.feed_outlined, const Color(0xFF2E62D8)),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children:
                cards.map((e) => SizedBox(width: width, child: e)).toList(),
          );
        },
      );

  Widget _tab(String label, int index) => ChoiceChip(
        label: Text(label),
        selected: selectedTab == index,
        onSelected: (_) => onTabChanged(index),
        selectedColor: pdpGreen.withOpacity(.12),
        side: BorderSide(
          color: selectedTab == index ? pdpGreen : const Color(0xFFDCE5DE),
        ),
        labelStyle: TextStyle(
          color: selectedTab == index ? pdpGreenDark : ink,
          fontWeight: FontWeight.w800,
        ),
      );

  Widget _overview() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            'Command health',
            'These indicators demonstrate the future live command model. Production scores will be calculated from verified operational records.',
          ),
          const SizedBox(height: 14),
          _ProgressLine('Campaign structure', metrics.structure),
          _ProgressLine('Field coverage', metrics.fieldCoverage),
          _ProgressLine('Communications readiness', metrics.communications),
          _ProgressLine('Logistics readiness', metrics.logistics),
          _ProgressLine('Data completeness', metrics.dataCompleteness),
          const SizedBox(height: 16),
          const _NoteCard(
            icon: Icons.fact_check_outlined,
            title: 'Production rule',
            text:
                'Readiness must be derived from assigned coordinators, agent rosters, training, check-ins, logistics, reports and verified data — never manually invented by the forecast engine.',
          ),
        ],
      );

  Widget _hierarchy() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionHeading(
            'Ward & polling-unit hierarchy',
            'The system is ready to display granular geography, but no ward or polling-unit names are fabricated.',
          ),
          SizedBox(height: 14),
          _ImportStatusRow('Ward records', 'Verified dataset required'),
          _ImportStatusRow('Polling-unit records', 'Verified dataset required'),
          _ImportStatusRow('Ward coordinators', 'Links to Field Network'),
          _ImportStatusRow('Polling-unit agents', 'Links to Election Readiness'),
          _ImportStatusRow('Granular historical results', 'Source required'),
          SizedBox(height: 14),
          _NoteCard(
            icon: Icons.data_object_rounded,
            title: 'Import validation already built',
            text:
                'The geography catalog validates 23 LGAs, duplicate IDs, unknown parents, ward/LGA mismatches and polling-unit/ward/LGA relationships before data can be trusted.',
          ),
        ],
      );

  Widget _historical() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            'LGA historical intelligence',
            'Statewide election totals are available. LGA-specific figures remain unavailable until verified granular results are loaded.',
          ),
          const SizedBox(height: 14),
          ...historicalElections.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE4EAE5)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 58,
                      child: Text('${e.year}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 17)),
                    ),
                    const Expanded(
                      child: Text('LGA result not loaded',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    const StatusPill('SOURCE REQUIRED',
                        color: Color(0xFFD68A00)),
                  ],
                ),
              ),
            ),
          ),
          const Text(
            'After import, this panel will calculate LGA swing, turnout change, PDP/APC movement, winning-margin change and contribution to the statewide result.',
            style: TextStyle(color: muted, height: 1.45),
          ),
        ],
      );

  Widget _operations() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            'Connected operational modules',
            'Geography is the shared key joining campaign operations across the whole system.',
          ),
          SizedBox(height: 12),
          _OperationRow(Icons.groups_2_outlined, 'Field Network',
              'Coordinators, agents, volunteers, training and check-ins.'),
          _OperationRow(Icons.chat_bubble_outline_rounded, 'Communications',
              'LGA channels, ward rooms and incident conversations.'),
          _OperationRow(Icons.warning_amber_rounded, 'Situation Room',
              'Incidents, escalations, evidence and command decisions.'),
          _OperationRow(Icons.inventory_2_outlined, 'Logistics & Tasks',
              'Assets, assignments, distribution and deadlines.'),
          _OperationRow(Icons.how_to_vote_outlined, 'Election Day',
              'Agent check-ins, polling-unit reports and result verification.'),
        ],
      );
}

class _DataIntegrityBanner extends StatelessWidget {
  const _DataIntegrityBanner();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.map_outlined, color: pdpGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'The 23 LGA names are treated as base geography. LGA-specific ward, polling-unit and historical-result details remain locked until verified source data is imported. Prototype readiness metrics are visually identified and must not be treated as real campaign measurements.',
                style: TextStyle(fontWeight: FontWeight.w600, color: ink),
              ),
            ),
          ],
        ),
      );
}

class _DemoLgaMetrics {
  const _DemoLgaMetrics({
    required this.readiness,
    required this.openIncidents,
    required this.activeTeams,
    required this.reportsToday,
    required this.structure,
    required this.fieldCoverage,
    required this.communications,
    required this.logistics,
    required this.dataCompleteness,
  });

  final int readiness;
  final int openIncidents;
  final int activeTeams;
  final int reportsToday;
  final int structure;
  final int fieldCoverage;
  final int communications;
  final int logistics;
  final int dataCompleteness;

  factory _DemoLgaMetrics.fromIndex(int rawIndex) {
    final index = rawIndex < 0 ? 0 : rawIndex;
    int metric(int base, int step, int range) => base + ((index * step) % range);
    final structure = metric(42, 11, 51);
    final field = metric(35, 13, 58);
    final communications = metric(48, 9, 47);
    final logistics = metric(40, 7, 52);
    final data = metric(30, 17, 61);
    return _DemoLgaMetrics(
      readiness:
          ((structure + field + communications + logistics + data) / 5).round(),
      openIncidents: index % 4,
      activeTeams: 2 + (index % 7),
      reportsToday: 3 + ((index * 3) % 18),
      structure: structure,
      fieldCoverage: field,
      communications: communications,
      logistics: logistics,
      dataCompleteness: data,
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3EAE5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w900)),
                  Text(label,
                      style: const TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine(this.label, this.percent);

  final String label;
  final int percent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(label,
                        style: const TextStyle(fontWeight: FontWeight.w800))),
                Text('$percent%',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 9,
                backgroundColor: const Color(0xFFE7EEE8),
              ),
            ),
          ],
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, height: 1.4)),
        ],
      );
}

class _ImportStatusRow extends StatelessWidget {
  const _ImportStatusRow(this.title, this.status);

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE7ECE8))),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            const SizedBox(width: 12),
            const Icon(Icons.hourglass_empty_rounded,
                size: 17, color: Color(0xFFD68A00)),
            const SizedBox(width: 6),
            Flexible(
                child: Text(status,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: muted))),
          ],
        ),
      );
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8F5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE0E9E2)),
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
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(text,
                      style: const TextStyle(color: muted, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _OperationRow extends StatelessWidget {
  const _OperationRow(this.icon, this.title, this.detail);

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF4ED),
          child: Icon(icon, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(detail),
        trailing: const Icon(Icons.chevron_right_rounded),
      );
}
