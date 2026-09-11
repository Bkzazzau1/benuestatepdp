import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'session.dart';
import 'widgets.dart';

/// Premium statewide home for the Director General.
///
/// This view deliberately answers a different question from the Situation
/// Room: is the whole campaign executing to plan, and where must the DG act?
class PremiumDirectorGeneralCommandView extends StatelessWidget {
  const PremiumDirectorGeneralCommandView({
    super.key,
    required this.onOpenModule,
  });

  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final records = CampaignRecords.of(context);
    final scope = CampaignScope.of(context);
    final session = CampaignSession.of(context);
    final summary = records.summaryFor(scope.lgaId);
    final incidents = records.incidentsFor(scope.lgaId).toList()
      ..sort((a, b) {
        final severity = _severityRank(b.severity).compareTo(_severityRank(a.severity));
        if (severity != 0) return severity;
        return b.reportedAt.compareTo(a.reportedAt);
      });
    final tasks = records.tasksFor(scope.lgaId).toList()
      ..sort((a, b) {
        final severity = _severityRank(b.priority).compareTo(_severityRank(a.priority));
        if (severity != 0) return severity;
        final aDue = a.dueAt ?? DateTime(2100);
        final bDue = b.dueAt ?? DateTime(2100);
        return aDue.compareTo(bDue);
      });
    final activities = records.activitiesFor(scope.lgaId).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    final readiness = records.readinessFor(scope.lgaId);
    final assignments = records.assignmentsFor(scope.lgaId);

    final critical = incidents
        .where((e) => e.severity == IncidentSeverity.critical)
        .length;
    final attention = readiness
        .where((e) => e.status == ElectionReadinessStatus.attentionRequired)
        .length;
    final checkedIn = assignments.where((e) => e.checkedIn).length;
    final checkRate = assignments.isEmpty ? 0.0 : checkedIn / assignments.length;
    final readyAssets = summary.assets == 0 ? 0.0 : summary.readyAssets / summary.assets;

    return ColoredBox(
      color: const Color(0xFFF2F5F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          _DgHero(
            operatorName: session.operatorName,
            scopeLabel: scope.label,
            readiness: summary.averageReadiness,
            criticalIncidents: critical,
            openTasks: summary.openTasks,
          ),
          const SizedBox(height: 16),
          _DgKpiGrid(items: [
            _DgKpi(
              'Campaign readiness',
              '${summary.averageReadiness.toStringAsFixed(0)}%',
              'Average agent coverage',
              Icons.speed_rounded,
              pdpGreen,
            ),
            _DgKpi(
              'Field presence',
              '${summary.checkedInAssignments}/${summary.assignments}',
              '${(checkRate * 100).toStringAsFixed(0)}% checked in',
              Icons.how_to_reg_rounded,
              const Color(0xFF2563EB),
            ),
            _DgKpi(
              'Critical incidents',
              '$critical',
              '${summary.openIncidents} open total',
              Icons.crisis_alert_rounded,
              const Color(0xFFD72638),
            ),
            _DgKpi(
              'Open tasks',
              '${summary.openTasks}',
              'Cross-unit execution queue',
              Icons.task_alt_rounded,
              const Color(0xFF7C3AED),
            ),
            _DgKpi(
              'LGAs needing attention',
              '$attention',
              scope.isStatewide ? 'Readiness status' : 'Active scope',
              Icons.location_city_rounded,
              const Color(0xFFD97706),
            ),
            _DgKpi(
              'Asset readiness',
              summary.assets == 0
                  ? '—'
                  : '${(readyAssets * 100).toStringAsFixed(0)}%',
              '${summary.readyAssets}/${summary.assets} operational',
              Icons.inventory_2_outlined,
              const Color(0xFF0F766E),
            ),
          ]),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final readinessPanel = _LgaReadinessBoard(
              records: records,
              activeLgaId: scope.lgaId,
              onOpenMap: () => onOpenModule(AppModule.benueMap),
            );
            final decisions = _DecisionDesk(
              incidents: incidents,
              tasks: tasks,
              onSituationRoom: () => onOpenModule(AppModule.situationRoom),
              onOperations: () => onOpenModule(AppModule.campaignOperations),
            );
            if (c.maxWidth < 1060) {
              return Column(children: [
                readinessPanel,
                const SizedBox(height: 14),
                decisions,
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 13, child: readinessPanel),
              const SizedBox(width: 14),
              Expanded(flex: 9, child: decisions),
            ]);
          }),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final activity = _CampaignActivityBoard(activities: activities);
            final execution = _ExecutionHealth(
              summary: summary,
              assignments: assignments,
              readiness: readiness,
            );
            if (c.maxWidth < 1060) {
              return Column(children: [
                activity,
                const SizedBox(height: 14),
                execution,
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 12, child: activity),
              const SizedBox(width: 14),
              Expanded(flex: 9, child: execution),
            ]);
          }),
          const SizedBox(height: 16),
          _ExecutiveBrief(
            summary: summary,
            criticalIncidents: critical,
            attentionLgas: attention,
            scopeLabel: scope.label,
          ),
          const SizedBox(height: 16),
          _DgQuickActions(actions: [
            _DgAction('Situation Room', 'Escalations & incidents', Icons.radar_rounded,
                () => onOpenModule(AppModule.situationRoom)),
            _DgAction('Campaign Operations', 'Execution & activities', Icons.campaign_outlined,
                () => onOpenModule(AppModule.campaignOperations)),
            _DgAction('Election Intelligence', 'Historical & current analysis', Icons.analytics_rounded,
                () => onOpenModule(AppModule.electionIntelligence)),
            _DgAction('Benue Map', 'Geographic command', Icons.map_outlined,
                () => onOpenModule(AppModule.benueMap)),
            _DgAction('Reports', 'Executive reporting', Icons.description_outlined,
                () => onOpenModule(AppModule.reportsDocuments)),
            _DgAction('Data & Governance', 'Audit & data integrity', Icons.admin_panel_settings_outlined,
                () => onOpenModule(AppModule.dataGovernance)),
          ]),
          const SizedBox(height: 16),
          const _DgDoctrine(),
        ],
      ),
    );
  }
}

class _DgHero extends StatelessWidget {
  const _DgHero({
    required this.operatorName,
    required this.scopeLabel,
    required this.readiness,
    required this.criticalIncidents,
    required this.openTasks,
  });

  final String operatorName;
  final String scopeLabel;
  final double readiness;
  final int criticalIncidents;
  final int openTasks;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF061D13), Color(0xFF0B5F34), Color(0xFF0D8347)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x26064F2A), blurRadius: 34, offset: Offset(0, 14)),
          ],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 900;
          final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Wrap(spacing: 8, runSpacing: 8, children: [
              _DgDarkBadge(Icons.account_balance_rounded, 'DIRECTOR GENERAL'),
              _DgDarkBadge(Icons.dashboard_customize_outlined, 'STATEWIDE COMMAND'),
              _DgDarkBadge(Icons.verified_user_outlined, 'SOURCE-CONTROLLED'),
            ]),
            const SizedBox(height: 19),
            Text(
              'Director General Command',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 31 : 42,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: -.9,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              '${CampaignIdentity.candidateName} • statewide execution, accountability and campaign readiness.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]);
          final status = Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: .14)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(operatorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(scopeLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 10.5)),
              const SizedBox(height: 14),
              Wrap(spacing: 20, runSpacing: 10, children: [
                _DgHeroMetric('${readiness.toStringAsFixed(0)}%', 'READINESS'),
                _DgHeroMetric('$criticalIncidents', 'CRITICAL'),
                _DgHeroMetric('$openTasks', 'OPEN TASKS'),
              ]),
            ]),
          );
          if (compact) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              copy,
              const SizedBox(height: 20),
              status,
            ]);
          }
          return Row(children: [
            Expanded(flex: 14, child: copy),
            const SizedBox(width: 26),
            Expanded(flex: 7, child: status),
          ]);
        }),
      );
}

class _DgDarkBadge extends StatelessWidget {
  const _DgDarkBadge(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              )),
        ]),
      );
}

class _DgHeroMetric extends StatelessWidget {
  const _DgHeroMetric(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
          Text(label,
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .9)),
        ],
      );
}

class _DgKpi {
  const _DgKpi(this.label, this.value, this.detail, this.icon, this.color);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
}

class _DgKpiGrid extends StatelessWidget {
  const _DgKpiGrid({required this.items});
  final List<_DgKpi> items;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 1200
            ? 6
            : c.maxWidth >= 780
                ? 3
                : c.maxWidth >= 500
                    ? 2
                    : 1;
        const gap = 11.0;
        final width = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map((item) => SizedBox(
                    width: width,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE3E9E4)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: .09),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: item.color, size: 19),
                        ),
                        const SizedBox(height: 12),
                        Text(item.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: ink, fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text(item.label,
                            style: const TextStyle(
                                color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 3),
                        Text(item.detail,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: muted, fontSize: 9.5, height: 1.25)),
                      ]),
                    ),
                  ))
              .toList(),
        );
      });
}

class _LgaReadinessBoard extends StatelessWidget {
  const _LgaReadinessBoard({
    required this.records,
    required this.activeLgaId,
    required this.onOpenMap,
  });

  final CampaignRecordsController records;
  final String? activeLgaId;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final rows = records.electionReadiness.toList()
      ..sort((a, b) => a.agentCoveragePercent.compareTo(b.agentCoveragePercent));
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LGA readiness board',
                  style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
              SizedBox(height: 3),
              Text('Lowest coverage first — where statewide command attention is most useful',
                  style: TextStyle(color: muted, fontSize: 10.5)),
            ]),
          ),
          TextButton.icon(
            onPressed: onOpenMap,
            icon: const Icon(Icons.map_outlined, size: 16),
            label: const Text('Open map'),
          ),
        ]),
        const SizedBox(height: 13),
        if (rows.isEmpty)
          const _DgEmpty('No readiness records in this scope.')
        else
          ...rows.take(8).map((row) {
            final color = switch (row.status) {
              ElectionReadinessStatus.ready => pdpGreen,
              ElectionReadinessStatus.attentionRequired => const Color(0xFFD72638),
              ElectionReadinessStatus.incomplete => const Color(0xFFD97706),
              ElectionReadinessStatus.notStarted => muted,
            };
            final active = activeLgaId != null && row.scope.lgaId == activeLgaId;
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFEAF5EE) : const Color(0xFFFAFBFA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: active ? const Color(0xFFCAE4D2) : const Color(0xFFE6EBE7)),
              ),
              child: Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.location_city_outlined, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(row.scope.lga ?? row.scope.label,
                      style: const TextStyle(
                          color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: (row.agentCoveragePercent / 100).clamp(0, 1).toDouble(),
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE7ECE8),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ])),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${row.agentCoveragePercent.toStringAsFixed(0)}%',
                      style: TextStyle(color: color, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(_enumLabel(row.status.name),
                      style: const TextStyle(color: muted, fontSize: 8.5)),
                ]),
              ]),
            );
          }),
      ]),
    );
  }
}

class _DecisionDesk extends StatelessWidget {
  const _DecisionDesk({
    required this.incidents,
    required this.tasks,
    required this.onSituationRoom,
    required this.onOperations,
  });

  final List<CampaignIncident> incidents;
  final List<CampaignTask> tasks;
  final VoidCallback onSituationRoom;
  final VoidCallback onOperations;

  @override
  Widget build(BuildContext context) {
    final severe = incidents
        .where((e) => e.severity == IncidentSeverity.critical || e.severity == IncidentSeverity.high)
        .take(3)
        .toList();
    final priorityTasks = tasks.take(3).toList();
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('DG decision desk',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        const Text('Exceptions that deserve executive attention rather than routine processing',
            style: TextStyle(color: muted, fontSize: 10.5)),
        const SizedBox(height: 14),
        if (severe.isEmpty && priorityTasks.isEmpty)
          const _DgEmpty('No priority decisions in this scope.')
        else ...[
          ...severe.map((item) => _DecisionRow(
                title: item.title,
                detail: '${item.scope.label} • ${_enumLabel(item.severity.name)} incident',
                icon: Icons.crisis_alert_outlined,
                color: const Color(0xFFD72638),
              )),
          ...priorityTasks.map((item) => _DecisionRow(
                title: item.title,
                detail: '${item.scope.label} • ${_enumLabel(item.status.name)}',
                icon: Icons.task_outlined,
                color: const Color(0xFF7C3AED),
              )),
        ],
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onSituationRoom,
              icon: const Icon(Icons.radar_rounded, size: 17),
              label: const Text('Escalations'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onOperations,
              icon: const Icon(Icons.campaign_outlined, size: 17),
              label: const Text('Execution'),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _DecisionRow extends StatelessWidget {
  const _DecisionRow({
    required this.title,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String title;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFA),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE6EBE7)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted, fontSize: 9.2, height: 1.3)),
          ])),
        ]),
      );
}

class _CampaignActivityBoard extends StatelessWidget {
  const _CampaignActivityBoard({required this.activities});
  final List<CampaignActivity> activities;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Campaign activity board',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        const Text('Upcoming and active activities in the shared campaign calendar',
            style: TextStyle(color: muted, fontSize: 10.5)),
        const SizedBox(height: 14),
        if (activities.isEmpty)
          const _DgEmpty('No campaign activities in this scope.')
        else
          ...activities.take(6).map((activity) {
            final color = switch (activity.status) {
              ActivityStatus.active => pdpGreen,
              ActivityStatus.approved => const Color(0xFF2563EB),
              ActivityStatus.planned => const Color(0xFFD97706),
              ActivityStatus.completed => const Color(0xFF64748B),
              ActivityStatus.cancelled => const Color(0xFFD72638),
            };
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAF9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6EBE7)),
              ),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.event_note_outlined, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(activity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('${activity.scope.label} • ${activity.ownerUnit}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 9.2)),
                ])),
                const SizedBox(width: 10),
                _SmallStatus(_enumLabel(activity.status.name).toUpperCase(), color),
              ]),
            );
          }),
      ]),
    );
  }
}

class _ExecutionHealth extends StatelessWidget {
  const _ExecutionHealth({
    required this.summary,
    required this.assignments,
    required this.readiness,
  });

  final CampaignRecordsSummary summary;
  final List<FieldAssignment> assignments;
  final List<ElectionReadinessRecord> readiness;

  @override
  Widget build(BuildContext context) {
    final checked = assignments.where((e) => e.checkedIn).length;
    final trained = assignments.where((e) => e.trainingComplete).length;
    final checkRate = assignments.isEmpty ? 0.0 : checked / assignments.length;
    final trainingRate = assignments.isEmpty ? 0.0 : trained / assignments.length;
    final commReady = readiness.where((e) => e.communicationReady).length;
    final logReady = readiness.where((e) => e.logisticsReady).length;
    final commRate = readiness.isEmpty ? 0.0 : commReady / readiness.length;
    final logRate = readiness.isEmpty ? 0.0 : logReady / readiness.length;
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Execution health',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        const Text('Cross-unit conditions behind statewide campaign execution',
            style: TextStyle(color: muted, fontSize: 10.5)),
        const SizedBox(height: 17),
        _DgHealthBar('Field check-in', checkRate,
            '$checked/${assignments.length}', const Color(0xFF2563EB)),
        _DgHealthBar('Training complete', trainingRate,
            '$trained/${assignments.length}', const Color(0xFF7C3AED)),
        _DgHealthBar('Communications ready', commRate,
            '$commReady/${readiness.length}', const Color(0xFF0F766E)),
        _DgHealthBar('Logistics ready', logRate,
            '$logReady/${readiness.length}', const Color(0xFFD97706)),
        _DgHealthBar('Average agent coverage', summary.averageReadiness / 100,
            '${summary.averageReadiness.toStringAsFixed(0)}%', pdpGreen),
      ]),
    );
  }
}

class _DgHealthBar extends StatelessWidget {
  const _DgHealthBar(this.label, this.value, this.display, this.color);
  final String label;
  final double value;
  final String display;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(label,
                style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800))),
            Text(display,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value.clamp(0, 1).toDouble(),
              minHeight: 7,
              backgroundColor: const Color(0xFFE7ECE8),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ]),
      );
}

class _ExecutiveBrief extends StatelessWidget {
  const _ExecutiveBrief({
    required this.summary,
    required this.criticalIncidents,
    required this.attentionLgas,
    required this.scopeLabel,
  });

  final CampaignRecordsSummary summary;
  final int criticalIncidents;
  final int attentionLgas;
  final String scopeLabel;

  @override
  Widget build(BuildContext context) {
    final bullets = <String>[
      'Agent coverage across $scopeLabel is ${summary.averageReadiness.toStringAsFixed(0)}% in the current shared record set.',
      '$criticalIncidents critical incident${criticalIncidents == 1 ? '' : 's'} currently require executive visibility.',
      '$attentionLgas readiness record${attentionLgas == 1 ? '' : 's'} are flagged for attention.',
      '${summary.openTasks} operational task${summary.openTasks == 1 ? '' : 's'} remain open.',
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF5EE), Color(0xFFF7FAF8)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD5E7DA)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: pdpGreen.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.auto_awesome_outlined, color: pdpGreen),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Text('Executive command brief',
                style: TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
            SizedBox(width: 8),
            _SmallStatus('RECORD-DERIVED', pdpGreen),
          ]),
          const SizedBox(height: 4),
          const Text(
            'A concise operational summary generated only from records currently visible to this prototype.',
            style: TextStyle(color: muted, fontSize: 10.5, height: 1.4),
          ),
          const SizedBox(height: 11),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.circle, size: 5, color: pdpGreen),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b,
                      style: const TextStyle(color: ink, fontSize: 10.5, height: 1.4))),
                ]),
              )),
        ])),
      ]),
    );
  }
}

class _DgAction {
  const _DgAction(this.label, this.detail, this.icon, this.onTap);
  final String label;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
}

class _DgQuickActions extends StatelessWidget {
  const _DgQuickActions({required this.actions});
  final List<_DgAction> actions;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('DG command shortcuts',
              style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          const Text('Move from executive overview directly into the responsible command module',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth >= 1050
                ? 6
                : c.maxWidth >= 700
                    ? 3
                    : c.maxWidth >= 450
                        ? 2
                        : 1;
            const gap = 10.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: actions
                  .map((a) => SizedBox(
                        width: width,
                        child: InkWell(
                          onTap: a.onTap,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAF9),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE4EAE5)),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Icon(a.icon, color: pdpGreen, size: 22),
                              const SizedBox(height: 10),
                              Text(a.label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 3),
                              Text(a.detail,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: muted, fontSize: 8.8, height: 1.3)),
                              const SizedBox(height: 10),
                              const Icon(Icons.arrow_outward_rounded, color: pdpGreen, size: 16),
                            ]),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
        ]),
      );
}

class _DgDoctrine extends StatelessWidget {
  const _DgDoctrine();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF071C13),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.account_tree_outlined, color: Color(0xFF67C98A)),
          SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DG operating doctrine',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            SizedBox(height: 4),
            Text(
              'See the whole campaign → identify exceptions → assign accountable ownership → unblock execution → verify closure. The DG view should highlight what needs leadership attention, not duplicate every operational screen.',
              style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.45),
            ),
          ])),
        ]),
      );
}

class _SmallStatus extends StatelessWidget {
  const _SmallStatus(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .25,
            )),
      );
}

class _DgEmpty extends StatelessWidget {
  const _DgEmpty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(text, style: const TextStyle(color: muted))),
      );
}

int _severityRank(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => 5,
      IncidentSeverity.high => 4,
      IncidentSeverity.medium => 3,
      IncidentSeverity.low => 2,
      IncidentSeverity.info => 1,
    };

String _enumLabel(String value) {
  final spaced = value.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m.group(1)} ${m.group(2)}',
  );
  if (spaced.isEmpty) return spaced;
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
