import 'package:flutter/material.dart';

import 'data.dart';
import 'domain/models.dart';
import 'widgets.dart';

class BenueGeographyPage extends StatefulWidget {
  const BenueGeographyPage({super.key});

  @override
  State<BenueGeographyPage> createState() => _BenueGeographyPageState();
}

class _BenueGeographyPageState extends State<BenueGeographyPage> {
  final _search = TextEditingController();
  int selectedLga = 12;
  int tab = 0;
  String query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<String> get filteredLgas {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return benueLgas;
    return benueLgas.where((e) => e.toLowerCase().contains(q)).toList();
  }

  _LgaCommandSnapshot snapshotFor(String lga) {
    final index = benueLgas.indexOf(lga);
    return _LgaCommandSnapshot.demo(lga, index < 0 ? 0 : index);
  }

  @override
  Widget build(BuildContext context) {
    final currentLga = benueLgas[selectedLga.clamp(0, benueLgas.length - 1)];
    final snapshot = snapshotFor(currentLga);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const PageHeading(
          title: 'Benue Geographic Command',
          subtitle:
              'State → LGA → ward → polling-unit operational drill-down for campaign structure, readiness, incidents, historical data and field reporting.',
          trailing: StatusPill('23 LGA COMMANDS'),
        ),
        const SizedBox(height: 18),
        const _GeographyDataNotice(),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1050;
            final selector = _LgaSelector(
              controller: _search,
              lgas: filteredLgas,
              selected: currentLga,
              onSearch: (value) => setState(() => query = value),
              onSelect: (lga) => setState(() {
                selectedLga = benueLgas.indexOf(lga);
                tab = 0;
              }),
              snapshotFor: snapshotFor,
            );
            final detail = _LgaDetail(
              snapshot: snapshot,
              tab: tab,
              onTabChanged: (value) => setState(() => tab = value),
            );

            if (!wide) {
              return Column(
                children: [
                  selector,
                  const SizedBox(height: 14),
                  detail,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 330, child: selector),
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

class _LgaSelector extends StatelessWidget {
  const _LgaSelector({
    required this.controller,
    required this.lgas,
    required this.selected,
    required this.onSearch,
    required this.onSelect,
    required this.snapshotFor,
  });

  final TextEditingController controller;
  final List<String> lgas;
  final String selected;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onSelect;
  final _LgaCommandSnapshot Function(String lga) snapshotFor;

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
                  Text('Select an LGA to inspect its command view.',
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
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
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
                        final active = lga == selected;
                        final snapshot = snapshotFor(lga);
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
                              '${benueLgas.indexOf(lga) + 1}',
                              style: TextStyle(
                                color: active ? pdpGreenDark : muted,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          title: Text(lga,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          subtitle: Text(
                            '${snapshot.readiness}% readiness • ${snapshot.openIncidents} open incidents',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: active ? pdpGreen : muted,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
}

class _LgaDetail extends StatelessWidget {
  const _LgaDetail({
    required this.snapshot,
    required this.tab,
    required this.onTabChanged,
  });

  final _LgaCommandSnapshot snapshot;
  final int tab;
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
                          Text('${snapshot.name} LGA Command',
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 5),
                          const Text(
                            'Operational workspace for campaign structure, field readiness, incidents, reports and election data.',
                            style: TextStyle(color: muted, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const StatusPill('PROTOTYPE METRICS',
                        color: Color(0xFFD68A00)),
                  ],
                ),
                const SizedBox(height: 18),
                LayoutBuilder(builder: (context, c) {
                  final cols = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
                  const gap = 10.0;
                  final width = (c.maxWidth - gap * (cols - 1)) / cols;
                  final cards = [
                    _CompactMetric('Readiness', '${snapshot.readiness}%',
                        Icons.speed_rounded, pdpGreen),
                    _CompactMetric('Open incidents', '${snapshot.openIncidents}',
                        Icons.warning_amber_rounded, const Color(0xFFD68A00)),
                    _CompactMetric('Field teams', '${snapshot.activeTeams}',
                        Icons.groups_2_outlined, const Color(0xFF5E5CB2)),
                    _CompactMetric('Reports today', '${snapshot.reportsToday}',
                        Icons.feed_outlined, const Color(0xFF2E62D8)),
                  ];
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children:
                        cards.map((e) => SizedBox(width: width, child: e)).toList(),
                  );
                }),
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
                    _tab('Wards & Polling Units', 1),
                    _tab('Historical', 2),
                    _tab('Operations', 3),
                  ],
                ),
                const SizedBox(height: 18),
                if (tab == 0) _overview(),
                if (tab == 1) _wards(),
                if (tab == 2) _historical(),
                if (tab == 3) _operations(),
              ],
            ),
          ),
        ],
      );

  Widget _tab(String label, int index) => ChoiceChip(
        label: Text(label),
        selected: tab == index,
        onSelected: (_) => onTabChanged(index),
        selectedColor: pdpGreen.withOpacity(.12),
        side: BorderSide(
            color: tab == index ? pdpGreen : const Color(0xFFDCE5DE)),
        labelStyle: TextStyle(
          color: tab == index ? pdpGreenDark : ink,
          fontWeight: FontWeight.w800,
        ),
      );

  Widget _overview() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Command health',
            'Prototype operational indicators only; production values must come from verified assignments, check-ins, incidents and reports.',
          ),
          const SizedBox(height: 14),
          _ProgressRow('Campaign structure', snapshot.structure / 100),
          _ProgressRow('Field coverage', snapshot.fieldCoverage / 100),
          _ProgressRow('Communications readiness', snapshot.communication / 100),
          _ProgressRow('Logistics readiness', snapshot.logistics / 100),
          _ProgressRow('Data completeness', snapshot.dataCompleteness / 100),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 760;
            final alerts = _InfoBlock(
              title: 'Current command attention',
              icon: Icons.priority_high_rounded,
              color: pdpRed,
              children: [
                'Resolve ${snapshot.openIncidents} open incident${snapshot.openIncidents == 1 ? '' : 's'}.',
                'Confirm ward coordinator and field-team coverage.',
                'Review overdue operational reports and tasks.',
              ],
            );
            final next = _InfoBlock(
              title: 'Next verification steps',
              icon: Icons.fact_check_outlined,
              color: pdpGreen,
              children: const [
                'Import official ward and polling-unit hierarchy.',
                'Link verified campaign personnel to assigned geography.',
                'Replace prototype readiness with live operational records.',
              ],
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: alerts),
                    const SizedBox(width: 12),
                    Expanded(child: next),
                  ])
                : Column(children: [alerts, const SizedBox(height: 12), next]);
          }),
        ],
      );

  Widget _wards() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Ward & polling-unit hierarchy',
            'The UI is ready for verified ward and polling-unit imports. No ward names or counts are fabricated in this prototype.',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8E3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.dataset_linked_outlined, color: pdpGreen),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verified geography import required',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      SizedBox(height: 5),
                      Text(
                        'Production data should provide ward ID, ward name, polling-unit ID/name, registration-area codes and source/version metadata. The system will then unlock ward and PU drill-down automatically.',
                        style: TextStyle(color: muted, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _HierarchyHeader(),
          const _EmptyHierarchyRow(
              'Ward records', 'Awaiting verified ward dataset'),
          const _EmptyHierarchyRow(
              'Polling-unit records', 'Awaiting verified polling-unit dataset'),
          const _EmptyHierarchyRow(
              'Coordinator assignments', 'Will link to Field Network'),
          const _EmptyHierarchyRow(
              'Election history', 'Will link to verified LGA/ward/PU results'),
        ],
      );

  Widget _historical() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'Historical election intelligence',
            'Statewide totals are already available; this LGA panel activates when verified LGA-level historical results are imported.',
          ),
          const SizedBox(height: 14),
          ...historicalElections.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                        width: 54,
                        child: Text('${e.year}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 17)),
                      ),
                      const Expanded(
                        child: Text(
                          'LGA result not loaded',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const StatusPill('SOURCE REQUIRED',
                          color: Color(0xFFD68A00)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 6),
          const Text(
            'Once imported, this page will calculate LGA swing, turnout change, winner change, PDP/APC vote movement, margin change and contribution to the statewide result.',
            style: TextStyle(color: muted, height: 1.45),
          ),
        ],
      );

  Widget _operations() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            'LGA operational links',
            'Every geography becomes a shared context for teams, incidents, messages, tasks, reports, logistics and election-day records.',
          ),
          const SizedBox(height: 14),
          const _OperationLink(Icons.groups_2_outlined, 'Field Network',
              'Coordinators, agents, volunteers, training and check-ins.'),
          const _OperationLink(Icons.chat_bubble_outline_rounded,
              'Communications', 'LGA channel, ward rooms and incident chats.'),
          const _OperationLink(Icons.warning_amber_rounded, 'Incidents',
              'Open, acknowledged, assigned and escalated cases.'),
          const _OperationLink(Icons.inventory_2_outlined, 'Logistics',
              'Vehicles, materials, equipment and distribution status.'),
          const _OperationLink(Icons.assignment_outlined, 'Tasks & Reports',
              'Assigned work, deadlines, evidence and field reporting.'),
          const _OperationLink(Icons.how_to_vote_outlined, 'Election Day',
              'Agent check-ins, incidents and unofficial result workflow.'),
        ],
      );
}

class _GeographyDataNotice extends StatelessWidget {
  const _GeographyDataNotice();

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
                'Verified base geography: Benue State has 23 LGAs. Statewide ward and polling-unit totals already exist in the prototype, but LGA-specific ward/PU structures will only appear after a verified official dataset is imported. Operational readiness values below are clearly marked prototype metrics.',
                style: TextStyle(fontWeight: FontWeight.w600, color: ink),
              ),
            ),
          ],
        ),
      );
}

class _LgaCommandSnapshot {
  const _LgaCommandSnapshot({
    required this.name,
    required this.readiness,
    required this.openIncidents,
    required this.activeTeams,
    required this.reportsToday,
    required this.structure,
    required this.fieldCoverage,
    required this.communication,
    required this.logistics,
    required this.dataCompleteness,
  });

  final String name;
  final int readiness;
  final int openIncidents;
  final int activeTeams;
  final int reportsToday;
  final int structure;
  final int fieldCoverage;
  final int communication;
  final int logistics;
  final int dataCompleteness;

  factory _LgaCommandSnapshot.demo(String name, int index) {
    int metric(int base, int step, int range) => base + ((index * step) % range);
    final structure = metric(42, 11, 51);
    final field = metric(35, 13, 58);
    final communication = metric(48, 9, 47);
    final logistics = metric(40, 7, 52);
    final data = metric(30, 17, 61);
    final readiness =
        ((structure + field + communication + logistics + data) / 5).round();
    return _LgaCommandSnapshot(
      name: name,
      readiness: readiness,
      openIncidents: index % 4,
      activeTeams: 2 + (index % 7),
      reportsToday: 3 + ((index * 3) % 18),
      structure: structure,
      fieldCoverage: field,
      communication: communication,
      logistics: logistics,
      dataCompleteness: data,
    );
  }

  GeographicScope get scope => GeographicScope(
        level: GeographyLevel.lga,
        state: 'Benue',
        lga: name,
      );
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric(this.label, this.value, this.icon, this.color);

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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.subtitle);

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

class _ProgressRow extends StatelessWidget {
  const _ProgressRow(this.label, this.value);

  final String label;
  final double value;

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
                Text('${(value * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 9,
                backgroundColor: const Color(0xFFE7EEE8),
              ),
            ),
          ],
        ),
      );
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> children;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(.06),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ]),
            const SizedBox(height: 10),
            ...children.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: muted)),
                      Expanded(
                          child: Text(text,
                              style: const TextStyle(color: muted, height: 1.35))),
                    ],
                  ),
                )),
          ],
        ),
      );
}

class _HierarchyHeader extends StatelessWidget {
  const _HierarchyHeader();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Expanded(
                child: Text('Layer',
                    style: TextStyle(fontWeight: FontWeight.w900))),
            Expanded(
                flex: 2,
                child: Text('Status',
                    style: TextStyle(fontWeight: FontWeight.w900))),
          ],
        ),
      );
}

class _EmptyHierarchyRow extends StatelessWidget {
  const _EmptyHierarchyRow(this.layer, this.status);

  final String layer;
  final String status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE7ECE8))),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(layer,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.hourglass_empty_rounded,
                      size: 17, color: Color(0xFFD68A00)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(status,
                          style: const TextStyle(color: muted))),
                ],
              ),
            ),
          ],
        ),
      );
}

class _OperationLink extends StatelessWidget {
  const _OperationLink(this.icon, this.title, this.detail);

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
        onTap: () {},
      );
}
