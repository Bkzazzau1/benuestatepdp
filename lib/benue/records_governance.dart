import 'package:flutter/material.dart';

import 'domain/models.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

class RecordsGovernancePage extends StatelessWidget {
  const RecordsGovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final records = CampaignRecords.of(context);
    final totalRecords = records.users.length +
        records.assignments.length +
        records.activities.length +
        records.incidents.length +
        records.tasks.length +
        records.assets.length +
        records.fieldReports.length +
        records.electionReadiness.length;
    final enteredCount = _originCount(records, RecordOrigin.campaignEntry);
    final importedCount = _originCount(records, RecordOrigin.imported);
    final recent = records.auditEvents.reversed.take(20).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const PageHeading(
          title: 'Data & Governance',
          subtitle:
              'Campaign records, access discipline, information quality and activity history.',
          trailing: StatusPill('CAMPAIGN RECORDS'),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(
              label: 'Campaign records',
              value: '$totalRecords',
              icon: Icons.folder_copy_outlined,
            ),
            MetricCard(
              label: 'Campaign entries',
              value: '$enteredCount',
              icon: Icons.edit_note_rounded,
            ),
            MetricCard(
              label: 'Imported records',
              value: '$importedCount',
              icon: Icons.cloud_download_outlined,
            ),
            MetricCard(
              label: 'Recorded activities',
              value: '${records.auditEvents.length}',
              icon: Icons.history_rounded,
            ),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
          );
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 950;
          const standards = _GovernancePanel(
            title: 'Information standards',
            subtitle: 'Keep campaign records clear, consistent and accountable',
            children: [
              _Rule(Icons.location_on_outlined, 'Geography',
                  'Every local record should be attached to the correct campaign area.'),
              _Rule(Icons.people_outline_rounded, 'People & assignments',
                  'Campaign responsibilities should have clear owners and locations.'),
              _Rule(Icons.crisis_alert_outlined, 'Incidents',
                  'Related reports, tasks and evidence should stay connected to the same case.'),
              _Rule(Icons.inventory_2_outlined, 'Assets',
                  'Campaign assets should show their current location, condition and custodian.'),
              _Rule(Icons.how_to_vote_outlined, 'Election records',
                  'Election-day information should remain traceable to the correct area and reporting team.'),
            ],
          );
          const access = _GovernancePanel(
            title: 'Access principles',
            subtitle: 'Campaign information should be available to the right people',
            children: [
              _Rule(Icons.badge_outlined, 'Role access',
                  'Members should see the tools and information required for their responsibilities.'),
              _Rule(Icons.map_outlined, 'Location access',
                  'Local coordination should remain within the member’s assigned campaign area.'),
              _Rule(Icons.visibility_outlined, 'Executive visibility',
                  'Leadership should have a concise statewide view of major campaign activity.'),
              _Rule(Icons.history_toggle_off_rounded, 'Accountability',
                  'Important changes should remain visible in the activity history.'),
            ],
          );
          return wide
              ? const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: standards),
                  SizedBox(width: 14),
                  Expanded(child: access),
                ])
              : const Column(children: [
                  standards,
                  SizedBox(height: 14),
                  access,
                ]);
        }),
        const SizedBox(height: 14),
        _GovernancePanel(
          title: 'Recent activity',
          subtitle: 'Latest changes across campaign records',
          children: recent.isEmpty
              ? const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text('No recent activity.', style: TextStyle(color: muted)),
                    ),
                  ),
                ]
              : recent.map((event) => _ActivityRow(event)).toList(),
        ),
      ],
    );
  }

  int _originCount(CampaignRecordsController records, RecordOrigin origin) {
    var count = 0;
    count += records.users.where((e) => e.origin == origin).length;
    count += records.assignments.where((e) => e.origin == origin).length;
    count += records.activities.where((e) => e.origin == origin).length;
    count += records.incidents.where((e) => e.origin == origin).length;
    count += records.tasks.where((e) => e.origin == origin).length;
    count += records.assets.where((e) => e.origin == origin).length;
    count += records.fieldReports.where((e) => e.origin == origin).length;
    count += records.electionReadiness.where((e) => e.origin == origin).length;
    return count;
  }
}

class _GovernancePanel extends StatelessWidget {
  const _GovernancePanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          ...children,
        ]),
      );
}

class _Rule extends StatelessWidget {
  const _Rule(this.icon, this.title, this.detail);
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4ED),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: pdpGreen, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted, height: 1.4, fontSize: 10.5)),
          ])),
        ]),
      );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow(this.event);
  final AuditEvent event;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5EBE6)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFEAF4ED),
            child: Icon(Icons.history_rounded, color: pdpGreen, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_friendlyAction(event.action),
                style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            if (event.detail != null) ...[
              const SizedBox(height: 4),
              Text(_cleanDetail(event.detail!),
                  style: const TextStyle(color: muted, height: 1.35, fontSize: 10.5)),
            ],
          ])),
          const SizedBox(width: 8),
          Text(event.actorId == 'SYSTEM' ? 'Campaign' : event.actorId,
              style: const TextStyle(color: muted, fontSize: 9.5, fontWeight: FontWeight.w700)),
        ]),
      );
}

String _friendlyAction(String value) {
  final spaced = value
      .replaceAll('_', ' ')
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}');
  if (spaced.isEmpty) return 'Campaign activity';
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}

String _cleanDetail(String value) {
  if (value.toLowerCase().contains('prototype')) {
    return 'Campaign records prepared for the current command view.';
  }
  return value;
}
