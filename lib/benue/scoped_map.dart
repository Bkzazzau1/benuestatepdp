import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data.dart';
import 'domain/geography_catalog.dart';
import 'widgets.dart';

class ScopedBenueMapPage extends StatefulWidget {
  const ScopedBenueMapPage({super.key});

  @override
  State<ScopedBenueMapPage> createState() => _ScopedBenueMapPageState();
}

class _ScopedBenueMapPageState extends State<ScopedBenueMapPage> {
  final searchController = TextEditingController();
  String query = '';
  int selectedTab = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<LgaRecord> get filteredLgas {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return BenueBaseGeography.lgas;
    return BenueBaseGeography.lgas
        .where((lga) => lga.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  LgaRecord? _recordForScope(CampaignScopeController scope) {
    if (scope.lgaId == null) return null;
    for (final lga in BenueBaseGeography.lgas) {
      if (lga.id == scope.lgaId) return lga;
    }
    return null;
  }

  void _selectLga(BuildContext context, LgaRecord lga) {
    CampaignScope.of(context, listen: false)
        .selectLga(id: lga.id, name: lga.name);
    setState(() => selectedTab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final selected = _recordForScope(scope);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Benue Geographic Command',
          subtitle:
              'Select an LGA here and the same geography becomes active across operations, situation room, communications, field network, logistics and election day.',
          trailing: StatusPill(selected == null ? 'STATEWIDE' : '${selected.name} ACTIVE'),
        ),
        const SizedBox(height: 18),
        _ScopeRuleCard(selected: selected),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth >= 1050;
          final selector = _selector(context, selected);
          final detail = selected == null
              ? _StatewideDetail(onSelectFirst: () {
                  final makurdi = BenueBaseGeography.lgas
                      .firstWhere((lga) => lga.name == 'Makurdi');
                  _selectLga(context, makurdi);
                })
              : _LgaDetail(
                  lga: selected,
                  selectedTab: selectedTab,
                  onTabChanged: (value) => setState(() => selectedTab = value),
                );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 330, child: selector),
                  const SizedBox(width: 14),
                  Expanded(child: detail),
                ])
              : Column(children: [selector, const SizedBox(height: 14), detail]);
        }),
      ],
    );
  }

  Widget _selector(BuildContext context, LgaRecord? selected) => SectionCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LGA command nodes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      SizedBox(height: 3),
                      Text('23 verified LGA names', style: TextStyle(color: muted)),
                    ],
                  ),
                ),
                if (selected != null)
                  IconButton(
                    tooltip: 'Return to statewide scope',
                    onPressed: CampaignScope.of(context, listen: false).clearToStatewide,
                    icon: const Icon(Icons.public_rounded),
                  ),
              ]),
            ),
            TextField(
              controller: searchController,
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Search LGA',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() => query = '');
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
              child: ListView.separated(
                itemCount: filteredLgas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final lga = filteredLgas[index];
                  final active = selected?.id == lga.id;
                  final globalIndex = BenueBaseGeography.lgas
                      .indexWhere((item) => item.id == lga.id);
                  final readiness = 35 + ((globalIndex * 13) % 61);
                  return ListTile(
                    selected: active,
                    selectedTileColor: const Color(0xFFE8F4EB),
                    selectedColor: pdpGreenDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    onTap: () => _selectLga(context, lga),
                    leading: CircleAvatar(
                      backgroundColor: active
                          ? pdpGreen.withOpacity(.12)
                          : const Color(0xFFF0F3F0),
                      child: Text('${globalIndex + 1}',
                          style: TextStyle(
                              color: active ? pdpGreenDark : muted,
                              fontWeight: FontWeight.w900)),
                    ),
                    title: Text(lga.name,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text('$readiness% prototype readiness'),
                    trailing: active
                        ? const Icon(Icons.check_circle_rounded, color: pdpGreen)
                        : const Icon(Icons.chevron_right_rounded),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

class _ScopeRuleCard extends StatelessWidget {
  const _ScopeRuleCard({required this.selected});
  final LgaRecord? selected;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.hub_rounded, color: pdpGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              selected == null
                  ? 'Statewide scope is active. Select any LGA to synchronize operational modules to that geography.'
                  : '${selected!.name} is now the shared active geography. Operational pages will use ${selected!.name} until you choose another LGA or reset to statewide.',
              style: const TextStyle(fontWeight: FontWeight.w700, color: ink),
            ),
          ),
        ]),
      );
}

class _StatewideDetail extends StatelessWidget {
  const _StatewideDetail({required this.onSelectFirst});
  final VoidCallback onSelectFirst;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Benue State Command',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          const Text(
            'No LGA filter is active. Dashboards operate at statewide scope.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
            const gap = 10.0;
            final width = (c.maxWidth - gap * (columns - 1)) / columns;
            const cards = [
              MetricCard(label: 'LGAs', value: '23', icon: Icons.location_city_outlined),
              MetricCard(label: 'Wards / RAs', value: '276', icon: Icons.grid_view_rounded),
              MetricCard(label: 'Polling units', value: '5,102', icon: Icons.how_to_vote_outlined),
              MetricCard(label: 'Scope mode', value: 'State', icon: Icons.public_rounded),
            ];
            return Wrap(spacing: gap, runSpacing: gap,
                children: cards.map((e) => SizedBox(width: width, child: e)).toList());
          }),
          const SizedBox(height: 18),
          const Text('How geographic integration works',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const _FlowRow('1', 'Choose an LGA', 'The selected geography is stored once in the shared campaign scope.'),
          const _FlowRow('2', 'Move between modules', 'Situation Room, Field Network, Logistics and Election Day read the same scope.'),
          const _FlowRow('3', 'Add ward / PU data', 'Verified imports will extend the same model down to ward and polling-unit level.'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onSelectFirst,
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Demonstrate with Makurdi'),
          ),
        ]),
      );
}

class _LgaDetail extends StatelessWidget {
  const _LgaDetail({
    required this.lga,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final LgaRecord lga;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  int get index => BenueBaseGeography.lgas.indexWhere((e) => e.id == lga.id);
  int get readiness => 35 + ((index * 13) % 61);
  int get incidents => 1 + ((index * 3) % 7);
  int get teams => 3 + ((index * 5) % 19);
  int get reports => 4 + ((index * 7) % 31);

  @override
  Widget build(BuildContext context) => Column(children: [
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
                      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text('${lga.id} • shared active geography',
                      style: const TextStyle(color: muted)),
                ]),
              ),
              const StatusPill('ACTIVE SCOPE'),
            ]),
            const SizedBox(height: 18),
            LayoutBuilder(builder: (context, c) {
              final columns = c.maxWidth > 850 ? 4 : c.maxWidth > 480 ? 2 : 1;
              const gap = 10.0;
              final width = (c.maxWidth - gap * (columns - 1)) / columns;
              final cards = [
                MetricCard(label: 'Readiness', value: '$readiness%', icon: Icons.speed_rounded,
                    detail: 'Prototype value'),
                MetricCard(label: 'Open incidents', value: '$incidents', icon: Icons.warning_amber_rounded,
                    accent: const Color(0xFFD68A00)),
                MetricCard(label: 'Field teams', value: '$teams', icon: Icons.groups_2_outlined,
                    detail: 'Prototype value'),
                MetricCard(label: 'Reports today', value: '$reports', icon: Icons.feed_outlined,
                    detail: 'Prototype value'),
              ];
              return Wrap(spacing: gap, runSpacing: gap,
                  children: cards.map((e) => SizedBox(width: width, child: e)).toList());
            }),
          ]),
        ),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 8, runSpacing: 8, children: [
              _tab('Overview', 0),
              _tab('Wards & PUs', 1),
              _tab('Historical', 2),
              _tab('Connected modules', 3),
            ]),
            const SizedBox(height: 18),
            if (selectedTab == 0) _overview(),
            if (selectedTab == 1) _hierarchy(),
            if (selectedTab == 2) _historical(),
            if (selectedTab == 3) _connected(),
          ]),
        ),
      ]);

  Widget _tab(String label, int index) => ChoiceChip(
        label: Text(label),
        selected: selectedTab == index,
        onSelected: (_) => onTabChanged(index),
        selectedColor: pdpGreen.withOpacity(.12),
        side: BorderSide(
            color: selectedTab == index ? pdpGreen : const Color(0xFFDCE5DE)),
      );

  Widget _overview() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Command health',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        _Progress('Campaign structure', (readiness + 9).clamp(0, 100)),
        _Progress('Field coverage', readiness),
        _Progress('Communications readiness', (readiness + 6).clamp(0, 100)),
        _Progress('Logistics readiness', (readiness - 4).clamp(0, 100)),
        _Progress('Data completeness', (readiness - 12).clamp(0, 100)),
        const SizedBox(height: 12),
        const Text(
          'All percentages above are prototype values. Production readiness must be computed from verified assignments, training, check-ins, logistics and reports.',
          style: TextStyle(color: muted, height: 1.45),
        ),
      ]);

  Widget _hierarchy() => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Verified hierarchy required',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        SizedBox(height: 8),
        Text(
          'No ward names, ward counts per LGA, or polling-unit lists are invented. The geography import validator is ready to load and validate official granular data.',
          style: TextStyle(color: muted, height: 1.45),
        ),
        SizedBox(height: 12),
        _Pending('Ward records'),
        _Pending('Polling-unit records'),
        _Pending('Ward coordinators'),
        _Pending('Polling-unit agents'),
      ]);

  Widget _historical() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('LGA historical intelligence',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text(
          'Statewide historical totals are available. LGA-level figures remain locked until verified granular election results are imported.',
          style: TextStyle(color: muted, height: 1.45),
        ),
        const SizedBox(height: 12),
        ...historicalElections.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text('${e.year}')),
              title: const Text('LGA result not loaded',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              trailing: const StatusPill('SOURCE REQUIRED', color: Color(0xFFD68A00)),
            )),
      ]);

  Widget _connected() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${lga.name} shared module context',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        _Connected(Icons.campaign_outlined, 'Campaign Operations', '${lga.name} structure and activity'),
        _Connected(Icons.radar_rounded, 'Situation Room', '${lga.name} incidents and field reports'),
        _Connected(Icons.chat_bubble_outline_rounded, 'Communications', '${lga.name} command and incident rooms'),
        _Connected(Icons.hub_rounded, 'Field Network', '${lga.name} coordinators and readiness'),
        _Connected(Icons.inventory_2_outlined, 'Logistics & Tasks', '${lga.name} assets and assignments'),
        _Connected(Icons.how_to_vote_outlined, 'Election Day', '${lga.name} agents and result workflow'),
      ]);
}

class _FlowRow extends StatelessWidget {
  const _FlowRow(this.number, this.title, this.detail);
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: pdpGreen,
          foregroundColor: Colors.white,
          child: Text(number, style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(detail),
      );
}

class _Progress extends StatelessWidget {
  const _Progress(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text('$value%', style: const TextStyle(fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 9,
              backgroundColor: const Color(0xFFE8EFEA),
            ),
          ),
        ]),
      );
}

class _Pending extends StatelessWidget {
  const _Pending(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.hourglass_empty_rounded, color: Color(0xFFD68A00)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: const StatusPill('IMPORT REQUIRED', color: Color(0xFFD68A00)),
      );
}

class _Connected extends StatelessWidget {
  const _Connected(this.icon, this.title, this.detail);
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
        trailing: const Icon(Icons.link_rounded),
      );
}
