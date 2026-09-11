import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'widgets.dart';

String _enumLabel(Object value) {
  final raw = value.toString().split('.').last;
  return raw
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceFirstMapped(RegExp(r'^.'), (m) => m[0]!.toUpperCase());
}

String _shortTime(DateTime value) {
  final local = value.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${local.day}/${local.month} $hh:$mm';
}

class RecordsOverviewPage extends StatelessWidget {
  const RecordsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final summary = records.summaryFor(scope.lgaId);
    final scoped = !scope.isStatewide;

    final cards = <Widget>[
      MetricCard(
        label: 'Field assignments',
        value: '${summary.assignments}',
        icon: Icons.badge_outlined,
        detail: '${summary.checkedInAssignments} checked in',
      ),
      MetricCard(
        label: 'Open incidents',
        value: '${summary.openIncidents}',
        icon: Icons.warning_amber_rounded,
        accent: const Color(0xFFD68A00),
      ),
      MetricCard(
        label: 'Open tasks',
        value: '${summary.openTasks}',
        icon: Icons.task_alt_outlined,
      ),
      MetricCard(
        label: 'Readiness',
        value: '${summary.averageReadiness.toStringAsFixed(0)}%',
        icon: Icons.speed_rounded,
        detail: 'Prototype seeded records',
      ),
    ];

    final incidents = records.incidentsFor(scope.lgaId);
    final tasks = records.tasksFor(scope.lgaId);
    final reports = records.reportsFor(scope.lgaId);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Benue State PDP Governorship Campaign — Command Centre',
          subtitle: scoped
              ? '${scope.label} command snapshot from one shared campaign record store.'
              : 'Statewide command snapshot from one shared campaign record store across all 23 LGAs.',
          trailing: StatusPill(scoped ? scope.shortLabel.toUpperCase() : 'STATEWIDE'),
        ),
        const SizedBox(height: 18),
        const _SeedDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: cards.map((e) => SizedBox(width: width, child: e)).toList(),
          );
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 950;
          final incidentCard = _RecordListCard(
            title: 'Priority incidents',
            subtitle: 'Same incident IDs used by Situation Room, tasks and communications.',
            children: incidents.take(5).map((incident) => _IncidentRecordTile(incident)).toList(),
          );
          final taskCard = _RecordListCard(
            title: 'Operational tasks',
            subtitle: 'Tasks retain owner, geography and incident linkage.',
            children: tasks.take(5).map((task) => _TaskRecordTile(task, records)).toList(),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: incidentCard),
                  const SizedBox(width: 14),
                  Expanded(child: taskCard),
                ])
              : Column(children: [incidentCard, const SizedBox(height: 14), taskCard]);
        }),
        const SizedBox(height: 14),
        _RecordListCard(
          title: 'Latest field reports',
          subtitle: 'Reports are stored once and surfaced wherever their geography or incident is relevant.',
          children: reports.take(6).map((report) => _FieldReportTile(report)).toList(),
        ),
      ],
    );
  }
}

class RecordsCampaignOperationsPage extends StatelessWidget {
  const RecordsCampaignOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assignments = records.assignmentsFor(scope.lgaId);
    final activities = records.activitiesFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Campaign Operations',
          subtitle:
              '${scope.label}: organization, assignments and activities backed by shared record IDs.',
          trailing: StatusPill(scope.shortLabel.toUpperCase()),
        ),
        const SizedBox(height: 18),
        const _SeedDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(
                label: 'Assignments',
                value: '${summary.assignments}',
                icon: Icons.badge_outlined),
            MetricCard(
                label: 'Checked in',
                value: '${summary.checkedInAssignments}',
                icon: Icons.login_rounded),
            MetricCard(
                label: 'Activities',
                value: '${activities.length}',
                icon: Icons.event_available_outlined),
            MetricCard(
                label: 'Record scope',
                value: scope.isStatewide ? '23 LGAs' : '1 LGA',
                icon: Icons.location_on_outlined),
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
          final people = _RecordListCard(
            title: 'Field assignments',
            subtitle: 'Each assignment has its own ID, user ID and geography.',
            children: assignments
                .map((assignment) => _AssignmentTile(assignment, records))
                .toList(),
          );
          final schedule = _RecordListCard(
            title: 'Campaign activities',
            subtitle: 'Activities share the same geography key as incidents, logistics and reports.',
            children: activities.map((activity) => _ActivityTile(activity)).toList(),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: people),
                  const SizedBox(width: 14),
                  Expanded(child: schedule),
                ])
              : Column(children: [people, const SizedBox(height: 14), schedule]);
        }),
      ],
    );
  }
}

class RecordsSituationRoomPage extends StatelessWidget {
  const RecordsSituationRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final incidents = records.incidentsFor(scope.lgaId);
    final reports = records.reportsFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);
    final critical = incidents
        .where((item) => item.severity == IncidentSeverity.critical)
        .length;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Situation Room',
          subtitle:
              '${scope.label}: incident command, field reports and cross-linked operational records.',
          trailing: const StatusPill('LIVE RECORD MODEL', color: pdpRed),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(label: 'Open incidents', value: '${summary.openIncidents}', icon: Icons.warning_amber_rounded,
                accent: const Color(0xFFD68A00)),
            MetricCard(label: 'Critical', value: '$critical', icon: Icons.crisis_alert_rounded, accent: pdpRed),
            MetricCard(label: 'Field reports', value: '${summary.fieldReports}', icon: Icons.feed_outlined),
            MetricCard(label: 'Linked tasks', value: '${summary.openTasks}', icon: Icons.task_alt_outlined),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 950;
          final incidentCard = _RecordListCard(
            title: 'Incident command feed',
            subtitle: 'Incident ID is the shared link for tasks, reports, evidence and incident rooms.',
            children: incidents.map((incident) => _IncidentRecordTile(incident)).toList(),
          );
          final reportCard = _RecordListCard(
            title: 'Field reporting feed',
            subtitle: 'Structured reports use the same geographic scope and optional incident ID.',
            children: reports.map((report) => _FieldReportTile(report)).toList(),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: incidentCard),
                  const SizedBox(width: 14),
                  Expanded(child: reportCard),
                ])
              : Column(children: [incidentCard, const SizedBox(height: 14), reportCard]);
        }),
      ],
    );
  }
}

class RecordsFieldNetworkPage extends StatelessWidget {
  const RecordsFieldNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assignments = records.assignmentsFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);
    final trained = assignments.where((item) => item.trainingComplete).length;
    final ready = assignments
        .where((item) => item.status == AssignmentStatus.ready)
        .length;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Field Network & Readiness',
          subtitle:
              '${scope.label}: coordinator assignments, training state and check-in records.',
          trailing: StatusPill(scope.shortLabel.toUpperCase()),
        ),
        const SizedBox(height: 18),
        const _SeedDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(label: 'Assignments', value: '${assignments.length}', icon: Icons.badge_outlined),
            MetricCard(label: 'Training complete', value: '$trained', icon: Icons.school_outlined),
            MetricCard(label: 'Checked in', value: '${summary.checkedInAssignments}', icon: Icons.login_rounded),
            MetricCard(label: 'Ready', value: '$ready', icon: Icons.verified_user_outlined),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        _RecordListCard(
          title: 'Assignment registry',
          subtitle:
              'Ward and polling-unit assignments will join this same registry after verified geography import.',
          children: assignments
              .map((assignment) => _AssignmentTile(assignment, records))
              .toList(),
        ),
      ],
    );
  }
}

class RecordsLogisticsTasksPage extends StatelessWidget {
  const RecordsLogisticsTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assets = records.assetsFor(scope.lgaId);
    final tasks = records.tasksFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Logistics & Tasks',
          subtitle:
              '${scope.label}: assets and tasks linked to the same people, incidents and geography.',
          trailing: StatusPill(scope.shortLabel.toUpperCase()),
        ),
        const SizedBox(height: 18),
        const _SeedDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(label: 'Open tasks', value: '${summary.openTasks}', icon: Icons.task_alt_outlined),
            MetricCard(label: 'Assets', value: '${summary.assets}', icon: Icons.inventory_2_outlined),
            MetricCard(label: 'Ready assets', value: '${summary.readyAssets}', icon: Icons.local_shipping_outlined),
            MetricCard(label: 'Linked incidents', value: '${summary.openIncidents}', icon: Icons.link_rounded),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 950;
          final assetCard = _RecordListCard(
            title: 'Asset registry',
            subtitle: 'Assets have stable IDs, custodians, geography and current status.',
            children: assets.map((asset) => _AssetTile(asset, records)).toList(),
          );
          final taskCard = _RecordListCard(
            title: 'Task registry',
            subtitle: 'Tasks can link back to the exact incident and assigned user.',
            children: tasks.map((task) => _TaskRecordTile(task, records)).toList(),
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: assetCard),
                  const SizedBox(width: 14),
                  Expanded(child: taskCard),
                ])
              : Column(children: [assetCard, const SizedBox(height: 14), taskCard]);
        }),
      ],
    );
  }
}

class RecordsElectionDayPage extends StatelessWidget {
  const RecordsElectionDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final readiness = records.readinessFor(scope.lgaId);
    final assignments = records.assignmentsFor(scope.lgaId);
    final average = readiness.isEmpty
        ? 0.0
        : readiness
                .map((item) => item.agentCoveragePercent)
                .reduce((a, b) => a + b) /
            readiness.length;
    final communicationReady = readiness.where((item) => item.communicationReady).length;
    final logisticsReady = readiness.where((item) => item.logisticsReady).length;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        PageHeading(
          title: 'Election Day Command',
          subtitle:
              '${scope.label}: readiness records now share the same assignment and geography IDs used before election day.',
          trailing: const StatusPill('READINESS RECORDS', color: Color(0xFFD68A00)),
        ),
        const SizedBox(height: 18),
        const _SeedDataBanner(),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, c) {
          final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
          const gap = 12.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          final cards = [
            MetricCard(label: 'Readiness', value: '${average.toStringAsFixed(0)}%', icon: Icons.speed_rounded),
            MetricCard(label: 'Assignments', value: '${assignments.length}', icon: Icons.badge_outlined),
            MetricCard(label: 'Comms ready', value: '$communicationReady', icon: Icons.wifi_tethering_rounded),
            MetricCard(label: 'Logistics ready', value: '$logisticsReady', icon: Icons.inventory_2_outlined),
          ];
          return Wrap(spacing: gap, runSpacing: gap,
              children: cards.map((e) => SizedBox(width: width, child: e)).toList());
        }),
        const SizedBox(height: 14),
        _RecordListCard(
          title: 'Election readiness registry',
          subtitle:
              'No polling-unit result records are created until verified ward/PU geography exists. Campaign-collected results will remain explicitly unofficial.',
          children: readiness.map((item) => _ReadinessTile(item)).toList(),
        ),
        const SizedBox(height: 14),
        const SectionCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.shield_outlined, color: pdpGreen),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Next data milestone: import verified wards and polling units, assign agents to those IDs, then unlock polling-unit check-in and result-submission records. No fake PU records are generated here.',
                style: TextStyle(color: ink, height: 1.45, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _SeedDataBanner extends StatelessWidget {
  const _SeedDataBanner();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5D9),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFFFE19B)),
        ),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.dataset_outlined, color: Color(0xFF8A5B00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prototype seed records: IDs and relationships are real application structures, but people/status values are demonstration data until replaced by authorized campaign records. Provenance stays attached to every record.',
              style: TextStyle(color: Color(0xFF6D4A00), fontWeight: FontWeight.w600),
            ),
          ),
        ]),
      );
}

class _RecordListCard extends StatelessWidget {
  const _RecordListCard({
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
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted)),
          const SizedBox(height: 12),
          if (children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No records in the current scope.',
                    style: TextStyle(color: muted)),
              ),
            )
          else
            ...children,
        ]),
      );
}

class _AssignmentTile extends StatelessWidget {
  const _AssignmentTile(this.assignment, this.records);
  final FieldAssignment assignment;
  final CampaignRecordsController records;

  @override
  Widget build(BuildContext context) {
    final user = records.userById(assignment.userId);
    return _BaseRecordTile(
      icon: Icons.badge_outlined,
      title: user?.displayName ?? assignment.userId,
      id: assignment.id,
      detail:
          '${_enumLabel(assignment.role)} • ${_enumLabel(assignment.status)} • ${assignment.scope.label}',
      trailing: Wrap(spacing: 6, children: [
        StatusPill(assignment.trainingComplete ? 'TRAINED' : 'TRAINING',
            color: assignment.trainingComplete ? pdpGreen : const Color(0xFFD68A00)),
        StatusPill(assignment.checkedIn ? 'CHECKED IN' : 'NOT CHECKED IN',
            color: assignment.checkedIn ? const Color(0xFF2E62D8) : muted),
      ]),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile(this.activity);
  final CampaignActivity activity;

  @override
  Widget build(BuildContext context) => _BaseRecordTile(
        icon: Icons.event_outlined,
        title: activity.title,
        id: activity.id,
        detail:
            '${activity.category} • ${_shortTime(activity.startsAt)} • ${activity.ownerUnit}',
        trailing: StatusPill(_enumLabel(activity.status).toUpperCase()),
      );
}

class _IncidentRecordTile extends StatelessWidget {
  const _IncidentRecordTile(this.incident);
  final CampaignIncident incident;

  Color get color => switch (incident.severity) {
        IncidentSeverity.critical => pdpRed,
        IncidentSeverity.high => const Color(0xFFD68A00),
        IncidentSeverity.medium => const Color(0xFF6A5ACD),
        IncidentSeverity.low => const Color(0xFF2E62D8),
        IncidentSeverity.info => pdpGreen,
      };

  @override
  Widget build(BuildContext context) => _BaseRecordTile(
        icon: Icons.warning_amber_rounded,
        iconColor: color,
        title: incident.title,
        id: incident.id,
        detail:
            '${incident.category} • ${incident.scope.label} • ${_shortTime(incident.reportedAt)}${incident.conversationId == null ? '' : ' • ${incident.conversationId}'}',
        trailing: StatusPill(_enumLabel(incident.severity).toUpperCase(), color: color),
      );
}

class _TaskRecordTile extends StatelessWidget {
  const _TaskRecordTile(this.task, this.records);
  final CampaignTask task;
  final CampaignRecordsController records;

  @override
  Widget build(BuildContext context) {
    final owner = records.userById(task.ownerId);
    final incident = task.incidentId == null ? null : records.incidentById(task.incidentId!);
    return _BaseRecordTile(
      icon: Icons.task_alt_outlined,
      title: task.title,
      id: task.id,
      detail:
          '${owner?.displayName ?? task.ownerId} • ${task.scope.label}${incident == null ? '' : ' • linked ${incident.id}'}',
      trailing: StatusPill(_enumLabel(task.status).toUpperCase(),
          color: task.status == TaskStatus.blocked ? pdpRed : pdpGreen),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile(this.asset, this.records);
  final CampaignAsset asset;
  final CampaignRecordsController records;

  @override
  Widget build(BuildContext context) {
    final custodian =
        asset.custodianId == null ? null : records.userById(asset.custodianId!);
    return _BaseRecordTile(
      icon: Icons.inventory_2_outlined,
      title: asset.name,
      id: asset.id,
      detail:
          '${asset.category} • ${asset.scope.label} • Custodian: ${custodian?.displayName ?? 'Unassigned'}',
      trailing: StatusPill(_enumLabel(asset.status).toUpperCase(),
          color: asset.status == AssetStatus.maintenance
              ? const Color(0xFFD68A00)
              : pdpGreen),
    );
  }
}

class _FieldReportTile extends StatelessWidget {
  const _FieldReportTile(this.report);
  final FieldReport report;

  @override
  Widget build(BuildContext context) => _BaseRecordTile(
        icon: Icons.feed_outlined,
        title: report.summary,
        id: report.id,
        detail:
            '${report.category} • ${report.scope.label} • ${_shortTime(report.reportedAt)}${report.incidentId == null ? '' : ' • ${report.incidentId}'}',
        trailing: StatusPill(_enumLabel(report.status).toUpperCase()),
      );
}

class _ReadinessTile extends StatelessWidget {
  const _ReadinessTile(this.item);
  final ElectionReadinessRecord item;

  @override
  Widget build(BuildContext context) => _BaseRecordTile(
        icon: Icons.how_to_vote_outlined,
        title: item.scope.label,
        id: item.id,
        detail:
            'Agent coverage ${item.agentCoveragePercent.toStringAsFixed(0)}% • Communications ${item.communicationReady ? 'ready' : 'pending'} • Logistics ${item.logisticsReady ? 'ready' : 'pending'}',
        trailing: StatusPill(_enumLabel(item.status).toUpperCase(),
            color: item.status == ElectionReadinessStatus.ready
                ? pdpGreen
                : const Color(0xFFD68A00)),
      );
}

class _BaseRecordTile extends StatelessWidget {
  const _BaseRecordTile({
    required this.icon,
    required this.title,
    required this.id,
    required this.detail,
    required this.trailing,
    this.iconColor = pdpGreen,
  });

  final IconData icon;
  final String title;
  final String id;
  final String detail;
  final Widget trailing;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE7ECE8))),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(.10),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(id,
                  style: const TextStyle(
                      color: pdpGreenDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace')),
              const SizedBox(height: 3),
              Text(detail, style: const TextStyle(color: muted, height: 1.35)),
            ]),
          ),
          const SizedBox(width: 8),
          trailing,
        ]),
      );
}
