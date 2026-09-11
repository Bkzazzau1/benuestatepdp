import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'domain/geography_catalog.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

class ScopedBenueMapPage extends StatefulWidget {
  const ScopedBenueMapPage({super.key});

  @override
  State<ScopedBenueMapPage> createState() => _ScopedBenueMapPageState();
}

class _ScopedBenueMapPageState extends State<ScopedBenueMapPage> {
  final searchController = TextEditingController();
  String query = '';
  int tab = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<LgaRecord> get filteredLgas {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return BenueBaseGeography.lgas;
    return BenueBaseGeography.lgas
        .where((lga) => lga.name.toLowerCase().contains(value))
        .toList(growable: false);
  }

  LgaRecord? _selected(CampaignScopeController scope) {
    for (final lga in BenueBaseGeography.lgas) {
      if (lga.id == scope.lgaId) return lga;
    }
    return null;
  }

  void _selectLga(BuildContext context, LgaRecord lga) {
    CampaignScope.of(context, listen: false)
        .selectLga(id: lga.id, name: lga.name);
    setState(() => tab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final selected = _selected(scope);

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          PageHeading(
            title: 'Benue Campaign Map',
            subtitle:
                'Choose a Local Government Area to focus campaign operations, field teams and command activity.',
            trailing: StatusPill(
              selected == null ? 'STATEWIDE' : '${selected.name.toUpperCase()} LGA',
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1050;
            final selector = _LgaSelector(
              lgas: filteredLgas,
              selected: selected,
              query: query,
              controller: searchController,
              onQueryChanged: (value) => setState(() => query = value),
              onClear: () {
                searchController.clear();
                setState(() => query = '');
              },
              onSelect: (lga) => _selectLga(context, lga),
              onStatewide: CampaignScope.of(context, listen: false).clearToStatewide,
            );
            final detail = selected == null
                ? _StatewideOverview(
                    onSelectMakurdi: () {
                      final makurdi = BenueBaseGeography.lgas
                          .firstWhere((lga) => lga.name == 'Makurdi');
                      _selectLga(context, makurdi);
                    },
                  )
                : _LgaOverview(
                    lga: selected,
                    tab: tab,
                    onTab: (value) => setState(() => tab = value),
                  );
            if (!wide) {
              return Column(children: [
                selector,
                const SizedBox(height: 14),
                detail,
              ]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 330, child: selector),
                const SizedBox(width: 14),
                Expanded(child: detail),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _LgaSelector extends StatelessWidget {
  const _LgaSelector({
    required this.lgas,
    required this.selected,
    required this.query,
    required this.controller,
    required this.onQueryChanged,
    required this.onClear,
    required this.onSelect,
    required this.onStatewide,
  });

  final List<LgaRecord> lgas;
  final LgaRecord? selected;
  final String query;
  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<LgaRecord> onSelect;
  final VoidCallback onStatewide;

  @override
  Widget build(BuildContext context) => SectionCard(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Local Government Areas',
                      style: TextStyle(
                          color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
                  SizedBox(height: 3),
                  Text('23 LGAs across Benue State',
                      style: TextStyle(color: muted, fontSize: 10.5)),
                ]),
              ),
              if (selected != null)
                IconButton(
                  tooltip: 'Statewide view',
                  onPressed: onStatewide,
                  icon: const Icon(Icons.public_rounded),
                ),
            ]),
          ),
          TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search LGA',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
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
            child: ListView.separated(
              itemCount: lgas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final lga = lgas[index];
                final active = selected?.id == lga.id;
                return ListTile(
                  selected: active,
                  selectedTileColor: const Color(0xFFE8F4EB),
                  selectedColor: pdpGreenDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  onTap: () => onSelect(lga),
                  leading: CircleAvatar(
                    backgroundColor: active
                        ? pdpGreen.withValues(alpha: .12)
                        : const Color(0xFFF0F3F0),
                    child: Icon(Icons.location_on_outlined,
                        color: active ? pdpGreen : muted, size: 18),
                  ),
                  title: Text(lga.name,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: const Text('Open LGA command',
                      style: TextStyle(color: muted, fontSize: 10)),
                  trailing: active
                      ? const Icon(Icons.check_circle_rounded, color: pdpGreen)
                      : const Icon(Icons.chevron_right_rounded),
                );
              },
            ),
          ),
        ]),
      );
}

class _StatewideOverview extends StatelessWidget {
  const _StatewideOverview({required this.onSelectMakurdi});
  final VoidCallback onSelectMakurdi;

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF062C1A), Color(0xFF0B7A3B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusPill('BENUE STATE', color: Colors.white),
            SizedBox(height: 14),
            Text('Statewide Campaign Command',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 7),
            Text(
              'View the whole state or choose an LGA for a focused campaign command picture.',
              style: TextStyle(color: Colors.white70, height: 1.45),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
          const gap = 10.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          const cards = [
            MetricCard(label: 'LGAs', value: '23', icon: Icons.location_city_outlined),
            MetricCard(label: 'Wards / RAs', value: '276', icon: Icons.grid_view_rounded),
            MetricCard(label: 'Polling Units', value: '5,102', icon: Icons.how_to_vote_outlined),
            MetricCard(label: 'Campaign scope', value: 'Statewide', icon: Icons.public_rounded),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
          );
        }),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Campaign geography',
                style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text(
              'Use the LGA list to move from statewide command into a local campaign view.',
              style: TextStyle(color: muted, height: 1.45),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onSelectMakurdi,
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Open Makurdi'),
            ),
          ]),
        ),
      ]);
}

class _LgaOverview extends StatelessWidget {
  const _LgaOverview({
    required this.lga,
    required this.tab,
    required this.onTab,
  });

  final LgaRecord lga;
  final int tab;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    final records = CampaignRecords.of(context);
    final summary = records.summaryFor(lga.id);
    final assignments = records.assignmentsFor(lga.id);
    final readiness = records.readinessFor(lga.id);

    return Column(children: [
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${lga.name} LGA Command',
                    style: const TextStyle(
                        color: ink, fontSize: 23, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text('Local campaign command view',
                    style: TextStyle(color: muted)),
              ]),
            ),
            const StatusPill('ACTIVE'),
          ]),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
            const gap = 10.0;
            final width = (c.maxWidth - gap * (columns - 1)) / columns;
            final cards = [
              MetricCard(
                label: 'Readiness',
                value: '${summary.averageReadiness.toStringAsFixed(0)}%',
                icon: Icons.speed_rounded,
              ),
              MetricCard(
                label: 'Field assignments',
                value: '${summary.assignments}',
                icon: Icons.groups_2_outlined,
              ),
              MetricCard(
                label: 'Open incidents',
                value: '${summary.openIncidents}',
                icon: Icons.warning_amber_rounded,
                accent: const Color(0xFFD97706),
              ),
              MetricCard(
                label: 'Open tasks',
                value: '${summary.openTasks}',
                icon: Icons.task_alt_outlined,
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
            );
          }),
        ]),
      ),
      const SizedBox(height: 14),
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MapTab('Overview', 0, tab, onTab),
              _MapTab('Teams & Readiness', 1, tab, onTab),
              _MapTab('Historical', 2, tab, onTab),
              _MapTab('Connected Areas', 3, tab, onTab),
            ],
          ),
          const SizedBox(height: 18),
          if (tab == 0) ...[
            const Text('LGA command picture',
                style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            _Progress('Campaign readiness', summary.averageReadiness.toInt()),
            _Progress(
              'Field presence',
              summary.assignments == 0
                  ? 0
                  : ((summary.checkedInAssignments / summary.assignments) * 100).round(),
            ),
            _Progress(
              'Asset readiness',
              summary.assets == 0
                  ? 0
                  : ((summary.readyAssets / summary.assets) * 100).round(),
            ),
          ],
          if (tab == 1) ...[
            const Text('Teams & readiness',
                style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            if (assignments.isEmpty)
              const Text('No field assignments are available in this LGA.',
                  style: TextStyle(color: muted))
            else
              ...assignments.take(8).map((assignment) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8F4EB),
                      child: Icon(
                        assignment.checkedIn
                            ? Icons.how_to_reg_rounded
                            : Icons.person_outline_rounded,
                        color: pdpGreen,
                      ),
                    ),
                    title: Text(_roleLabel(assignment.role),
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(
                        '${_statusLabel(assignment.status)}${assignment.checkedIn ? ' • Checked in' : ''}'),
                  )),
            if (readiness.isNotEmpty) ...[
              const Divider(height: 22),
              _Progress('Agent coverage',
                  readiness.first.agentCoveragePercent.round()),
            ],
          ],
          if (tab == 2) ...const [
            Text('Historical elections',
                style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text(
              'Open Historical Elections from the main navigation for the full 2015, 2019 and 2023 LGA comparison.',
              style: TextStyle(color: muted, height: 1.45),
            ),
          ],
          if (tab == 3) ...const [
            Text('Connected campaign areas',
                style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
            SizedBox(height: 10),
            _Connected(Icons.campaign_outlined, 'Campaign Operations',
                'Activities, teams and execution'),
            _Connected(Icons.radar_rounded, 'Situation Room',
                'Incidents and field reports'),
            _Connected(Icons.chat_bubble_outline_rounded, 'Communications',
                'Local coordination and escalation'),
            _Connected(Icons.hub_rounded, 'Field Network',
                'Coordinators and field readiness'),
            _Connected(Icons.inventory_2_outlined, 'Logistics & Tasks',
                'Assets, movement and assignments'),
            _Connected(Icons.how_to_vote_outlined, 'Election Day',
                'Agent coverage and election readiness'),
          ],
        ]),
      ),
    ]);
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab(this.label, this.index, this.selected, this.onSelected);
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(label),
        selected: index == selected,
        onSelected: (_) => onSelected(index),
        selectedColor: pdpGreen.withValues(alpha: .12),
        side: BorderSide(
          color: index == selected ? pdpGreen : const Color(0xFFDCE5DE),
        ),
      );
}

class _Progress extends StatelessWidget {
  const _Progress(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(label,
                style: const TextStyle(color: ink, fontWeight: FontWeight.w800))),
            Text('${value.clamp(0, 100)}%',
                style: const TextStyle(color: pdpGreen, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value.clamp(0, 100) / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE4EBE5),
              valueColor: const AlwaysStoppedAnimation<Color>(pdpGreen),
            ),
          ),
        ]),
      );
}

class _Connected extends StatelessWidget {
  const _Connected(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF4ED),
          child: Icon(icon, color: pdpGreen, size: 19),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
      );
}

String _roleLabel(dynamic role) {
  final raw = role.toString().split('.').last;
  final spaced = raw.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
  if (spaced.isEmpty) return 'Campaign member';
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}

String _statusLabel(dynamic status) {
  final raw = status.toString().split('.').last;
  final spaced = raw.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
  if (spaced.isEmpty) return '';
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
