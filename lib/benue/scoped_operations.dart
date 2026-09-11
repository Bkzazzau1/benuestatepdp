import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data.dart';
import 'widgets.dart';

int _scopeIndex(String? lga) {
  if (lga == null) return -1;
  return benueLgas.indexOf(lga);
}

int _metricFor(String? lga, int base, int step, int span) {
  final index = _scopeIndex(lga);
  if (index < 0) return base;
  return base + ((index * step) % span);
}

class ScopedCampaignOperationsPage extends StatelessWidget {
  const ScopedCampaignOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    final scoped = lga != null;
    final activityLocation = scoped ? '$lga LGA' : 'Statewide';

    final cards = <Widget>[
      MetricCard(
        label: scoped ? 'Active LGA command' : 'LGA coordination target',
        value: scoped ? '1' : '23',
        icon: Icons.account_tree_outlined,
        detail: scoped ? '$lga command workspace' : null,
      ),
      MetricCard(
        label: 'Ward coordination',
        value: scoped ? 'Pending' : '276',
        icon: Icons.grid_view_rounded,
        detail: scoped ? 'Verified ward import required' : null,
      ),
      MetricCard(
        label: 'Polling-unit coverage',
        value: scoped ? 'Pending' : '5,102',
        icon: Icons.how_to_vote_outlined,
        detail: scoped ? 'Verified PU import required' : null,
      ),
      MetricCard(
        label: 'Operational mode',
        value: scoped ? 'LGA' : 'State',
        icon: Icons.settings_suggest_outlined,
        detail: scoped ? 'Filtered to $lga' : 'Statewide command',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Campaign Operations',
          subtitle: scoped
              ? '$lga campaign structure, activities, candidate movement, volunteers and execution tracking.'
              : 'State campaign structure, coordinators, activities, candidate movement, volunteers and execution tracking.',
          trailing: StatusPill(scoped ? '$lga LGA' : 'STATE CAMPAIGN'),
        ),
        const SizedBox(height: 18),
        const PrototypeBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards.map((e) => SizedBox(width: width, child: e)).toList(),
          );
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 930;
          final structure = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title('Campaign command structure',
                    scoped ? '$lga roles are shown inside the statewide chain of command.' : 'Roles are configured by level, geography and permission.'),
                const SizedBox(height: 14),
                const _RowItem(Icons.flag_outlined, 'State Campaign Council',
                    'Candidate • DG • Situation Room • Operations • Legal • Media • Logistics'),
                _RowItem(Icons.location_city_outlined,
                    scoped ? '$lga LGA Coordinator' : 'LGA Coordinators',
                    scoped ? 'Primary command owner for $lga with state-level escalation.' : '23 geographic commands with state-level escalation.'),
                _RowItem(Icons.grid_view_rounded, 'Ward Coordinators',
                    scoped ? 'Loaded after verified $lga ward hierarchy is imported.' : '276 ward-level coordination and reporting nodes.'),
                const _RowItem(Icons.badge_outlined, 'Polling-Unit Agents',
                    'Election-day assignment and reporting layer.'),
                const _RowItem(Icons.groups_2_outlined, 'Volunteers & Field Teams',
                    'Purpose-limited access to assigned campaign tasks.'),
              ],
            ),
          );
          final activity = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title('Activity command board',
                    'Prototype schedule for $activityLocation until the verified campaign calendar is connected.'),
                const SizedBox(height: 10),
                _Activity('Today', 'Operations review', activityLocation, 'Planning'),
                _Activity('Tomorrow', 'Coordinator coverage audit', activityLocation, 'Operations'),
                _Activity('This week', 'Structure verification', activityLocation, 'Field'),
                _Activity('This week', 'Media response review', activityLocation, 'Communications'),
              ],
            ),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: structure),
                  const SizedBox(width: 14),
                  Expanded(child: activity),
                ])
              : Column(children: [structure, const SizedBox(height: 14), activity]);
        }),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title('Candidate movement & engagement workflow',
                  scoped ? 'Every $lga engagement is linked to the LGA command node, logistics, media, field reports and follow-up.' : 'Every engagement is linked to geography, logistics, media, field reports and follow-up.'),
              const SizedBox(height: 14),
              const _Step('1', 'Plan', 'Location, purpose, stakeholder group, logistics, media and security requirements.'),
              const _Step('2', 'Authorize', 'Leadership confirms owner, resources and communication plan.'),
              const _Step('3', 'Execute', 'Field team checks in and submits structured updates.'),
              const _Step('4', 'Close & follow up', 'Capture commitments, issues, media outputs and responsible follow-up team.'),
            ],
          ),
        ),
      ],
    );
  }
}

class ScopedSituationRoomPage extends StatelessWidget {
  const ScopedSituationRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    final scoped = lga != null;
    final officers = _metricFor(lga, 128, 7, 31);
    final incidents = _metricFor(lga, 23, 3, 7);
    final critical = scoped ? (_scopeIndex(lga).abs() % 3) : 2;
    final reports = _metricFor(lga, 184, 11, 63);
    final visibleLgas = scoped ? <String>[lga] : benueLgas;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Situation Room',
          subtitle: scoped
              ? '$lga live field reporting, incidents, escalation, communications and command decisions.'
              : 'Live field reporting, incidents, escalation, communications and command decisions.',
          trailing: StatusPill(scoped ? '$lga LIVE' : 'LIVE OPERATIONS', color: pdpRed),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final count = c.maxWidth > 1000 ? 4 : c.maxWidth > 600 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (count - 1)) / count;
          final items = [
            MetricCard(label: 'Field officers online', value: '$officers', icon: Icons.radar_rounded,
                detail: scoped ? 'Prototype $lga metric' : 'Prototype statewide metric'),
            MetricCard(label: 'Open incidents', value: '$incidents', icon: Icons.warning_amber_rounded,
                accent: const Color(0xFFD68A00)),
            MetricCard(label: 'Critical alerts', value: '$critical', icon: Icons.crisis_alert_rounded, accent: pdpRed),
            MetricCard(label: 'Reports today', value: '$reports', icon: Icons.feed_outlined),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: items.map((e) => SizedBox(width: width, child: e)).toList(),
          );
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
                  _Title(scoped ? '$lga operational layer' : 'Benue operational map',
                      scoped ? 'All incident, field, team and evidence views are filtered to $lga.' : 'Select an LGA in Benue Map to make the rest of the command system follow that geography.'),
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
                          children: visibleLgas
                              .map((name) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .9),
                                      borderRadius: BorderRadius.circular(999),
                                      border: scoped ? Border.all(color: pdpGreen) : null,
                                    ),
                                    child: Text(name,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
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
                _Title('Priority feed', scoped ? 'Prototype events filtered to $lga.' : 'Structured statewide operational events.'),
                const SizedBox(height: 8),
                if (scoped) ...[
                  _IncidentRow('Critical', 'Operational interruption requires review', lga, pdpRed),
                  _IncidentRow('High', 'Field report awaiting verification', lga, const Color(0xFFD68A00)),
                  _IncidentRow('Medium', 'Coordinator check-in overdue', lga, const Color(0xFF6A5ACD)),
                  _IncidentRow('Info', 'Campaign activity completed', lga, pdpGreen),
                ] else ...const [
                  _IncidentRow('Critical', 'Logistics interruption reported', 'Makurdi', pdpRed),
                  _IncidentRow('High', 'Field report awaiting verification', 'Gboko', Color(0xFFD68A00)),
                  _IncidentRow('Medium', 'Ward coordinator check-in overdue', 'Otukpo', Color(0xFF6A5ACD)),
                  _IncidentRow('Info', 'Campaign activity completed', 'Vandeikya', pdpGreen),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Icon(Icons.chat_bubble_outline_rounded, color: pdpGreen),
                    const SizedBox(width: 9),
                    Expanded(child: Text(scoped
                        ? '$lga incidents should open a linked $lga communication room.'
                        : 'Every incident can open a linked communication room.')),
                  ]),
                ),
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
}

class ScopedFieldNetworkPage extends StatelessWidget {
  const ScopedFieldNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    final scoped = lga != null;
    final entries = scoped
        ? benueLgas.asMap().entries.where((e) => e.value == lga)
        : benueLgas.asMap().entries;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Field Network & Readiness',
          subtitle: scoped
              ? '$lga coordinator coverage, agent readiness, tasks, check-ins and logistics.'
              : 'Campaign structure, agent coverage, ward readiness, tasks and logistics.',
          trailing: StatusPill(scoped ? '$lga LGA' : '23 LGAs'),
        ),
        const SizedBox(height: 18),
        const PrototypeBanner(),
        const SizedBox(height: 14),
        if (scoped)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: LayoutBuilder(builder: (context, c) {
              final columns = c.maxWidth > 900 ? 4 : c.maxWidth > 560 ? 2 : 1;
              const gap = 12.0;
              final width = (c.maxWidth - gap * (columns - 1)) / columns;
              final index = _scopeIndex(lga);
              final cards = [
                MetricCard(label: 'LGA coordinator', value: 'Pending', icon: Icons.person_outline_rounded,
                    detail: 'Verified roster required'),
                MetricCard(label: 'Ward coordinators', value: 'Pending', icon: Icons.grid_view_rounded,
                    detail: 'Ward import required'),
                MetricCard(label: 'Field check-ins', value: '${3 + ((index * 5) % 19)}', icon: Icons.how_to_reg_outlined,
                    detail: 'Prototype only'),
                MetricCard(label: 'Open field tasks', value: '${1 + ((index * 3) % 8)}', icon: Icons.task_alt_outlined,
                    detail: 'Prototype only'),
              ];
              return Wrap(spacing: gap, runSpacing: gap,
                  children: cards.map((e) => SizedBox(width: width, child: e)).toList());
            }),
          ),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title(scoped ? '$lga readiness board' : 'LGA readiness board',
                  'Prototype coverage values; production values come from verified assignments, training, check-ins and logistics.'),
              const SizedBox(height: 16),
              ...entries.map((entry) {
                final pct = 35 + ((entry.key * 13) % 61);
                return _Readiness(entry.value, pct);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class ScopedLogisticsTasksPage extends StatelessWidget {
  const ScopedLogisticsTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    final scoped = lga != null;
    final index = _scopeIndex(lga);
    final taskCount = scoped ? 2 + ((index * 2) % 9) : 0;
    final overdue = scoped ? (index.abs() % 3) : 0;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Logistics & Tasks',
          subtitle: scoped
              ? '$lga assets, campaign materials, transport, assignments and deadlines.'
              : 'Assets, campaign materials, transport, assignments, deadlines and escalation in one operational board.',
          trailing: StatusPill(scoped ? '$lga OPERATIONS' : 'OPERATIONS'),
        ),
        const SizedBox(height: 18),
        const PrototypeBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (cols - 1)) / cols;
          final cards = [
            MetricCard(label: 'Open tasks', value: '$taskCount', icon: Icons.task_alt_outlined,
                detail: scoped ? 'Prototype $lga value' : null),
            MetricCard(label: 'Overdue tasks', value: '$overdue', icon: Icons.timer_off_outlined,
                accent: overdue > 0 ? const Color(0xFFD68A00) : pdpGreen),
            MetricCard(label: 'Registered assets', value: scoped ? 'Pending' : '0', icon: Icons.inventory_2_outlined,
                detail: scoped ? 'Verified asset registry required' : null),
            MetricCard(label: 'Distribution gaps', value: scoped ? 'Review' : '0', icon: Icons.local_shipping_outlined),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 930;
          final assets = SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Title('Asset registry', scoped ? 'Assets assigned to $lga will appear here with custodian, condition and availability.' : 'Track custodian, assignment, availability and condition.'),
              const SizedBox(height: 12),
              const _RowItem(Icons.directions_car_outlined, 'Vehicles', 'Transport & field mobility'),
              const _RowItem(Icons.campaign_outlined, 'PA systems & generators', 'Campaign events'),
              const _RowItem(Icons.devices_outlined, 'Phones & laptops', 'Field and situation-room operations'),
              _RowItem(Icons.inventory_2_outlined, 'Campaign materials', scoped ? 'State → $lga → ward distribution' : 'State → LGA → ward distribution'),
              const _RowItem(Icons.how_to_vote_outlined, 'Election-day kits', 'Restricted readiness inventory'),
            ]),
          );
          final tasks = SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Title('Task workflow', scoped ? 'Tasks shown here inherit $lga as their geographic scope.' : 'Every instruction has an owner, deadline, geography and evidence of completion.'),
              const SizedBox(height: 12),
              _Task('Verify venue', 'Operations', scoped ? lga : 'Statewide', 'Planned'),
              _Task('Confirm coordinator roster', 'Field Network', scoped ? lga : 'Statewide', 'Planned'),
              _Task('Review logistics requirement', 'Logistics', scoped ? lga : 'Statewide', 'Planned'),
              _Task('Prepare command brief', 'Situation Room', scoped ? lga : 'Statewide', 'Planned'),
            ]),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: assets), const SizedBox(width: 14), Expanded(child: tasks),
                ])
              : Column(children: [assets, const SizedBox(height: 14), tasks]);
        }),
      ],
    );
  }
}

class ScopedElectionDayPage extends StatelessWidget {
  const ScopedElectionDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final lga = scope.lgaName;
    final scoped = lga != null;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Election Day Command',
          subtitle: scoped
              ? '$lga agent deployment, polling-unit reporting, incidents and unofficial result verification.'
              : 'Agent deployment, polling-unit reporting, incident command, unofficial campaign result capture and verification.',
          trailing: StatusPill(scoped ? '$lga READINESS' : 'READINESS MODE', color: const Color(0xFFD68A00)),
        ),
        const SizedBox(height: 18),
        const PrototypeBanner(),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 1000 ? 4 : c.maxWidth > 600 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (cols - 1)) / cols;
          final items = [
            MetricCard(label: 'Polling units', value: scoped ? 'Pending' : '5,102', icon: Icons.how_to_vote_outlined,
                detail: scoped ? 'Verified $lga PU hierarchy required' : null),
            const MetricCard(label: 'Agent coverage', value: '0%', icon: Icons.badge_outlined,
                detail: 'Awaiting verified roster'),
            const MetricCard(label: 'Results verified', value: '0', icon: Icons.verified_outlined),
            const MetricCard(label: 'Disputed entries', value: '0', icon: Icons.gavel_outlined, accent: pdpRed),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: items.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Title('Election-day workflow', scoped
                ? 'Every $lga result remains campaign-collected and unofficial until INEC declares official results.'
                : 'Every result remains campaign-collected and unofficial until INEC declares official results.'),
            const SizedBox(height: 16),
            const _Step('1', 'Agent arrival & check-in', 'Confirm assigned polling unit and operational readiness.'),
            const _Step('2', 'Poll opening report', 'Record opening status and permitted observations.'),
            const _Step('3', 'Incident reporting', 'Escalate security, logistics or legal issues with evidence.'),
            const _Step('4', 'Result capture', 'Upload permitted result image and enter figures.'),
            const _Step('5', 'Independent verification', 'Second authorized officer verifies critical entries.'),
            const _Step('6', 'Aggregation', 'Aggregate PU → ward → LGA → state with anomaly flags.'),
          ]),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted)),
        ],
      );
}

class _RowItem extends StatelessWidget {
  const _RowItem(this.icon, this.title, this.detail);
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF5EE),
          child: Icon(icon, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(detail),
      );
}

class _Activity extends StatelessWidget {
  const _Activity(this.when, this.title, this.location, this.type);
  final String when;
  final String title;
  final String location;
  final String type;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.event_outlined, color: pdpGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('$when • $location'),
        trailing: StatusPill(type),
      );
}

class _Step extends StatelessWidget {
  const _Step(this.number, this.title, this.detail);
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            backgroundColor: pdpGreen,
            foregroundColor: Colors.white,
            child: Text(number, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted)),
          ])),
        ]),
      );
}

class _IncidentRow extends StatelessWidget {
  const _IncidentRow(this.severity, this.title, this.lga, this.color);
  final String severity;
  final String title;
  final String lga;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE8EEE9))),
        ),
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

class _Readiness extends StatelessWidget {
  const _Readiness(this.name, this.value);
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
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 10,
                backgroundColor: const Color(0xFFE7EEE8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 44, child: Text('$value%', textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w900))),
        ]),
      );
}

class _Task extends StatelessWidget {
  const _Task(this.title, this.owner, this.geography, this.status);
  final String title;
  final String owner;
  final String geography;
  final String status;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF5EE),
          child: Icon(Icons.task_alt_outlined, color: pdpGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('$owner • $geography'),
        trailing: StatusPill(status, color: const Color(0xFF5E5CB2)),
      );
}
