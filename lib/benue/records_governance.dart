import 'package:flutter/material.dart';

import 'domain/models.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

class RecordsGovernancePage extends StatelessWidget {
  const RecordsGovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final records = CampaignRecords.of(context);
    final seedCount = <Object>[
      ...records.users,
      ...records.assignments,
      ...records.activities,
      ...records.incidents,
      ...records.tasks,
      ...records.assets,
      ...records.fieldReports,
      ...records.electionReadiness,
    ].length;

    final importedCount = _originCount(records, RecordOrigin.imported);
    final enteredCount = _originCount(records, RecordOrigin.campaignEntry);
    final audit = records.auditEvents.reversed.take(20).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const PageHeading(
          title: 'Data & Governance',
          subtitle:
              'Provenance, auditability, record integrity, geography keys and production data controls.',
          trailing: StatusPill('AUDITABLE RECORDS'),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(
              label: 'Prototype seed entities',
              value: '$seedCount',
              icon: Icons.dataset_outlined,
              detail: 'Clearly provenance-labelled',
            ),
            MetricCard(
              label: 'Campaign-entered',
              value: '$enteredCount',
              icon: Icons.edit_note_rounded,
            ),
            MetricCard(
              label: 'Imported verified',
              value: '$importedCount',
              icon: Icons.cloud_download_outlined,
            ),
            MetricCard(
              label: 'Audit events',
              value: '${records.auditEvents.length}',
              icon: Icons.history_rounded,
            ),
          ];
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards.map((e) => SizedBox(width: width, child: e)).toList(),
          );
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 950;
          final integrity = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Title('Referential-integrity rules',
                    'Records must stay connected by stable IDs rather than display text.'),
                SizedBox(height: 12),
                _Rule('Geography',
                    'Every LGA-scoped record carries BEN-LGA-xx. Ward and PU records must carry verified parent IDs.'),
                _Rule('People & assignments',
                    'Assignments reference a stable user ID and geography scope.'),
                _Rule('Incident workflow',
                    'Tasks, reports, evidence and incident rooms may reference the same incident ID.'),
                _Rule('Assets',
                    'Assets retain their own ID, geography, status and optional custodian user ID.'),
                _Rule('Election records',
                    'Polling-unit result submissions remain locked until verified ward/PU geography is loaded.'),
              ],
            ),
          );
          final provenance = SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Title('Provenance policy',
                    'No number should lose its origin when it moves into a dashboard or report.'),
                SizedBox(height: 12),
                _Origin('PROTOTYPE SEED',
                    'Demonstration content used to exercise real IDs and relationships.',
                    Color(0xFFD68A00)),
                _Origin('CAMPAIGN ENTRY',
                    'Authorized staff-created operational data.', pdpGreen),
                _Origin('IMPORTED',
                    'External data imported from an approved source with source/version metadata.',
                    Color(0xFF2E62D8)),
                _Origin('SYSTEM DERIVED',
                    'Metrics computed from other records; underlying source IDs must remain traceable.',
                    Color(0xFF6A5ACD)),
              ],
            ),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: integrity),
                  const SizedBox(width: 14),
                  Expanded(child: provenance),
                ])
              : Column(children: [integrity, const SizedBox(height: 14), provenance]);
        }),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Title('Audit trail',
                  'The newest record mutations appear first. Production will persist this server-side and make it tamper-evident.'),
              const SizedBox(height: 12),
              if (audit.isEmpty)
                const Text('No audit events recorded yet.',
                    style: TextStyle(color: muted))
              else
                ...audit.map((event) => _AuditRow(event)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SectionCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.storage_rounded, color: pdpGreen),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Backend direction: Django/DRF should enforce the same IDs, role/geography permissions, provenance fields and audit events server-side. Flutter visibility rules are user experience controls, not security boundaries.',
                style: TextStyle(color: ink, height: 1.45, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
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

class _Title extends StatelessWidget {
  const _Title(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted)),
        ],
      );
}

class _Rule extends StatelessWidget {
  const _Rule(this.title, this.detail);
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.link_rounded, color: pdpGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(detail, style: const TextStyle(color: muted, height: 1.35)),
            ]),
          ),
        ]),
      );
}

class _Origin extends StatelessWidget {
  const _Origin(this.label, this.detail, this.color);
  final String label;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StatusPill(label, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(detail,
                style: const TextStyle(color: muted, height: 1.35)),
          ),
        ]),
      );
}

class _AuditRow extends StatelessWidget {
  const _AuditRow(this.event);
  final AuditEvent event;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE7ECE8))),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFEAF4ED),
            child: Icon(Icons.history_rounded, color: pdpGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.action,
                  style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text('${event.entityType} • ${event.entityId}',
                  style: const TextStyle(
                      color: pdpGreenDark,
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              if (event.detail != null) ...[
                const SizedBox(height: 3),
                Text(event.detail!,
                    style: const TextStyle(color: muted, height: 1.35)),
              ],
            ]),
          ),
          const SizedBox(width: 8),
          Text(event.actorId,
              style: const TextStyle(color: muted, fontWeight: FontWeight.w700)),
        ]),
      );
}
