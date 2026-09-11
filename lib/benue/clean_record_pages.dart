import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'session.dart';
import 'widgets.dart';

class CleanCampaignOperationsPage extends StatelessWidget {
  const CleanCampaignOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assignments = records.assignmentsFor(scope.lgaId);
    final activities = records.activitiesFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);

    return _Page(
      title: 'Campaign Operations',
      subtitle: '${scope.label}: teams, assignments, activities and campaign execution.',
      badge: scope.shortLabel.toUpperCase(),
      metrics: [
        _Metric('Assignments', '${summary.assignments}', Icons.badge_outlined),
        _Metric('Checked in', '${summary.checkedInAssignments}', Icons.how_to_reg_rounded),
        _Metric('Activities', '${activities.length}', Icons.event_available_outlined),
        _Metric('Readiness', '${summary.averageReadiness.toStringAsFixed(0)}%', Icons.speed_rounded),
      ],
      sections: [
        _ResponsivePair(
          left: _ListPanel(
            title: 'Field assignments',
            subtitle: 'Campaign personnel and their current assignments',
            children: assignments.map((assignment) {
              final user = records.userById(assignment.userId);
              return _RowItem(
                icon: Icons.person_outline_rounded,
                title: user?.displayName ?? roleLabel(assignment.role),
                subtitle:
                    '${assignment.scope.label} • ${_label(assignment.status.name)}${assignment.checkedIn ? ' • Checked in' : ''}',
              );
            }).toList(),
          ),
          right: _ListPanel(
            title: 'Campaign activities',
            subtitle: 'Upcoming and active campaign work',
            children: activities.map((activity) => _RowItem(
                  icon: Icons.event_note_outlined,
                  title: activity.title,
                  subtitle:
                      '${activity.scope.label} • ${activity.category} • ${_label(activity.status.name)}',
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class CleanSituationRoomPage extends StatelessWidget {
  const CleanSituationRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final incidents = records.incidentsFor(scope.lgaId);
    final reports = records.reportsFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);
    final critical = incidents
        .where((incident) => incident.severity == IncidentSeverity.critical)
        .length;

    return _Page(
      title: 'Situation Room',
      subtitle: '${scope.label}: incidents, field reports and campaign response.',
      badge: 'LIVE COMMAND',
      badgeColor: pdpRed,
      metrics: [
        _Metric('Open incidents', '${summary.openIncidents}', Icons.warning_amber_rounded,
            color: const Color(0xFFD97706)),
        _Metric('Critical', '$critical', Icons.crisis_alert_rounded, color: pdpRed),
        _Metric('Field reports', '${summary.fieldReports}', Icons.feed_outlined),
        _Metric('Open tasks', '${summary.openTasks}', Icons.task_alt_outlined),
      ],
      sections: [
        _ResponsivePair(
          left: _ListPanel(
            title: 'Incident command feed',
            subtitle: 'Current issues requiring attention',
            children: incidents.map((incident) => _RowItem(
                  icon: Icons.crisis_alert_outlined,
                  title: incident.title,
                  subtitle:
                      '${incident.scope.label} • ${_label(incident.severity.name)} • ${_label(incident.status.name)}',
                  accent: _severityColor(incident.severity),
                )).toList(),
          ),
          right: _ListPanel(
            title: 'Field reporting feed',
            subtitle: 'Recent reports from campaign teams',
            children: reports.map((report) => _RowItem(
                  icon: Icons.feed_outlined,
                  title: report.category,
                  subtitle: '${report.scope.label} • ${_label(report.status.name)}',
                  body: report.summary,
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class CleanFieldNetworkPage extends StatelessWidget {
  const CleanFieldNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assignments = records.assignmentsFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);
    final trained = assignments.where((e) => e.trainingComplete).length;
    final ready = assignments.where((e) => e.status == AssignmentStatus.ready).length;

    return _Page(
      title: 'Field Network',
      subtitle: '${scope.label}: coordinators, field teams, preparation and check-in.',
      badge: scope.shortLabel.toUpperCase(),
      metrics: [
        _Metric('Assignments', '${assignments.length}', Icons.badge_outlined),
        _Metric('Prepared', '$trained', Icons.school_outlined),
        _Metric('Checked in', '${summary.checkedInAssignments}', Icons.login_rounded),
        _Metric('Ready', '$ready', Icons.verified_user_outlined),
      ],
      sections: [
        _ListPanel(
          title: 'Field team',
          subtitle: 'Campaign personnel in the active area',
          children: assignments.map((assignment) {
            final user = records.userById(assignment.userId);
            return _RowItem(
              icon: roleIcon(assignment.role),
              title: user?.displayName ?? roleLabel(assignment.role),
              subtitle:
                  '${roleLabel(assignment.role)} • ${assignment.scope.label} • ${_label(assignment.status.name)}',
              trailing: assignment.checkedIn ? 'CHECKED IN' : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CleanLogisticsTasksPage extends StatelessWidget {
  const CleanLogisticsTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final assets = records.assetsFor(scope.lgaId);
    final tasks = records.tasksFor(scope.lgaId);
    final summary = records.summaryFor(scope.lgaId);

    return _Page(
      title: 'Logistics & Tasks',
      subtitle: '${scope.label}: assets, materials, movement and campaign tasks.',
      badge: scope.shortLabel.toUpperCase(),
      metrics: [
        _Metric('Open tasks', '${summary.openTasks}', Icons.task_alt_outlined),
        _Metric('Assets', '${summary.assets}', Icons.inventory_2_outlined),
        _Metric('Ready assets', '${summary.readyAssets}', Icons.local_shipping_outlined),
        _Metric('Open incidents', '${summary.openIncidents}', Icons.warning_amber_rounded),
      ],
      sections: [
        _ResponsivePair(
          left: _ListPanel(
            title: 'Asset register',
            subtitle: 'Campaign assets in the active area',
            children: assets.map((asset) => _RowItem(
                  icon: Icons.inventory_2_outlined,
                  title: asset.name,
                  subtitle:
                      '${asset.scope.label} • ${asset.category} • ${_label(asset.status.name)}',
                )).toList(),
          ),
          right: _ListPanel(
            title: 'Task board',
            subtitle: 'Current campaign tasks and priorities',
            children: tasks.map((task) => _RowItem(
                  icon: Icons.task_outlined,
                  title: task.title,
                  subtitle:
                      '${task.scope.label} • ${_label(task.status.name)} • ${_label(task.priority.name)} priority',
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class CleanElectionDayPage extends StatelessWidget {
  const CleanElectionDayPage({super.key});

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
    final communicationReady =
        readiness.where((item) => item.communicationReady).length;
    final logisticsReady = readiness.where((item) => item.logisticsReady).length;

    return _Page(
      title: 'Election Day',
      subtitle: '${scope.label}: agent coverage, communications and logistics readiness.',
      badge: 'ELECTION COMMAND',
      metrics: [
        _Metric('Agent coverage', '${average.toStringAsFixed(0)}%', Icons.groups_2_outlined),
        _Metric('Assignments', '${assignments.length}', Icons.badge_outlined),
        _Metric('Communications ready', '$communicationReady/${readiness.length}',
            Icons.wifi_tethering_rounded),
        _Metric('Logistics ready', '$logisticsReady/${readiness.length}',
            Icons.local_shipping_outlined),
      ],
      sections: [
        _ResponsivePair(
          left: _ListPanel(
            title: 'Readiness by area',
            subtitle: 'Election-day preparation across the active command area',
            children: readiness.map((item) => _RowItem(
                  icon: Icons.how_to_vote_outlined,
                  title: item.scope.lga ?? item.scope.label,
                  subtitle:
                      '${item.agentCoveragePercent.toStringAsFixed(0)}% agent coverage • ${_label(item.status.name)}',
                  trailing: item.communicationReady && item.logisticsReady
                      ? 'READY'
                      : 'CHECK',
                )).toList(),
          ),
          right: const _ElectionDaySteps(),
        ),
      ],
    );
  }
}

class _ElectionDaySteps extends StatelessWidget {
  const _ElectionDaySteps();

  @override
  Widget build(BuildContext context) => const _ListPanel(
        title: 'Election-day workflow',
        subtitle: 'A clear sequence for field teams',
        children: [
          _RowItem(icon: Icons.login_rounded, title: 'Check in', subtitle: 'Confirm assignment and arrival'),
          _RowItem(icon: Icons.report_problem_outlined, title: 'Report issues', subtitle: 'Escalate incidents immediately'),
          _RowItem(icon: Icons.document_scanner_outlined, title: 'Preserve evidence', subtitle: 'Capture clear result documentation'),
          _RowItem(icon: Icons.upload_file_outlined, title: 'Submit campaign copy', subtitle: 'Send the campaign result record'),
        ],
      );
}

class _Page extends StatelessWidget {
  const _Page({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.metrics,
    required this.sections,
    this.badgeColor = pdpGreen,
  });
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final List<_Metric> metrics;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(28),
        children: [
          PageHeading(
            title: title,
            subtitle: subtitle,
            trailing: StatusPill(badge, color: badgeColor),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth > 1000 ? 4 : c.maxWidth > 620 ? 2 : 1;
            const gap = 12.0;
            final width = (c.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: metrics
                  .map((metric) => SizedBox(
                        width: width,
                        child: MetricCard(
                          label: metric.label,
                          value: metric.value,
                          icon: metric.icon,
                          accent: metric.color,
                        ),
                      ))
                  .toList(),
            );
          }),
          for (final section in sections) ...[
            const SizedBox(height: 14),
            section,
          ],
        ],
      );
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, {this.color = pdpGreen});
  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _ResponsivePair extends StatelessWidget {
  const _ResponsivePair({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        if (c.maxWidth < 950) {
          return Column(children: [left, const SizedBox(height: 14), right]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: left),
          const SizedBox(width: 14),
          Expanded(child: right),
        ]);
      });
}

class _ListPanel extends StatelessWidget {
  const _ListPanel({
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
          if (children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No items at the moment.', style: TextStyle(color: muted))),
            )
          else
            ...children,
        ]),
      );
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.body,
    this.trailing,
    this.accent = pdpGreen,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String? body;
  final String? trailing;
  final Color accent;

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
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: accent, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 11.5)),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: muted, fontSize: 10, height: 1.35)),
            if (body != null) ...[
              const SizedBox(height: 5),
              Text(body!, style: const TextStyle(color: ink, fontSize: 10.5, height: 1.4)),
            ],
          ])),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            StatusPill(trailing!, color: accent),
          ],
        ]),
      );
}

Color _severityColor(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => pdpRed,
      IncidentSeverity.high => const Color(0xFFDC2626),
      IncidentSeverity.medium => const Color(0xFFD97706),
      IncidentSeverity.low => const Color(0xFF2563EB),
      IncidentSeverity.info => muted,
    };

String _label(String value) {
  final spaced = value.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
  if (spaced.isEmpty) return spaced;
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
